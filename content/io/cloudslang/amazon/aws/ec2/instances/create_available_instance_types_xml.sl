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
#! @description: Converts all instance types from the JSON format to XML.
#!
#! @input json_data: Json data file.
#!
#! @output available_instance_types_list: list of all available instance types in XML.
#!!#
########################################################################################################################
namespace: io.cloudslang.amazon.aws.ec2.instances
operation:
  name: create_available_instance_types_xml
  inputs:
    - json_data
  python_action:
    use_jython: false
    script: "import json\n\ndef execute(json_data):\n    return_code = 0\n    error_message = ''\n    instances_start = '<InstanceTypes>'\n    instances_end = '</InstanceTypes>'\n    instance_start = '<instanceType>'\n    instance_end = '</instanceType>'\n    name_start = '<Name>'\n    name_end = '</Name>'\n    instance_types = ''\n\n    \n    isArray = \"[\" in json_data\n    try:\n        json_load = (json.loads(json_data))\n        data=json_load['DescribeInstanceTypeOfferingsResponse']['instanceTypeOfferingSet']['item']\n        if (isArray):\n            for x in data:\n                instance_types += instance_start + '\\n' + name_start + x['instanceType'] + name_end + '\\n' + instance_end + '\\n'\n        \n            instance_types = instances_start + '\\n' + instance_types + instances_end\n        else:\n            instance_types = instance_start + '\\n'+ name_start + data['instanceType'] + name_end + '\\n' + instance_end + '\\n'\n            \n            instance_types = instances_start + instance_types  + instances_end\n            \n    except Exception as e:\n        return_code = 1\n        error_message = str(e)\n    return{\"available_instance_types_list\":instance_types, \"return_code\": return_code, \"error_message\": error_message}"
  outputs:
    - available_instance_types_list
  results:
    - SUCCESS