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
#! @input endpoint: Optional - The endpoint to which requests are sent.
#!                  Examples:  ec2.us-east-1.amazonaws.com, ec2.us-west-2.amazonaws.com, ec2.us-west-1.amazonaws.com.
#!                  Default: 'https://ec2.amazonaws.com'
#! @input identity: The Amazon Access Key ID.
#! @input credential: The Amazon Secret Access Key that corresponds to the Amazon Access Key ID.
#! @input proxy_host: Optional - Proxy server used to connect to Amazon API. If empty no proxy will be used.
#! @input proxy_port: Optional - Proxy server port. You must either specify values for both proxyHost and proxyPort
#!                    inputs or leave them both empty.
#! @input proxy_username: Optional - Proxy server user name.
#! @input proxy_password: Optional - Proxy server password associated with the proxyUsername input value.
#! @input worker_group: Optional - A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output subnet_xml: Describes the information of each subnets.
#!!#
########################################################################################################################
namespace: io.cloudslang.amazon.aws.vpc

flow:
  name: available_subnets
  inputs:
    - endpoint:
        default: 'https://ec2.amazonaws.com'
        required: false
    - identity
    - credential:
        sensitive: true
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
    - iterate_subnet_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.array_iterator:
            - array: '${array_list}'
        publish:
          - list_of_array: '${result_string}'
          - return_code
        navigate:
          - HAS_MORE: get_subnet_value
          - NO_MORE: is_list_null
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
          - SUCCESS: get_subnet_array_list
          - FAILURE: on_failure
    - get_subnet_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${list_of_array}'
            - json_path: subnetId
        publish:
          - subnet_id: '${"subnetId="+return_result}'
        navigate:
          - SUCCESS: get_availability_zone
          - FAILURE: on_failure
    - get_subnet_array_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${return_result}'
            - json_path: DescribeSubnetsResponse.subnetSet.item
        publish:
          - array_list: '${return_result}'
        navigate:
          - SUCCESS: iterate_subnet_list
          - FAILURE: on_failure
    - get_availability_zone:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${list_of_array}'
            - json_path: availabilityZone
        publish:
          - availability_zone: '${"availabilityZone="+return_result}'
        navigate:
          - SUCCESS: get_vpc_id
          - FAILURE: on_failure
    - get_vpc_id:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${list_of_array}'
            - json_path: vpcId
        publish:
          - vpc_id: '${"vpcId="+return_result}'
        navigate:
          - SUCCESS: get_default_for_az
          - FAILURE: on_failure
    - get_default_for_az:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${list_of_array}'
            - json_path: defaultForAz
        publish:
          - default_for_az: '${"defaultForAz="+return_result}'
        navigate:
          - SUCCESS: set_value_for_subnet_list
          - FAILURE: on_failure
    - set_value_for_subnet_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - subnet_id: '${subnet_id}'
            - vpc_id: '${vpc_id}'
            - default_for_az: '${default_for_az}'
            - availability_zone: '${availability_zone}'
        publish:
          - list_of_array_item: '${subnet_id + "," + availability_zone + ","+ vpc_id + "," + default_for_az}'
        navigate:
          - SUCCESS: set_empty_list
          - FAILURE: on_failure
    - set_empty_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - subnet_list: '${subnet_list}'
            - return_code: '${return_code}'
        publish:
          - subnet_list
        navigate:
          - SUCCESS: add_values_to_main_list
          - FAILURE: on_failure
    - add_values_to_main_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${subnet_list}'
            - element: '${list_of_array_item}'
            - delimiter: ' '
        publish:
          - subnet_list: '${return_result}'
        navigate:
          - SUCCESS: check_status_code
          - FAILURE: on_failure
    - is_list_null:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${list_of_array}'
        publish:
          - list_of_array: '${variable}'
        navigate:
          - IS_NULL: start_subnets_xml_tag
          - IS_NOT_NULL: get_subnet_value
    - check_status_code:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${return_code}'
            - second_string: '0'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: iterate_subnet_list
          - FAILURE: start_subnets_xml_tag
    - start_subnets_xml_tag:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - subnet_start: '<Subnets>'
            - subnet_end: '</Subnets>'
        publish:
          - subnet_start
          - subnet_end
        navigate:
          - SUCCESS: is_subnet_list_null
          - FAILURE: on_failure
    - is_subnet_list_null:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${subnet_list}'
        publish: []
        navigate:
          - IS_NULL: end_subnets_xml_tag
          - IS_NOT_NULL: list_iterator
    - list_iterator:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${subnet_list}'
            - separator: ' '
        publish:
          - subnet_ids: '${result_string}'
        navigate:
          - HAS_MORE: get_subnet_id
          - NO_MORE: end_subnets_xml_tag_if_not_null
          - FAILURE: on_failure
    - end_subnets_xml_tag:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - subnet_start: '<Subnets>'
            - subnet_end: '</Subnets>'
        publish:
          - subnetxml: "${subnet_start+\"\\n\"+subnet_end}"
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
          - subnet_id: "${return_result.lstrip('subnetId').lstrip('=')}"
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
          - availability_zone: "${return_result.lstrip('availabilityZone').lstrip('=')}"
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
          - default_for_az: "${return_result.lstrip('defaultForAz').lstrip('=')}"
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
          - SUCCESS: set_empty_list_xml
          - FAILURE: on_failure
    - set_empty_list_xml:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - subnet_final_xml: '${subnet_final_xml}'
        publish:
          - subnet_final_xml
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
          - subnetxml: "${subnet_start+\"\\n\"+subnet_final_xml+\"\\n\"+subnet_end}"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - subnet_xml: '${subnetxml}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      describe_subnets:
        x: 100
        'y': 80
      check_status_code:
        x: 640
        'y': 360
      set_empty_list_xml:
        x: 400
        'y': 760
      end_subnets_xml_tag:
        x: 200
        'y': 280
        navigate:
          0a0c80f1-9781-b403-92ba-162ef620e618:
            targetId: 75bacfa7-905e-30ac-aaeb-ac8dc7c439f9
            port: SUCCESS
      get_availability_zone:
        x: 880
        'y': 80
      get_value_of_default_az:
        x: 640
        'y': 600
      start_subnets_xml_tag:
        x: 480
        'y': 440
      set_empty_list:
        x: 1080
        'y': 440
      list_iterator:
        x: 280
        'y': 440
      is_list_null:
        x: 480
        'y': 280
      get_availability_zone_tag_value:
        x: 440
        'y': 600
      get_subnet_id:
        x: 280
        'y': 600
      get_default_for_az:
        x: 1080
        'y': 80
      get_subnet_value:
        x: 680
        'y': 80
      convert_xml_to_json:
        x: 240
        'y': 80
      get_vpc_id:
        x: 880
        'y': 240
      end_subnets_xml_tag_if_not_null:
        x: 80
        'y': 440
        navigate:
          d432a9cb-0ae6-bdb8-8fb8-b5476799ba35:
            targetId: 75bacfa7-905e-30ac-aaeb-ac8dc7c439f9
            port: SUCCESS
      is_subnet_list_null:
        x: 360
        'y': 280
      iterate_subnet_list:
        x: 480
        'y': 80
      get_subnet_array_list:
        x: 360
        'y': 80
      add_element:
        x: 80
        'y': 760
      set_xml_tags:
        x: 640
        'y': 760
      add_values_to_main_list:
        x: 880
        'y': 400
      set_value_for_subnet_list:
        x: 1080
        'y': 240
    results:
      SUCCESS:
        75bacfa7-905e-30ac-aaeb-ac8dc7c439f9:
          x: 40
          'y': 280

