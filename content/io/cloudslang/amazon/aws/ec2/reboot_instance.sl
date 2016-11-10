#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Performs an Amazon Web Services Elastic Compute Cloud (EC2) command to reboot a server (instance).
#!               Requests to reboot terminated instances are ignored.
#!
#! @input identity: ID of the secret access key associated with your Amazon AWS account.
#! @input credential: Secret access key associated with your Amazon AWS account.
#! @input proxy_host: Proxy server used to access the provider services
#! @input proxy_port: Proxy server port used to access the provider services
 #!                   Default: '8080'
#! @input proxy_username: Proxy server user name.
#! @input proxy_password: Proxy server password associated with the proxyUsername input value.
#! @input headers: String containing the headers to use for the request separated by new line (CRLF). The header
#!                 name-value pair will be separated by ":". Format: Conforming with HTTP standard for headers (RFC 2616).
#!                 Examples: "Accept:text/plain"
#! @input query_params: String containing query parameters that will be appended to the URL. The names and the values
#!                      must not be URL encoded because if they are encoded then a double encoded will occur. The separator
#!                      between name-value pairs is "&" symbol. The query name will be separated from query value by "=".
#!                      Examples: "parameterName1=parameterValue1&parameterName2=parameterValue2"
#! @input instance_id: The ID of the server (instance) you want to reboot
#! @input region: Region where the server (instance) is.
#!                Default: 'us-east-1'
#! @input polling_interval: The number of seconds to wait until performing another check.
#!                          Default: 10
#! @input polling_retries: The number of retries to check if the instance is stopped.
#!                         Default: 50
#!
#! @output output: contains the success message or the exception in case of failure
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise
#! @output exception: exception if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: the server (instance) was successfully rebooted
#! @result FAILURE: error rebooting instance
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2

imports:
  instances: io.cloudslang.amazon.aws.ec2.instances

flow:
  name: reboot_instance
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
    - headers:
        required: false
    - query_params:
        required: false
    - instance_id:
        required: true
    - region:
        required: false
    - polling_interval:
        required: false
    - polling_retries:
        required: false

  workflow:
    - reboot_instances:
        do:
          instances.reboot_instances:
            - identity
            - credential
            - instance_ids_string: '${instance_id}'
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - headers
            - query_params
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: check_instance_state

    - check_instance_state:
        loop:
          for: 'step in range(0, int(get("polling_retries", 50)))'
          do:
            instances.check_instance_state:
              - identity
              - credential
              - instance_id
              - instance_state: running
              - proxy_host
              - proxy_port
              - region
              - polling_interval
          break:
            - SUCCESS
          publish:
            - return_result: '${output}'
            - return_code
            - exception
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS

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
      reboot_instances:
        x: 74
        y: 73
        navigate:
          19eed9a4-7b57-5201-6bdf-317af7f1fe7e:
            targetId: 48574ded-e846-247a-6c11-2497265849aa
            port: FAILURE
      check_instance_state:
        x: 317
        y: 70
        navigate:
          3654941e-a894-e960-e463-1b2b8315697d:
            targetId: 6912f217-4cd7-11c7-8f89-428022b6558c
            port: SUCCESS
          4342a1f4-3721-15c1-d70a-586df655fa47:
            targetId: 48574ded-e846-247a-6c11-2497265849aa
            port: FAILURE
    results:
      SUCCESS:
        6912f217-4cd7-11c7-8f89-428022b6558c:
          x: 560
          y: 74
      FAILURE:
        48574ded-e846-247a-6c11-2497265849aa:
          x: 206
          y: 218