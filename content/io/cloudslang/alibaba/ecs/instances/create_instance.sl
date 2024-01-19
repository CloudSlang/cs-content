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
#! @description: Create an ECS instance.
#!
#! @input access_key_id: The Access Key ID associated with your Alibaba cloud account.
#! @input access_key_secret: The Secret ID of the Access Key associated with your Alibaba cloud account.
#! @input proxy_host: Proxy server used to access the Alibaba cloud services.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the Alibaba cloud services.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input region_id: Region ID of an instance. You can call DescribeRegions to obtain the latest region list.
#! @input image_id: ID of an image file. An image is a running environment template for ECS instances.
#! @input instance_type: Instance type. For more information, call DescribeInstanceTypes to view the latest instance
#!                       type list.
#! @input security_group_id: ID of the security group to which an ECS instance belongs. A security group is a firewall
#!                           group that manages instances in the same region with the same security requirements and
#!                           mutual trust.
#! @input zone_id: ID of a zone to which an instance belongs.  If it is null, a zone is selected by the system.
#!                 Default: ''
#!                 Optional
#! @input instance_name: Name of an ECS instance.It can contain [2, 128] characters in length, must begin with an
#!                       English or Chinese character, and can contain digits, periods (.), colons (:), underscores (_),
#!                       and hyphens (-).If this parameter is not specified, the default value is the InstanceId of the
#!                       instance.
#!                       Optional
#! @input description: Description of an ECS instance.It can be [2, 256] characters in length.It cannot begin with
#!                     "http://" or "https://".
#!                     Default: ''.
#!                     Optional
#! @input internet_charge_type: Internet billing method. PayByTraffic: You are billed based on the traffic usage.
#!                              Default: 'PayByTraffic'
#!                              Optional
#! @input internet_max_bandwidth_in: Maximum inbound bandwidth from the Internet, its unit of measurement is Mbit/s.
#!                                   Value range: [1, 200].
#!                                   Default: '200'
#!                                   Optional
#! @input internet_max_bandwidth_out: Maximum outbound bandwidth to the Internet, its unit of measurement is Mbit/s. If
#!                                    this parameter is not specified, an error is returned.
#!                                    Value range: PayByTraffic: [0,100].
#!                                    Default: '1'
#!                                    Optional
#! @input hostname: Host name of the ECS instance.It cannot start or end with a period (.) or a hyphen (-) and it cannot
#!                  have two or more consecutive periods (.) or hyphens (-).On Windows, the host name can contain [2,
#!                  15] characters in length. It can contain uppercase or lowercase letters, digits, periods (.), and
#!                  hyphens (-). It cannot be only digits.On other OSs, such as Linux, the host name can contain [2,
#!                  128] characters in length. It can be segments separated by periods (.) and can contain uppercase or
#!                  lowercase letters, digits, and hyphens (-).
#!                  Optional
#! @input password: Password of the ECS instance.It can be 8 to 30 characters in length and can contain uppercase and
#!                  lowercase letters, digits, and special characters.Special characters such as ( ) ' ~ !  @ # $ % ^ &
#!                  * - + = | { } [ ] : ; ‘ < > , . ? are allowed. /
#!                  Optional
#! @input password_inherit: Whether to use the password pre-configured in the image you select or not. When
#!                          PasswordInherit is specified, the Password must be null. For a secure access, make sure that
#!                          the selected image has password configured.
#!                          Default: 'false'
#!                          Optional
#! @input is_optimized: Whether it is an I/O-optimized instance or not.
#!                      Valid values: none, optimized
#!                      Default: 'optimized'
#!                      Optional
#! @input system_disk_category: The category of the system disk.
#!                              Optional values:cloud: Basic cloud disk. cloud_efficiency: Ultra cloud disk.
#!                              cloud_ssd: Cloud SSD. ephemeral_ssd: Ephemeral SSD.
#!                              Default: 'cloud_efficiency'
#!                              Optional
#! @input system_disk_size: Size of the system disk, measured in GiB. Value range: [20, 500]. The specified value must
#!                          be equal to or greater than max{20, Imagesize}.
#!                          Default: '40'
#!                          Optional
#! @input system_disk_name: Name of the system disk.It can be [2, 128] characters in length, must begin with an English
#!                          letter or Chinese character, and can contain digits, colons (:), underscores (_), or hyphens
#!                          (-).The name is displayed in the ECS console.It cannot begin with http:// or https://.
#!                          Default: ''
#!                          Optional
#! @input system_disk_description: Description of a system disk.It can be [2, 256] characters in length.The description
#!                                 is displayed in the ECS console.It cannot begin with http:// or https://.
#!                                 Default: ''
#!                                 Optional
#! @input delimiter: The delimiter used to separate the values for dataDisksSizeList, dataDisksCategoryList,
#!                   dataDisksEncryptedList, dataDisksSnapshotList, dataDisksNameList, dataDisksDescriptionList,
#!                   dataDisksDeleteWithInstanceList, tagsKeyList, tagsValueList inputs.
#!                   Default: ','
#!                   Optional
#! @input cluster_id: The cluster ID to which the instance belongs.
#!                    Optional
#! @input hpc_cluster_id: The cluster ID to which the instance belongs.
#!                        Optional
#! @input v_switch_id: The VSwitch ID must be specified when you create a VPC-connected instance.
#!                     Optional
#! @input private_ip_address: Private IP address of an ECS instance. PrivateIpAddress depends on VSwitchId and cannot be
#!                            specified separately
#!                            Optional
#! @input instance_charge_type: Billing methods. Valid values: 'PrePaid', 'PostPaid'
#!                              Default: 'PostPaid'
#!                              Optional
#! @input spot_strategy: The spot price you are willing to accept for a preemptible instance. It takes effect only when
#!                       parameter InstanceChargeType is PostPaid. Optional values:NoSpot: A normal Pay-As-You-Go
#!                       instance. SpotWithPriceLimit: Sets the price threshold for a preemptible instance.
#!                       SpotAsPriceGo: A price that is based on the highest Pay-As-You-Go instance.
#!                       Default: 'NoSpot'
#!                       Optional
#! @input spot_price_limit: The hourly price threshold for a preemptible instance, and it takes effect only when
#!                          parameter SpotStrategy is SpotWithPriceLimit. Three decimal places are allowed at most.
#!                          Default: '0.0'
#!                          Optional
#! @input period: This parameter is valid and mandatory only when InstanceChargeType is set to PrePaid. Unit: month.
#!                Valid values: '1-9', '12', '24', '36', '48', '60'
#!                Optional
#! @input period_unit: Value: Optional values: 'week', 'month'.
#!                     Default: 'month'
#!                     Optional
#! @input auto_renew: Whether to set AutoRenew. Whether to set AutoRenew. This parameter is valid when
#!                    InstanceChargeType is PrePaid.
#!                    Valid values: true, false
#!                    Default: 'false'
#!                    Optional
#! @input auto_renew_period: When AutoRenew is set to True, this parameter is required.
#!                           Valid values: '1', '2', '3', '6', '12'
#!                           Optional
#! @input user_data: The user data for an instance must be encoded in Base64 format. The maximum size of the
#!                   user-defined data is 16 KB.
#!                   Optional
#! @input client_token: It is used to guarantee the idempotence of the request. This parameter value is generated by the
#!                      client and is guaranteed to be unique between different requests. It can contain a maximum of 64
#!                      ASCII characters only. 
#!                      Optional
#! @input key_pair_name: The name of the key pair. This parameter is valid only for a Linux instance. For a Windows ECS
#!                       instance, if a value is set for parameter KeyPairName, the password still takes effect. The user
#!                       name and password authentication method is disabled if a value is set for parameter KeyPairName
#!                       for a Linux instance.
#!                       Default: ''
#!                       Optional
#! @input deployment_set_id: Deployment Set ID. If you do not enter the value, 1 is used.
#!                           Optional
#! @input ram_role_name: The RAM role name of the instance. 
#!                       Optional
#! @input security_enhancement_strategy: Whether or not to enable security enhancement.
#!                                       Valid values: active, deactive
#!                                       Optional
#!
#! @output return_code: "0" if operation was successfully executed, "-1" otherwise.
#! @output return_result: The authentication token in case of success, or an error message in case of failure.
#! @output instance_id: The specified instance ID.
#! @output exception: Exception if there was an error when executing, empty otherwise.
#!
#! @result SUCCESS: The instance has been successfully created.
#! @result FAILURE: An error has occurred while trying to create the instance.
#!!#
########################################################################################################################

namespace: io.cloudslang.alibaba.ecs.instances

operation: 
  name: create_instance
  
  inputs: 
    - access_key_id    
    - accessKeyId: 
        default: ${get('access_key_id', '')}  
        required: false 
        private: true 
    - access_key_secret:    
        sensitive: true
    - accessKeySecret: 
        default: ${get('access_key_secret', '')}  
        required: false 
        private: true 
        sensitive: true
    - proxy_host:  
        required: false  
    - proxyHost: 
        default: ${get('proxy_host', '')}  
        required: false 
        private: true 
    - proxy_port:
        default: "8080"
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
    - region_id    
    - regionId: 
        default: ${get('region_id', '')}  
        required: false 
        private: true 
    - image_id    
    - imageId: 
        default: ${get('image_id', '')}  
        required: false 
        private: true 
    - instance_type    
    - instanceType: 
        default: ${get('instance_type', '')}  
        required: false 
        private: true 
    - security_group_id    
    - securityGroupId: 
        default: ${get('security_group_id', '')}  
        required: false 
        private: true 
    - zone_id:
        default: ''
        required: false  
    - zoneId: 
        default: ${get('zone_id', '')}  
        required: false 
        private: true 
    - instance_name:  
        required: false  
    - instanceName: 
        default: ${get('instance_name', '')}  
        required: false 
        private: true 
    - description:
        default: ''
        required: false  
    - internet_charge_type:
        default: 'PayByTraffic'
        required: false  
    - internetChargeType: 
        default: ${get('internet_charge_type', '')}  
        required: false 
        private: true 
    - internet_max_bandwidth_in:
        default: '200'
        required: false  
    - internetMaxBandwidthIn: 
        default: ${get('internet_max_bandwidth_in', '')}  
        required: false 
        private: true 
    - internet_max_bandwidth_out:
        default: '1'
        required: false  
    - internetMaxBandwidthOut: 
        default: ${get('internet_max_bandwidth_out', '')}  
        required: false 
        private: true 
    - hostname:  
        required: false  
    - password:  
        required: false  
        sensitive: true
    - password_inherit:
        default: 'false'
        required: false  
    - passwordInherit: 
        default: ${get('password_inherit', '')}  
        required: false 
        private: true 
    - is_optimized:
        default: 'optimized'
        required: false  
    - isOptimized: 
        default: ${get('is_optimized', '')}  
        required: false 
        private: true 
    - system_disk_category:
        default: 'cloud_efficiency'
        required: false  
    - systemDiskCategory: 
        default: ${get('system_disk_category', '')}  
        required: false 
        private: true 
    - system_disk_size:
        default: '40'
        required: false  
    - systemDiskSize: 
        default: ${get('system_disk_size', '')}  
        required: false 
        private: true 
    - system_disk_name:
        default: ''
        required: false  
    - systemDiskName: 
        default: ${get('system_disk_name', '')}  
        required: false 
        private: true 
    - system_disk_description:
        default: ''
        required: false  
    - systemDiskDescription: 
        default: ${get('system_disk_description', '')}  
        required: false 
        private: true 
    - delimiter:
        default: ','
        required: false  
    - cluster_id:  
        required: false  
    - clusterId: 
        default: ${get('cluster_id', '')}  
        required: false 
        private: true 
    - hpc_cluster_id:  
        required: false  
    - hpcClusterId: 
        default: ${get('hpc_cluster_id', '')}  
        required: false 
        private: true 
    - v_switch_id:  
        required: false  
    - vSwitchId: 
        default: ${get('v_switch_id', '')}  
        required: false 
        private: true 
    - private_ip_address:  
        required: false  
    - privateIpAddress: 
        default: ${get('private_ip_address', '')}  
        required: false 
        private: true 
    - instance_charge_type:
        default: 'PostPaid'
        required: false  
    - instanceChargeType: 
        default: ${get('instance_charge_type', '')}  
        required: false 
        private: true 
    - spot_strategy:
        default: 'NoSpot'
        required: false  
    - spotStrategy: 
        default: ${get('spot_strategy', '')}  
        required: false 
        private: true 
    - spot_price_limit:
        default: '0.0'
        required: false  
    - spotPriceLimit: 
        default: ${get('spot_price_limit', '')}  
        required: false 
        private: true 
    - period:  
        required: false  
    - period_unit:
        default: 'month'
        required: false  
    - periodUnit: 
        default: ${get('period_unit', '')}  
        required: false 
        private: true 
    - auto_renew:
        default: "false"
        required: false  
    - autoRenew: 
        default: ${get('auto_renew', '')}  
        required: false 
        private: true 
    - auto_renew_period:  
        required: false  
    - autoRenewPeriod: 
        default: ${get('auto_renew_period', '')}  
        required: false 
        private: true 
    - user_data:  
        required: false  
    - userData: 
        default: ${get('user_data', '')}  
        required: false 
        private: true
    - client_token:
        required: false  
    - clientToken: 
        default: ${get('client_token', '')}  
        required: false 
        private: true 
    - key_pair_name:
        default: ''
        required: false
    - keyPairName:
        default: ${get('key_pair_name', '')}
        required: false
        private: true
    - deployment_set_id:  
        required: false  
    - deploymentSetId: 
        default: ${get('deployment_set_id', '')}  
        required: false 
        private: true 
    - ram_role_name:  
        required: false  
    - ramRoleName: 
        default: ${get('ram_role_name', '')}  
        required: false 
        private: true 
    - security_enhancement_strategy:  
        required: false  
    - securityEnhancementStrategy: 
        default: ${get('security_enhancement_strategy', '')}  
        required: false 
        private: true 
    
  java_action: 
    gav: 'io.cloudslang.content:cs-alibaba:0.0.5'
    class_name: 'io.cloudslang.content.alibaba.actions.instances.CreateInstance'
    method_name: 'execute'
  
  outputs: 
    - return_code: ${get('returnCode', '')} 
    - return_result: ${get('returnResult', '')} 
    - instance_id: ${get('instanceId', '')} 
    - exception: ${get('exception', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
