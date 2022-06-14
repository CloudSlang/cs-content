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
          - SUCCESS: get_describe_instance_type_offerings_array_list
          - FAILURE: on_failure
    - get_describe_instance_type_offerings_array_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${return_result}'
            - json_path: DescribeInstanceTypeOfferingsResponse.instanceTypeOfferingSet.item
        publish:
          - array_list: '${return_result}'
        navigate:
          - SUCCESS: is_list_null
          - FAILURE: on_failure
    - iterate_instance_type_offerings:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.array_iterator:
            - array: '${array_list}'
        publish:
          - list_of_array: '${result_string}'
          - return_code
        navigate:
          - HAS_MORE: get_vm_size_name
          - NO_MORE: end_instance_type_xml_tag
          - FAILURE: on_failure
    - is_list_null:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${array_list}'
        publish:
          - array_list: '${variable}'
        navigate:
          - IS_NULL: end_instance_type_xml_tag
          - IS_NOT_NULL: iterate_instance_type_offerings
    - get_vm_size_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${list_of_array}'
            - json_path: instanceType
        publish:
          - vm_size_name: '${return_result}'
        navigate:
          - SUCCESS: set_xml_tags
          - FAILURE: on_failure
    - set_xml_tags:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - vm_size_name: '${vm_size_name}'
        publish:
          - vm_size_name: "${\"<instanceType>\"+\"\\n\"+\"<Name>\"+vm_size_name+\"</Name>\"+\"\\n\"+\"</instanceType>\"}"
        navigate:
          - SUCCESS: set_empty_list_xml
          - FAILURE: on_failure
    - set_empty_list_xml:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - instance_type_final_xml: '${instance_type_final_xml}'
        publish:
          - instance_type_final_xml
        navigate:
          - SUCCESS: add_element
          - FAILURE: on_failure
    - add_element:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${instance_type_final_xml}'
            - element: '${vm_size_name}'
            - delimiter: "${' '+\"\\n\"}"
        publish:
          - instance_type_final_xml: '${return_result}'
        navigate:
          - SUCCESS: iterate_instance_type_offerings
          - FAILURE: on_failure
    - end_instance_type_xml_tag:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - instance_type_off_start: '${instance_type_off_start}'
            - instance_type_off_stop: '${instance_type_off_stop}'
            - instance_type_final_xml: '${instance_type_final_xml}'
        publish:
          - instancetypesxml: "${instance_type_off_start+\"\\n\"+instance_type_final_xml+\"\\n\"+instance_type_off_stop}"
        navigate:
          - SUCCESS: SUCCESS_1
          - FAILURE: on_failure
  outputs:
    - InstanceTypeOfferingsXml: '${instancetypesxml}'
  results:
    - FAILURE
    - SUCCESS_1
extensions:
  graph:
    steps:
      set_empty_list_xml:
        x: 1040
        'y': 280
      start_instance_type_offerings_xml_tag:
        x: 80
        'y': 80
      get_vm_size_name:
        x: 1040
        'y': 80
      iterate_instance_type_offerings:
        x: 880
        'y': 80
      end_instance_type_xml_tag:
        x: 560
        'y': 280
        navigate:
          bc707cb8-5440-f329-fec5-314a179054e5:
            targetId: 72b495c6-29ae-fe49-bc81-9543091c501a
            port: SUCCESS
      is_list_null:
        x: 720
        'y': 80
      convert_xml_to_json:
        x: 400
        'y': 80
      get_describe_instance_type_offerings_array_list:
        x: 560
        'y': 80
      add_element:
        x: 880
        'y': 280
      describe_instance_type_offerings:
        x: 240
        'y': 80
      set_xml_tags:
        x: 1160
        'y': 80
    results:
      SUCCESS_1:
        72b495c6-29ae-fe49-bc81-9543091c501a:
          x: 400
          'y': 280
