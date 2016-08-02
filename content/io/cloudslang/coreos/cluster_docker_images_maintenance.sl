#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @description: Runs the docker_images_maintenance flow against all the machines in the cluster.
#! @input coreos_host: CoreOS machine host;
#!                     Can be any machine from the cluster
#! @input coreos_username: CoreOS machine username
#! @input coreos_password: optional - CoreOS machine password;
#!                         Can be empty since CoreOS machines uses private key file authentication
#! @input private_key_file: optional - path to the private key file
#! @input timeout: optional - time in milliseconds to wait for the command to complete
#! @input percentage: if disk space is greater than this value then unused images will be deleted
#!                    Default: 0%
#!                    Example: 50%
#! @output number_of_deleted_images_per_host: how many images were deleted for every host
#!                                            Format: "ip1: number1, ip2: number2"
#!!#
####################################################

namespace: io.cloudslang.coreos

imports:
  coreos: io.cloudslang.coreos
  maintenance: io.cloudslang.docker.maintenance

flow:
  name: cluster_docker_images_maintenance

  inputs:
    - coreos_host
    - coreos_username
    - coreos_password:
        required: false
        sensitive: true
    - private_key_file:
        required: false
    - timeout:
        required: false
    - percentage: '0%'
    - number_of_deleted_images_per_host_var:
        default: ''
        required: false
        private: true

  workflow:
    - list_machines_public_ip:
        do:
          coreos.list_machines_public_ip:
            - coreos_host
            - coreos_username
            - coreos_password
            - private_key_file
            - timeout
        publish:
          - machines_public_ip_list

    - loop_docker_images_maintenance:
        loop:
          for: machine_public_ip in machines_public_ip_list.split()
          do:
            maintenance.images_maintenance:
              - docker_host: ${machine_public_ip}
              - docker_username: ${coreos_username}
              - docker_password: ${coreos_password}
              - private_key_file
              - percentage
              - timeout
              - number_of_deleted_images_per_host_var
              - machine_public_ip
          publish:
            - number_of_deleted_images_per_host_var: >
                ${number_of_deleted_images_per_host_var + machine_public_ip + ': ' + str(total_amount_of_images_deleted) + ','}

  outputs:
    - number_of_deleted_images_per_host: ${number_of_deleted_images_per_host_var[:-1]}
