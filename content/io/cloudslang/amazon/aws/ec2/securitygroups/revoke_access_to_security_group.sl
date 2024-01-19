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
#! @description: This flow revokes access to the security groups given in the inputs.
#!               If the number of security groups after detaching is less than 1, this flow will fail. Additionally,
#!               if the security group to be detached is not attached to the instance or if the security group id
#!               is invalid, an error will occur.
#!
#! @input endpoint: The AWS endpoint as described here: https://docs.aws.amazon.com/general/latest/gr/rande.html
#!                  Default: 'https://ec2.amazonaws.com'
#! @input identity: The ID of the secret access key associated with your Amazon AWS account.
#! @input credential: The secret access key associated with your Amazon AWS account.
#! @input region: The region where to deploy the instance. To select a specific region, you either mention the endpoint
#!                corresponding to that region or provide a value to region input. In case both serviceEndpoint and
#!                region are specified, the serviceEndpoint will be used and region will be ignored.
#!                Examples: us-east-1, us-east-2, us-west-1, us-west-2, ca-central-1, eu-west-1, eu-central-1,
#!                eu-west-2, ap-northeast-1, ap-northeast-2, ap-southeast-1, ap-southeast-2, ap-south-1, sa-east-1
#! @input instance_id: The ID of the instance for which the security group has to be revoked.
#! @input security_group_ids_to_detach: IDs of the security groups  to be revoked from the instance.
#!                                      Example: "sg-01234567"
#! @input proxy_host: Optional - Proxy server used to access the provider services
#! @input proxy_port: Optional - Proxy server port used to access the provider services
#!                    Default: '8080'
#! @input proxy_username: Optional - proxy server user name.
#!                        Default: ''
#! @input proxy_password: Optional - proxy server password associated with the proxy_username
#!                        input value.
#!                        Default: ''
#! @input worker_group: A worker group is a logical collection of workers. A worker may belong to more than
#!                      one group simultaneously.
#!                      Default: 'RAS_Operator_Path'
#!                      Optional
#!
#! @output security_group_id_list: Returns the security groups which are currently attached to the instance after
#!                                 detaching
#! @output return_result: Contains the details in case of success, error message otherwise.
#!
#! @result FAILURE: There was an error while trying to detach the security group from the instance.
#! @result SUCCESS: The security groups have been successfully detached from the instance.
#!!#
########################################################################################################################
namespace: io.cloudslang.amazon.aws.ec2.securitygroups
flow:
  name: revoke_access_to_security_group
  inputs:
    - endpoint:
        default: 'https://ec2.amazonaws.com'
        required: true
    - identity
    - credential:
        sensitive: true
    - region
    - instance_id
    - security_group_ids_to_detach:
        required: true
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
    - set_endpoint:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - region: '${region}'
        publish:
          - endpoint: '${".".join(("https://ec2",region, "amazonaws.com"))}'
        navigate:
          - SUCCESS: describe_instances
          - FAILURE: on_failure
    - describe_instances:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.instances.describe_instances:
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
            - instance_ids_string: '${instance_id}'
        publish:
          - instance_xml: '${return_result}'
        navigate:
          - SUCCESS: convert_xml_to_json
          - FAILURE: on_failure
    - modify_instance_attribute:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.instances.modify_instance_attribute:
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
            - security_group_ids_string: '${final_security_groups_present}'
            - instance_id: '${instance_id}'
        publish:
          - return_result
        navigate:
          - SUCCESS: updated_security_group_list
          - FAILURE: on_failure
    - convert_xml_to_json:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.xml.convert_xml_to_json:
            - xml: '${instance_xml}'
        publish:
          - instance_json: '${return_result}'
        navigate:
          - SUCCESS: extract_security_groupIds_from_json
          - FAILURE: on_failure
    - extract_security_groupIds_from_json:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.utils.extract_from_json:
            - json_response: '${instance_json}'
        publish:
          - security_group_id_list: '${result}'
        navigate:
          - SUCCESS: detach_security_group_condition_check
    - detach_security_group_condition_check:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.utils.detach_security_group_condition_check:
            - existing_security_groups: '${security_group_id_list}'
            - security_groups_to_delete: '${security_group_ids_to_detach}'
        publish:
          - final_security_groups_present: '${result}'
          - return_result: '${error_message}'
        navigate:
          - SUCCESS: modify_instance_attribute
          - FAILURE: on_failure
    - updated_security_group_list:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - security_group_id_list: '${final_security_groups_present}'
        publish:
          - security_group_id_list
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - security_group_id_list
    - return_result
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      describe_instances:
        x: 40
        'y': 360
      modify_instance_attribute:
        x: 400
        'y': 120
      convert_xml_to_json:
        x: 40
        'y': 120
      extract_security_groupIds_from_json:
        x: 240
        'y': 360
      detach_security_group_condition_check:
        x: 240
        'y': 120
      updated_security_group_list:
        x: 600
        'y': 120
        navigate:
          83d0a6be-5059-f479-529a-19140d19fb12:
            targetId: 5dc00d9d-0360-962d-86fd-396c7abd0b76
            port: SUCCESS
      set_endpoint:
        x: 40
        'y': 560
    results:
      SUCCESS:
        5dc00d9d-0360-962d-86fd-396c7abd0b76:
          x: 600
          'y': 360