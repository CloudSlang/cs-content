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
########################################################################################################################
#!!
#! @description: This python operation replaces empty string values for input properties with null and Maps comma-separated values to JSON
#!
#! @input hcmx_ci_instance_id: HCMX ci instance id. Default: '' Optional
#! @input hcmx_service_instance_id: HCMX service instance id. Default: '' Optional
#! @input hcmx_subscription_owner: HCMX subscription owner. Default: '' Optional
#! @input hcmx_subscription_id: HCMX subscription id. Default: '' Optional
#! @input hcmx_service_component_id: HCMX service component id. Default: '' Optional
#! @input hcmx_tenant_id: HCMX tenant id. Default: '' Optional
#!
#! @output result: If successful, returns the json (tag_names and tag_values mapped)
#!
#! @result SUCCESS: The values were successfully returned.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.databases.instances.utils
operation:
  name: list_to_json
  inputs:
    - hcmx_ci_instance_id:
        required: false
    - hcmx_service_instance_id:
        required: false
    - hcmx_subscription_owner:
        required: false
    - hcmx_subscription_id:
        required: false
    - hcmx_service_component_id:
        required: false
    - hcmx_tenant_id:
        required: false
  python_action:
    use_jython: false
    script: "def execute(hcmx_ci_instance_id, hcmx_service_component_id, hcmx_service_instance_id,\r\n            hcmx_subscription_owner,  hcmx_subscription_id, hcmx_tenant_id):\r\n\r\n    # Check if any of the input values are a single space character and replace them with null\r\n    if hcmx_ci_instance_id.strip() == \"\":\r\n        hcmx_ci_instance_id = \"null\"\r\n    if hcmx_service_component_id.strip() == \"\":\r\n        hcmx_service_component_id = \"null\"\r\n    if hcmx_service_instance_id.strip() == \"\":\r\n        hcmx_service_instance_id = \"null\"\r\n    if hcmx_subscription_owner.strip() == \"\":\r\n        hcmx_subscription_owner = \"null\"\r\n    if hcmx_subscription_id.strip() == \"\":\r\n        hcmx_subscription_id = \"null\"\r\n    if hcmx_tenant_id.strip() == \"\":\r\n        hcmx_tenant_id = \"null\"\r\n\r\n    # Create a dictionary that maps input properties to their corresponding values\r\n    result = {\r\n        \"hcmx_ci_instance_id\": hcmx_ci_instance_id,\r\n        \"hcmx_service_component_id\": hcmx_service_component_id,\r\n        \"hcmx_service_instance_id\": hcmx_service_instance_id,\r\n        \"hcmx_subscription_owner\": hcmx_subscription_owner,\r\n        \"hcmx_subscription_id\": hcmx_subscription_id,\r\n        \"hcmx_tenant_id\": hcmx_tenant_id\r\n    }\r\n\r\n    # Return the dictionary\r\n    return {\"result\": result}"
  outputs:
    - result
  results:
    - SUCCESS


