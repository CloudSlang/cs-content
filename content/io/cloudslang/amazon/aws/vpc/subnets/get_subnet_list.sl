#   (c) Copyright 2022 Micro Focus, L.P.
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
#! @description: list the subnets.
#!
#! @input json_data: Json data file.
#! @input vpc_id: The IDs of the groups that you want to describe.
#!
#! @output subnet_list: returns list of subnets.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.vpc.subnets
operation:
  name: get_subnet_list
  inputs:
    - json_data:
        required: true
    - vpc_id
  python_action:
    use_jython: false
    script: "import json\n\ndef execute(json_data,vpc_id):\n    return_code = 0\n    error_message = ''\n    subnets_start = '<Subnets>'\n    subnets_end = '</Subnets>'\n    subnet_start = '<Subnet>'\n    subnet_end = '</Subnet>'\n    subnet_id_start = '<SubnetId>'\n    subnet_id_end = '</SubnetId>'\n    availabilityZone_start = '<AvailabilityZone>'\n    availabilityZone_end = '</AvailabilityZone>'\n    defaultSubnet_start = '<DefaultSubnet>'\n    defaultSubnet_end = '</DefaultSubnet>'\n    subnet_Name=''\n    isArray = \"[\" in json_data\n   \n    try:\n        json_load = (json.loads(json_data))\n        data=json_load['DescribeSubnetsResponse']['subnetSet']['item']\n        if (isArray):\n            for x in data:\n                if vpc_id in x['vpcId']:\n                    subnet_Name += subnet_start + '\\n'+ subnet_id_start+ x['subnetId'] + subnet_id_end + '\\n' + availabilityZone_start + x['availabilityZone'] + availabilityZone_end +'\\n'+defaultSubnet_start + x['defaultForAz']+defaultSubnet_end+'\\n'+subnet_end+'\\n'\n            \n            subnet_Name = subnets_start +'\\n' + subnet_Name +subnets_end\n        else:\n            subnet_Name = subnet_start + '\\n'+ subnet_id_start+ data['subnetId'] + subnet_id_end + '\\n' + availabilityZone_start + data['availabilityZone'] + availabilityZone_end +'\\n'+defaultSubnet_start + data['defaultForAz']+defaultSubnet_end+'\\n'+subnet_end +'\\n'\n            \n            subnet_Name = subnets_start +'\\n' + subnet_Name + subnets_end\n    except Exception as e:\n        return_code = 1\n        error_message = str(e)\n    return{\"subnet_list\":subnet_Name, \"return_code\": return_code, \"error_message\": error_message}"
  outputs:
    - subnet_list
    - return_code
    - error_message
  results:
    - SUCCESS


