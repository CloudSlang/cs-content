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
#! @input json_response: response of cAdvisor container information
#! @input machine_memory_limit: Optional - container machine memory limit - Default: -1
#!
#! @output decoded: parsed response
#! @output spec: parsed cAdvisor spec
#! @output stats: parsed cAdvisor stats
#! @output timestamp: time used to calculate the stat
#! @output cpu: parsed cAdvisor CPU
#! @output memory: parsed cAdvisor memory
#! @output network: parsed cAdvisor network
#! @output cpu_usage: calculated CPU usage of the container
#! @output memory_usage: calculated memory usage of the container; the container memory usage divided by the
#!                       machine_memory_limit or by the minimum memory limit of the container whichever is smaller
#! @output throughput_rx: calculated network Throughput Rx bytes
#! @output throughput_tx: calculated network Throughput Tx bytes
#! @output error_rx: calculated network error Rx
#! @output error_tx: calculated network error Tx
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
  name: parse_container
  inputs:
    - json_response
    - machine_memory_limit:
        default: '-1'
        required: false

  python_action:
    script: |
      try:
        import json
        decoded = json.loads(json_response)
        for key, value in decoded.items():
          statsPrev= value['stats'][len(value['stats'])-2]
          stats= value['stats'][len(value['stats'])-1]
          spec = value['spec']
        cpu=stats['cpu']
        memory=stats['memory']
        network=stats['network']
        timestamp=stats['timestamp']
        prev_timestamp=statsPrev['timestamp']
        cpu_total=cpu['usage']['total']
        prev_cpu_total=statsPrev['cpu']['usage']['total']
        timestamp_arr=timestamp.split(':')[2];
        prev_timestamp_arr=prev_timestamp.split(':')[2];
        interval=float(timestamp_arr[0:-1])-float(prev_timestamp_arr[0:-1])
        interval=interval*1000000000
        cpu_usage=float(cpu_total)-float(prev_cpu_total)
        cpu_usage=cpu_usage/interval
        throughput_tx=float(network['tx_bytes'])-float(statsPrev['network']['tx_bytes'])
        throughput_tx=throughput_tx/interval
        throughput_rx=float(network['rx_bytes'])-float(statsPrev['network']['rx_bytes'])
        throughput_rx=throughput_rx/interval
        error_tx=float(network['tx_errors'])-float(statsPrev['network']['tx_errors'])
        error_tx=error_tx/interval
        error_rx=float(network['rx_errors'])-float(statsPrev['network']['rx_errors'])
        error_rx=error_rx/interval
        memory_usage=float(memory['usage'])
        min=long(spec['memory']['limit'])
        machine_memory_limit=long(machine_memory_limit)
        if machine_memory_limit != -1:
          if min>machine_memory_limit:
            min=machine_memory_limit
        memory_usage=memory_usage/min
        return_code = '0'
        return_result = 'Parsing successful.'
      except Exception as ex:
        return_code = '-1'
        return_result = 'Parsing error: ' + str(ex)

  outputs:
    - decoded: ${str(decoded)}
    - spec: ${str(spec)}
    - stats: ${str(stats)}
    - timestamp: ${str(timestamp)}
    - cpu: ${str(cpu)}
    - memory: ${str(memory)}
    - network: ${str(network)}
    - cpu_usage: ${str(cpu_usage)}
    - memory_usage: ${str(memory_usage)}
    - throughput_rx: ${str(throughput_rx)}
    - throughput_tx: ${str(throughput_tx)}
    - error_rx: ${str(error_rx)}
    - error_tx: ${str(error_tx)}
    - return_code: ${str(return_code)}
    - return_result
    - error_message: ${return_result if return_code == '-1' else ''}

  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE
