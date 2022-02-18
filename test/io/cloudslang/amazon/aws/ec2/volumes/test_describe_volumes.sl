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

namespace: io.cloudslang.amazon.aws.ec2.volumes

imports:
  volumes: io.cloudslang.amazon.aws.ec2.volumes
  lists: io.cloudslang.base.lists

flow:
  name: test_describe_volumes

  inputs:
    - endpoint
    - identity
    - credential
    - proxy_host
    - proxy_port
    - proxy_username
    - proxy_password
    - headers
    - query_params
    - version
    - delimiter
    - volume_ids_string
    - filter_attachment_attach_time
    - filter_attachment_delete_on_termination
    - filter_attachment_device
    - filter_attachment_instance_id
    - filter_attachment_status
    - filter_availability_zone
    - filter_create_time
    - filter_encrypted
    - filter_size
    - filter_snapshot_id
    - filter_status
    - filter_tag
    - filter_tag_key
    - filter_tag_value
    - filter_volume_id
    - filter_volume_type
    - max_results
    - next_token

  workflow:
    - describe_volumes:
        do:
          volumes.describe_volumes:
              - endpoint
              - identity
              - credential
              - proxy_host
              - proxy_port
              - proxy_username
              - proxy_password
              - headers
              - query_params
              - version
              - delimiter
              - volume_ids_string
              - filter_attachment_attach_time
              - filter_attachment_delete_on_termination
              - filter_attachment_device
              - filter_attachment_instance_id
              - filter_attachment_status
              - filter_availability_zone
              - filter_create_time
              - filter_encrypted
              - filter_size
              - filter_snapshot_id
              - filter_status
              - filter_tag
              - filter_tag_key
              - filter_tag_value
              - filter_volume_id
              - filter_volume_type
              - max_results
              - next_token
        publish:
          - return_result
          - return_code
          - exception
        navigate:
          - SUCCESS: check_result
          - FAILURE: LIST_SERVERS_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${str(exception) + "," + return_code}
            - list_2: ",0"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_RESULT_FAILURE

  results:
    - SUCCESS
    - LIST_SERVERS_FAILURE
    - CHECK_RESULT_FAILURE
