#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: Poll host repeatedly until TCP port is open.
#!
#! @input host: Hostname or IP to check.
#! @input port: TCP port number to check.
#! @input timeout: Optional - Timeout, in seconds, for each check, throttles the polling.
#!                 Default: '10'
#! @input tries: Optional - Total number of tries: total wait time = timeout x tries.
#!               Default: '30'
#!
#! @result SUCCESS: Connection successful, host is active and listening on port.
#! @result FAILURE: Host is not listening, port is closed or host down.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.network

operation:
  name: wait_port_open

  inputs:
    - host
    - port
    - timeout:
        default: "10"
        required: false
    - tries:
        default: "30"
        required: false

  python_action:
    script: |
      import socket, time, sys
      is_open = False

      for t in range(0, int(tries)):
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        sock.settimeout(float(timeout))
        res = sock.connect_ex((host, int(port)))
        if res in [0, 10056]:
          is_open = True
          break
        elif res != None:
          time.sleep(float(timeout))

      sock.close()
      del sock

  results:
    - SUCCESS: ${ is_open == True }
    - FAILURE
