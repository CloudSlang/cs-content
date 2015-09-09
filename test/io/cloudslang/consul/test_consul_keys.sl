#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################

namespace: io.cloudslang.consul

imports:
  ssh: io.cloudslang.base.remote_command_execution.ssh

flow:
  name: test_consul_keys
  inputs:
    - host
    - port:
        required: false
    - username
    - password:
        required: false
    - private_key_file:
        required: false
    - key_name
    - key_value

  workflow:

    - create_key:
        do:
          create_kv:
            - host
            - key_name
            - key_value
        navigate:
          SUCCESS: get_key
          FAILURE: FAIL_CREATING_KEY
    - get_key:
        do:
          report_kv:
            - host
            - key_name
        publish:
          - create_index
          - update_index
          - lock_index
          - key
          - flags
          - value
        navigate:
          SUCCESS: delete_key
          FAILURE: FAIL_GETTING_KEY
    - delete_key:
        do:
          delete_kv:
            - host
            - key_name
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAIL_DELETING_KEY

  outputs:
    - create_index
    - update_index
    - lock_index
    - key
    - flags
    - value
  results:
    - SUCCESS
    - FAIL_STARTING_CONTAINER
    - FAIL_CREATING_KEY
    - FAIL_DELETING_KEY
    - FAIL_GETTING_KEY