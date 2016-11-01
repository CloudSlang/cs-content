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
#! @input subnet_id: The ID of the subnet to associate with network interface
#! @input network_interface_query_params: String containing query parameters regarding the network interface that will
#!                                        be created in order to be attached to instance. These parameters will be appended
#!                                        to the URL, but the names and the values must not be URL encoded because if
#!                                        they are encoded then a double encoded will occur. The separator between
#!                                        name-value pairs is "&" symbol. The query name will be separated from query
#!                                        value by "=".
#!                                        Examples: "parameterName1=parameterValue1&parameterName2=parameterValue2"
#! @input image_id: ID of the AMI, which you can get by calling <DescribeImages>.
#!                  For more information go to: http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ComponentsAMIs.html Example: "ami-abcdef12"
#! @input instance_query_params: String containing query parameters regarding the instance. These parameters will be
#!                               appended to the URL, but the names and the values must not be URL encoded because if
#!                               they are encoded then a double encoded will occur. The separator between name-value
#!                               pairs is "&" symbol. The query name will be separated from query value by "=".
#!                               Examples: "parameterName1=parameterValue1&parameterName2=parameterValue2"
#! @input device_index: Index of the device for the network interface attachment on the instance. Example: "1"
#! @input key_tags_string: String that contains one or more key tags separated by delimiter. Constraints: Tag keys are
#!                         case-sensitive and accept a maximum of 127 Unicode characters. May not begin with "aws:";
#!                         Each resource can have a maximum of 50 tags. Note: if you want to overwrite the existing tag
#!                         and replace it with empty value then specify the parameter with "Not relevant" string.
#!                         Example: "Name,webserver,stack,scope" Default: ""
#! @input value_tags_string: String that contains one or more tag values separated by delimiter. The value parameter is
#!                           required, but if you don't want the tag to have a value, specify the parameter with
#!                           "Not relevant" string, and we set the value to an empty string. Constraints: Tag values are
#!                           case-sensitive and accept a maximum of 255 Unicode characters; Each resource can have a
#!                           maximum of 50 tags.
#!                           Example of values string for tagging resources with values corresponding to the keys from above example:
#!                           "Tagged from API call,Not relevant,Testing,For testing purposes"
#!                           Default: ""
#! @input polling_interval: The number of seconds to wait until performing another check. Default: 10
#! @input polling_retries: The number of retries to check if the instance is stopped. Deafult: 50
#! @output instance_id: The ID of the newly created instance
#! @output network_interface_id: The ID of the newly created network interface attached to the instance
#! @output attachment_id: The ID resulted after the network interface is attached to the instance
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise
#! @output exception: Exception if there was an error when executing, empty otherwise
#! @result FAILURE: error deploying instance
#! @result SUCCESS: the server (instance) was successfully deployed
#!!#
namespace: io.cloudslang.amazon.aws.ec2
flow:
  name: deploy_instance
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
    - subnet_id:
        required: true
    - network_interface_query_params:
        required: true
    - image_id
    - instance_query_params
    - device_index
    - key_tags_string
    - value_tags_string
    - polling_interval:
        required: false
    - polling_retries:
        required: false
  workflow:
    - create_network_interface:
        do:
          io.cloudslang.amazon.aws.ec2.network.create_network_interface:
            - identity: '${identity}'
            - subnet_id: '${subnet_id}'
            - credential: '${credential}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - headers: '${headers}'
            - query_params: '${query_params}'
        publish:
          - return_result
          - return_code: '${return_code}'
          - exception: '${exception}'
          - network_interface_id: '${network_interface_id_result}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: run_instances
    - run_instances:
        do:
          io.cloudslang.amazon.aws.ec2.instances.run_instances:
            - endpoint: 'https://ec2.amazonaws.com'
            - identity: '${identity}'
            - credential: '${credential}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - headers: '${headers}'
            - query_params: '${instance_query_params}'
            - image_id: '${image_id}'
        publish:
          - return_result
          - return_code: '${return_code}'
          - exception: '${exception}'
          - instance_id: '${instance_id_result}'
        navigate:
          - FAILURE: delete_network_interface
          - SUCCESS: check_instance_state
    - attach_network_interface:
        do:
          io.cloudslang.amazon.aws.ec2.network.attach_network_interface:
            - identity: '${identity}'
            - credential: '${credential}'
            - network_interface_id: '${network_interface_id}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - instance_id: '${instance_id}'
            - headers: '${headers}'
            - device_index: '${device_index}'
        publish:
          - return_result: '${return_result}'
          - return_code: '${return_code}'
          - exception: '${exception}'
          - attachement_id: '${attachement_id_result}'
        navigate:
          - FAILURE: terminate_instances
          - SUCCESS: create_tags
    - delete_network_interface:
        loop:
          for: 'step in range(0, int(get("polling_retries", 50)))'
          do:
            io.cloudslang.amazon.aws.ec2.network.delete_network_interface:
              - identity: '${identity}'
              - credential: '${credential}'
              - proxy_host: '${proxy_host}'
              - proxy_port: '${proxy_port}'
              - proxy_username: '${proxy_username}'
              - proxy_password: '${proxy_password}'
              - headers: '${headers}'
              - network_interface_id: '${network_interface_id}'
          break:
            - SUCCESS
          publish:
            - return_result: '${return_result}'
            - return_code: '${return_code}'
            - exception: '${exception}'
        navigate:
          - FAILURE: FAILURE
          - SUCCESS: FAILURE
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
              - instance_state: running
              - polling_interval: '${polling_interval}'
          break:
            - SUCCESS
          publish:
            - return_result: '${output}'
            - return_code: '${return_code}'
            - exception: '${exception}'
        navigate:
          - FAILURE: terminate_instances
          - SUCCESS: attach_network_interface
    - terminate_instances:
        loop:
          for: 'step in range(0, int(get("polling_retries", 50)))'
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
          break:
            - SUCCESS
          publish:
            - return_result: '${return_result}'
            - return_code: '${return_code}'
            - exception: '${exception}'
        navigate:
          - FAILURE: delete_network_interface
          - SUCCESS: check_instance_state_1
    - check_instance_state_1:
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
          - FAILURE: delete_network_interface
          - SUCCESS: delete_network_interface
    - create_tags:
        do:
          io.cloudslang.amazon.aws.ec2.tags.create_tags:
            - identity: '${identity}'
            - credential: '${credential}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - resource_ids_string: '${instance_id}'
            - key_tags_string: '${key_tags_string}'
            - value_tags_string: '${value_tags_string}'
        publish:
          - return_result: '${return_result}'
          - return_code: '${return_code}'
          - exception: '${exception}'
        navigate:
          - FAILURE: terminate_instances
          - SUCCESS: SUCCESS
  outputs:
    - instance_id: '${instance_id}'
    - network_interface_id: '${network_interface_id}'
    - attachment_id: '${attachement_id}'
    - return_code: '${return_code}'
    - exception: '${exception}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      create_network_interface:
        x: 89
        y: 73
        navigate:
          016f586e-7f10-6eca-9345-fd2189c41b61:
            targetId: ec31434a-1b02-4c0f-72c2-ee53bdf9744f
            port: FAILURE
      run_instances:
        x: 323
        y: 69
      attach_network_interface:
        x: 776
        y: 70
      delete_network_interface:
        x: 313
        y: 450
        navigate:
          632b90c1-0e37-8d65-1179-cbc17b12e00f:
            targetId: ec31434a-1b02-4c0f-72c2-ee53bdf9744f
            port: SUCCESS
          23fc18cd-2637-dbb7-2723-9d936ab0b4d8:
            targetId: ec31434a-1b02-4c0f-72c2-ee53bdf9744f
            port: FAILURE
      check_instance_state:
        x: 530
        y: 71
      terminate_instances:
        x: 517
        y: 248
      check_instance_state_1:
        x: 511
        y: 450
      create_tags:
        x: 771
        y: 252
        navigate:
          f1cde31b-5b33-371e-d2f8-c802b744739f:
            targetId: 3daeaee4-40c0-5e5e-b244-7c7bed391de6
            port: SUCCESS
    results:
      FAILURE:
        ec31434a-1b02-4c0f-72c2-ee53bdf9744f:
          x: 83
          y: 447
      SUCCESS:
        3daeaee4-40c0-5e5e-b244-7c7bed391de6:
          x: 764
          y: 456