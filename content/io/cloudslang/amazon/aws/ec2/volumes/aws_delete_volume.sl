#   Copyright 2023 Open Text
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
#########################################################################################################################
#!!
#! @description: The flow can be used to delete aws volume .
#!
#! @input access_key_id: ID of the secret access key associated with your Amazon AWS account.
#! @input access_key: Secret access key associated with your Amazon AWS account.
#! @input region: The region where the instance is deployed. To select a specific region, you either mention the endpoint corresponding to that region or provide a value to region input. In case both serviceEndpoint and region are specified, the serviceEndpoint will be used and region will be ignored. Examples: us-east-1, us-east-2, us-west-1, us-west-2, ca-central-1, eu-west-1, eu-central-1, eu-west-2, ap-northeast-1, ap-northeast-2, ap-southeast-1, ap-southeast-2, ap-south-1, sa-east-1
#! @input volume_id: The ID of the volume to be deleted.
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than one group simultaneously. Default: RAS_Operator_Path Optional
#! @input proxy_host: Proxy server used to access the provider services. Optional
#! @input proxy_port: Proxy server port used to access the provider services. Optional
#! @input proxy_username: Proxy server user name. Optional
#! @input proxy_password: Proxy server password associated with the proxyUsername input value. Optional
#!
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise
#! @output exception: exception if there was an error when executing, empty otherwise
#!
#! @result FAILURE: Error in deleting the volume
#! @result SUCCESS: The volume has been successfully deleted
#!!#
########################################################################################################################
namespace: io.cloudslang.amazon.aws.ec2
flow:
  name: aws_delete_volume
  inputs:
    - access_key_id
    - access_key:
        sensitive: true
    - region
    - volume_id
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
  workflow:
    - set_endpoint:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - region: '${region}'
        publish:
          - provider_sap: '${".".join(("https://ec2",region, "amazonaws.com"))}'
        navigate:
          - SUCCESS: describe_volume
          - FAILURE: on_failure
    - describe_volume:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.volumes.describe_volumes:
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
            - volume_ids_string: '${volume_id}'
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: delete_volume_in_region
          - FAILURE: on_failure
    - delete_volume_in_region:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.volumes.delete_volume_in_region:
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
            - volume_id: '${volume_id}'
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: describe_volume_to_check_instance_state
          - FAILURE: on_failure
    - describe_volume_to_check_instance_state:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.volumes.describe_volumes:
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
            - volume_ids_string: '${volume_id}'
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: delete_volume_in_region
          - FAILURE: SUCCESS
  outputs:
    - return_code
    - exception
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      set_endpoint:
        x: 80
        'y': 200
      describe_volume:
        x: 240
        'y': 200
      delete_volume_in_region:
        x: 400
        'y': 200
      describe_volume_to_check_instance_state:
        x: 560
        'y': 200
        navigate:
          9a7c803f-95ce-25a4-d104-7db4aabd02b4:
            targetId: 4402ff28-68e3-5ec9-bfe0-6be49c5e77bd
            port: FAILURE
    results:
      SUCCESS:
        4402ff28-68e3-5ec9-bfe0-6be49c5e77bd:
          x: 760
          'y': 200
