#   (c) Copyright 2023 Micro Focus, L.P.
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
#! @description: This flow attaches up to a maximum of five security groups to the instance. An error will be generated
#!              if the number of security groups is greater than 5, if the security group to be added is already present,
#!              or if the security group ID is invalid.
#!
#! @input endpoint: The AWS endpoint as described here: https://docs.aws.amazon.com/general/latest/gr/rande.html
#!                  Default: 'https://ec2.amazonaws.com'
#! @input identity: The ID of the secret access key associated with your Amazon AWS account.
#! @input credential: The secret access key associated with your Amazon AWS account.
#! @input instance_id: The ID of the instance for which the security group has to be attached.
#! @input security_group_ids_to_attach: IDs of the security groups  to be attached to the instance.
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
#! @output  security_group_list: The Security Groups currently attached to the instance.
#! @output error_message: Exception if there was an error when executing, empty otherwise.
#!
#! @result FAILURE: There was an error while trying to attach the security group to the instance.
#! @result SUCCESS: The security groups have been successfully attached to the instance
#!!#
########################################################################################################################
namespace: io.cloudslang.amazon.aws.ec2.securitygroups
flow:
  name: allow_access_to_security_group
  inputs:
    - endpoint:
        default: 'https://ec2.us-west-2.amazonaws.com'
        required: true
    - identity
    - credential:
        sensitive: true
    - instance_id
    - security_group_ids_to_attach:
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
            - security_group_ids_string: '${existing_security_group_ids+","+security_group_ids_to_attach}'
            - instance_id: '${instance_id}'
        publish:
          - return_result
          - error_message: '${exception}'
          - security_groups_list: '${security_group_ids_string}'
        navigate:
          - SUCCESS: SUCCESS
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
          io.cloudslang.amazon.aws.ec2.utils.extract_from_json.sl:
            - json_response: '${instance_json}'
        publish:
          - existing_security_group_ids: '${result}'
        navigate:
          - SUCCESS: attach_sec_grp_pre_test
    - attach_sec_grp_pre_test:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.amazon.aws.ec2.utils.attach_security_group_pre_test.sl:
            - security_grp_ids_new: '${security_group_ids_to_attach}'
            - security_grp_ids_old: '${existing_security_group_ids}'
        publish:
          - error_message
        navigate:
          - SUCCESS: modify_instance_attribute
          - FAILURE: on_failure
  outputs:
    - security_group_list
    - error_message
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      describe_instances:
        x: 40
        'y': 160
      modify_instance_attribute:
        x: 440
        'y': 160
        navigate:
          3df73323-d476-a637-4ea5-5155d3d363f3:
            targetId: 5dc00d9d-0360-962d-86fd-396c7abd0b76
            port: SUCCESS
      convert_xml_to_json:
        x: 40
        'y': 360
      extract_security_groupIds_from_json:
        x: 240
        'y': 360
      attach_sec_grp_pre_test:
        x: 240
        'y': 160
    results:
      SUCCESS:
        5dc00d9d-0360-962d-86fd-396c7abd0b76:
          x: 440
          'y': 360

