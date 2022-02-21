########################################################################################################################
#!!
#!   (c) Copyright 2022 Micro Focus, L.P.
#!   All rights reserved. This program and the accompanying materials
#!   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#!
#!   The Apache License is available at
#!   http://www.apache.org/licenses/LICENSE-2.0
#!
#!   Unless required by applicable law or agreed to in writing, software
#!   distributed under the License is distributed on an "AS IS" BASIS,
#!   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#!   See the License for the specific language governing permissions and
#!   limitations under the License.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.octane.v1.utils
operation:
  name: create_cookie
  inputs:
    - response_headers
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function
      def execute(response_headers):
          # code goes here
          string = response_headers.split("OCTANE_USER=")
          string = string[1].split(";Version")

          cookie = 'cookie: OCTANE_USER:' + string[0] + '; LWSSO_COOKIE_KEY='
          string = string[1].split("LWSSO_COOKIE_KEY=")
          cookie = cookie + string[1]
          return locals()
      # you can add additional helper methods below.
  outputs:
    - cookie
  results:
    - SUCCESS
