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
#! @description: Gets keys from a map.
#!
#! @input map: Map.
#!             Example: {'laptop': 1000, 'docking station':200, 'monitor': 500, 'phone': 100}
#!
#! @output result: Keys from map.
#!
#! @result SUCCESS: Keys retrieved successfully.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.maps

operation:
  name: get_keys

  inputs:
    - map

  python_action:
    script: |
      import ast
      map = ast.literal_eval(map)
      keys=[]
      for key, item in map.items():
        keys.append(str(key))

  outputs:
    - result: ${str(keys)}

  results:
    - SUCCESS
