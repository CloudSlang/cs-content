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
#! @description: Creates a new DB instance.
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
#!
#! @result SUCCESS: The product was successfully provisioned.
#! @result FAILURE: An error has occurred while trying to provision the product.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.rds

flow:
  name: aws_deploy_db_instance
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
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
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
          - SUCCESS: create_db_instance
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
  outputs:
    - return_result
    - return_code
    - exception
    - db_instance_status
    - endpoint_address
    - db_instance_arn
    - db_instance_name
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      random_number_generator:
        x: 80
        'y': 200
      create_db_instance:
        x: 280
        'y': 200
      describe_db_instance:
        x: 520
        'y': 200
      delete_db_instance:
        x: 280
        'y': 480
        navigate:
          c469adb7-fc24-1c83-f7ad-06c299e12cef:
            targetId: e37946a9-8c96-f57c-3189-a1ec899693fd
            port: SUCCESS
      set_random_number:
        x: 80
        'y': 480
      wait_before_check:
        x: 520
        'y': 400
      compare_power_state:
        x: 720
        'y': 200
        navigate:
          3f378b3c-6acd-36de-02e2-91f18cdaf887:
            targetId: 7c1ba9a1-e160-ac97-8ffb-45652629a992
            port: SUCCESS
      counter:
        x: 720
        'y': 600
    results:
      SUCCESS:
        7c1ba9a1-e160-ac97-8ffb-45652629a992:
          x: 920
          'y': 200
      FAILURE:
        e37946a9-8c96-f57c-3189-a1ec899693fd:
          x: 280
          'y': 680
