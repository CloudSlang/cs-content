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
#! @input subnet_ids_string: Optional - The list of subnets by their IDs. If empty, all the subnets are described.
#! @input proxy_host: Optional - Proxy server used to connect to Amazon API. If empty no proxy will be used.
#! @input proxy_port: Optional - Proxy server port. You must either specify values for both proxyHost and proxyPort
#!                    inputs or leave them both empty.
#!                    Default: '8080'
#!
#! @input proxy_username: Optional - Proxy server user name.
#! @input proxy_password: Optional - Proxy server password associated with the proxyUsername input value.
#! @output subnet_xml: Describes the information of each subnet.
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
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
  workflow:
    - start_subnets_xml_tag:
        do:
          io.cloudslang.base.utils.do_nothing:
            - subnet_start: '<Subnets>'
            - subnet_end: '</Subnets>'
        publish:
          - subnet_start
          - subnet_end
        navigate:
          - SUCCESS: get_subnet_list
          - FAILURE: on_failure
    - is_subnet_list_null:
        do:
          io.cloudslang.base.utils.is_null:
            - variable: '${subnet_list}'
        publish: []
        navigate:
          - IS_NULL: end_subnets_xml_tag
          - IS_NOT_NULL: iterate_subnet_id
    - get_subnet_id:
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${subnet_ids}'
            - delimiter: ','
            - index: '0'
        publish:
          - subnet_id: "${return_result.lstrip('subnetId').lstrip('=')}"
        navigate:
          - SUCCESS: get_availability_zone
          - FAILURE: on_failure
    - get_availability_zone:
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${subnet_ids}'
            - delimiter: ','
            - index: '1'
        publish:
          - availability_zone: "${return_result.lstrip('availabilityZone').lstrip('=')}"
        navigate:
          - SUCCESS: get_defualt_for_az
          - FAILURE: on_failure
    - get_defualt_for_az:
        do:
          io.cloudslang.base.lists.get_by_index:
            - list: '${subnet_ids}'
            - delimiter: ','
            - index: '6'
        publish:
          - default_for_az: "${return_result.lstrip('defaultForAz').lstrip('=')}"
        navigate:
          - SUCCESS: set_xml_tags
          - FAILURE: on_failure
    - set_xml_tags:
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
        do:
          io.cloudslang.base.utils.do_nothing:
            - subnet_final_xml: '${subnet_final_xml}'
        publish:
          - subnet_final_xml
        navigate:
          - SUCCESS: add_element
          - FAILURE: on_failure
    - add_element:
        do:
          io.cloudslang.base.lists.add_element:
            - list: '${subnet_final_xml}'
            - element: '${subnet_xml}'
            - delimiter: "${' '+\"\\n\"}"
        publish:
          - subnet_final_xml: '${return_result}'
        navigate:
          - SUCCESS: iterate_subnet_id
          - FAILURE: on_failure
    - end_subnets_xml_tag:
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
    - iterate_subnet_id:
        do:
          io.cloudslang.base.lists.list_iterator:
            - list: '${subnet_list}'
            - separator: ' '
        publish:
          - subnet_ids: '${result_string}'
        navigate:
          - HAS_MORE: get_subnet_id
          - NO_MORE: end_subnets_xml_tag
          - FAILURE: on_failure
    - get_subnet_list:
        do:
          checkin.get_subnet_list:
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
        navigate:
          - FAILURE: on_failure
          - SUCCESS: is_subnet_list_null
  outputs:
    - subnet_xml: '${subnetxml}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      set_empty_list_xml:
        x: 880
        'y': 440
      end_subnets_xml_tag:
        x: 440
        'y': 440
        navigate:
          bde03cd4-e94d-c99d-9e34-9f9eaa00ff88:
            targetId: c2abf053-e4dc-311a-f4d0-f0b307ad3e7d
            port: SUCCESS
      get_availability_zone:
        x: 760
        'y': 120
      start_subnets_xml_tag:
        x: 0
        'y': 120
      get_subnet_id:
        x: 640
        'y': 120
      get_subnet_list:
        x: 160
        'y': 120
      iterate_subnet_id:
        x: 480
        'y': 120
      is_subnet_list_null:
        x: 320
        'y': 120
      add_element:
        x: 600
        'y': 440
      set_xml_tags:
        x: 880
        'y': 280
      get_defualt_for_az:
        x: 880
        'y': 120
    results:
      SUCCESS:
        c2abf053-e4dc-311a-f4d0-f0b307ad3e7d:
          x: 240
          'y': 440

