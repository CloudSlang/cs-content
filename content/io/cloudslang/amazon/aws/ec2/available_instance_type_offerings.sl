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
#! @description: Describes all the instance types.
#!
#! @input provider_sap: AWS endpoint as described here: https://docs.aws.amazon.com/general/latest/gr/rande.htmlDefault: 'https://ec2.amazonaws.com'.
#! @input access_key_id: The Amazon Access Key ID.
#! @input access_key: The Amazon Secret Access Key that corresponds to the Amazon Access Key ID.
#! @input proxy_host: Optional - Proxy server used to connect to Amazon API. If empty no proxy will be used.
#! @input proxy_port: Optional - Proxy server port. You must either specify values for both proxyHost and proxyPort
#! @input proxy_username: Optional - Proxy server user name.
#! @input proxy_password: Optional - Proxy server password associated with the proxyUsername input value.
#! @input connect_timeout: Optional - The time to wait for a connection to be established.
#! @input execution_timeout: Optional - The amount of time (in milliseconds) to allow the client.
#! @input worker_group: Optional - A worker group is a logical collection of workers. A worker may belong to more thanone group simultaneously.Default: 'RAS_Operator_Path'
#!
#! @output InstanceTypeOfferingsXml: Returns all available instance types in xml form.
#!!#
########################################################################################################################
namespace: io.cloudslang.amazon.aws.ec2
flow:
  name: available_instance_type_offerings
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
    - connect_timeout:
        required: false
    - execution_timeout:
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - start_instance_type_offerings_xml_tag:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - instance_type_off_start: '<InstanceTypes>'
            - instance_type_off_stop: '</InstanceTypes>'
        publish:
          - instance_type_off_start
          - instance_type_off_stop
        navigate:
          - SUCCESS: describe_instance_type_offerings
          - FAILURE: on_failure
    - describe_instance_type_offerings:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.instances.describe_instance_type_offerings:
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
            - version: '2016-11-15'
            - connect_timeout: '${connect_timeout}'
            - execution_timeout: '${execution_timeout}'
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
          - return_result
        navigate:
          - SUCCESS: create_available_instance_types_xml
          - FAILURE: on_failure
    - create_available_instance_types_xml:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.instances.create_available_instance_types_xml:
            - json_data: '${return_result}'
        publish:
          - available_instance_types_xml: '${available_instance_types_list}'
        navigate:
          - SUCCESS: SUCCESS_1
  outputs:
    - InstanceTypeOfferingsXml: '${available_instance_types_xml}'
  results:
    - FAILURE
    - SUCCESS_1
extensions:
  graph:
    steps:
      start_instance_type_offerings_xml_tag:
        x: 80
        'y': 80
      describe_instance_type_offerings:
        x: 240
        'y': 80
      convert_xml_to_json:
        x: 400
        'y': 80
      create_available_instance_types_xml:
        x: 600
        'y': 80
        navigate:
          b5d6340a-01d0-ab49-1559-61a367aa2516:
            targetId: 72b495c6-29ae-fe49-bc81-9543091c501a
            port: SUCCESS
    results:
      SUCCESS_1:
        72b495c6-29ae-fe49-bc81-9543091c501a:
          x: 400
          'y': 280

