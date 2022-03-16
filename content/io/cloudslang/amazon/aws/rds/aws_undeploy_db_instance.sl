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
#! @description: Deletes a DB instance.
#!
#! @input access_key_id: ID of the secret access key associated with your Amazon AWS or IAM account.
#! @input access_key: Secret access key associated with your Amazon AWS or IAM account.
#! @input region: String that contains the Amazon AWS region name.
#! @input db_instance_identifier: Name of the RDS DB instance identifier.
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
#! @output return_result: The full API response in case of success, or an error message in case of failure.
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The product was successfully provisioned.
#! @result FAILURE: An error has occurred while trying to provision the product.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.rds

flow:
  name: aws_undeploy_db_instance
  inputs:
    - access_key_id
    - access_key:
        sensitive: true
    - region
    - db_instance_identifier
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
          - SUCCESS: describe_db_instance
          - FAILURE: on_failure
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
          - FAILURE: SUCCESS
    - wait_before_check:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '${polling_interval}'
        navigate:
          - SUCCESS: describe_db_instance
          - FAILURE: on_failure
    - counter:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.microsoft.azure.utils.counter:
            - from: '1'
            - to: '${polling_retries}'
            - increment_by: '1'
            - reset: 'false'
        navigate:
          - HAS_MORE: wait_before_check
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - compare_power_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${db_instance_status}'
            - second_string: deleting
        navigate:
          - SUCCESS: counter
          - FAILURE: SUCCESS
  outputs:
    - return_result
    - return_code
    - exception
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      delete_db_instance:
        x: 200
        'y': 200
      describe_db_instance:
        x: 520
        'y': 200
        navigate:
          acab8ba5-a845-c625-e5a1-282a028cdbc4:
            targetId: 7c1ba9a1-e160-ac97-8ffb-45652629a992
            port: FAILURE
      wait_before_check:
        x: 520
        'y': 400
      counter:
        x: 840
        'y': 600
        navigate:
          8f76edeb-f76d-65c2-8923-f40089781ec2:
            targetId: e37946a9-8c96-f57c-3189-a1ec899693fd
            port: NO_MORE
      compare_power_state:
        x: 840
        'y': 200
        navigate:
          60948d1c-f921-4c8c-18cc-f8c6dc6eda38:
            targetId: 7c1ba9a1-e160-ac97-8ffb-45652629a992
            port: FAILURE
    results:
      SUCCESS:
        7c1ba9a1-e160-ac97-8ffb-45652629a992:
          x: 680
          'y': 360
      FAILURE:
        e37946a9-8c96-f57c-3189-a1ec899693fd:
          x: 520
          'y': 600