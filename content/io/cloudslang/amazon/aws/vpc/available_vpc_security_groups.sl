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
#! @input endpoint: Optional - The endpoint to which requests are sent.
#!                  Examples:  ec2.us-east-1.amazonaws.com, ec2.us-west-2.amazonaws.com, ec2.us-west-1.amazonaws.com.
#!                  Default: 'https://ec2.amazonaws.com'
#! @input identity: The Amazon Access Key ID.
#! @input credential: The Amazon Secret Access Key that corresponds to the Amazon Access Key ID.
#! @input vpc_id: Optional - The IDs of the groups that you want to describe.
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
    - endpoint:
        default: 'https://ec2.amazonaws.com'
        required: false
    - identity
    - credential:
        sensitive: true
    - vpc_id:
        required: false
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
            - endpoint: '${endpoint}'
            - identity: '${identity}'
            - credential:
                value: '${credential}'
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
          - SUCCESS: get_security_groups_array_list
          - FAILURE: on_failure
    - get_security_groups_array_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${return_result}'
            - json_path: DescribeSecurityGroupsResponse.securityGroupInfo.item
        publish:
          - array_list: '${return_result}'
        navigate:
          - SUCCESS: set_empty_list
          - FAILURE: on_failure
    - iterate_security_group_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.array_iterator:
            - array: '${array_list}'
        publish:
          - list_of_array: '${result_string}'
          - return_code
        navigate:
          - HAS_MORE: get_group_id_value
          - NO_MORE: is_list_null
          - FAILURE: on_failure
    - get_group_id_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${list_of_array}'
            - json_path: groupId
        publish:
          - group_id: '${return_result}'
        navigate:
          - SUCCESS: get_group_name_value
          - FAILURE: on_failure
    - get_group_name_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${list_of_array}'
            - json_path: groupName
        publish:
          - group_name: '${return_result}'
        navigate:
          - SUCCESS: get_group_vpc_id
          - FAILURE: on_failure
    - set_empty_list:
        do:
          io.cloudslang.base.utils.do_nothing:
            - security_empty_list: '${security_empty_list}'
        publish:
          - security_empty_list
        navigate:
          - SUCCESS: iterate_security_group_list
          - FAILURE: on_failure
    - get_group_vpc_id:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${list_of_array}'
            - json_path: vpcId
        publish:
          - vpc_id_list_value: '${return_result}'
        navigate:
          - SUCCESS: set_value_for_security_group_list
          - FAILURE: on_failure
    - set_value_for_security_group_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - group_id: '${group_id}'
            - group_name: '${group_name}'
            - vpc_id_list_value: '${vpc_id_list_value}'
        publish:
          - list_of_array_item: '${group_id + "," + group_name + ","+ vpc_id_list_value}'
        navigate:
          - SUCCESS: add_values_to_main_list
          - FAILURE: on_failure
    - add_values_to_main_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${security_empty_list}'
            - element: '${list_of_array_item}'
            - delimiter: ' '
        publish:
          - security_empty_list: '${return_result}'
        navigate:
          - SUCCESS: check_status_code
          - FAILURE: on_failure
    - check_status_code:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${return_code}'
            - second_string: '0'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: iterate_security_group_list
          - FAILURE: start_security_group_xml_tag
    - is_list_null:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${list_of_array}'
        publish:
          - list_of_array: '${variable}'
        navigate:
          - IS_NULL: start_security_group_xml_tag
          - IS_NOT_NULL: get_group_id_value
    - start_security_group_xml_tag:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - security_group_start: '<SecurityGroups>'
            - security_group_end: '</SecurityGroups>'
        publish:
          - security_group_start
          - security_group_end
        navigate:
          - SUCCESS: is_security_group_list_null
          - FAILURE: on_failure
    - list_iterator:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${security_empty_list}'
            - separator: ' '
        publish:
          - security_vpc: '${result_string}'
        navigate:
          - HAS_MORE: set_list_empty
          - NO_MORE: is_xml_empty
          - FAILURE: on_failure
    - get_group_id:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${security_vpc}'
            - delimiter: ','
            - index: '0'
        publish:
          - group_id: '${return_result}'
        navigate:
          - SUCCESS: get_group_name
          - FAILURE: on_failure
    - get_group_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${security_vpc}'
            - delimiter: ','
            - index: '1'
        publish:
          - group_name: '${return_result}'
        navigate:
          - SUCCESS: set_security_tag_value
          - FAILURE: on_failure
    - get_vpc_id_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${security_vpc}'
            - delimiter: ','
            - index: '2'
        publish:
          - vpc_value_id: '${return_result}'
        navigate:
          - SUCCESS: check_vpc_is_matching
          - FAILURE: on_failure
    - check_vpc_is_matching:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.contains:
            - container: '${vpc_id}'
            - sublist: '${vpc_value_id}'
        navigate:
          - SUCCESS: get_group_id
          - FAILURE: list_iterator
    - set_security_tag_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - group_id: '${group_id}'
            - group_name: '${group_name}'
            - security_group_empty_list: '${security_group_empty_list}'
        publish:
          - security_group_list: "${\"<SecurityGroup>\"+\"\\n\"+\"<SecurityGroupId>\"+group_id+\"</SecurityGroupId>\"+\"\\n\"+\"<SecurityGroupName>\"+group_name+\"</SecurityGroupName>\"+\"\\n\"+\"</SecurityGroup>\"}"
          - security_group_empty_list
        navigate:
          - SUCCESS: add_element_to_the_list
          - FAILURE: on_failure
    - add_element_to_the_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${security_group_empty_list}'
            - element: '${security_group_list}'
            - delimiter: "${' '+\"\\n\"}"
        publish:
          - security_group_empty_list: '${return_result}'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - set_list_empty:
        do:
          io.cloudslang.base.utils.do_nothing:
            - security_group_empty_list: '${security_group_empty_list}'
        publish:
          - security_group_empty_list
        navigate:
          - SUCCESS: get_vpc_id_value
          - FAILURE: on_failure
    - is_xml_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${security_group_empty_list}'
        navigate:
          - IS_NULL: end_security_xml_tag
          - IS_NOT_NULL: end_security_group_xml_tag
    - end_security_xml_tag:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - security_group_start: '<SecurityGroups>'
            - security_group_end: '</SecurityGroups>'
        publish:
          - security_group_xml: "${security_group_start+\"\\n\"+security_group_end}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - end_security_group_xml_tag:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - security_group_start: '<SecurityGroups>'
            - security_group_end: '</SecurityGroups>'
            - security_group_xml: '${security_group_empty_list}'
        publish:
          - security_group_xml: "${security_group_start+\"\\n\"+security_group_xml+\"\\n\"+security_group_end}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - is_security_group_list_null:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${security_empty_list}'
        publish: []
        navigate:
          - IS_NULL: end_security_xml_tag
          - IS_NOT_NULL: list_iterator
  outputs:
    - security_group_xml
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      check_status_code:
        x: 800
        'y': 440
      get_group_id:
        x: 840
        'y': 760
      check_vpc_is_matching:
        x: 680
        'y': 600
      get_group_name_value:
        x: 1120
        'y': 80
      set_list_empty:
        x: 480
        'y': 560
      set_security_tag_value:
        x: 1040
        'y': 920
      get_vpc_id_value:
        x: 480
        'y': 760
      set_empty_list:
        x: 600
        'y': 80
      list_iterator:
        x: 480
        'y': 400
      add_element_to_the_list:
        x: 240
        'y': 920
      is_xml_empty:
        x: 200
        'y': 440
      start_security_group_xml_tag:
        x: 640
        'y': 240
      is_list_null:
        x: 920
        'y': 280
      get_group_name:
        x: 1040
        'y': 720
      get_group_id_value:
        x: 960
        'y': 80
      end_security_xml_tag:
        x: 200
        'y': 280
        navigate:
          ee091afe-1085-39fa-1edc-1fc2e3742b13:
            targetId: dd23344c-e104-c471-9e35-c58c1b2645be
            port: SUCCESS
      end_security_group_xml_tag:
        x: 40
        'y': 560
        navigate:
          6d64cec8-6d1d-f98d-1ff1-b40a902e4592:
            targetId: dd23344c-e104-c471-9e35-c58c1b2645be
            port: SUCCESS
      iterate_security_group_list:
        x: 800
        'y': 80
      convert_xml_to_json:
        x: 240
        'y': 80
      get_security_groups_array_list:
        x: 400
        'y': 80
      get_group_vpc_id:
        x: 1280
        'y': 80
      set_value_for_security_group_list:
        x: 1280
        'y': 240
      is_security_group_list_null:
        x: 360
        'y': 240
      add_values_to_main_list:
        x: 1280
        'y': 440
      describe_security_groups:
        x: 40
        'y': 80
    results:
      SUCCESS:
        dd23344c-e104-c471-9e35-c58c1b2645be:
          x: 40
          'y': 280
