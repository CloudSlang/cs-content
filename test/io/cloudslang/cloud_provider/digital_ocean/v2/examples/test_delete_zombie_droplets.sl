# (c) Copyright 2015 Liran Tal
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################

namespace: io.cloudslang.cloud_provider.digital_ocean.v2.examples

imports:
  droplets: io.cloudslang.cloud_provider.digital_ocean.v2.droplets
  strings: io.cloudslang.base.strings
  utils: io.cloudslang.base.utils

flow:
  name: test_delete_zombie_droplets

  inputs:
    - time_to_live
    - droplet_name
    - image
    - ssh_keys
    - token
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false

  workflow:
    - create_zombie_stub:
        do:
          droplets.create_droplet:
            - name: droplet_name
            - image
            - ssh_keys
            - token
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        navigate:
          SUCCESS: wait_for_create_event
          FAILURE: CREATE_DROPLET_FAILURE

    - wait_for_create_event:
        do:
          utils.sleep:
            - seconds: 20 # replace with polling
        navigate:
          SUCCESS: remove_zombie_droplets

    - remove_zombie_droplets:
        do:
          delete_zombie_droplets:
            - time_to_live
            - name_pattern: droplet_name
            - token
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        navigate:
          SUCCESS: wait_for_remove_events
          FAILURE: REMOVE_ZOMBIE_DROPLETS_FAILURE

    - wait_for_remove_events:
        do:
          utils.sleep:
            - seconds: 20
        navigate:
          SUCCESS: list_all_droplets # replace with polling

    - list_all_droplets:
        do:
          droplets.list_all_droplets:
            - token
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - remaining_zombie_droplets: >
              filter (lambda droplet : droplet['name'] == fromInputs['droplet_name'], droplets)
        navigate:
          SUCCESS: check_droplet_was_removed
          FAILURE: LIST_ALL_DROPLETS_FAILURE

    - check_droplet_was_removed:
        do:
          strings.string_equals:
            - first_string: "'0'"
            - second_string: str(len(remaining_zombie_droplets))
        navigate:
          SUCCESS: SUCCESS
          FAILURE: CHECK_DROPLET_WAS_REMOVED_FAILURE
  results:
    - SUCCESS
    - CREATE_DROPLET_FAILURE
    - REMOVE_ZOMBIE_DROPLETS_FAILURE
    - LIST_ALL_DROPLETS_FAILURE
    - CHECK_DROPLET_WAS_REMOVED_FAILURE
