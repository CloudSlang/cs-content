#   (c) Copyright 2022 Micro Focus, L.P.
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
#! @description: Describes the information about each security groups.
#!
#! @input provider_sap: AWS endpoint as described here: https://docs.aws.amazon.com/general/latest/gr/rande.html
#!                      Default: 'https://ec2.amazonaws.com'.
#! @input access_key_id: ID of the secret access key associated with your Amazon AWS account.
#! @input access_key: Secret access key associated with your Amazon AWS account.
#! @input vpc_id: The IDs of the groups that you want to describe.
#! @input proxy_host: Optional - Proxy server used to connect to Amazon API. If empty no proxy will be used.
#! @input proxy_port: Optional - Proxy server port. You must either specify values for both proxyHost and proxyPort
#!                    inputs or leave them both empty.
#! @input proxy_username: Optional - Proxy server user name.
#! @input proxy_password: Optional - Proxy server password associated with the proxyUsername input value.
#! @input worker_group: Optional - A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output security_group_xml: Returns information of security groups.
#!!#
########################################################################################################################
namespace: io.cloudslang.amazon.aws.vpc

flow:
  name: available_vpc_security_groups
  inputs:
    - provider_sap:
        default: 'https://ec2.amazonaws.com'
        required: true
    - access_key_id
    - access_key:
        sensitive: true
    - vpc_id:
        required: true
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - describe_security_groups:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.securitygroups.describe_security_groups:
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
        publish:
          - return_result
        navigate:
          - SUCCESS: convert_xml_to_json
          - FAILURE: on_failure
    - convert_xml_to_json:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.convert_xml_to_json:
            - xml: '${return_result}'
        publish:
          - return_code
          - return_result
        navigate:
          - SUCCESS: get_vpc_security_list
          - FAILURE: on_failure
    - get_vpc_security_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.vpc.get_vpc_security_list:
            - json_data: '${return_result}'
            - vpc_id: '${vpc_id}'
        publish:
          - security_group_xml: '${vpc_security_list}'
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - security_group_xml
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      describe_security_groups:
        x: 40
        'y': 80
      convert_xml_to_json:
        x: 200
        'y': 80
      get_vpc_security_list:
        x: 360
        'y': 80
        navigate:
          dea72b6b-f3f2-5501-1369-5bbb2791b7ef:
            targetId: dd23344c-e104-c471-9e35-c58c1b2645be
            port: SUCCESS
    results:
      SUCCESS:
        dd23344c-e104-c471-9e35-c58c1b2645be:
          x: 560
          'y': 80
