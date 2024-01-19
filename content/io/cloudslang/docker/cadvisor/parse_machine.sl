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
#! @description: Parses the response of the cAdvisor container information.
#!
#! @input json_response: response of the cAdvisor container information
#!
#! @output decoded: parsed response
#! @output num_cores: machine number of cores
#! @output cpu_frequency_khz: machine CPU
#! @output memory_capacity: machine memory
#! @output file_systems: parsed cAdvisor machine filesystems
#! @output disk_map: parsed cAdvisor machine disk map
#! @output network_devices: parsed cAdvisor machine network devices
#! @output topology: parsed cAdvisor machine topology
#! @output return_code: '0' if parsing was successful, '-1' otherwise
#! @output return_result: notification string; was parsing was successful or not
#! @output error_message: return_result if there was an error
#!
#! @result SUCCESS: parsing was successful (return_code == '0')
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.docker.cadvisor

operation:
  name: parse_machine

  inputs:
    - json_response

  python_action:
    script: |
      try:
        import json
        decoded = json.loads(json_response)
        num_cores=int(decoded['num_cores'])
        cpu_frequency_khz=int(decoded['cpu_frequency_khz'])
        memory_capacity=int(decoded['memory_capacity'])
        file_systems=decoded['filesystems']
        disk_map=decoded['disk_map']
        network_devices=decoded['network_devices']
        topology=decoded['topology']
        return_code = '0'
        return_result = 'Parsing successful.'
      except:
        return_code = '-1'
        return_result = 'Parsing error.'

  outputs:
    - decoded: ${ str(decoded) }
    - num_cores: ${str(num_cores)}
    - cpu_frequency_khz: ${str(cpu_frequency_khz)}
    - memory_capacity: ${ str(memory_capacity) }
    - file_systems: ${ str(file_systems) }
    - disk_map: ${ str(disk_map) }
    - network_devices: ${ str(network_devices) }
    - topology: ${ str(topology) }
    - return_code
    - return_result
    - error_message: ${return_result if return_code == '-1' else ''}

  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE
