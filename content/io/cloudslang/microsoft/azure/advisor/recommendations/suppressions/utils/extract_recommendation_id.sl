#   (c) Copyright 2024 Micro Focus, L.P.
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
#! @description: This operation is used to extract recommendation id's .
#!
#! @input resource_id_list: List of extracted resource id 
#!
#! @output return_result: List of extracted recommendation id's
#!
#! @result SUCCESS: Successfully extracted List of  recommendation id's.
#!!#
########################################################################################################################
namespace: io.cloudslang.microsoft.azure.advisor.recommendations.suppressions.utils
operation:
  name: extract_recommendation_id
  inputs:
    - resource_id_list
  python_action:
    use_jython: false
    script: "def execute(resource_id_list):\r\n    resource_id_list=resource_id_list.split(',')\r\n    return_code=0\r\n    recommendation_ids = []\r\n    for resource_id in resource_id_list:\r\n        parts = resource_id.split('/recommendations/')\r\n        if len(parts) > 1:\r\n            recommendation_id = parts[1].split('/')[0]\r\n            recommendation_ids.append(recommendation_id)\r\n    return{\"return_code\": return_code, \"return_result\": recommendation_ids}"
  outputs:
    - return_result
  results:
    - SUCCESS

