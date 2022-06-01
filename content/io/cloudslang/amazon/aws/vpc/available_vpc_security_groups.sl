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
    - is_list_null:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${list_of_array}'
        publish:
          - list_of_array: '${variable}'
        navigate:
          - IS_NULL: end_security_group_xml_tag
          - IS_NOT_NULL: get_group_id_value
    - get_group_name_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${list_of_array}'
            - json_path: groupName
        publish:
          - group_name: '${return_result}'
        navigate:
          - SUCCESS: start_security_group_xml_tag
          - FAILURE: on_failure
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
          - SUCCESS: set_security_tag_value
          - FAILURE: on_failure
    - end_security_group_xml_tag:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - security_group_start: '<SecurityGroups>'
            - security_group_end: '</SecurityGroups>'
            - security_empty_list: '${security_empty_list}'
        publish:
          - security_group_xml: "${security_group_start+ \"\\n\"+security_empty_list+\"\\n\"+security_group_end}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - set_security_tag_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - group_id: '${group_id}'
            - group_name: '${group_name}'
            - security_empty_list: '${security_empty_list}'
        publish:
          - security_group_list: "${\"<SecurityGroup>\"+\"\\n\"+\"<SecurityGroupId>\"+group_id+\"</SecurityGroupId>\"+\"\\n\"+\"<SecurityGroupName>\"+group_name+\"</SecurityGroupName>\"+\"\\n\"+\"</SecurityGroup>\"}"
          - security_empty_list
        navigate:
          - SUCCESS: add_element_to_the_list
          - FAILURE: on_failure
    - add_element_to_the_list:
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${security_empty_list}'
            - element: '${security_group_list}'
            - delimiter: "${' '+\"\\n\"}"
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
          - FAILURE: end_security_group_xml_tag
    - set_empty_list:
        do:
          io.cloudslang.base.utils.do_nothing:
            - security_empty_list: '${security_empty_list}'
        publish:
          - security_empty_list
        navigate:
          - SUCCESS: iterate_security_group_list
          - FAILURE: on_failure
  outputs:
    - security_group_xml
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      check_status_code:
        x: 560
        'y': 280
      get_group_name_value:
        x: 920
        'y': 80
      set_security_tag_value:
        x: 1080
        'y': 640
      set_empty_list:
        x: 400
        'y': 80
      add_element_to_the_list:
        x: 560
        'y': 640
      start_security_group_xml_tag:
        x: 1080
        'y': 80
      is_list_null:
        x: 760
        'y': 280
      get_group_id_value:
        x: 760
        'y': 80
      end_security_group_xml_tag:
        x: 760
        'y': 440
        navigate:
          cf5eaf13-dea3-d7dd-8a1e-a8c2b025eef2:
            targetId: 4708bbb9-5447-18e7-9473-5f27e1ce436a
            port: SUCCESS
      iterate_security_group_list:
        x: 560
        'y': 80
      convert_xml_to_json:
        x: 80
        'y': 80
      get_security_groups_array_list:
        x: 240
        'y': 80
      describe_security_groups:
        x: 80
        'y': 280
    results:
      SUCCESS:
        4708bbb9-5447-18e7-9473-5f27e1ce436a:
          x: 1000
          'y': 440

