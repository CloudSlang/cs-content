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
#! @description: Performs an Amazon Web Services Elastic Compute Cloud (EC2) command to reboot a server (instance).
#!               Requests to reboot terminated instances are ignored.
#!
#! @input access_key_id: ID of the secret access key associated with your Amazon AWS account.
#! @input access_key: Secret access key associated with your Amazon AWS account.
#! @input region: The name of the region.
#! @input instance_id: The ID of the server (instance) you want to reboot.
#! @input worker_group: Optional - A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Default: RAS_Operator_Path
#! @input proxy_host: Optional - Proxy server used to access the provider services
#! @input proxy_port: Optional - Proxy server port used to access the provider services.
#! @input proxy_username: Optional - Proxy server user name.
#! @input proxy_password: Optional - Proxy server password associated with the proxyUsername input value.
#! @input headers: Optional - String containing the headers to use for the request separated by new line (CRLF).
#!                 The headername-value pair will be separated by ":".
#!                 Format: Conforming with HTTP standard for headers (RFC 2616).
#!                 Examples: "Accept:text/plain"
#! @input query_params: Optional - String containing query parameters that will be appended to the URL.
#!                      The separatorbetween name-value pairs is "&" symbol.
#!                      The query name will be separated from query value by "=".
#!                      Examples: "parameterName1=parameterValue1&parameterName2=parameterValue2".
#! @input polling_interval: Optional - The number of seconds to wait until performing another check.
#!                          Default: 10
#! @input polling_retries: Optional - The number of retries to check if the instance is stopped.
#!                         Default: 60
#!
#! @output output: Contains the state of the instance or the exception in case of failure
#! @output ip_address: The public IP address of the instance
#! @output instance_state: The state of a instance.
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise
#! @output exception: Exception if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: The server (instance) was successfully rebooted
#! @result FAILURE: error rebooting instance
#!!#
########################################################################################################################

namespace: checkin
imports:
  instances: io.cloudslang.amazon.aws.ec2.instances
  xml: io.cloudslang.base.xml
  strings: io.cloudslang.base.strings
flow:
  name: reboot_instance_v2
  inputs:
    - access_key_id
    - access_key:
        sensitive: true
    - region
    - instance_id
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
          - SUCCESS: reboot_instances
          - FAILURE: on_failure
    - reboot_instances:
        worker_group: '${worker_group}'
        do:
          instances.reboot_instances:
            - endpoint: '${provider_sap}'
            - identity: '${access_key_id}'
            - credential:
                value: '${access_key}'
                sensitive: true
            - instance_ids_string: '${instance_id}'
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - headers
            - query_params
        publish:
          - output: '${return_result}'
          - return_code
          - exception
        navigate:
          - FAILURE: check_if_instace_is_in_stopped_state
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
              - instance_state: running
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
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - check_if_instace_is_in_stopped_state:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${return_code}'
            - second_string: '-1'
        navigate:
          - SUCCESS: parse_failure_message
          - FAILURE: on_failure
    - parse_failure_message:
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${output}'
            - xpath_query: "/*[local-name()='Response']/*[local-name()='Errors']/*[local-name()='Error']/*[local-name()='Message']"
            - query_type: value
        publish:
          - output: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
  outputs:
    - output
    - ip_address
    - instance_state
    - return_code
    - exception
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      set_endpoint:
        x: 5
        'y': 83
      reboot_instances:
        x: 113
        'y': 82
      check_instance_state_v2:
        x: 220
        'y': 80
      search_and_replace:
        x: 375
        'y': 80
      parse_state:
        x: 528
        'y': 88
      parse_ip_address:
        x: 678
        'y': 91
        navigate:
          eacd4405-0136-6257-3102-4e1e14085e5b:
            targetId: 19717164-3739-f1dd-5e35-b13b3541f103
            port: SUCCESS
      check_if_instace_is_in_stopped_state:
        x: 109
        'y': 246
      parse_failure_message:
        x: 245
        'y': 248
        navigate:
          3edf1540-2fe9-a8bf-5041-f875b074c5b7:
            targetId: 82a03499-9235-5958-aace-7f41fbc36899
            port: SUCCESS
    results:
      SUCCESS:
        19717164-3739-f1dd-5e35-b13b3541f103:
          x: 866
          'y': 92
      FAILURE:
        82a03499-9235-5958-aace-7f41fbc36899:
          x: 380
          'y': 252
