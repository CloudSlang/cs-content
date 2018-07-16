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
#!                 Default value: ''
#!                 Optional
#! @input instance_name: Name of an ECS instance.It can contain [2, 128] characters in length, must begin with an
#!                       English or Chinese character, and can contain digits, periods (.), colons (:), underscores (_),
#!                       and hyphens (-).If this parameter is not specified, the default value is the InstanceId of the
#!                       instance.
#!                       Optional
#! @input description: Description of an ECS instance.It can be [2, 256] characters in length.It cannot begin with
#!                     "http://" or "https://"
#!                     Default value: ''
#!                     Optional
#! @input internet_charge_type: Internet billing method. PayByTraffic: You are billed based on the traffic usage.
#!                              Default: ''
#!                              Optional
#! @input internet_max_bandwidth_in: Maximum inbound bandwidth from the Internet, its unit of measurement is Mbit/s.
#!                                   Value range: [1, 200].
#!                                   Default: '200'
#!                                   Optional
#! @input internet_max_bandwidth_out: Maximum outbound bandwidth to the Internet, its unit of measurement is Mbit/s. If
#!                                    this parameter is not specified, an error is returned.
#!                                    Value range: PayByTraffic: [0,100]. Default: '0'
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
#!                  * - + = | { } [ ] : ; ‘ < > , . ? are allowed.
#!                  Optional
#! @input password_inherit: Whether to use the password pre-configured in the image you select or not. When
#!                          PasswordInherit is specified, the Password must be null. For a secure access, make sure that
#!                          the selected image has password configured.
#!                          Optional
#! @input is_optimized: Whether it is an I/O-optimized instance or not. For phased-out instance types, the default value
#!                      is none. For other instance types, the default value is optimized.Valid values: none, optimized
#!                      Optional
#! @input system_disk_category: The category of the system disk.
#!                              Optional values:cloud: Basic cloud disk.cloud_efficiency:
#!                              Ultra cloud disk.cloud_ssd: Cloud SSD.ephemeral_ssd: Ephemeral
#!                              SSD.For phased-out instance types and non-I/O optimized instances, the default value is
#!                              cloud.Otherwise, the default value is cloud_efficiency.
#!                              Optional
#! @input system_disk_size: Size of the system disk, measured in GiB. Value range: [20, 500]. The specified value must
#!                          be equal to or greater than max{20, Imagesize}.
#!                          Default: max{40, ImageSize}.
#!                          Optional
#! @input system_disk_name: Name of the system disk.It can be [2, 128] characters in length, must begin with an English
#!                          letter or Chinese character, and can contain digits, colons (:), underscores (_), or hyphens
#!                          (-).The name is displayed in the ECS console. It cannot begin with 'http://' or
#!                          'https://'
#!                          Default value: ''
#!                          Optional
#! @input system_disk_description: Description of a system disk.It can be [2, 256] characters in length.The description
#!                                 is displayed in the ECS console.It cannot begin with http:// or https://.Default
#!                                 value: ''
#!                                 Optional
#! @input delimiter: The delimiter used to separate the values for dataDisksSizeList, dataDisksCategoryList,
#!                   dataDisksEncryptedList, dataDisksSnapshotList, dataDisksNameList, dataDisksDescriptionList,
#!                   dataDisksDeleteWithInstanceList, tagsKeyList, tagsValueList inputs.
#!                   Default: ','
#!                   Optional
#! @input data_disks_size_list: Size of the n data disk in GBs, n starts from 1. Optional values:cloud: [5, 2000],
#!                              cloud_efficiency: [20, 32768], cloud_ssd: [20, 32768], ephemeral_ssd: [5, 800].The value
#!                              must be equal to or greater than the specific snapshot (SnapshotId).
#!                              Optional
#! @input data_disks_category_list: Category of the data disk n, the valid range of n is [1, 16]. Optional values:cloud:
#!                                  Basic cloud disk, cloud_efficiency: Ultra cloud disk, cloud_ssd: Cloud SSD,
#!                                  ephemeral_ssd: Ephemeral SSD
#!                                  Default: cloud.
#!                                  Optional
#! @input data_disks_encrypted_list: Whether the data disk n is encrypted or not.
#!                                   Valid values: 'true', 'false'
#!                                   Default: 'false'
#!                                   Optional
#! @input data_disks_snapshot_id_list: Snapshot is used to create the data disk. After the parameter
#!                                     DataDisk.n.SnapshotId is specified, parameter DataDisk.n.Size is ignored, and the
#!                                     size of a new disk is the size of the specified snapshot.If the specified
#!                                     snapshot was created on or before July 15, 2013, this invocation is denied, and
#!                                     an error InvalidSnapshot.TooOld is returned.
#!                                     Optional
#! @input data_disks_disk_name_list: Name of a data disk.It can be [2, 128] characters in length. Must begin with an
#!                                   English letter or Chinese character. It can contain digits, colons (:), underscores
#!                                   (_), or hyphens (-).The data disk name is displayed in the ECS console.Cannot begin
#!                                   with "http://" or "https://".Default value: ''
#!                                   Optional
#! @input data_disks_description_list: Description of a data disk.It can be [2, 256] characters in length.The disk
#!                                     description is displayed in the console.It cannot begin with "http://" or
#!                                     "https://"
#!                                     Default value: ''
#!                                     Optional
#! @input data_disks_delete_with_instance_list: Whether a data disk is released along with the instance or not.This
#!                                              parameter is only valid for an independent cloud disk, whose value of
#!                                              parameter DataDisk.n.Category is cloud, cloud_efficiency, or cloud_ssd.
#!                                              If you specify a value to DataDisk.n.DeleteWithInstance for
#!                                              ephemeral_ssd, an error is returned.
#!                                              Valid values: 'true', 'false'
#!                                              Default: 'true'
#!                                              Optional
#! @input cluster_id: The cluster ID to which the instance belongs.
#!                    Optional
#! @input hpc_cluster_id: The cluster ID to which the instance belongs.
#!                        Optional
#! @input v_switch_id: The VSwitch ID must be specified when you create a VPC-connected instance.
#!                     Optional
#! @input private_ip_address: Private IP address of an ECS instance. PrivateIpAddress depends on VSwitchId and cannot be
#!                            specified separately
#!                            Optional
#! @input instance_charge_type: Billing methods.
#!                              Valid values: 'PrePaid', 'PostPaid'
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
#!                          Optional
#! @input period: Unit: month. This parameter is valid and mandatory only when InstanceChargeType is set to PrePaid.
#!                Valid values: '1-9', '12', '24', '36', '48', '60'
#!                Optional
#! @input period_unit: Value:
#!                     Optional values: 'week', 'month'.
#!                     Default: 'month'
#!                     Optional
#! @input auto_renew: Whether to set AutoRenew. Whether to set AutoRenew. This parameter is valid when
#!                    InstanceChargeType is PrePaid.
#!                    Valid values: 'true', 'false'
#!                    Default: 'false'
#!                    Optional
#! @input auto_renew_period: When AutoRenew is set to True, this parameter is required. Valid values: '1', '2', '3',
#!                           '6', '12'
#!                           Optional
#! @input user_data: The user data for an instance must be encoded in Base64 format. The maximum size of the
#!                   user-defined data is 16 KB.
#!                   Optional
#! @input client_token: It is used to guarantee the idempotence of the request. This parameter value is generated by the
#!                      client and is guaranteed to be unique between different requests. It can contain a maximum of 64
#!                      ASCII characters only. 
#!                      Optional
#! @input client_token: The name of the key pair.This parameter is valid only for a Linux instance. For a Windows ECS
#!                      instance, if a value is set for parameter KeyPairName, the password still takes effect. If a
#!                      value is set for parameter KeyPairName, the Password still takes effect.The user name and
#!                      password authentication method is disabled if a value is set for parameter KeyPairName for a
#!                      Linux instance.
#!                      Default: ''.
#!                      Optional
#! @input deployment_set_id: Deployment Set ID. If you do not enter the value, 1 is used.
#!                           Optional
#! @input ram_role_name: The RAM role name of the instance. 
#!                       Optional
#! @input security_enhancement_strategy: Whether or not to enable security enhancement. Valid values: active, deactive
#!                                       Optional
#! @input tags_key_list: The key of a tag of which n is from 1 to 5. It cannot be an empty string. Once you use this
#!                       parameter, it cannot be a null string. It can be up to 64 characters in length. It cannot start
#!                       with "aliyun", "acs:", "http://", or "https://".
#!                       Optional
#! @input tags_value_list: The value of a tag of which n is from 1 to 5. It can be a null string. It can be up to 128
#!                         characters in length Seven characters. It cannot begin with "aliyun", "http://", or
#!                         "https://".
#!                         Optional
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

namespace: io.cloudslang.alibaba_cloud.instances

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
        default: '8080'
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
        required: false
    - internet_charge_type:
        required: false
    - internetChargeType: 
        default: ${get('internet_charge_type', '')}  
        required: false 
        private: true 
    - internet_max_bandwidth_in:  
        required: false  
    - internetMaxBandwidthIn: 
        default: ${get('internet_max_bandwidth_in', '')}  
        required: false 
        private: true 
    - internet_max_bandwidth_out:  
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
        required: false  
    - passwordInherit: 
        default: ${get('password_inherit', '')}  
        required: false 
        private: true 
    - is_optimized:  
        required: false  
    - isOptimized: 
        default: ${get('is_optimized', '')}  
        required: false 
        private: true 
    - system_disk_category:  
        required: false  
    - systemDiskCategory: 
        default: ${get('system_disk_category', '')}  
        required: false 
        private: true 
    - system_disk_size:  
        required: false  
    - systemDiskSize: 
        default: ${get('system_disk_size', '')}  
        required: false 
        private: true 
    - system_disk_name:  
        required: false  
    - systemDiskName: 
        default: ${get('system_disk_name', '')}  
        required: false 
        private: true 
    - system_disk_description:  
        required: false  
    - systemDiskDescription: 
        default: ${get('system_disk_description', '')}  
        required: false 
        private: true 
    - delimiter:  
        required: false  
    - data_disks_size_list:  
        required: false  
    - dataDisksSizeList: 
        default: ${get('data_disks_size_list', '')}  
        required: false 
        private: true 
    - data_disks_category_list:  
        required: false  
    - dataDisksCategoryList: 
        default: ${get('data_disks_category_list', '')}  
        required: false 
        private: true 
    - data_disks_encrypted_list:  
        required: false  
    - dataDisksEncryptedList: 
        default: ${get('data_disks_encrypted_list', '')}  
        required: false 
        private: true 
    - data_disks_snapshot_id_list:  
        required: false  
    - dataDisksSnapshotIdList: 
        default: ${get('data_disks_snapshot_id_list', '')}  
        required: false 
        private: true 
    - data_disks_disk_name_list:  
        required: false  
    - dataDisksDiskNameList: 
        default: ${get('data_disks_disk_name_list', '')}  
        required: false 
        private: true 
    - data_disks_description_list:  
        required: false  
    - dataDisksDescriptionList: 
        default: ${get('data_disks_description_list', '')}  
        required: false 
        private: true 
    - data_disks_delete_with_instance_list:  
        required: false  
    - dataDisksDeleteWithInstanceList: 
        default: ${get('data_disks_delete_with_instance_list', '')}  
        required: false 
        private: true 
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
        required: false  
    - instanceChargeType: 
        default: ${get('instance_charge_type', '')}  
        required: false 
        private: true 
    - spot_strategy:  
        required: false  
    - spotStrategy: 
        default: ${get('spot_strategy', '')}  
        required: false 
        private: true 
    - spot_price_limit:  
        required: false  
    - spotPriceLimit: 
        default: ${get('spot_price_limit', '')}  
        required: false 
        private: true 
    - period:  
        required: false  
    - period_unit:  
        required: false  
    - periodUnit: 
        default: ${get('period_unit', '')}  
        required: false 
        private: true 
    - auto_renew:  
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
    - tags_key_list:  
        required: false  
    - tagsKeyList: 
        default: ${get('tags_key_list', '')}  
        required: false 
        private: true 
    - tags_value_list:  
        required: false  
    - tagsValueList: 
        default: ${get('tags_value_list', '')}  
        required: false 
        private: true 
    
  java_action: 
    gav: 'io.cloudslang.content:cs-alibaba:0.0.1-SNAPSHOT'
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
