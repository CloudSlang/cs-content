#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Filters and extracts the Docker container names from the raw output returned by 'docker ps' command.
#!               Containers can be filtered based on the images they are created from.
#! @input raw_output: raw output from 'docker ps' command
#! @input excluded_images: comma separated list of Docker images
#!                         the containers based on these images will not be included in the result list
#!                         Example: swarm:latest,tomcat:7
#! @output container_names: comma separated list of container names
#! @output container_ids: comma separated list of container IDs
#! @result SUCCESS: parsing was successful (return_code == '0')
#! @result FAILURE: otherwise
#!!#
####################################################

namespace: io.cloudslang.docker.utils

operation:
  name: filter_containers_raw_output
  inputs:
    - raw_output
    - excluded_images
  python_action:
    script: |
      def extract_container_name_from_line(line):
        return line.split()[-1]

      def extract_container_id_from_line(line):
        return line.split()[0]

      def resolve_tag(image):
        return image if ':' in image else image + ':latest'

      try:
        return_code = '0'
        container_names = ''
        container_ids = ''
        if bool(excluded_images):
          excluded_images_list = excluded_images.split(',')
          filter_on_images = True
        else:
          filter_on_images = False
        lines = raw_output.split('\n')[1:]
        for line in lines:
          if line != '':
            if filter_on_images == True:
              excluded = False
              actual_image = resolve_tag(line.split()[1])
              for excluded_image in excluded_images_list:
                excluded_image = resolve_tag(excluded_image)
                if excluded_image == actual_image:
                  excluded = True
              if excluded == False:
                container_names += extract_container_name_from_line(line) + ','
                container_ids += extract_container_id_from_line(line) + ','
            else:
              container_names += extract_container_name_from_line(line) + ','
              container_ids += extract_container_id_from_line(line) + ','
        if container_names != '':
          container_names = container_names[:-1]
        if container_names != '':
          container_ids = container_ids[:-1]
      except:
        return_code = '-1'
  outputs:
    - container_names
    - container_ids
  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE
