#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: Detaches an EBS volume from an instance.
#!               Note: Make sure to un-mount any file systems on the device within your operating system before detaching
#!               the volume. Failure to do so results in the volume being stuck in a busy state while detaching. If an
#!               Amazon EBS volume is the root device of an instance, it can't be detached while the instance is running.
#!               To detach the root volume, stop the instance first. When a volume with an AWS Marketplace product code
#!               is detached from an instance, the product code is no longer associated with the instance. For more
#!               information, see Detaching an Amazon EBS Volume in the Amazon Elastic Compute Cloud User Guide.
#!
#! @input endpoint: Optional - Endpoint to which the request will be sent
#!                  Default: 'https://ec2.amazonaws.com'
#! @input identity: The Amazon Access Key ID
#! @input credential: The Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#! @input proxy_host: Optional - the proxy server used to access the provider services
#! @input proxy_port: Optional - the proxy server port used to access the provider services
#!                    Default: '8080'
#! @input proxy_username: Optional - proxy server user name.
#! @input proxy_password: Optional - proxy server password associated with the proxy_username input value.
#! @input headers: Optional - string containing the headers to use for the request separated by new line (CRLF).
#!                 The header name-value pair will be separated by ":".
#!                 Format: Conforming with HTTP standard for headers (RFC 2616)
#!                 Examples: "Accept:text/plain"
#! @input query_params: Optional - string containing query parameters that will be appended to the URL. The names
#!                      and the values must not be URL encoded because if they are encoded then a double encoded
#!                      will occur. The separator between name-value pairs is "&" symbol. The query name will be
#!                      separated from query value by "=".
#!                      Examples: "parameterName1=parameterValue1&parameterName2=parameterValue2"
#! @input version: Version of the web service to make the call against it.
#!                 Example: "2016-04-01"
#!                 Default: "2016-04-01"
#! @input volume_id: ID of the EBS volume. The volume and instance must be within the same Availability Zone
#! @input instance_id: Optional - ID of the instance
#! @input device_name: Optional - Device name
#! @input force: Optional - Forces detachment if the previous detachment attempt did not occur cleanly (for example,
#!               logging into an instance, un-mounting the volume, and detaching normally). This option can lead
#!               to data loss or a corrupted file system. Use this option only as a last resort to detach a volume
#!               from a failed instance. The instance won't have an opportunity to flush file system caches or
#!               file system metadata. If you use this option, you must perform file system check and repair
#!               procedures
#!
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output exception: exception if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: The list with existing regions was successfully retrieved
#! @result FAILURE: An error occurred when trying to retrieve the regions list
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.volumes

operation:
  name: detach_volume_in_region

  inputs:
    - endpoint:
        default: 'https://ec2.amazonaws.com'
        required: false
    - identity
    - credential:
        sensitive: true
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        required: false
        private: true
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get("proxy_port", "8080")}
        required: false
        private: true
    - proxy_username:
        required: false
    - proxyUsername:
        default: ${get("proxy_username", "")}
        required: false
        private: true
    - proxy_password:
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get("proxy_password", "")}
        required: false
        private: true
        sensitive: true
    - headers:
        required: false
    - query_params:
        required: false
    - queryParams:
        default: ${get("query_params", "")}
        required: false
        private: true
    - version:
        default: "2016-04-01"
        required: false
    - volume_id
    - volumeId:
        default: ${volume_id}
        private: true
    - instance_id:
        required: false
    - instanceId:
        default: ${get("instance_id", "")}
        required: false
        private: true
    - device_name:
        required: false
    - deviceName:
        default: ${get("device_name", "")}
        required: false
        private: true
    - force:
        default: 'false'
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.18'
    class_name: io.cloudslang.content.amazon.actions.volumes.DetachVolumeAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE