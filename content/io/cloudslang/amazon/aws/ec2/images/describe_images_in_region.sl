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
#! @input identity_id: Scopes the images by users with explicit launch permissions. Specify an AWS account ID, 'self'
#!                     (the sender of the request), or 'all' (public AMIs)
#!                     Valid: '' (no identity_id filtering), 'self', 'all' or AWS account ID
#!                     Default: ''
#! @input architecture: Optional - Instance architecture
#!                      Valid values: '' (no architecture filtering), 'i386', 'x86_64'
#!                      Default: ''
#! @input delete_on_termination: Optional - a Boolean that indicates whether the EBS volume is deleted on instance termination.
#!                               Valid values: '' (no delete_on_termination filtering), 'true', 'false'
#!                               Default: ''
#! @input block_mapping_device_name: Optional - Device name for the EBS volume - Ex: '/dev/sdh'
#!                                   Default: ''
#! @input block_device_mapping_snapshot_id: Optional - ID of the snapshot used for the Amazon EBS volume
#!                                          Default: ''
#! @input volume_size: Optional - Volume size of the Amazon EBS volume, in GiB
#!                     Default: ''
#! @input volume_type: Optional - Volume type of the Amazon EBS volume
#!                     Valid values: '' (no delete_on_termination filtering),
#!                                   'gp2' (for General Purpose SSD volumes), 'io1' (for Provisioned IOPS SSD volumes),
#!                                   and 'standard' (for Magnetic volumes)
#!                     Default: ''
#! @input hypervisor: Optional - Hypervisor type of the instance.
#!                    Valid values: '' (no hypervisor filtering), 'ovm', 'xen'
#!                    Default: ''
#! @input image_id: Optional - ID of the specified image to search for
#!                  Default: ''
#! @input kernel_id: Optional - Kernel ID
#!                   Default: ''
#! @input owner_alias: Optional - AWS account alias. Ex: 'amazon'
#!                     Default: ''
#! @input owner_id: Optional - AWS account ID of the instance owner
#!                  Default: ''
#! @input platform: Optional - platform used. Use 'windows' if you have Windows instances; otherwise leave blank.
#!                  Valid values: '', 'windows' - Default: ''
#! @input product_code: Optional - product code associated with the AMI used to launch the instance
#!                      Default: ''
#! @input product_code_type: Optional - type of product code.
#!                           Valid values: '' (no hypervisor filtering), 'devpay', 'marketplace'
#!                           Default: ''
#! @input ramdisk_id: Optional - RAM disk ID
#!                    Default: ''
#! @input root_device_name: Optional - name of the root device for the instance. Ex: '/dev/sda1'
#!                          Default: ''
#! @input root_device_type: Optional - type of root device that the instance uses
#!                          Valid values: '' (no root_device_type filtering), 'ebs', 'instance-store'
#!                          Default: ''
#! @input state_reason_code: Optional - reason code for the state change
#!                           Default: ''
#! @input state_reason_message: Optional - a message that describes the state change
#!                              Default: ''
#! @input key_tags_string: Optional - A string that contains: none, one or more key tags separated by delimiter
#!                         Default: ''
#! @input value_tags_string: Optional - A string that contains: none, one or more tag values separated by delimiter
#! @input virtualization_type: Optional - virtualization type of the instance
#!                             Valid values: '' (no virtualization_type filtering), 'paravirtual', 'hvm'
#!                             Default: ''
#! @input ids_string: Optional - A string that contains: none, one or more image IDs separated by delimiter
#!                    Default: ''
#! @input owners_string: Optional - Filters the images by the owner. Specify an AWS account ID, a'mazon'
#!                       (owner is Amazon), 'aws-marketplace' (owner is AWS Marketplace),
#!                       'self' (owner is the sender of the request). Omitting this option returns all images for which
#!                       you have launch permissions, regardless of ownership
#!                       Valid values: '' (no owners_string filtering), 'amazon', 'aws-marketplace', or 'self'
#!                       Default: ''
#! @input description: Optional - Description of the image (provided during image creation)
#!                     Default: ''
#! @input type: Optional - Image type
#!              Valid values: '' (no owners_string filtering), 'machine', 'kernel', 'ramdisk'
#!              Default: ''
#! @input is_public: Optional - A Boolean that indicates whether the image is public
#!                   Valid values: '' (no is_public filtering), 'true', 'false'
#!                   Default: ''
#! @input manifest_location: Optional - Location of the image manifest
#!                           Default: ''
#! @input name: Optional - Name of the AMI (provided during image creation)
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
    - delimiter:
        required: false
        default: ','
    - identity_id:
        required: false
    - identityId:
        default: ${get("identity_id", "")}
        required: false
        private: true
    - architecture:
        required: false
    - delete_on_termination:
        required: false
    - deleteOnTermination:
        default: ${get("delete_on_termination", "")}
        required: false
        private: true
    - block_mapping_device_name:
        required: false
    - blockMappingDeviceName:
        default: ${get("block_mapping_device_name", "")}
        required: false
        private: true
    - block_device_mapping_snapshot_id:
        required: false
    - blockDeviceMappingSnapshotId:
        default: ${get("block_device_mapping_snapshot_id", "")}
        required: false
        private: true
    - volume_size:
        required: false
    - volumeSize:
        default: ${get("volume_size", "")}
        required: false
        private: true
    - volume_type:
        required: false
    - volumeType:
        default: ${get("volume_type", "")}
        required: false
        private: true
    - hypervisor:
        default: ''
        required: false
    - image_id:
        required: false
    - imageId:
        default: ${get("image_id", "")}
        required: false
        private: true
    - kernel_id:
        required: false
    - kernelId:
        default: ${get("kernel_id", "")}
        required: false
        private: true
    - owner_alias:
        required: false
    - ownerAlias:
        default: ${get("owner_alias", "")}
        required: false
        private: true
    - owner_id:
        required: false
    - ownerId:
        default: ${get("owner_id", "")}
        required: false
        private: true
    - platform:
        default: ''
        required: false
    - product_code:
        required: false
    - productCode:
        default: ${get("product_code", "")}
        required: false
        private: true
    - product_code_type:
        required: false
    - productCodeType:
        default: ${get("product_code_type", "")}
        required: false
        private: true
    - ramdisk_id:
        required: false
    - ramdiskId:
        default: ${get("ramdisk_id", "")}
        required: false
        private: true
    - root_device_name:
        required: false
    - rootDeviceName:
        default: ${get("root_device_name", "")}
        required: false
        private: true
    - root_device_type:
        required: false
    - rootDeviceType:
        default: ${get("root_device_type", "")}
        required: false
        private: true
    - state_reason_code:
        required: false
    - stateReasonCode:
        default: ${get("state_reason_code", "")}
        required: false
        private: true
    - state_reason_message:
        required: false
    - stateReasonMessage:
        default: ${get("state_reason_message", "")}
        required: false
        private: true
    - key_tags_string:
        required: false
    - keyTagsString:
        default: ${get("key_tags_string", "")}
        required: false
        private: true
    - value_tags_string:
        required: false
    - valueTagsString:
        default: ${get("value_tags_string", "")}
        required: false
        private: true
    - virtualization_type:
        required: false
    - virtualizationType:
        default: ${get("virtualization_type", "")}
        required: false
        private: true
    - ids_string:
        required: false
    - idsString:
        default: ${get("ids_string", "")}
        required: false
        private: true
    - owners_string:
        required: false
    - ownersString:
        default: ${get("owners_string", "")}
        required: false
        private: true
    - description:
        default: ''
        required: false
    - type:
        default: ''
        required: false
    - is_public:
        required: false
    - isPublic:
        default: ${get("is_public", "")}
        required: false
        private: true
    - manifest_location:
        required: false
    - manifestLocation:
        default: ${get("manifest_location", "")}
        required: false
        private: true
    - name:
        default: ''
        required: false
    - state:
        default: ''
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.18'
    class_name: io.cloudslang.content.amazon.actions.images.DescribeImagesAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE
