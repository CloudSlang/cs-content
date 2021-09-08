#   (c) Copyright 2021 Micro Focus, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: Stops an Amazon instance.
#!
#! @input access_key_id: ID of the secret access key associated with your Amazon AWS account.
#! @input access_key: Secret access key associated with your Amazon AWS account.
#! @input instance_id: The ID of the server (instance) you want to stop.
#! @input region: The name of the region.
#! @input force_stop: Forces the instances to stop. The instances do not have an opportunity to flush file system caches
#!                    or file system metadata. If you use this option, you must perform file system check and repair
#!                    procedures. This option is not recommended for Windows instances.
#!                    Default: ""
#! @input proxy_host: Proxy server used to access the provider services
#!                    Optional
#! @input proxy_port: Proxy server port used to access the provider services.
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxyUsername input value.
#!                        Optional
#! @input polling_interval: Optional - The number of seconds to wait until performing another check.
#!                          Default: 10
#! @input polling_retries: The number of retries to check if the instance is stopped.
#!                         Default: 60
#!                         Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Default: RAS_Operator_Path
#!                      Optional
#!
#! @output output: contains the state of the instance or the exception in case of failure.
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output exception: exception if there was an error when executing, empty otherwise.
#! @output instance_state: The state of a instance.
#! @output ip_address: The public IP address of the instance.
#!
#! @result SUCCESS: The server (instance) was successfully stopped
#! @result FAILURE: error stopping instance
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2
imports:
  instances: io.cloudslang.amazon.aws.ec2.instances
  xml: io.cloudslang.base.xml
  strings: io.cloudslang.base.strings
flow:
  name: aws_stop_instance_v2
  inputs:
    - access_key_id
    - access_key:
        sensitive: true
    - instance_id
    - region
    - force_stop:
        default: ' '
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - polling_interval:
        default: '10'
        required: false
    - polling_retries:
        default: '50'
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - set_endpoint:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - region: '${region}'
        publish:
          - provider_sap: '${".".join(("https://ec2",region, "amazonaws.com"))}'
        navigate:
          - SUCCESS: describe_instances
          - FAILURE: on_failure
    - stop_instances:
        do:
          instances.stop_instances:
            - endpoint: '${provider_sap}'
            - identity: '${access_key_id}'
            - credential:
                value: '${access_key}'
                sensitive: true
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - instance_ids_string: '${instance_id}'
            - force_stop: '${force_stop}'
        publish:
          - output: '${return_result}'
          - return_code
          - exception
        navigate:
          - FAILURE: on_failure
          - SUCCESS: check_instance_state_v2
    - check_instance_state_v2:
        worker_group:
          value: '${worker_group}'
          override: true
        loop:
          for: 'step in range(0, int(get("polling_retries", 50)))'
          do:
            io.cloudslang.amazon.aws.ec2.instances.check_instance_state_v2:
              - provider_sap: '${provider_sap}'
              - access_key_id: '${access_key_id}'
              - access_key:
                  value: '${access_key}'
                  sensitive: true
              - instance_id: '${instance_id}'
              - instance_state: stopped
              - proxy_host: '${proxy_host}'
              - proxy_port: '${proxy_port}'
              - proxy_username: '${proxy_username}'
              - proxy_password:
                  value: '${proxy_password}'
                  sensitive: true
              - polling_interval: '${polling_interval}'
              - worker_group: '${worker_group}'
          break:
            - SUCCESS
          publish:
            - instance_details: '${output}'
            - return_code
            - exception
        navigate:
          - SUCCESS: search_and_replace
          - FAILURE: on_failure
    - search_and_replace:
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${instance_details}'
            - text_to_replace: xmlns
            - replace_with: xhtml
        publish:
          - replaced_string
        navigate:
          - SUCCESS: parse_state
          - FAILURE: on_failure
    - parse_state:
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${instance_details}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='instanceState']/*[local-name()='name']"
            - query_type: value
        publish:
          - instance_state: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: parse_ip_address
          - FAILURE: on_failure
    - describe_instances:
        do:
          io.cloudslang.amazon.aws.ec2.instances.describe_instances:
            - endpoint: '${provider_sap}'
            - identity: '${access_key_id}'
            - credential:
                value: '${access_key}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - instance_ids_string: '${instance_id}'
        publish:
          - return_result
        navigate:
          - SUCCESS: parse_state_to_get_instance_status
          - FAILURE: on_failure
    - parse_state_to_get_instance_status:
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${return_result}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='instanceState']/*[local-name()='name']"
            - query_type: value
        publish:
          - instance_state: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: check_if_instace_is_in_stopped_state
          - FAILURE: on_failure
    - check_if_instace_is_in_stopped_state:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${instance_state}'
            - second_string: stopped
        navigate:
          - SUCCESS: set_failure_message_for_instance
          - FAILURE: stop_instances
    - set_failure_message_for_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - instance_id: '${instance_id}'
        publish:
          - output: "${\"Cannot the stop instance \\\"\"+instance_id+\"\\\" that is currently in stopped state.\"}"
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
    - parse_ip_address:
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${replaced_string}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='ipAddress']"
            - query_type: value
        publish:
          - ip_address: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: is_ip_address_not_found
          - FAILURE: on_failure
    - is_ip_address_not_found:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${ip_address}'
            - second_string: No match found
            - ignore_case: 'true'
        navigate:
          - SUCCESS: set_ip_address_empty
          - FAILURE: SUCCESS
    - set_ip_address_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing: []
        publish:
          - ip_address: ''
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - output
    - return_code
    - exception
    - instance_state
    - ip_address
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      stop_instances:
        x: 308
        'y': 90
      parse_state:
        x: 762
        'y': 93
      set_ip_address_empty:
        x: 763
        'y': 267
        navigate:
          b8e37e2e-33e1-f7de-410d-375b34699c24:
            targetId: 215a6711-9252-d04a-ab86-88ab028e3ac2
            port: SUCCESS
      parse_ip_address:
        x: 928
        'y': 95
      is_ip_address_not_found:
        x: 930
        'y': 269
        navigate:
          9427188f-a3c1-8796-e8a1-124a3e1d800b:
            targetId: 215a6711-9252-d04a-ab86-88ab028e3ac2
            port: FAILURE
      parse_state_to_get_instance_status:
        x: 162
        'y': 258
      describe_instances:
        x: 161
        'y': 84
      check_if_instace_is_in_stopped_state:
        x: 303
        'y': 259
      set_endpoint:
        x: 17
        'y': 86
      search_and_replace:
        x: 607
        'y': 92
      set_failure_message_for_instance:
        x: 303
        'y': 431
        navigate:
          7ec0c7f1-142a-1708-989e-2e69631e2d41:
            targetId: aeeb5d6a-8b41-5a45-7832-aa9cd8d27096
            port: SUCCESS
      check_instance_state_v2:
        x: 455
        'y': 92
    results:
      SUCCESS:
        215a6711-9252-d04a-ab86-88ab028e3ac2:
          x: 926
          'y': 443
      FAILURE:
        aeeb5d6a-8b41-5a45-7832-aa9cd8d27096:
          x: 459
          'y': 433

