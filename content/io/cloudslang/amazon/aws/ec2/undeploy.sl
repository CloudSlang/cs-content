#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
#!!
#! @input identity: ID of the secret access key associated with your Amazon AWS account.
#! @input credential: Secret access key associated with your Amazon AWS account.
#! @input proxy_host: Proxy server used to access the provider services.
#! @input proxy_port: Proxy server port used to access the provider services - Default: '8080'
#! @input proxy_username: Proxy server user name.
#! @input proxy_password: Proxy server password associated with the proxyUsername input value.
#! @input headers: String containing the headers to use for the request separated by new line (CRLF). The header
#!                 name-value pair will be separated by ":". Format: Conforming with HTTP standard for headers (RFC 2616).
#!                 Examples: "Accept:text/plain"
#! @input instance_id: The ID of the instance to be terminated.
#! @input attachment_id: The attachment ID generated when the network interface was attached to the instance.
#! @input force_detach: Specifies whether to force a detachment or not. Valid values: "true", "false". Default: "false"
#! @input polling_interval: The number of seconds to wait until performing another check. Default: 10
#! @input polling_retries: The number of retries to check if the instance is stopped. Deafult: 50
#! @output output: contains the success message or the exception in case of failure
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise
#! @output exception: Exception if there was an error when executing, empty otherwise
#! @result FAILURE: error terminating instance
#! @result SUCCESS: the server (instance) was successfully terminated
#!!#
namespace: io.cloudslang.amazon.aws.ec2
flow:
  name: undeploy
  inputs:
    - identity
    - credential
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - headers:
        required: false
    - instance_id
    - attachment_id
    - force_detach:
        required: false
    - polling_interval:
        required: false
    - polling_retries:
        required: false
  workflow:
    - detach_network_interface:
        do:
          io.cloudslang.amazon.aws.ec2.network.detach_network_interface:
            - identity: '${identity}'
            - credential: '${credential}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - attachment_id: '${attachment_id}'
            - force_detach: '${force_detach}'
        publish:
          - return_result: '${return_result}'
          - return_code: '${return_code}'
          - exception: '${exception}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: terminate_instances
    - terminate_instances:
        do:
          io.cloudslang.amazon.aws.ec2.instances.terminate_instances:
            - identity: '${identity}'
            - credential: '${credential}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - headers: '${headers}'
            - instance_id: '${instance_id}'
        publish:
          - return_result: '${return_result}'
          - return_code: '${return_code}'
          - exception: '${exception}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: check_instance_state
    - check_instance_state:
        loop:
          for: 'step in range(0, int(get("polling_retries", 50)))'
          do:
            io.cloudslang.amazon.aws.ec2.instances.check_instance_state:
              - identity: '${identity}'
              - credential: '${credential}'
              - proxy_host: '${proxy_host}'
              - proxy_port: '${proxy_port}'
              - instance_id: '${instance_id}'
              - instance_state: terminated
              - polling_interval: '${polling_interval}'
          break:
            - SUCCESS
          publish:
            - return_result: '${output}'
            - return_code: '${return_code}'
            - exception: '${exception}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: delete_network_interface
    - delete_network_interface:
        do:
          io.cloudslang.amazon.aws.ec2.network.delete_network_interface:
            - identity: '${identity}'
            - credential: '${credential}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - headers: '${headers}'
            - network_interface_id: '${network_interface_query_params}'
        publish:
          - return_result: '${return_result}'
          - return_code: '${return_code}'
          - exception: '${exception}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: SUCCESS
  outputs:
    - output: '${return_result}'
    - return_code: '${return_code}'
    - exception: '${exception}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      terminate_instances:
        x: 286
        y: 75
        navigate:
          1ef74747-b11f-1306-de18-f2321d46e5b3:
            targetId: e7e52e5e-c856-c253-0b31-ba3c203fc09c
            port: FAILURE
      detach_network_interface:
        x: 108
        y: 73
        navigate:
          59a1a349-51ac-e525-7d0b-0e60237a161b:
            targetId: e7e52e5e-c856-c253-0b31-ba3c203fc09c
            port: FAILURE
      check_instance_state:
        x: 534
        y: 70
        navigate:
          4fd4daaf-1439-17f4-6af8-80a97d551e2a:
            targetId: e7e52e5e-c856-c253-0b31-ba3c203fc09c
            port: FAILURE
      delete_network_interface:
        x: 528
        y: 279
        navigate:
          71dc9147-e034-df5d-e070-5fd81e00d152:
            targetId: e7e52e5e-c856-c253-0b31-ba3c203fc09c
            port: FAILURE
          0b21c11e-b292-66ef-04a7-322c27a43742:
            targetId: fe398880-3566-1a85-745a-1e92972bf3f7
            port: SUCCESS
    results:
      FAILURE:
        e7e52e5e-c856-c253-0b31-ba3c203fc09c:
          x: 286
          y: 292
      SUCCESS:
        fe398880-3566-1a85-745a-1e92972bf3f7:
          x: 754
          y: 286