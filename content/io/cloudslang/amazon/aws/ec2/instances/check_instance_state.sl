#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: It checks if an instance has a specific state.
#!
#! @input identity: ID of the secret access key associated with your Amazon AWS account.
#! @input credential: Secret access key associated with your Amazon AWS account.
#! @input proxy_host: Proxy server used to access the provider services
#! @input proxy_port: Proxy server port used to access the provider services
#!                    Default: '8080'
#! @input proxy_username: optional - proxy server user name.
#!                        Default: ""
#! @input proxy_password: optional - proxy server password associated with the <proxyUsername>
#!                        input value.
#!                        Default: ""
#! @input instance_id: The ID of the server (instance) you want to check.
#! @input instance_state: The state that you would like the instance to have.
#! @input polling_interval: The number of seconds to wait until performing another check.
#!                          Default: 10
#!
#! @output output: contains the success message or the exception in case of failure
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise
#! @output exception: exception if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: the server (instance) has the expected state
#! @result FAILURE: error checking the instance state, or the actual state is not the expected one
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.instances

imports:
  instances: io.cloudslang.amazon.aws.ec2.instances
  strings: io.cloudslang.base.strings
  utils: io.cloudslang.base.utils

flow:
  name: check_instance_state

  inputs:
    - identity
    - credential:
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - instance_id
    - instance_state
    - polling_interval:
        required: false

  workflow:
    - describe_instances:
        do:
          instances.describe_instances:
            - identity
            - credential
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - instance_ids_string: ${instance_id}
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: string_occurrence_counter
          - FAILURE: FAILURE

    - string_occurrence_counter:
        do:
          strings.string_occurrence_counter:
            - string_in_which_to_search: '${return_result}'
            - string_to_find: "${instance_state}"
        publish: []
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: sleep

    - sleep:
        do:
          utils.sleep:
            - seconds: "${get('polling_interval', '10')}"
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: FAILURE

  outputs:
    - output: '${return_result}'
    - return_code
    - exception

  results:
    - SUCCESS
    - FAILURE

extensions:
  graph:
    steps:
      describe_instances:
        x: 109
        y: 74
        navigate:
          6082fa29-9559-a046-0cc2-5df0f2e75bff:
            targetId: 0245819c-4f19-554f-5084-4546770f9f8b
            port: FAILURE
      string_occurrence_counter:
        x: 354
        y: 74
        navigate:
          a5c197ca-6c36-3e36-0a37-65bdf1e147f4:
            targetId: 780c13a5-3f6d-b50f-a3d8-db8a31c7a3f3
            port: SUCCESS
      sleep:
        x: 352
        y: 273
        navigate:
          e73d4ad5-cdb5-a6e0-af52-bdc5667b2bbb:
            targetId: 0245819c-4f19-554f-5084-4546770f9f8b
            port: FAILURE
          31cd0892-7527-9ce8-42ec-7bf9decde27f:
            targetId: 0245819c-4f19-554f-5084-4546770f9f8b
            port: SUCCESS
    results:
      SUCCESS:
        780c13a5-3f6d-b50f-a3d8-db8a31c7a3f3:
          x: 576
          y: 75
      FAILURE:
        0245819c-4f19-554f-5084-4546770f9f8b:
          x: 104
          y: 273