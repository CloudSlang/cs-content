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
#! @description: Describes one or more of the images (AMIs, AKIs, and ARIs) available to you. Images available to you
#!               include public images, private images that you own, and private images owned by other AWS accounts but
#!               for which you have explicit launch permissions.
#!               Note: De-registered images are included in the returned results for an unspecified interval
#!                     after de-registration.
#!
#! @input endpoint: Optional - Endpoint to which first request will be sent
#!                  Example: 'https://ec2.amazonaws.com'
#! @input identity: Amazon Access Key ID
#! @input credential: Amazon Secret Access Key that corresponds to the Amazon Access Key ID
#! @input owners: Optional - Scopes the results to images with the specified owners. You can specify a combination of AWS account
#!                IDs, self, amazon, and aws-marketplace. If you omit this parameter, the results include all images
#!                for which you have launch permissions, regardless of ownership.
#! @input executable_by: Optional - Scopes the images by users with explicit launch permissions. Specify an AWS account ID,
#!                self (the sender of the request), or all (public AMIs).
#! @input proxy_host: Optional - Proxy server used to access the provider services
#! @input proxy_port: Optional - Proxy server port used to access the provider services
#!                    Default: '8080'
#! @input proxy_username: Optional - Proxy server user name.
#! @input proxy_password: Optional - Proxy server password associated with the proxy_username input value.
#! @input headers: Optional - String containing the headers to use for the request separated by new line (CRLF).
#!                 The header name-value pair will be separated by ":".
#!                 Format: Conforming with HTTP standard for headers (RFC 2616)
#!                 Examples: "Accept:text/plain"
#! @input query_params: Optional - String containing query parameters that will be appended to the URL. The names
#!                      and the values must not be URL encoded because if they are encoded then a double encoded
#!                      will occur. The separator between name-value pairs is "&" symbol. The query name will be
#!                      separated from query value by "=".
#!                      Examples: "parameterName1=parameterValue1&parameterName2=parameterValue2"
#! @input version: Version of the web service to make the call against it.
#!                 Example: "2016-04-01"
#!                 Default: "2016-04-01"
#! @input delimiter: Optional - The delimiter to split the user_ids_string and user_groups_string
#!                   Default: ','
#! @input platform: Optional - platform used. Use 'windows' if you have Windows instances; otherwise leave blank.
#!                  Valid values: '', 'windows' - Default: ''
#! @input root_device_type: Optional - type of root device that the instance uses
#!                          Valid values: '' (no root_device_type filtering), 'ebs', 'instance-store'
#!                          Default: ''
#! @input type: Optional - Image type
#!              Valid values: '' (no owners_string filtering), 'machine', 'kernel', 'ramdisk'
#!              Default: ''
#! @input state: Optional - State of the image
#!               Valid values: '' (no state filtering), 'available', 'pending', 'failed'
#!               Default: ''
#!
#! @output return_result: Contains the exception in case of failure, success message otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output exception: Exception if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: The image was successfully created
#! @result FAILURE: An error occurred when trying to create image
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.images

operation:
  name: describe_images_in_region

  inputs:
    - endpoint:
        default: 'https://ec2.amazonaws.com'
        required: false
    - identity
    - credential:
        sensitive: true
    - owners:
        required: false
    - executable_by:
        required: false
    - executableBy:
        default: ${get("executable_by", "")}
        required: false
        private: true
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get("proxy_host", "")}
        required: false
        private: true
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get("proxy_port", "")}
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
        default: '2016-11-15'
        required: false
    - delimiter:
        required: false
        default: ','
    - platform:
        required: false
    - root_device_type:
        required: false
    - rootDeviceType:
        default: ${get("root_device_type", "")}
        required: false
        private: true
    - type:
        required: false
    - state:
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.58-SNAPSHOT-100'
    class_name: io.cloudslang.content.amazon.actions.images.DescribeImagesAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
