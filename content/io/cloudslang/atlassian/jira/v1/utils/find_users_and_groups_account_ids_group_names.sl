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
namespace: io.cloudslang.atlassian.jira.v1.utils
operation:
  name: find_users_and_groups_account_ids_group_names
  inputs:
    - return_result
  python_action:
    use_jython: false
    script: |-
      import json

      def execute(return_result):
          account_ids = ""
          group_names = ""
          json_obj = json.loads(return_result)
          for user in json_obj["users"]["users"]:
              account_ids = account_ids + user["accountId"] + ","
          account_ids = account_ids[:-1]
          for group in json_obj["groups"]["groups"]:
              group_names = group_names + group["name"] + ","
          group_names = group_names[:-1]
          return{"account_ids":account_ids,"group_names":group_names}
  outputs:
    - account_ids
    - group_names
  results:
    - SUCCESS
