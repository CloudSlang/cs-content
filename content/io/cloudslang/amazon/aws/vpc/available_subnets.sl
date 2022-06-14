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
#! @description: Describes the information about each subnets.
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
#! @output subnets_xml: Describes the information of each subnets.
#!!#
########################################################################################################################
namespace: io.cloudslang.amazon.aws.vpc

flow:
  name: available_subnets
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
        sensitive: true
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - describe_subnets:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.vpc.subnets.describe_subnets:
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
          - SUCCESS: get_subnet_list
          - FAILURE: on_failure
    - get_subnet_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.vpc.subnets.get_subnet_list:
            - json_data: '${return_result}'
            - vpc_id: '${vpc_id}'
        publish:
          - subnets_xml: '${subnet_list}'
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - subnets_xml
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      describe_subnets:
        x: 40
        'y': 80
      convert_xml_to_json:
        x: 200
        'y': 80
      get_subnet_list:
        x: 360
        'y': 80
        navigate:
          6ef4378f-b5c2-c8cc-e21e-c13366cca540:
            targetId: d7f17f21-e4cc-777b-4c0a-65c183594863
            port: SUCCESS
    results:
      SUCCESS:
        d7f17f21-e4cc-777b-4c0a-65c183594863:
          x: 560
          'y': 80
