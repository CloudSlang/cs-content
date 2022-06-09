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
#! @description: Describes the all key pairs.
#!
#! @input provider_sap: AWS endpoint as described here: https://docs.aws.amazon.com/general/latest/gr/rande.html
#!                      Default: 'https://ec2.amazonaws.com'.
#! @input access_key_id: ID of the secret access key associated with your Amazon AWS account.
#! @input access_key: Secret access key associated with your Amazon AWS account.
#! @input proxy_host: Optional - Proxy server used to connect to Amazon API. If empty no proxy will be used.
#! @input proxy_port: Optional - Proxy server port. You must either specify values for both proxyHost and proxyPort
#! @input proxy_username: Optional - Proxy server user name.
#! @input proxy_password: Optional - Proxy server password associated with the proxyUsername input value.
#! @input worker_group: Optional - A worker group is a logical collection of workers.
#!                      A worker may belong to more than one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output key_pair_xml: Returns information of each key-pair.
#!!#
########################################################################################################################
namespace: io.cloudslang.amazon.ec2
flow:
  name: available_key_pairs
  inputs:
    - provider_sap:
        default: 'https://ec2.amazonaws.com'
        required: true
    - access_key_id
    - access_key:
        sensitive: true
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
    - describe_key_pairs:
        do:
          io.cloudslang.amazon.aws.ec2.keypairs.describe_key_pairs:
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
          - describe_key_pairs: '${return_result}'
        navigate:
          - SUCCESS: convert_xml_to_json_describe_key_pairs
          - FAILURE: on_failure
    - convert_xml_to_json_describe_key_pairs:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.convert_xml_to_json:
            - xml: '${describe_key_pairs}'
        publish:
          - describe_key_pairs: '${return_result}'
        navigate:
          - SUCCESS: get_key_pair_list
          - FAILURE: on_failure
    - get_key_pair_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.keypairs.get_key_pair_list:
            - json_data: '${describe_key_pairs}'
        publish:
          - key_pair_xml: '${key_pair_list}'
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - key_pair_xml
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      describe_key_pairs:
        x: 40
        'y': 80
      convert_xml_to_json_describe_key_pairs:
        x: 160
        'y': 80
      get_key_pair_list:
        x: 320
        'y': 80
        navigate:
          b969a592-d4f1-bc2a-843c-c67c3675ea68:
            targetId: 6a2f91a0-1742-9970-7842-0fa4695e592d
            port: SUCCESS
    results:
      SUCCESS:
        6a2f91a0-1742-9970-7842-0fa4695e592d:
          x: 480
          'y': 80

