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
  name: create_body_update_user_role
  inputs:
    - id_actual_user_role
    - id_new_user_role
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function
      def execute(id_actual_user_role, id_new_user_role):
          body='{"workspace_roles": {"data": [{"type": "workspace_role","id": "'+id_actual_user_role+'"} , {"type": "workspace_role","id": "'+id_new_user_role+'"} ]}}'
          return locals()
      # you can add additional helper methods below.
  outputs:
    - body
  results:
    - SUCCESS
