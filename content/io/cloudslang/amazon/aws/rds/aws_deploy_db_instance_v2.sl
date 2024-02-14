#   Copyright 2024 Open Text
#   This program and the accompanying materials
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
#! @description: This flow is used to create a new RDS DB instance with organizational tags and custom tags.
#!
#! @input access_key_id: ID of the secret access key associated with your Amazon AWS or IAM account.
#! @input access_key: Secret access key associated with your Amazon AWS or IAM account.
#! @input region: String that contains the Amazon AWS region name.
#! @input db_instance_identifier: Name of the RDS DB instance identifier.
#! @input db_engine_name: The name of the database engine to be used for this instance.
#! @input db_engine_version: The version number of the database engine to use.
#! @input db_instance_size: The compute and memory capacity of the DB instance.
#! @input db_username: The name for the master user.
#! @input db_password: The password for the master user.
#! @input db_storage_size: The amount of storage in gibibytes (GiB) to allocate for the DB instance.
#! @input business_unit: The name of business unit.
#! @input product_id: The Id of the product.
#! @input product_name: The name of the product.
#! @input environment: Type of environment.
#!                     Example: production, development, staging, testing
#! @input tag_key_list: The list of key's of tags separated by comma(,)The length of the items in tag_key_list must be
#!                      equal with the length of the items in tag_value_list.
#!                      Optional
#! @input tag_value_list: The list of value's of tags separated by comma(,)The length of the items in tag_key_list must be
#!                        equal with the length of the items in tag_value_list.
#!                        Optional
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#! @input proxy_host: Proxy server used to connect to Amazon API. If empty no proxy will be used.
#!                    Optional
#! @input proxy_port: Proxy server port. You must either specify values for both proxyHost and proxyPort inputs or leave
#!                    them both empty.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxyUsername input value.
#!                        Optional
#! @input polling_interval: The number of seconds to wait until performing another check.
#!                          Default: '10'
#!                          Optional
#! @input polling_retries: The number of retries to check if the instance is stopped.
#!                         Default: '60'
#!                         Optional
#!
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output return_result: The full API response in case of success, or an error message in case of failure.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#! @output db_instance_status: Specifies the current state of this database.
#! @output endpoint_address: Specifies the DNS address of the DB instance.
#! @output db_instance_arn: The Amazon Resource Name (ARN) for the DB instance.
#! @output db_instance_name: Name of the RDS DB instance identifier.
#! @output tags_json: List of tags in json format.
#!
#! @result SUCCESS: The product was successfully provisioned.
#! @result FAILURE: An error has occurred while trying to provision the product.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.rds

flow:
  name: aws_deploy_db_instance_v2
  inputs:
    - access_key_id
    - access_key:
        sensitive: true
    - region
    - db_instance_identifier
    - db_engine_name
    - db_engine_version
    - db_instance_size
    - db_username
    - db_password:
        sensitive: true
    - db_storage_size
    - business_unit
    - product_id
    - product_name
    - environment
    - tag_key_list:
        required: false
    - tag_value_list:
        required: false
    - worker_group:
        default: RAS_Operator_Path
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
  workflow:
    - random_number_generator:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.math.random_number_generator:
            - min: '10000'
            - max: '99999'
        publish:
          - random_number
        navigate:
          - SUCCESS: set_random_number
          - FAILURE: random_number_generator
    - create_db_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.rds.databases.create_db_instance:
            - access_key_id: '${access_key_id}'
            - access_key:
                value: '${access_key}'
                sensitive: true
            - region: '${region}'
            - db_instance_identifier: '${db_instance_identifier}'
            - db_engine_name: '${db_engine_name}'
            - db_engine_version: '${db_engine_version}'
            - db_instance_size: '${db_instance_size}'
            - db_username: '${db_username}'
            - db_password:
                value: '${db_password}'
                sensitive: true
            - db_storage_size:
                value: '${db_storage_size}'
                sensitive: true
            - tag_key_list: '${key_list}'
            - tag_value_list: '${value_list}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - return_result
        navigate:
          - SUCCESS: describe_db_instance
          - FAILURE: delete_db_instance
    - describe_db_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.rds.databases.describe_db_instance:
            - access_key_id: '${access_key_id}'
            - access_key:
                value: '${access_key}'
                sensitive: true
            - region: '${region}'
            - db_instance_identifier: '${db_instance_identifier}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        publish:
          - db_instance_status
          - endpoint_address
          - db_instance_arn
          - return_result
          - db_instance_name: '${db_instance_identifier}'
          - return_code
          - exception
        navigate:
          - SUCCESS: compare_power_state
          - FAILURE: delete_db_instance
    - delete_db_instance:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.rds.databases.delete_db_instance:
            - access_key_id: '${access_key_id}'
            - access_key:
                value: '${access_key}'
                sensitive: true
            - region: '${region}'
            - db_instance_identifier: '${db_instance_identifier}'
            - skip_final_snapshot: 'true'
            - delete_automated_backups: 'true'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
        navigate:
          - SUCCESS: FAILURE
          - FAILURE: on_failure
    - set_random_number:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - db_instance_identifier: '${db_instance_identifier+random_number}'
        publish:
          - db_instance_identifier
        navigate:
          - SUCCESS: check_keytaglist_valuetaglist_equal
          - FAILURE: on_failure
    - wait_before_check:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '${polling_interval}'
        navigate:
          - SUCCESS: describe_db_instance
          - FAILURE: on_failure
    - compare_power_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${db_instance_status}'
            - second_string: available
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: counter
    - counter:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.counter:
            - from: '1'
            - to: '${polling_retries}'
            - increment_by: '1'
            - reset: 'false'
        publish:
          - return_result
        navigate:
          - HAS_MORE: wait_before_check
          - NO_MORE: delete_db_instance
          - FAILURE: on_failure
    - check_keytaglist_valuetaglist_equal:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.utils.check_keytaglist_valuetaglist_equal:
            - key_tag_list: '${tag_key_list}'
            - value_tag_list: '${tag_value_list}'
        navigate:
          - SUCCESS: form_tag_list
          - FAILURE: on_failure
    - form_tag_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.utils.list_to_json:
            - tag_key_list: '${tag_key_list}'
            - tag_value_list: '${tag_value_list}'
            - organizational_value_list: "${business_unit+','+product_id+','+product_name+','+environment}"
        publish:
          - tags_json
          - key_list
          - value_list
        navigate:
          - SUCCESS: create_db_instance
  outputs:
    - return_result
    - return_code
    - exception
    - db_instance_status
    - endpoint_address
    - db_instance_arn
    - db_instance_name
    - tags_json
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      delete_db_instance:
        x: 400
        'y': 480
        navigate:
          c469adb7-fc24-1c83-f7ad-06c299e12cef:
            targetId: e37946a9-8c96-f57c-3189-a1ec899693fd
            port: SUCCESS
      describe_db_instance:
        x: 560
        'y': 200
      set_random_number:
        x: 240
        'y': 200
      check_keytaglist_valuetaglist_equal:
        x: 80
        'y': 480
      wait_before_check:
        x: 560
        'y': 360
      create_db_instance:
        x: 400
        'y': 200
      random_number_generator:
        x: 80
        'y': 200
      counter:
        x: 720
        'y': 480
      compare_power_state:
        x: 720
        'y': 200
        navigate:
          3f378b3c-6acd-36de-02e2-91f18cdaf887:
            targetId: 7c1ba9a1-e160-ac97-8ffb-45652629a992
            port: SUCCESS
      form_tag_list:
        x: 240
        'y': 480
    results:
      SUCCESS:
        7c1ba9a1-e160-ac97-8ffb-45652629a992:
          x: 880
          'y': 200
      FAILURE:
        e37946a9-8c96-f57c-3189-a1ec899693fd:
          x: 400
          'y': 680
