#   (c) Copyright 2020 Micro Focus, L.P.
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
#! @description: Attaches the specified storage volume to the specified instance.
#!
#! @input tenancy_ocid: Oracle creates a tenancy for your company, which is a secure and isolated partition where you
#!                      can create, organize, and administer your cloud resources. This is the ID of the tenancy.
#! @input user_ocid: The ID of an individual employee or system that needs to manage or use your company’s Oracle Cloud
#!                   Infrastructure resources.
#! @input finger_print: The finger print of the public key generated for the OCI account.
#! @input private_key_file: The path to the private key file on the machine where the worker is.
#! @input api_version: Version of the API of OCI.
#!                     Default: '20160918'
#!                     Optional
#! @input region: The region's name. Ex: ap-sydney-1, ap-melbourne-1, sa-saopaulo-1,etc.
#! @input instance_id: The OCID of the instance.
#! @input volume_id: The OCID of the volume.
#! @input volume_type: The type of volume.
#!                     Allowed values: ''iscsi' and 'paravirtualized''.
#! @input device_name: The device name.
#!                     Optional
#! @input display_name: A user-friendly name. Does not have to be unique, and it cannot be changed. Avoid entering
#!                      confidential information.
#!                      Optional
#! @input is_read_only: Whether the attachment was created in read-only mode.
#!                      Optional
#! @input is_shareable: Whether the attachment should be created in shareable mode. If an attachment is created in
#!                      shareable mode, then other instances can attach the same volume, provided that they also create
#!                      their attachments in shareable mode. Only certain volume types can be attached in shareable
#!                      mode. Defaults to false if not specified.
#!                      Optional
#! @input proxy_host: Proxy server used to access the OCI.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the OCI.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0'
#!                         represents an infinite timeout.
#!                         Default: '10000'
#!                         Optional
#! @input socket_timeout: The timeout for waiting for data (a maximum period of inactivity between two consecutive data
#!                        packets), in seconds. A socketTimeout value of '0' represents an infinite timeout.
#!                        Optional
#! @input keep_alive: Specifies whether to create a shared connection that will be used in subsequent calls. If
#!                    keepAlive is false, an existing open connection is used and the connection will be closed after
#!                    execution.
#!                    Default: 'true'
#!                    Optional
#! @input connections_max_per_route: The maximum limit of connections on a per route basis.
#!                                   Default: '2'
#!                                   Optional
#! @input connections_max_total: The maximum limit of connections in total.
#!                               Default: '20'
#!                               Optional
#! @input retry_count: Number of checks if the instance was created successfully.
#!                     Default: '30'
#!                     Optional
#!
#! @output return_result: If successful, returns the complete API response. In case of an error this output will contain
#!                        the error message.
#! @output volume_attachment_id: The OCID of the volume attachment.
#! @output volume_attachment_state: The current state of the volume attachment.
#! @output exception: An error message in case there was an error while executing the request.
#! @output status_code: The HTTP status code for OCI API request.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################

namespace: io.cloudslang.oracle.oci.compute
flow:
  name: attach_volume_to_instance
  inputs:
    - tenancy_ocid
    - user_ocid
    - finger_print:
        sensitive: true
    - private_key_file
    - api_version:
        required: false
    - region
    - instance_id
    - volume_id
    - volume_type
    - device_name:
        required: false
    - display_name:
        required: false
    - is_read_only:
        required: false
    - is_shareable:
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
    - connect_timeout:
        required: false
    - socket_timeout:
        required: false
    - keep_alive:
        required: false
    - connections_max_per_route:
        required: false
    - connections_max_total:
        required: false
    - retry_count:
        default: '30'
        required: false
  workflow:
    - attach_volume:
        do:
          io.cloudslang.oracle.oci.compute.volumes.attach_volume:
            - tenancy_ocid: '${tenancy_ocid}'
            - user_ocid: '${user_ocid}'
            - finger_print:
                value: '${finger_print}'
                sensitive: true
            - private_key_file: '${private_key_file}'
            - api_version: '${api_version}'
            - region: '${region}'
            - instance_id: '${instance_id}'
            - volume_id: '${volume_id}'
            - volume_type: '${volume_type}'
            - device_name: '${device_name}'
            - display_name: '${display_name}'
            - is_read_only: '${is_read_only}'
            - is_shareable: '${is_shareable}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
        publish:
          - volume_attachment_id: '${volume_attachment_id}'
          - volume_attachment_state: '${volume_attachment_state}'
        navigate:
          - SUCCESS: get_volume_attachment_details
          - FAILURE: on_failure
    - is_volume_attached:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${volume_attachment_state}'
            - second_string: ATTACHED
            - ignore_case: 'true'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: wait_for_volume_to_attach
    - counter:
        do:
          io.cloudslang.oracle.oci.utils.counter:
            - from: '1'
            - to: '${retry_count}'
            - increment_by: '1'
        navigate:
          - HAS_MORE: get_volume_attachment_details
          - NO_MORE: FAILURE
          - FAILURE: on_failure
    - wait_for_volume_to_attach:
        do:
          io.cloudslang.base.utils.sleep:
            - seconds: '20'
        navigate:
          - SUCCESS: counter
          - FAILURE: on_failure
    - get_volume_attachment_details:
        do:
          io.cloudslang.oracle.oci.compute.volumes.get_volume_attachment_details:
            - tenancy_ocid: '${tenancy_ocid}'
            - user_ocid: '${user_ocid}'
            - finger_print:
                value: '${finger_print}'
                sensitive: true
            - private_key_file: '${private_key_file}'
            - api_version: '${api_version}'
            - region: '${region}'
            - volume_attachment_id: '${volume_attachment_id}'
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - keep_alive: '${keep_alive}'
            - connections_max_per_route: '${connections_max_per_route}'
            - connections_max_total: '${connections_max_total}'
        publish:
          - return_result: '${return_result}'
          - volume_attachment_state: '${volume_attachment_state}'
        navigate:
          - SUCCESS: is_volume_attached
          - FAILURE: on_failure
  outputs:
    - return_result: '${return_result}'
    - volume_attachment_id: '${volume_attachment_id}'
    - volume_attachment_state: '${volume_attachment_state}'
  results:
    - FAILURE
    - SUCCESS
