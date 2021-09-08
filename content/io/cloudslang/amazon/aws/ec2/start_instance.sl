#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: Performs an Amazon Web Services Elastic Compute Cloud (EC2) command to start a STOPPED server (instance)
#!               and changes its status to ACTIVE. PAUSED and SUSPENDED servers (instances) cannot be started.
#!
#! @input identity: ID of the secret access key associated with your Amazon AWS account.
#! @input credential: Secret access key associated with your Amazon AWS account.
#! @input proxy_host: Proxy server used to access the provider services
#! @input proxy_port: Proxy server port used to access the provider services
#!                    Default: '8080'
#! @input proxy_username: Proxy server user name.
#! @input proxy_password: Proxy server password associated with the proxyUsername input value.
#! @input headers: String containing the headers to use for the request separated by new line (CRLF). The header
#!                 name-value pair will be separated by ":". Format: Conforming with HTTP standard for headers (RFC 2616).
#!                 Examples: "Accept:text/plain"
#! @input query_params: String containing query parameters that will be appended to the URL. The names and the values
#!                      must not be URL encoded because if they are encoded then a double encoded will occur. The
#!                      separator between name-value pairs is "&" symbol. The query name will be separated from query
#!                      value by "=".
#!                      Examples: "parameterName1=parameterValue1&parameterName2=parameterValue2"
#! @input instance_id: The ID of the server (instance) you want to start.
#! @input polling_interval: The number of seconds to wait until performing another check.
#!                          Default: 10
#! @input polling_retries: The number of retries to check if the instance is stopped.
#!                         Default: 50
#!
#! @output output: contains the state of the instance or the exception in case of failure
#! @output ip_address: The public IP address of the instance
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise
#! @output exception: exception if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: The server (instance) was successfully started
#! @result FAILURE: error starting instance
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2

imports:
  instances: io.cloudslang.amazon.aws.ec2.instances
  xml: io.cloudslang.base.xml
  strings: io.cloudslang.base.strings

flow:
  name: start_instance
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
    - instance_id
    - polling_interval:
        required: false
    - polling_retries:
        required: false

  workflow:
    - start_instances:
        do:
          instances.start_instances:
            - identity
            - credential
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - headers
            - query_params
            - instance_ids_string: '${instance_id}'
        publish:
          - output: '${return_result}'
          - return_code
          - exception
        navigate:
          - SUCCESS: check_instance_state
          - FAILURE: on_failure

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
              - proxy_username
              - proxy_password
              - polling_interval
          break:
            - SUCCESS
          publish:
            - output
            - return_code
            - exception
        navigate:
          - SUCCESS: search_and_replace
          - FAILURE: on_failure

    - search_and_replace:
        do:
          strings.search_and_replace:
            - origin_string: '${output}'
            - text_to_replace: xmlns
            - replace_with: xhtml
        publish:
          - replaced_string
        navigate:
          - SUCCESS: parse_state
          - FAILURE: on_failure

    - parse_state:
        do:
          xml.xpath_query:
              - xml_document: ${replaced_string}
              - xpath_query: >
                  ${'"/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']' +
                  '/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']' +
                  '/*[local-name()='instanceState']/*[local-name()='name']"')
              - query_type: 'value'
        publish:
            - output: '${selected_value}'
            - return_code
        navigate:
          - SUCCESS: parse_ip_address
          - FAILURE: on_failure

    - parse_ip_address:
        do:
          xml.xpath_query:
            - xml_document: '${replaced_string}'
            - xpath_query: >
                ${'"/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']' +
                '/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']' +
                '/*[local-name()='ipAddress']"'}
            - query_type: 'value'
        publish:
          - ip_address: '${selected_value}'
          - return_result: '${return_result}'
          - error_message: '${error_message}'
          - return_code: '${return_code}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure

  outputs:
    - output
    - ip_address
    - return_code
    - exception

  results:
    - SUCCESS
    - FAILURE
