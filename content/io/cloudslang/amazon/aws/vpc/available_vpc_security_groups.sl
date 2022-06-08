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
    - provider_sap:
        default: 'https://ec2.amazonaws.com'
        required: true
    - access_key_id
    - access_key:
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
    - set_empty_list:
        do:
          io.cloudslang.base.utils.do_nothing:
            - security_empty_list: '${security_empty_list}'
        publish:
          - security_empty_list
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - list_iterator:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${vpc_security_list}'
            - separator: '  '
        publish:
          - security_vpc: '${result_string}'
        navigate:
          - HAS_MORE: get_vpc_id_value
          - NO_MORE: is_xml_is_empty
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
          - SUCCESS: set_list_empty
          - FAILURE: on_failure
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
    - get_vpc_security_list:
        worker_group: '${worker_group}'
        do:
          checkin.get_vpc_security_list:
            - json_data: '${return_result}'
            - vpc_id: '${vpc_id}'
        publish:
          - vpc_security_list: "${vpc_security_list.replace('],',' ').replace('[[','').replace(']]','').replace('[','').replace(', ' ,',').replace(\"'\",'').replace(']','')}"
        navigate:
          - SUCCESS: is_vpc_security_list_empty
    - set_list_empty:
        do:
          io.cloudslang.base.utils.do_nothing:
            - security_group_empty_list: '${security_group_empty_list}'
        publish:
          - security_group_empty_list
        navigate:
          - SUCCESS: get_group_id
          - FAILURE: on_failure
    - is_vpc_security_list_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${vpc_security_list}'
        navigate:
          - SUCCESS: end_security_xml_tag
          - FAILURE: set_empty_list
    - is_xml_is_empty:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${security_group_empty_list}'
        navigate:
          - SUCCESS: end_security_xml_tag
          - FAILURE: end_security_group_xml_tag
  outputs:
    - security_group_xml
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_vpc_security_list_empty:
        x: 520
        'y': 80
      get_group_id:
        x: 880
        'y': 720
      set_list_empty:
        x: 880
        'y': 520
      set_security_tag_value:
        x: 440
        'y': 720
      get_vpc_id_value:
        x: 1040
        'y': 360
      set_empty_list:
        x: 680
        'y': 80
      list_iterator:
        x: 1040
        'y': 80
      add_element_to_the_list:
        x: 440
        'y': 480
      get_group_name:
        x: 680
        'y': 720
      is_xml_is_empty:
        x: 520
        'y': 280
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
      convert_xml_to_json:
        x: 200
        'y': 80
      get_vpc_security_list:
        x: 360
        'y': 80
      describe_security_groups:
        x: 40
        'y': 80
    results:
      SUCCESS:
        dd23344c-e104-c471-9e35-c58c1b2645be:
          x: 40
          'y': 280
