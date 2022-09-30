#   (c) Copyright 2022 Micro Focus, L.P.
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
#! @description: This operation is used to get the terraform run id and plan id from list of terraform runs.
#!
#! @input run_list: The list of terraform runs.
#!
#! @output tf_run_id: The terraform run id.
#! @output tf_plan_id: The terraform plan id.
#!
#! @result SUCCESS: The request was successfully executed.
#!!#
########################################################################################################################
namespace: io.cloudslang.hashicorp.terraform.automation_content.resourcesync.subflows
operation:
  name: get_run_id_and_plan_id_python
  inputs:
    - run_list
  python_action:
    use_jython: false
    script: |-
      import json
      def execute(run_list):
          tf_run_id = ' '
          tf_plan_id = ' '
          y = json.loads(run_list)

          for i in y['data']:
              status = i['attributes']['status']
              if status == 'planned' or status == 'applied':
                  tf_run_id = i['id']
                  tf_plan_id = i["relationships"]["plan"]["data"]["id"]
                  break

          return {'tf_run_id': tf_run_id, 'tf_plan_id':tf_plan_id}
  outputs:
    - tf_run_id
    - tf_plan_id
  results:
    - SUCCESS
