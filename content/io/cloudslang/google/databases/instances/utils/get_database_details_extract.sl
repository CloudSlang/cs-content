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
#! @description: This python operation can be used to retrieve the information of instance from JSON.
#!
#! @input instance_json: Instance details in JSON.
#!
#! @output instance_name: The name of the database instance
#! @output self_link: The URI of this resource.
#! @output database_version: The database engine type and version.
#! @output connection_name: The database engine type and version. The databaseVersion field cannot be changed after instance creation.
#! @output instance_state: The current state of the database instance.
#! @output availability_type: ZONAL: The instance serves data from only one zone. REGIONAL: The instance can serve data from more than one zone in a region.
#! @output data_disk_size_gb: The size of data disk, in GB.
#! @output data_disk_type: The type of data disk.
#! @output region: The geographical region where the instance has to be created.
#! @output zone: The name of the zone in which the disks has to be created.
#! @output public_ip_address: The public ip address of the instance.
#! @output private_ip_address: The private ip address of the instance.
#! @output tier: The Machine type of the instance.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.databases.instances.utils
operation:
  name: get_database_details_extract
  inputs:
    - instance_json
  python_action:
    use_jython: false
    script: "import json\r\n\r\ndef execute(instance_json):\r\n    json_load = json.loads(instance_json)\r\n    instance_name = json_load['name']\r\n    self_link = json_load['selfLink']\r\n    database_version = json_load['databaseVersion']\r\n    connection_name = json_load['connectionName']\r\n    availability_type = json_load['settings']['availabilityType']\r\n    activation_policy = json_load['settings']['activationPolicy']\r\n    data_disk_size_gb = json_load['settings']['dataDiskSizeGb']\r\n    tier=json_load['settings']['tier']\r\n    data_disk_type = json_load['settings']['dataDiskType']\r\n    region = json_load['region']\r\n    zone = json_load['gceZone']\r\n    \r\n    # extract ip addresses\r\n    ip_addresses = json_load.get(\"ipAddresses\")\r\n    result = {\"public_ip_address\": \"\", \"private_ip_address\": \"\"}\r\n    if ip_addresses:\r\n        for ip in ip_addresses:\r\n            if ip.get(\"type\") == \"PRIMARY\":\r\n                result[\"public_ip_address\"] = ip.get(\"ipAddress\")\r\n            elif ip.get(\"type\") == \"PRIVATE\":\r\n                result[\"private_ip_address\"] = ip.get(\"ipAddress\")\r\n    \r\n    if activation_policy == \"ALWAYS\":\r\n        instance_state = 'RUNNING'\r\n    else:\r\n        instance_state = 'STOPPED'\r\n    \r\n    return {\r\n        \"instance_name\": instance_name,\r\n        \"public_ip_address\": result['public_ip_address'],\r\n        \"private_ip_address\": result['private_ip_address'],\r\n        \"database_version\": database_version,\r\n        \"self_link\": self_link,\r\n        \"connection_name\": connection_name,\r\n        \"instance_state\": instance_state,\r\n        \"availability_type\": availability_type,\r\n        \"data_disk_size_gb\": data_disk_size_gb,\r\n        \"data_disk_type\" :data_disk_type,\r\n        \"region\": region,\r\n        \"tier\":tier,\r\n        \"zone\": zone\r\n    }"
  outputs:
    - instance_name
    - self_link
    - database_version
    - connection_name
    - instance_state
    - availability_type
    - data_disk_size_gb
    - data_disk_type
    - region
    - zone
    - public_ip_address
    - private_ip_address
    - tier
  results:
    - SUCCESS

