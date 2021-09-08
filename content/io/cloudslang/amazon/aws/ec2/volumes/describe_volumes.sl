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
#! @description: This operation can be used to retrieve information about one or more volumes, in XML format, that
#!               respect all the filter criterion.
#!               Note: If you are describing a long list of volumes, you can paginate the output to make the list more
#!               manageable. The max_results parameter sets the maximum number of results returned in a single page.
#!               If the list of results exceeds your max_results value, then that number of results is returned along
#!               with a next_token value that can be passed to a subsequent describe_volumes operation
#!               to retrieve the remaining results.
#!
#! @input endpoint: Endpoint to which first request will be sent.
#!                  Default: 'https://ec2.amazonaws.com'
#!                  Optional
#! @input identity: Amazon Access Key ID.
#! @input credential: Amazon Secret Access Key that corresponds to the Amazon Access Key ID.
#! @input proxy_host: Proxy server used to access the provider services.
#!                    Default: ''
#!                    Optional
#! @input proxy_port: Proxy server port used to access the provider services.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Default: ''
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Default: ''
#!                        Optional
#! @input headers: String containing the headers to use for the request separated by new line (CRLF). The header
#!                 name-value pair will be separated by ':'.
#!                 Format: Conforming with HTTP standard for headers (RFC 2616)
#!                 Examples: 'Accept:text/plain'
#!                 Default: ''
#!                 Optional
#! @input query_params: String containing query parameters that will be appended to the URL. The names and the values
#!                      must not be URL encoded because if they are encoded then a double encoded will occur.
#!                      The separator between name-value pairs is '&' symbol. The query name will be separated from
#!                      query value by '='.
#!                      Examples: 'parameterName1=parameterValue1&parameterName2=parameterValue2'
#!                      Default: ''
#!                      Optional
#! @input delimiter: Delimiter that will be used to separate parameters in all of the inputs.
#!                   Default: ','
#!                   Optional
#! @input version: Version of the web service to made the call against it.
#!                 Example: '2016-11-15'
#!                 Default: '2016-11-15'
#! @input volume_ids_string: String that contains one or more values that represents volume IDs. If this input is empty,
#!                           the filters will be applied to all the volumes accessible by the account, otherwise
#!                           the given volumes will be filtered.
#!                           Example: 'vol-12345678,vol-abcdef12,vol-12ab34cd'
#!                           Default: ''
#!                           Optional
#! @input filter_attachment_attach_time: The time stamp when the attachment initiated.
#!                                       Example: '2016-12-02T10:28:20.000Z'
#!                                       Default: ''
#!                                       Optional
#! @input filter_attachment_delete_on_termination: Whether the volume is deleted on instance termination.
#!                                                 Valid values: 'true', 'false'
#!                                                 Default: ''
#!                                                 Optional
#! @input filter_attachment_device: The device name that is exposed to the instance.
#!                                  Example: '/dev/sda1'
#!                                  Default: ''
#!                                  Optional
#! @input filter_attachment_instance_id: The ID of the instance the volume is attached to.
#!                                       Example: 'i-468cisID'
#!                                       Default: ''
#!                                       Optional
#! @input filter_attachment_status: The attachment state.
#!                                  Valid values: 'attaching', 'attached', 'detaching', 'detached'
#!                                  Default: ''
#!                                  Optional
#! @input filter_availability_zone: The Availability Zone in which the volume was created.
#!                                  Example: 'us-east-xx'
#!                                  Default: ''
#!                                  Optional
#! @input filter_create_time: The time stamp when the volume was created.
#!                            Default: ''
#!                            Optional
#! @input filter_encrypted: The encryption status of the volume.
#!                          Valid values: 'true', 'false'
#!                          Default: ''
#!                          Optional
#! @input filter_size: The size of the volume, in GiB.
#!                     Example: '50'
#!                     Default: ''
#!                     Optional
#! @input filter_snapshot_id: The snapshot from which the volume was created.
#!                            Example: 'snap-1234567890abcdef0'
#!                            Default: ''
#!                            Optional
#! @input filter_status: The status of the volume.
#!                       Valid values: 'creating', 'available', 'in-use', 'deleting', 'deleted', 'error'
#!                       Default: ''
#!                       Optional
#! @input filter_tag: The key/value combination of a tag assigned to the resource.
#!                    Example: 'tagKey=tagValue'
#!                    Default: ''
#!                    Optional
#! @input filter_tag_key: The key of a tag assigned to the resource. This filter is independent of the filter_tag_value
#!                        filter. For example, if you use both filter_tag_key='Purpose' and filter_tag_value='X',
#!                        you get any resources assigned both the tag key Purpose (regardless of what the tag's value is),
#!                        and the tag value X (regardless of what the tag's key is).
#!                        Note: If you want to list only resources where Purpose is X, see the filter_tag filter.
#!                        Example: 'tagKey'
#!                        Default: ''
#!                        Optional
#! @input filter_tag_value: The value of a tag assigned to the resource.
#!                          This filter is independent of the filter_tag_key filter.
#!                          Example: 'tagValue'
#!                          Optional
#! @input filter_volume_id: The volume ID.
#!                          Example: 'vol-049df61146c4d7901'
#!                          Default: ''
#!                          Optional
#! @input filter_volume_type: The Amazon EBS volume type.
#!                            Valid values: 'gp2', 'io1', 'st1', 'sc1', 'standard'
#!                            Default: ''
#!                            Optional
#! @input max_results: The maximum number of results to return in a single call. To retrieve the remaining results,
#!                     make another call with the returned NextToken value. This value can be between 5 and 1000.
#!                     You cannot specify this parameter and the instance IDs parameter
#!                     or tag filters in the same call.
#!                     Default: ''
#!                     Optional
#! @input next_token: The token to use to retrieve the next page of results. This value is null when
#!                    there are no more results to return.
#!                    Default: ''
#!                    Optional
#!
#! @output return_result: Contains the response in XML format, otherwise the exception.
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The list with existing volumes was successfully retrieved.
#! @result FAILURE: An error occurred when trying to retrieve volumes list.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.volumes

operation:
  name: describe_volumes

  inputs:
    - endpoint:
        default: 'https://ec2.amazonaws.com'
        required: false
    - identity
    - credential:
        sensitive: true
    - proxy_host:
        default: ''
        required: false
    - proxyHost:
        default: ${get('proxy_host', '')}
        required: false
        private: true
    - proxy_port:
        default: '8080'
        required: false
    - proxyPort:
        default: ${get('proxy_port', '')}
        required: false
        private: true
    - proxy_username:
        default: ''
        required: false
    - proxyUsername:
        default: ${get('proxy_username', '')}
        required: false
        private: true
    - proxy_password:
        default: ''
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get('proxy_password', '')}
        required: false
        private: true
        sensitive: true
    - headers:
        default: ''
        required: false
    - query_params:
        default: ''
        required: false
    - queryParams:
        default: ${get('query_params', '')}
        required: false
        private: true
    - version:
        default: '2016-11-15'
        required: false
    - delimiter:
        default: ','
        required: false
    - volume_ids_string:
        default: ''
        required: false
    - volumeIdsString:
        default: ${get('volume_ids_string', '')}
        required: false
        private: true
    - filter_attachment_attach_time:
        default: ''
        required: false
    - filterAttachmentAttachTime:
        default: ${get('filter_attachment_attach_time', '')}
        required: false
        private: true
    - filter_attachment_delete_on_termination:
        default: ''
        required: false
    - filterAttachmentDeleteOnTermination:
        default: ${get('filter_attachment_delete_on_termination', '')}
        required: false
        private: true
    - filter_attachment_device:
        default: ''
        required: false
    - filterAttachmentDevice:
        default: ${get('filter_attachment_device', '')}
        required: false
        private: true
    - filter_attachment_instance_id:
        default: ''
        required: false
    - filterAttachmentInstanceId:
        default: ${get('filter_attachment_instance_id', '')}
        required: false
        private: true
    - filter_attachment_status:
        default: ''
        required: false
    - filterAttachmentStatus:
        default: ${get('filter_attachment_status', '')}
        required: false
        private: true
    - filter_availability_zone:
        default: ''
        required: false
    - filterAvailabilityZone:
        default: ${get('filter_availability_zone', '')}
        required: false
        private: true
    - filter_create_time:
        default: ''
        required: false
    - filterCreateTime:
        default: ${get('filter_create_time', '')}
        required: false
        private: true
    - filter_encrypted:
        default: ''
        required: false
    - filterEncrypted:
        default: ${get('filter_encrypted', '')}
        required: false
        private: true
    - filter_size:
        default: ''
        required: false
    - filterSize:
        default: ${get('filter_size', '')}
        required: false
        private: true
    - filter_snapshot_id:
        default: ''
        required: false
    - filterSnapshotId:
        default: ${get('filter_snapshot_id', '')}
        required: false
        private: true
    - filter_status:
        default: ''
        required: false
    - filterStatus:
        default: ${get('filter_status', '')}
        required: false
        private: true
    - filter_tag:
        default: ''
        required: false
    - filterTag:
        default: ${get('filter_tag', '')}
        required: false
        private: true
    - filter_tag_key:
        default: ''
        required: false
    - filterTagKey:
        default: ${get('filter_tag_key', '')}
        required: false
        private: true
    - filter_tag_value:
        default: ''
        required: false
    - filterTagValue:
        default: ${get('filter_tag_value', '')}
        required: false
        private: true
    - filter_volume_id:
        default: ''
        required: false
    - filterVolumeId:
        default: ${get('filter_volume_id', '')}
        required: false
        private: true
    - filter_volume_type:
        default: ''
        required: false
    - filterVolumeType:
        default: ${get('filter_volume_type', '')}
        required: false
        private: true
    - max_results:
        default: ''
        required: false
    - maxResults:
        default: ${get('max_results', '')}
        required: false
        private: true
    - next_token:
        default: ''
        required: false
    - nextToken:
        default: ${get('next_token', '')}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.18'
    class_name: io.cloudslang.content.amazon.actions.volumes.DescribeVolumesAction
    method_name: execute

  outputs:
    - return_code: ${returnCode}
    - return_result: ${returnResult}
    - exception: ${get("exception", "")}

  results:
  - SUCCESS: ${returnCode=='0'}
  - FAILURE
