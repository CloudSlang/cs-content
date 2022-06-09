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
#! @description: list of key pairs.
#!
#! @input json_data: Json data file.
#!
#! @output key_pair_list: returns list of key pairs.
#!!#
########################################################################################################################
namespace: io.cloudslang.amazon.aws.ec2.keypairs
operation:
  name: get_key_pair_list
  inputs:
    - json_data
  python_action:
    use_jython: false
    script: "import json\n\ndef execute(json_data):\n    return_code = 0\n    error_message = ''\n    keyPairs_start = '<Keypairs>'\n    keyPairs_end = '</Keypairs>'\n    keyPair_start = '<Keypair>'\n    keyPair_end = '</Keypair>'\n    name_start = '<Name>'\n    name_end = '</Name>'\n    keyPair_Name=''\n\n    \n    isArray = \"[\" in json_data\n    try:\n        json_load = (json.loads(json_data))\n        data=json_load['DescribeKeyPairsResponse']['keySet']['item']\n        if (isArray):\n            for x in data:\n                keyPair_Name += keyPair_start + '\\n'+ name_start+ x['keyName'] + name_end + '\\n' + keyPair_end + '\\n'\n              \n            keyPair_Name = keyPairs_start +'\\n' + keyPair_Name + keyPairs_end\n        else:\n            keyPair_Name = keyPair_start + '\\n'+ name_start+ data['keyName'] + name_end + '\\n' + keyPair_end + '\\n'\n         \n            keyPair_Name = keyPairs_start +'\\n' + keyPair_Name + keyPairs_end\n            \n    except Exception as e:\n        return_code = 1\n        error_message = str(e)\n    return{\"key_pair_list\":keyPair_Name, \"return_code\": return_code, \"error_message\": error_message}"
  outputs:
    - key_pair_list
  results:
    - SUCCESS