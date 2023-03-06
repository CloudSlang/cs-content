#   (c) Copyright 2023 Micro Focus, L.P.
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
#! @description: This operation is used to form the request body of the insert instance based on the provided inputs.
#!
#! @input instance_name_prefix: The name of the resource, provided by the client when initially creating the resource. The
#!                              resource name must be 1-63 characters long, and comply with RFC1035. Specifically, the name
#!                              must be 1-63 characters long and match the regular expression [a-z]([-a-z0-9]*[a-z0-9])? which
#!                              means the first character must be a lowercase letter, and all following characters must be a
#!                              dash, lowercase letter, or digit, except the last character, which cannot be a dash.
#! @input root_password: The initial root password. Use only on creation.
#! @input region: The geographical region where the instance has to be created.
#!                Examples: 'us-central1','us-east1'.
#! @input zone: The name of the zone in which the disks has to be created.
#!              Examples: 'us-central1-a', 'us-central1-b', 'us-central1-c'.
#!              Optional
#! @input instance_type: The instance type.
#!                       Examples: 'CLOUD_SQL_INSTANCE','ON_PREMISES_INSTANCE'
#!                       Optional
#! @input database_version: The database engine type and version. The databaseVersion field cannot be changed after
#!                          instance creation.
#!                          Examples: 'MYSQL_8_0','POSTGRES_10'.
#! @input tier: The tier (or machine type) for this instance.
#!              Example:'db-custom-1-3840'.
#! @input data_disk_type: The type of data disk.
#!                       Default: 'PD_SSD'.
#!                       Valid Values: 'PD_SSD', 'PD_HDD'.
#! @input data_disk_size_gb: The size of data disk, in GB. The data disk size minimum is 10GB.
#!                          Default: '10'.
#! @input storage_autoresize: The configuration to increase storage size automatically.
#!                            Default: 'true'.
#! @input availability_type: Availability type.
#!                           Valid values: - ZONAL: The instance serves data from only one zone.
#!                                                  Outages in that zone affect data accessibility.
#!                                         - REGIONAL: The instance can serve data from more than one zone in a region.
#!                           Default: 'REGIONAL'.
#! @input maintenance_window_day: Maintenance window day specifies the day of week (1-7),starting on Monday,when a Cloud
#!                                SQL instance is restarted for system maintenance purposes.
#!                                Default: '7'.
#! @input maintenance_window_hour: Maintenance window hour specifies the hour of day(0 to 23), when a Cloud SQL instance
#!                                 is restarted for system maintenance purposes.
#!                                 Default: '0'.
#! @input activation_policy: The activation policy specifies when the instance is activated;  it is applicable only when
#!                           the instance state is RUNNABLE.
#!                           Valid values: - ALWAYS: The instance remains on even in the absence of connection requests.
#!                                         - NEVER: The instance is not activated, even if a connection request arrives.
#!                           Default: 'ALWAYS'.
#! @input ipv4_enabled: This specifies whether the instance is assigned a public IP address or not.
#!                      Default: 'true'.
#! @input private_network: The resource link for the VPC network from which the instance is accessible for private IP.
#!                         This setting can be updated, but it cannot be removed after it is set.
#!                         Example: '/projects/myProject/global/networks/default'.
#!                         Optional
#! @input deletion_protection_enabled: Configuration to protect against accidental instance deletion.
#!                                     Default: 'false'.
#! @input label_keys: The labels key list separated by comma(,).
#!                    Keys must conform to the following regexp: [a-zA-Z0-9-_]+, and be less than 128 bytes in
#!                    length. This is reflected as part of a URL in the metadata server. Additionally,
#!                    to avoid ambiguity, keys must not conflict with any other metadata keys for the project.
#!                    The length of the itemsKeysList must be equal with the length of the itemsValuesList.
#!                    Optional
#! @input label_values: The labels value list separated by comma(,).
#!                      Optional
#!
#! @output return_result: The insert instance request body.
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise.
#!
#! @result SUCCESS: The request body formed successfully.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.databases.instances.utils
operation:
  name: insert_instance_request_body
  inputs:
    - instance_name_prefix
    - root_password:
        sensitive: true
    - region
    - zone
    - instance_type
    - database_version:
        required: false
    - tier:
        required: false
    - data_disk_type:
        required: false
    - data_disk_size_gb:
        required: false
    - storage_autoresize:
        required: false
    - availability_type:
        required: false
    - maintenance_window_day:
        required: false
    - maintenance_window_hour:
        required: false
    - activation_policy:
        required: false
    - ipv4_enabled:
        required: false
    - private_network:
        required: false
    - deletion_protection_enabled:
        required: false
    - label_keys_list:
        required: false
    - label_values_list:
        required: false
  python_action:
    use_jython: false
    script: "import json\r\ndef execute(instance_name_prefix,region,zone,database_version,instance_type,tier,
    root_password,availability_type,activation_policy,storage_autoresize,data_disk_type,data_disk_size_gb,
    deletion_protection_enabled,label_keys_list,label_values_list,ipv4_enabled,private_network,maintenance_window_day,
    maintenance_window_hour):\r\n    return_code = 0\r\n    return_result = '\"name\": \"'+instance_name_prefix+'\",
    \"region\": \"'+region+'\",\"gceZone\": \"'+zone+'\"'\r\n    if database_version != '':\r\n        return_result =
    return_result + ',\"databaseVersion\": \"'+database_version+'\"'\r\n    if instance_type != '':\r\n
    return_result = return_result + ',\"instanceType\": \"'+instance_type+'\"'\r\n    if root_password != '':\r\n
      return_result = return_result + ',\"rootPassword\": \"'+root_password+'\"'\r\n    return_result = return_result
      +',\"settings\": {\"tier\": \"'+tier+'\"'\r\n    if availability_type != '':\r\n        return_result =
      return_result + ',\"availabilityType\": \"'+availability_type+'\"'\r\n    if activation_policy != '':\r\n
      return_result = return_result + ',\"activationPolicy\": \"'+activation_policy+'\"'\r\n    if storage_autoresize
      != '':\r\n        return_result = return_result + ',\"storageAutoResize\": '+storage_autoresize+','\r\n    if
      data_disk_type != '':\r\n        return_result = return_result + '\"dataDiskType\": \"'+data_disk_type+'\"'\r\n
        if data_disk_size_gb != '':\r\n        return_result = return_result + ',\"dataDiskSizeGb\":
        '+data_disk_size_gb+','\r\n    if deletion_protection_enabled != '':\r\n        return_result = return_result +
         '\"deletionProtectionEnabled\": '+deletion_protection_enabled+','\r\n    if label_keys_list != '':\r\n
         label_key=label_keys_list.split(',')\r\n        label_value=label_values_list.split(',')\r\n
         return_result = return_result+'\"userLabels\": '+json.dumps(dict(zip(label_key,label_value)))\r\n    if
         ipv4_enabled != '':\r\n        return_result = return_result +',\"ipConfiguration\":
         {\"ipv4Enabled\":'+ipv4_enabled+'}}'\r\n    if private_network != '':\r\n        return_result = return_result
          +',\"ipConfiguration\": {\"privateNetwork\":'+private_network+'}},'\r\n    if maintenance_window_day != ''
          and maintenance_window_hour != '':\r\n        return_result = return_result +',\"maintenanceWindow\":
          {\"day\":'+maintenance_window_day+',\"hour\":'+maintenance_window_hour+'}'\r\n    return{\"return_code\":
          return_code, \"return_result\": '{'+return_result+'}'}"
  outputs:
    - return_result
    - return_code
  results:
    - SUCCESS

