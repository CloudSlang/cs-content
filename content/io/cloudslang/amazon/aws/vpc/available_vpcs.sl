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
#! @description: Describes the information about each vpc.
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
#!                      A worker may belong to more thanone group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output available_vpcs_xml: Returns information of vpc's.
#!!#
########################################################################################################################
namespace: io.cloudslang.amazon.aws.vpc

flow:
  name: available_vpcs
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
    - describe_vpcs:
        do:
          io.cloudslang.amazon.aws.vpc.describe_vpcs:
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
          - describe_vpc_xml: '${return_result}'
        navigate:
          - SUCCESS: convert_xml_to_json_describe_vpc
          - FAILURE: on_failure
    - convert_xml_to_json_describe_vpc:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.convert_xml_to_json:
            - xml: '${describe_vpc_xml}'
        publish:
          - return_code
          - return_result
        navigate:
          - SUCCESS: get_vpc_list
          - FAILURE: on_failure
    - list_iterator:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${vpc_list}'
            - separator: '  '
        publish:
          - vpc_list_final: '${result_string}'
        navigate:
          - HAS_MORE: start_vpc_xml_tag
          - NO_MORE: is_vpc_xml_is_empty
          - FAILURE: on_failure
    - start_vpc_xml_tag:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - vpc_start: '<Vpcs>'
            - vpc_end: '</Vpcs>'
        publish:
          - vcp_start: '${vpc_start}'
          - vpc_end
        navigate:
          - SUCCESS: get_vpc_id_value
          - FAILURE: on_failure
    - get_vpc_id_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${vpc_list_final}'
            - delimiter: ','
            - index: '0'
        publish:
          - vpc_id: '${return_result}'
        navigate:
          - SUCCESS: get_value_of_is_default
          - FAILURE: on_failure
    - get_value_of_is_default:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${vpc_list_final}'
            - delimiter: ','
            - index: '1'
        publish:
          - is_default_vpc: '${return_result}'
        navigate:
          - SUCCESS: set_empty_list_xml
          - FAILURE: on_failure
    - end_vpc_xml_tag_if_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - vpc_start: '<Vpcs>'
            - vpc_end: '</Vpcs>'
        publish:
          - available_vpcs_xml: "${vpc_start+\"\\n\"+vpc_end}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - set_security_tag_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - vpc_id: '${vpc_id}'
            - is_default_vpc: '${is_default_vpc}'
        publish:
          - available_final_vpc_list: "${\"<Vpc>\"+\"\\n\"+\"<VpcId>\"+vpc_id+\"</VpcId>\"+\"\\n\"+\"<IsDefaultVpc>\"+is_default_vpc+\"</IsDefaultVpc>\"}"
        navigate:
          - SUCCESS: available_subnets
          - FAILURE: on_failure
    - set_empty_list_xml:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - available_empty_xml: '${available_empty_xml}'
        publish:
          - available_empty_xml
        navigate:
          - SUCCESS: set_security_tag_value
          - FAILURE: on_failure
    - add_element:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${available_empty_xml}'
            - element: '${vpcs_xml}'
            - delimiter: "${' '+\"\\n\"}"
        publish:
          - available_empty_xml: '${return_result}'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - end_vpcs_xml_tag:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - vpc_start: '<Vpcs>'
            - vpc_end: '</Vpcs>'
            - available_empty_xml: '${available_empty_xml}'
        publish:
          - available_vpcs_xml: "${vpc_start+\"\\n\"+available_empty_xml+\"\\n\"+vpc_end}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - set_values_of_security_subnet_tags:
        do:
          io.cloudslang.base.utils.do_nothing:
            - available_final_vpc_list: '${available_final_vpc_list}'
            - subnets_xml: '${subnets_xml}'
            - security_group_xml: '${security_group_xml}'
        publish:
          - vpcs_xml: "${available_final_vpc_list+\"\\n\"+subnets_xml+\"\\n\"+security_group_xml+\"\\n\"+\"</Vpc>\"}"
        navigate:
          - SUCCESS: add_element
          - FAILURE: on_failure
    - get_vpc_list:
        worker_group: '${worker_group}'
        do:
          checkin.get_vpc_list:
            - json_data: '${return_result}'
        publish:
          - vpc_list: "${vpc_list.replace('],',' ').replace('[[','').replace(']]','').replace('[','').replace(', ' ,',').replace(\"'\",'').replace(']','')}"
        navigate:
          - SUCCESS: is_vpc_list_is_empty
    - is_vpc_list_is_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${vpc_list}'
        navigate:
          - SUCCESS: end_vpc_xml_tag_if_empty
          - FAILURE: list_iterator
    - is_vpc_xml_is_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${available_empty_xml}'
        navigate:
          - SUCCESS: end_vpc_xml_tag_if_empty
          - FAILURE: end_vpcs_xml_tag
    - available_subnets:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.amazon.aws.vpc.available_subnets:
            - provider_sap: '${provider_sap}'
            - access_key_id: '${access_key_id}'
            - access_key:
                value: '${access_key}'
                sensitive: true
            - vpc_id: '${vpc_id}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - worker_group: '${worker_group}'
        publish:
          - subnets_xml
        navigate:
          - FAILURE: on_failure
          - SUCCESS: available_vpc_security_groups
    - available_vpc_security_groups:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.amazon.aws.vpc.available_vpc_security_groups:
            - provider_sap: '${provider_sap}'
            - access_key_id: '${access_key_id}'
            - access_key:
                value: '${access_key}'
                sensitive: true
            - vpc_id: '${vpc_id}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password: '${proxy_password}'
            - worker_group: '${worker_group}'
        publish:
          - security_group_xml
        navigate:
          - FAILURE: on_failure
          - SUCCESS: set_values_of_security_subnet_tags
  outputs:
    - available_vpcs_xml
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      available_subnets:
        x: 760
        'y': 640
      end_vpcs_xml_tag:
        x: 240
        'y': 480
        navigate:
          2c689639-8e85-790b-910f-e8f2f9d30680:
            targetId: 6a2f91a0-1742-9970-7842-0fa4695e592d
            port: SUCCESS
      set_values_of_security_subnet_tags:
        x: 640
        'y': 440
      set_empty_list_xml:
        x: 1000
        'y': 440
      available_vpc_security_groups:
        x: 560
        'y': 640
      set_security_tag_value:
        x: 1000
        'y': 640
      is_vpc_xml_is_empty:
        x: 440
        'y': 280
      get_vpc_id_value:
        x: 1000
        'y': 80
      is_vpc_list_is_empty:
        x: 480
        'y': 80
      list_iterator:
        x: 640
        'y': 80
      end_vpc_xml_tag_if_empty:
        x: 240
        'y': 280
        navigate:
          38aa052f-2c1c-3706-8b5a-46d496cf9af4:
            targetId: 6a2f91a0-1742-9970-7842-0fa4695e592d
            port: SUCCESS
      convert_xml_to_json_describe_vpc:
        x: 160
        'y': 80
      get_vpc_list:
        x: 320
        'y': 80
      get_value_of_is_default:
        x: 1000
        'y': 280
      add_element:
        x: 640
        'y': 280
      describe_vpcs:
        x: 100
        'y': 80
      start_vpc_xml_tag:
        x: 800
        'y': 80
    results:
      SUCCESS:
        6a2f91a0-1742-9970-7842-0fa4695e592d:
          x: 100
          'y': 280
