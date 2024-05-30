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
#! @description: This operation is used to get host,protocol, and port details.
#!
#! @input provider_sap: Provider SAP.
#!
#! @output host_name: The host name of the VMWare vCloud director.
#! @output port: The port of the host.
#! @output protocol: The protocol for rest API call.
#!
#! @result SUCCESS: The vApp has been  deleted successfully.
#! @result FAILURE: Error in deleting vApp.
#!!#
########################################################################################################################

namespace: io.cloudslang.vmware.cloud_director.utils
operation:
  name: get_host_details
  inputs:
    - provider_sap
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(provider_sap):\n    provider_sap = provider_sap.split('://')\n    protocol = provider_sap[0]\n    hostname = provider_sap[1].split(':')[0]\n    if len(provider_sap[1].split(':')) == 2 :\n        port = provider_sap[1].split(':')[1]\n    else:\n        port = '443'\n    return{\"hostname\":hostname,\"port\":port,\"protocol\":protocol}   \n    # code goes here\n# you can add additional helper methods below."
  outputs:
    - hostname
    - protocol
    - port
  results:
    - SUCCESS