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
# Created by Florian TEISSEDRE - florian.teissedre@hpe.com
####################################################

namespace: io.cloudslang.heroku.collaborators

imports:
  collaborators: io.cloudslang.heroku.collaborators
  lists: io.cloudslang.base.lists

flow:
  name: test_delete_application_collaborator

  inputs:
    - username
    - password
    - collaborator_email_or_id
    - app_id_or_name

  workflow:
    - delete_application_collaborator:
        do:
          collaborators.delete_application_collaborator:
            - username
            - password
            - collaborator_email_or_id
            - app_id_or_name
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: check_result
          - FAILURE: DELETE_APPLICATION_COLLABORATOR_FAILURE

    - check_result:
        do:
          lists.compare_lists:
            - list_1: ${str(error_message) + "," + return_code + "," + status_code}
            - list_2: ",0,200"
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: CHECK_RESULT_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code

  results:
    - SUCCESS
    - DELETE_APPLICATION_COLLABORATOR_FAILURE
    - CHECK_RESULT_FAILURE
