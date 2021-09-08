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
#! @description: Creates a snapshot of an Amazon EBS volume and stores it in Amazon S3.
#!               Note: You can use snapshots for backups, to make copies of instance store volumes, and to save data before
#!               shutting down an instance. When a snapshot is created from a volume with an AWS Marketplace product code,
#!               the product code is propagated to the snapshot. You can take a snapshot of an attached volume that is in
#!               use. However, snapshots only capture data that has been written to your Amazon EBS volume at the time the
#!               snapshot command is issued. This might exclude any data that has been cached by any applications or the
#!               operating system. If you can pause any file writes to the volume long enough to take a snapshot, your
#!               snapshot should be complete. However, if you can't pause all file writes to the volume, you should un-mount
#!               the volume from within the instance, issue the snapshot command, and then remount the volume to ensure
#!               a consistent and complete snapshot. You can remount and use your volume while the snapshot status is pending.
#!               To create a snapshot for Amazon EBS volumes that serve as root devices, you should stop the instance before
#!               taking the snapshot. Snapshots that are taken from encrypted volumes are automatically encrypted. Volumes
#!               that are created from encrypted snapshots are also automatically encrypted. Your encrypted volumes and
#!               any associated snapshots always remain protected. For more information, see Amazon Elastic Block Store
#!               and Amazon EBS Encryption in the Amazon Elastic Compute Cloud User Guide.
#!
#! @input endpoint: Optional - Endpoint to which first request will be sent
#!                  Default: 'https://ec2.amazonaws.com'#!
#! @input identity: Amazon Access Key ID
#! @input credential: Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#! @input proxy_host: Optional - Proxy server used to access the provider services
#! @input proxy_port: Optional - Proxy server port used to access the provider services
#!                    Default: '8080'
#! @input proxy_username: Optional - Proxy server user name.
#! @input proxy_password: Optional - Proxy server password associated with the proxy_username input value.
#! @input headers: Optional - String containing the headers to use for the request separated by new line (CRLF).
#!                 The header name-value pair will be separated by ":".
#!                 Format: Conforming with HTTP standard for headers (RFC 2616)
#!                 Examples: 'Accept:text/plain'
#! @input query_params: Optional - String containing query parameters that will be appended to the URL. The names
#!                      and the values must not be URL encoded because if they are encoded then a double encoded
#!                      will occur. The separator between name-value pairs is "&" symbol. The query name will be
#!                      separated from query value by "=".
#!                      Examples: 'parameterName1=parameterValue1&parameterName2=parameterValue2'
#! @input version: Version of the web service to make the call against it.
#!                 Example: '2016-04-01'
#!                 Default: '2016-04-01'
#! @input volume_id: ID of the EBS volume
#!
#! @output return_result: contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output exception: exception if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: The image was successfully created
#! @result FAILURE: An error occurred when trying to create image
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.snapshots

operation:
  name: create_snapshot_in_region

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
        default: '2016-04-01'
        required: false
    - volume_id
    - volumeId:
        default: ${volume_id}
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.18'
    class_name: io.cloudslang.content.amazon.actions.snapshots.CreateSnapshotAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE