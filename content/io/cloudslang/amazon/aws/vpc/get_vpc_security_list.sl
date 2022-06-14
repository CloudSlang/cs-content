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
#! @description: list the security groups.
#!
#! @input json_data: Json data file.
#! @input vpc_id: The IDs of the groups that you want to describe.
#!
#! @output vpc_security_list: returns list of security groups.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.vpc
operation:
  name: get_vpc_security_list
  inputs:
    - json_data:
        required: true
    - vpc_id
  python_action:
    use_jython: false
    script: "import json\n\ndef execute(json_data,vpc_id):\n    return_code = 0\n    error_message = ''\n    securityGroups_start = '<SecurityGroups>'\n    securityGroups_end = '</SecurityGroups>'\n    securityGroup_start = '<SecurityGroup>'\n    securityGroup_end = '</SecurityGroup>'\n    securityGroup_id_start = '<SecurityGroupId>'\n    securityGroup_id_end = '</SecurityGroupId>'\n    securityGroup_name_start = '<SecurityGroupName>'\n    securityGroup_name_end = '</SecurityGroupName>'\n    security_names = ''\n    isArray = \"[\" in json_data\n    try:\n        json_load = (json.loads(json_data))\n        data=json_load['DescribeSecurityGroupsResponse']['securityGroupInfo']['item']\n        if (isArray):\n            for x in data:\n                if vpc_id in x['vpcId']:\n                    security_names += securityGroup_start + '\\n'+ securityGroup_id_start+ x['groupId'] + securityGroup_id_end + '\\n' + securityGroup_name_start + x['groupName'] + securityGroup_name_end +'\\n'+securityGroup_end +'\\n'\n            \n            security_names = securityGroups_start +'\\n' + security_names + securityGroups_end        \n        else:\n            security_names += securityGroup_start + '\\n'+ securityGroup_id_start+ x['groupId'] + securityGroup_id_end + '\\n' + securityGroup_name_start + x['groupName'] + securityGroup_name_end +'\\n'+securityGroup_end +'\\n'\n            \n            security_names = securityGroups_start +'\\n' + security_names + securityGroups_end\n    except Exception as e:\n        return_code = 1\n        error_message = str(e)\n    return{\"vpc_security_list\":security_names, \"return_code\": return_code, \"error_message\": error_message}"
  outputs:
    - vpc_security_list
    - return_code
    - error_message
  results:
    - SUCCESS

