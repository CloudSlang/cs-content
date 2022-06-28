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
#! @description: Starts an Amazon instance.
#!
#! @input provider_sap: AWS endpoint as described here: https://docs.aws.amazon.com/general/latest/gr/rande.html
#!                      Default: 'https://ec2.amazonaws.com'
#! @input access_key_id: ID of the secret access key associated with your Amazon AWS account.
#! @input access_key: Secret access key associated with your Amazon AWS account.
#! @input region: The name of the region.
#! @input instance_id: The ID of the server (instance) you want to start.
#! @input proxy_host: Proxy server used to access the provider services
#!                    Optional
#! @input proxy_port: Proxy server port used to access the provider services.
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxyUsername input value.
#!                        Optional
#! @input polling_interval: The number of seconds to wait until performing another check.
#!                          Default: 10
#!                          Optional
#! @input polling_retries: The number of retries to check if the instance is stopped.
#!                         Default: 60
#!                         Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group
#!                      simultaneously.
#!                      Default: RAS_Operator_Path
#!                      Optional
#!
#! @output return_result: Contains the instance details in case of success, error message otherwise.
#! @output instance_state: The state of a instance.
#! @output ip_address: The public IP address of the instance
#! @output public_dns_name: The fully qualified public domain name of the instance.
#!
#! @result FAILURE: error starting instance
#! @result SUCCESS: The server (instance) was successfully started
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2
imports:
  instances: io.cloudslang.amazon.aws.ec2.instances
  xml: io.cloudslang.base.xml
  strings: io.cloudslang.base.strings
flow:
  name: aws_start_instance_v3
  inputs:
    - provider_sap: 'https://ec2.amazonaws.com'
    - access_key_id
    - access_key:
        sensitive: true
    - region
    - instance_id
    - start_instance_scheduler_id:
        required: false
    - scheduler_time_zone:
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
    - polling_interval:
        default: '10'
        required: false
    - polling_retries:
        default: '60'
        required: false
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - set_endpoint:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - region: '${region}'
        publish:
          - provider_sap: '${".".join(("https://ec2",region, "amazonaws.com"))}'
        navigate:
          - SUCCESS: set_tenant
          - FAILURE: on_failure
    - check_instance_state_v2:
        worker_group:
          value: '${worker_group}'
          override: true
        loop:
          for: 'step in range(0, int(get("polling_retries", 50)))'
          do:
            io.cloudslang.amazon.aws.ec2.instances.check_instance_state_v2:
              - provider_sap: '${provider_sap}'
              - access_key_id: '${access_key_id}'
              - access_key:
                  value: '${access_key}'
                  sensitive: true
              - instance_id: '${instance_id}'
              - instance_state: running
              - proxy_host: '${proxy_host}'
              - proxy_port: '${proxy_port}'
              - proxy_username: '${proxy_username}'
              - proxy_password:
                  value: '${proxy_password}'
                  sensitive: true
              - polling_interval: '${polling_interval}'
              - worker_group: '${worker_group}'
          break:
            - SUCCESS
          publish:
            - instance_details: '${output}'
            - return_code
            - exception
        navigate:
          - SUCCESS: search_and_replace
          - FAILURE: on_failure
    - search_and_replace:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.search_and_replace:
            - origin_string: '${instance_details}'
            - text_to_replace: xmlns
            - replace_with: xhtml
        publish:
          - replaced_string
        navigate:
          - SUCCESS: parse_state
          - FAILURE: on_failure
    - parse_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${instance_details}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='instanceState']/*[local-name()='name']"
            - query_type: value
        publish:
          - instance_state: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: parse_ip_address
          - FAILURE: on_failure
    - parse_ip_address:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${replaced_string}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='ipAddress']"
            - query_type: value
        publish:
          - ip_address: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: is_ip_address_not_found
          - FAILURE: on_failure
    - describe_instances:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.instances.describe_instances:
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
            - instance_ids_string: '${instance_id}'
        publish:
          - instance_details: '${return_result}'
        navigate:
          - SUCCESS: parse_state_to_get_instance_status
          - FAILURE: on_failure
    - parse_state_to_get_instance_status:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${instance_details}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='instanceState']/*[local-name()='name']"
            - query_type: value
        publish:
          - instance_state: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: check_if_instace_is_in_stopped_state_1
          - FAILURE: on_failure
    - check_if_instace_is_in_stopped_state_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${instance_state}'
            - second_string: running
        navigate:
          - SUCCESS: set_failure_message_for_instance
          - FAILURE: start_instances
    - set_failure_message_for_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - instance_id: '${instance_id}'
        publish:
          - output: "${\"Cannot start the instance \\\"\"+instance_id+\"\\\" that is currently in running state.\"}"
        navigate:
          - SUCCESS: search_and_replace
          - FAILURE: on_failure
    - is_ip_address_not_found:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${ip_address}'
            - second_string: No match found
            - ignore_case: 'true'
        navigate:
          - SUCCESS: set_ip_address_empty
          - FAILURE: set_public_dns_name
    - set_ip_address_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing: []
        publish:
          - ip_address: '-'
        navigate:
          - SUCCESS: set_public_dns_name
          - FAILURE: on_failure
    - set_public_dns_name:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.xpath_query:
            - xml_document: '${replaced_string}'
            - xpath_query: "/*[local-name()='DescribeInstancesResponse']/*[local-name()='reservationSet']/*[local-name()='item']/*[local-name()='instancesSet']/*[local-name()='item']/*[local-name()='dnsName']"
            - query_type: value
        publish:
          - public_dns_name: '${selected_value}'
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: is_public_dns_name_not_present
          - FAILURE: on_failure
    - is_public_dns_name_not_present:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${public_dns_name}'
            - second_string: No match found
            - ignore_case: 'true'
        navigate:
          - SUCCESS: set_public_dns_name_empty
          - FAILURE: check_start_instance_scheduler_id_empty
    - set_public_dns_name_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing: []
        publish:
          - public_dns_name: '-'
        navigate:
          - SUCCESS: check_start_instance_scheduler_id_empty
          - FAILURE: on_failure
    - start_instances:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.instances.start_instances:
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
            - instance_ids_string: '${instance_id}'
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: check_instance_state_v2
          - FAILURE: on_failure
    - check_start_instance_scheduler_id_empty:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${start_instance_scheduler_id}'
            - second_string: ''
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: get_scheduler_details
    - get_scheduler_details:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get_sp('io.cloudslang.microfocus.content.oo_rest_uri')+'/scheduler/rest/v1/'+dnd_tenant_id+'/schedules/'+start_instance_scheduler_id.strip()}"
            - username: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_user')}"
            - password:
                value: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_password')}"
                sensitive: true
            - proxy_host: "${get_sp('io.cloudslang.microfocus.content.proxy_host')}"
            - proxy_port: "${get_sp('io.cloudslang.microfocus.content.proxy_port')}"
            - proxy_username: "${get_sp('io.cloudslang.microfocus.content.proxy_username')}"
            - proxy_password:
                value: "${get_sp('io.cloudslang.microfocus.content.proxy_password')}"
                sensitive: true
            - trust_all_roots: "${get_sp('io.cloudslang.microfocus.content.trust_all_roots')}"
            - x_509_hostname_verifier: "${get_sp('io.cloudslang.microfocus.content.x_509_hostname_verifier')}"
        publish:
          - return_result
          - error_message
        navigate:
          - SUCCESS: get_value
          - FAILURE: on_failure
    - get_value:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: nextFireTime
        publish:
          - next_run_in_unix_time: '${return_result}'
        navigate:
          - SUCCESS: time_format
          - FAILURE: on_failure
    - time_format:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.utils.time_format:
            - time: '${next_run_in_unix_time}'
            - timezone: '${scheduler_time_zone}'
            - format: '%Y-%m-%dT%H:%M:%S'
        publish:
          - updated_start_instance_scheduler_time: '${result_date + ".000" + timezone.split("UTC")[1].split(")")[0] + timezone.split(")")[1]}'
        navigate:
          - SUCCESS: SUCCESS
    - check_start_instance_scheduler_id_empty_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${start_instance_scheduler_id}'
            - second_string: ''
        navigate:
          - SUCCESS: describe_instances
          - FAILURE: get_scheduler_details_1
    - get_scheduler_details_1:
        worker_group:
          value: '${worker_group}'
          override: true
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${get_sp('io.cloudslang.microfocus.content.oo_rest_uri')+'/scheduler/rest/v1/'+dnd_tenant_id+'/schedules/'+start_instance_scheduler_id.strip()}"
            - username: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_user')}"
            - password:
                value: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_password')}"
                sensitive: true
            - proxy_host: "${get_sp('io.cloudslang.microfocus.content.proxy_host')}"
            - proxy_port: "${get_sp('io.cloudslang.microfocus.content.proxy_port')}"
            - proxy_username: "${get_sp('io.cloudslang.microfocus.content.proxy_username')}"
            - proxy_password:
                value: "${get_sp('io.cloudslang.microfocus.content.proxy_password')}"
                sensitive: true
            - trust_all_roots: "${get_sp('io.cloudslang.microfocus.content.trust_all_roots')}"
            - x_509_hostname_verifier: "${get_sp('io.cloudslang.microfocus.content.x_509_hostname_verifier')}"
        publish:
          - return_result
          - error_message
        navigate:
          - SUCCESS: get_value_1
          - FAILURE: on_failure
    - get_value_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.json.get_value:
            - json_input: '${return_result}'
            - json_path: nextFireTime
        publish:
          - next_run_in_unix_time: '${return_result}'
        navigate:
          - SUCCESS: time_format_1
          - FAILURE: on_failure
    - time_format_1:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.utils.time_format:
            - time: '${next_run_in_unix_time}'
            - timezone: '${scheduler_time_zone}'
            - format: '%Y-%m-%dT%H:%M:%S'
        publish:
          - updated_start_instance_scheduler_time: '${result_date + ".000" + timezone.split("UTC")[1].split(")")[0] + timezone.split(")")[1]}'
        navigate:
          - SUCCESS: describe_instances
    - set_tenant:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - dnd_rest_user: "${get_sp('io.cloudslang.microfocus.content.dnd_rest_user')}"
            - scheduler_id: '${start_instance_scheduler_id}'
        publish:
          - dnd_rest_user
          - dnd_tenant_id: '${dnd_rest_user.split("/")[0]}'
          - updated_scheduler_id: '${scheduler_id}'
        navigate:
          - SUCCESS: check_start_instance_scheduler_id_empty_1
          - FAILURE: on_failure
    - on_failure:
        - do_nothing_1:
            do:
              io.cloudslang.base.utils.do_nothing: []
  outputs:
    - return_result
    - instance_state
    - ip_address
    - public_dns_name
    - updated_scheduler_id
    - updated_start_instance_scheduler_time
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      start_instances:
        x: 480
        'y': 80
      check_start_instance_scheduler_id_empty:
        x: 960
        'y': 480
        navigate:
          5f9b5f76-7a92-56bc-05cc-6ae73b5be022:
            targetId: d2ef709d-2cef-d264-0a6b-105705aa8c53
            port: SUCCESS
      parse_state:
        x: 960
        'y': 80
      get_scheduler_details_1:
        x: 160
        'y': 640
      set_ip_address_empty:
        x: 960
        'y': 280
      set_tenant:
        x: 160
        'y': 240
      parse_ip_address:
        x: 1120
        'y': 80
      get_value:
        x: 720
        'y': 640
      is_ip_address_not_found:
        x: 1280
        'y': 80
      set_public_dns_name_empty:
        x: 1280
        'y': 440
      time_format:
        x: 960
        'y': 640
        navigate:
          1076b3fe-b425-26b4-d93e-61a8c4bd4ff0:
            targetId: d2ef709d-2cef-d264-0a6b-105705aa8c53
            port: SUCCESS
      parse_state_to_get_instance_status:
        x: 320
        'y': 80
      describe_instances:
        x: 320
        'y': 240
      set_endpoint:
        x: 160
        'y': 80
      is_public_dns_name_not_present:
        x: 1280
        'y': 280
      search_and_replace:
        x: 800
        'y': 80
      get_scheduler_details:
        x: 480
        'y': 640
      set_failure_message_for_instance:
        x: 480
        'y': 400
      check_start_instance_scheduler_id_empty_1:
        x: 160
        'y': 400
      get_value_1:
        x: 320
        'y': 640
      set_public_dns_name:
        x: 1120
        'y': 280
      time_format_1:
        x: 320
        'y': 400
      check_instance_state_v2:
        x: 640
        'y': 80
      check_if_instace_is_in_stopped_state_1:
        x: 480
        'y': 240
    results:
      SUCCESS:
        d2ef709d-2cef-d264-0a6b-105705aa8c53:
          x: 1280
          'y': 640
