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
#! @input region: The region's name.
#!                Example: ap-sydney-1, ap-melbourne-1, sa-saopaulo-1, etc.
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
#!
#! @output return_result: If successful, returns the complete API response. In case of an error this output will contain
#!                        the error message.
#! @output exception: An error message in case there was an error while executing the request.
#! @output status_code: The HTTP status code for OCI API request.
#! @output volume_attachment_id: The OCID of the volume attachment.
#! @output volume_attachment_state: The current state of the volume attachment.
#!
#! @result SUCCESS: The request was successfully executed.
#! @result FAILURE: There was an error while executing the request.
#!!#
########################################################################################################################

namespace: io.cloudslang.oracle.oci.compute.volumes

operation:
  name: attach_volume

  inputs:
    - tenancy_ocid
    - tenancyOcid:
        default: ${get('tenancy_ocid', '')}
        required: false
        private: true
    - user_ocid
    - userOcid:
        default: ${get('user_ocid', '')}
        required: false
        private: true
    - finger_print:
        sensitive: true
    - fingerPrint:
        default: ${get('finger_print', '')}
        required: false
        private: true
        sensitive: true
    - private_key_file
    - privateKeyFile:
        default: ${get('private_key_file', '')}
        private: true
    - api_version:
        required: false
    - apiVersion:
        default: ${get('api_version', '')}
        required: false
        private: true
    - region
    - instance_id
    - instanceId:
        default: ${get('instance_id', '')}
        required: false
        private: true
    - volume_id
    - volumeId:
        default: ${get('volume_id', '')}
        required: false
        private: true
    - volume_type
    - volumeType:
        default: ${get('volume_type', '')}
        required: false
        private: true
    - device_name:
        required: false
    - deviceName:
        default: ${get('device_name', '')}
        required: false
        private: true
    - display_name:
        required: false
    - displayName:
        default: ${get('display_name', '')}
        required: false
        private: true
    - is_read_only:
        required: false
    - isReadOnly:
        default: ${get('is_read_only', '')}
        required: false
        private: true
    - is_shareable:
        required: false
    - isShareable:
        default: ${get('is_shareable', '')}
        required: false
        private: true
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get('proxy_host', '')}
        required: false
        private: true
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get('proxy_port', '')}
        required: false
        private: true
    - proxy_username:
        required: false
    - proxyUsername:
        default: ${get('proxy_username', '')}
        required: false
        private: true
    - proxy_password:
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get('proxy_password', '')}
        required: false
        private: true
        sensitive: true
    - connect_timeout:
        required: false
    - connectTimeout:
        default: ${get('connect_timeout', '')}
        required: false
        private: true
    - socket_timeout:
        required: false
    - socketTimeout:
        default: ${get('socket_timeout', '')}
        required: false
        private: true
    - keep_alive:
        required: false
    - keepAlive:
        default: ${get('keep_alive', '')}
        required: false
        private: true
    - connections_max_per_route:
        required: false
    - connectionsMaxPerRoute:
        default: ${get('connections_max_per_route', '')}
        required: false
        private: true
    - connections_max_total:
        required: false
    - connectionsMaxTotal:
        default: ${get('connections_max_total', '')}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-oracle-cloud:1.0.4'
    class_name: 'io.cloudslang.content.oracle.oci.actions.volumes.AttachVolume'
    method_name: 'execute'

  outputs:
    - return_result: ${get('returnResult', '')}
    - exception: ${get('exception', '')}
    - status_code: ${get('statusCode', '')}
    - volume_attachment_id: ${get('volumeAttachmentId', '')}
    - volume_attachment_state: ${get('volumeAttachmentState', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE
