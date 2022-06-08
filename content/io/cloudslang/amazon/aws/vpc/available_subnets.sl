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
        required: false
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
    - list_iterator:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${subnet_list_array}'
            - separator: '  '
        publish:
          - subnet_ids: '${result_string}'
        navigate:
          - HAS_MORE: set_empty_list_xml
          - NO_MORE: is_xml_is_empty
          - FAILURE: on_failure
    - end_subnets_xml_tag:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - subnet_start: '<Subnets>'
            - subnet_end: '</Subnets>'
        publish:
          - subnets_xml: "${subnet_start+\"\\n\"+subnet_end}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - get_subnet_id:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${subnet_ids}'
            - delimiter: ','
            - index: '0'
        publish:
          - subnet_id: '${return_result}'
        navigate:
          - SUCCESS: get_availability_zone_tag_value
          - FAILURE: on_failure
    - get_availability_zone_tag_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${subnet_ids}'
            - delimiter: ','
            - index: '1'
        publish:
          - availability_zone: '${return_result}'
        navigate:
          - SUCCESS: get_value_of_default_az
          - FAILURE: on_failure
    - get_value_of_default_az:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${subnet_ids}'
            - delimiter: ','
            - index: '3'
        publish:
          - default_for_az: '${return_result}'
        navigate:
          - SUCCESS: set_xml_tags
          - FAILURE: on_failure
    - set_xml_tags:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - subnet_id: '${"<SubnetId>"+subnet_id+"</SubnetId>"}'
            - availability_zone: '${"<AvailabilityZone>"+availability_zone+"</AvailabilityZone>"}'
            - default_for_az: '${"<DefaultSubnet>"+default_for_az+"</DefaultSubnet>"}'
        publish:
          - subnet_xml: "${\"<Subnet>\"+\"\\n\"+subnet_id+\"\\n\"+availability_zone+\"\\n\"+default_for_az+\"\\n\"+\"</Subnet>\"}"
        navigate:
          - SUCCESS: add_element
          - FAILURE: on_failure
    - add_element:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${subnet_final_xml}'
            - element: '${subnet_xml}'
            - delimiter: "${' '+\"\\n\"}"
        publish:
          - subnet_final_xml: '${return_result}'
        navigate:
          - SUCCESS: list_iterator
          - FAILURE: on_failure
    - end_subnets_xml_tag_if_not_null:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - subnet_start: '<Subnets>'
            - subnet_end: '</Subnets>'
            - subnet_final_xml: '${subnet_final_xml}'
        publish:
          - subnets_xml: "${subnet_start+\"\\n\"+subnet_final_xml+\"\\n\"+subnet_end}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
    - get_vpc_id_from_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${subnet_ids}'
            - delimiter: ','
            - index: '2'
        publish:
          - vpc_id_value: '${return_result}'
        navigate:
          - SUCCESS: get_subnet_id
          - FAILURE: on_failure
    - get_subnet_list:
        worker_group: '${worker_group}'
        do:
          checkin.get_subnet_list:
            - json_data: '${return_result}'
            - vpc_id: '${vpc_id}'
        publish:
          - subnet_list_array: "${subnet_list.replace('],',' ').replace('[[','').replace(']]','').replace('[','').replace(', ' ,',').replace(\"'\",'').replace(']','')}"
          - subnet_empty_array: '${subnet_list}'
        navigate:
          - SUCCESS: is_subnet_list_empty
    - set_empty_list_xml:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - subnet_final_xml: '${subnet_final_xml}'
        publish:
          - subnet_final_xml
        navigate:
          - SUCCESS: get_vpc_id_from_list
          - FAILURE: on_failure
    - is_subnet_list_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${subnet_list_array}'
        navigate:
          - SUCCESS: end_subnets_xml_tag
          - FAILURE: list_iterator
    - is_xml_is_empty:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${subnet_final_xml}'
        navigate:
          - SUCCESS: end_subnets_xml_tag
          - FAILURE: end_subnets_xml_tag_if_not_null
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
      set_empty_list_xml:
        x: 1080
        'y': 80
      end_subnets_xml_tag:
        x: 200
        'y': 280
        navigate:
          0a0c80f1-9781-b403-92ba-162ef620e618:
            targetId: 75bacfa7-905e-30ac-aaeb-ac8dc7c439f9
            port: SUCCESS
      get_value_of_default_az:
        x: 720
        'y': 680
      get_vpc_id_from_list:
        x: 1080
        'y': 240
      list_iterator:
        x: 800
        'y': 80
      get_availability_zone_tag_value:
        x: 880
        'y': 680
      get_subnet_id:
        x: 880
        'y': 280
      is_xml_is_empty:
        x: 640
        'y': 200
      get_subnet_list:
        x: 360
        'y': 80
      convert_xml_to_json:
        x: 200
        'y': 80
      is_subnet_list_empty:
        x: 520
        'y': 80
      end_subnets_xml_tag_if_not_null:
        x: 520
        'y': 360
        navigate:
          d432a9cb-0ae6-bdb8-8fb8-b5476799ba35:
            targetId: 75bacfa7-905e-30ac-aaeb-ac8dc7c439f9
            port: SUCCESS
      add_element:
        x: 720
        'y': 360
      set_xml_tags:
        x: 720
        'y': 520
    results:
      SUCCESS:
        75bacfa7-905e-30ac-aaeb-ac8dc7c439f9:
          x: 400
          'y': 600
