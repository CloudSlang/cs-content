#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################
# This flow deletesa a DigitalOcean droplet if it is considered a zombie.
#
# Inputs:
#   - droplet_id - id of the droplet as a string value
#   - droplet_name - name of the droplet
#   - creation_time_as_string - creation time (UTC timezone) of the droplet as a string value
#                             - format (used by DigitalOcean): 2015-09-27T18:47:19Z
#   - time_to_live - threshold to compare the droplet's lifetime to (in minutes)
#   - name_pattern - regex pattern for zombie droplet names - e.g. ci-([0-9]+)-coreos-([0-9]+)
#   - token - personal access token for DigitalOcean API
#
# Results:
#   - DELETED: droplet is deleted
#   - NOT_DELETED: droplet is not deleted
#   - FAILURE: an error occurred
########################################################################################################
namespace: io.cloudslang.cloud_provider.digital_ocean.v2.examples

imports:
  droplets: io.cloudslang.cloud_provider.digital_ocean.v2.droplets

flow:
  name: delete_droplet_if_zombie

  inputs:
    - droplet_id
    - droplet_name
    - creation_time_as_string
    - time_to_live
    - name_pattern
    - token
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - connect_timeout:
        required: false
    - socket_timeout:
        required: false
  workflow:
    - check_droplet_is_zombie:
        do:
          check_droplet_is_zombie:
            - droplet_name
            - creation_time_as_string
            - time_to_live
            - name_pattern
        navigate:
          ZOMBIE: delete_droplet
          NOT_ZOMBIE: NOT_DELETED
          FAILURE: FAILURE

    - delete_droplet:
        do:
          droplets.delete_droplet:
            - token
            - droplet_id
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - connect_timeout
            - socket_timeout
        navigate:
          SUCCESS: DELETED
          FAILURE: FAILURE
  results:
    - DELETED
    - NOT_DELETED
    - FAILURE
