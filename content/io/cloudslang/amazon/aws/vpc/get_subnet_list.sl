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
#! @description: Return list of subnets.
#!
#! @input endpoint: Optional - The endpoint to which requests are sent.
#!                  Examples:  ec2.us-east-1.amazonaws.com, ec2.us-west-2.amazonaws.com, ec2.us-west-1.amazonaws.com.
#!                  Default: 'https://ec2.amazonaws.com'
#! @input identity: The Amazon Access Key ID.
#! @input credential: The Amazon Secret Access Key that corresponds to the Amazon Access Key ID.
#! @input proxy_host: Optional - Proxy server used to connect to Amazon API. If empty no proxy will be used.
#! @input proxy_port: Optional - Proxy server port. You must either specify values for both proxyHost and proxyPort
#!                    inputs or leave them both empty.
#!                    Default: '8080'
#! @input proxy_username: Optional - Proxy server user name.
#! @input proxy_password: Optional - Proxy server password associated with the proxyUsername input value.
#!
#! @output subnet_list: returns list of subnets.
#!!#
########################################################################################################################
namespace: io.cloudslang.amazon.aws.vpc

flow:
  name: get_subnet_list
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
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
  workflow:
    - describe_subnets:
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
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${list_of_array}'
            - json_path: availabilityZone
        publish:
          - availability_zone: '${"availabilityZone="+return_result}'
        navigate:
          - SUCCESS: get_state
          - FAILURE: on_failure
    - get_state:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${list_of_array}'
            - json_path: state
        publish:
          - state: '${"state="+return_result}'
        navigate:
          - SUCCESS: get_available_ip_address_count
          - FAILURE: on_failure
    - get_available_ip_address_count:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${list_of_array}'
            - json_path: availableIpAddressCount
        publish:
          - available_ip_address_count: '${"availableIpAddressCount="+return_result}'
        navigate:
          - SUCCESS: get_cidr_block
          - FAILURE: on_failure
    - get_cidr_block:
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${list_of_array}'
            - json_path: cidrBlock
        publish:
          - cidr_block: '${"cidrBlock="+return_result}'
        navigate:
          - SUCCESS: get_vpc_id
          - FAILURE: on_failure
    - get_vpc_id:
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
        do:
          io.cloudslang.base.utils.do_nothing:
            - subnet_id: '${subnet_id}'
            - state: '${state}'
            - available_ip_address_count: '${available_ip_address_count}'
            - cidr_block: '${cidr_block}'
            - vpc_id: '${vpc_id}'
            - default_for_az: '${default_for_az}'
            - availability_zone: '${availability_zone}'
        publish:
          - list_of_array_item: '${subnet_id + "," + availability_zone + ","+ state + "," + available_ip_address_count + "," + cidr_block + "," + vpc_id + "," + default_for_az}'
        navigate:
          - SUCCESS: set_empty_list
          - FAILURE: on_failure
    - set_empty_list:
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
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${list_of_array}'
        publish:
          - list_of_array: '${variable}'
        navigate:
          - IS_NULL: SUCCESS
          - IS_NOT_NULL: get_subnet_value
    - check_status_code:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${return_code}'
            - second_string: '0'
            - ignore_case: 'true'
        navigate:
          - SUCCESS: iterate_subnet_list
          - FAILURE: SUCCESS
  outputs:
    - subnet_list: '${subnet_list}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      describe_subnets:
        x: 40
        'y': 80
      check_status_code:
        x: 360
        'y': 480
        navigate:
          1b118082-ee9c-bb28-7afc-31c24e86d7df:
            targetId: 49a4028b-0f75-2ad0-3ddd-b87e2719ac37
            port: FAILURE
      get_availability_zone:
        x: 640
        'y': 80
      get_state:
        x: 800
        'y': 80
      get_cidr_block:
        x: 1080
        'y': 80
      get_available_ip_address_count:
        x: 960
        'y': 80
      set_empty_list:
        x: 600
        'y': 640
      is_list_null:
        x: 640
        'y': 320
        navigate:
          0e8e7f28-926d-d6a0-4404-0c139670d138:
            targetId: 49a4028b-0f75-2ad0-3ddd-b87e2719ac37
            port: IS_NULL
      get_default_for_az:
        x: 1080
        'y': 640
      get_subnet_value:
        x: 480
        'y': 80
      convert_xml_to_json:
        x: 200
        'y': 80
      get_vpc_id:
        x: 1080
        'y': 320
      iterate_subnet_list:
        x: 360
        'y': 320
      get_subnet_array_list:
        x: 360
        'y': 80
      add_values_to_main_list:
        x: 360
        'y': 640
      set_value_for_subnet_list:
        x: 840
        'y': 640
    results:
      SUCCESS:
        49a4028b-0f75-2ad0-3ddd-b87e2719ac37:
          x: 640
          'y': 480

