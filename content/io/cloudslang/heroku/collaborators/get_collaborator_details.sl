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
#! @description: Performs a REST API call to get the details of a specified Heroku collaborator.
#!
#! @input username: Heroku username
#!                  example: 'someone@mailprovider.com'
#! @input password: Heroku password used for authentication
#! @input app_id_or_name: ID or name of Heroku application that collaborator is associated with
#! @input collaborator_email_or_id: email or ID of collaborator
#!
#! @output return_result: response of the operation in case of success, error message otherwise
#! @output error_message: return_result if status_code is not '200'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by operation
#! @output id: ID of the collaborator; useful when <collaborator_email_or_id> is a name
#! @output created_at: time when collaborator was created/added
#!                     example: '2016-01-04T14:49:53Z'
#! @output updated_at: time when collaborator was last updated
#!                     example: '2016-01-04T14:49:53Z'
#!
#! @result SUCCESS: Heroku collaborator details were successfully retrieved
#! @result GET_COLLABORATOR_DETAILS_FAILURE: Heroku collaborator details could not be retrieved
#! @result GET_COLLABORATOR_ID_FAILURE: ID of collaborator could not be retrieved from GET REST API call response
#! @result GET_CREATED_AT_FAILURE: created_at collaborator time could not be retrieved from GET REST API call response
#! @result GET_UPDATED_AT_FAILURE: updated_at collaborator time could not be retrieved from GET REST API call response
#!!#
########################################################################################################################

namespace: io.cloudslang.heroku.collaborators

imports:
  rest: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: get_collaborator_details

  inputs:
    - username
    - password:
        sensitive: true
    - app_id_or_name
    - collaborator_email_or_id

  workflow:
    - details_app_collaborator:
        do:
          rest.http_client_get:
            - url: ${'https://api.heroku.com/apps/' + app_id_or_name +'/collaborators/' + collaborator_email_or_id}
            - username
            - password
            - headers: "Accept:application/vnd.heroku+json; version=3"
            - content_type: "application/json"
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
        navigate:
          - SUCCESS: get_id
          - FAILURE: GET_COLLABORATOR_DETAILS_FAILURE

    - get_id:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "id"
        publish:
          - id: ${return_result}
        navigate:
          - SUCCESS: get_created_at
          - FAILURE: GET_COLLABORATOR_ID_FAILURE

    - get_created_at:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "created_at"
        publish:
          - created_at: ${return_result}
        navigate:
          - SUCCESS: get_updated_at
          - FAILURE: GET_CREATED_AT_FAILURE

    - get_updated_at:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: "updated_at"
        publish:
          - updated_at: ${return_result}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: GET_UPDATED_AT_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - id
    - created_at
    - updated_at

  results:
    - SUCCESS
    - GET_COLLABORATOR_DETAILS_FAILURE
    - GET_COLLABORATOR_ID_FAILURE
    - GET_CREATED_AT_FAILURE
    - GET_UPDATED_AT_FAILURE
