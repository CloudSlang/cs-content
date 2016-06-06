####################################################
#!!
#! @description: Performs a REST API call to get the details of a specified Heroku collaborator.
#! @input username: Heroku username
#!                  example: 'someone@mailprovider.com'
#! @input password: Heroku password used for authentication
#! @input app_id_or_name: ID or name of Heroku application that collaborator is associated with
#! @input collaborator_email_or_id: email or ID of collaborator
#! @input trust_keystore: optional - the pathname of the Java TrustStore file. This contains certificates from other parties
#!                        that you expect to communicate with, or from Certificate Authorities that you trust to
#!                        identify other parties.  If the protocol (specified by the 'url') is not 'https' or if
#!                        trustAllRoots is 'true' this input is ignored.
#!                        Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: optional - the password associated with the TrustStore file. If trustAllRoots is false and trustKeystore is empty,
#!                        trustPassword default will be supplied.
#!                        Default value: changeit
#! @input keystore: optional - the pathname of the Java KeyStore file. You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is 'true' this input is ignored.
#!                  Default value: ..JAVA_HOME/java/lib/security/cacerts
#!                  Format: Java KeyStore (JKS)
#! @input keystore_password: optional - the password associated with the KeyStore file. If trustAllRoots is false and keystore
#!                           is empty, keystorePassword default will be supplied.
#!                           Default value: changeit
#! @output return_result: response of the operation in case of success, error message otherwise
#! @output error_message: return_result if status_code is not '200'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by operation
#! @output id: ID of the collaborator; useful when <collaborator_email_or_id> is a name
#! @output created_at: time when collaborator was created/added
#!                     example: '2016-01-04T14:49:53Z'
#! @output updated_at: time when collaborator was last updated
#!                     example: '2016-01-04T14:49:53Z'
#! @result SUCCESS: Heroku collaborator details were successfully retrieved
#! @result GET_COLLABORATOR_DETAILS_FAILURE: Heroku collaborator details could not be retrieved
#! @result GET_COLLABORATOR_ID_FAILURE: ID of collaborator could not be retrieved from GET REST API call response
#! @result GET_CREATED_AT_FAILURE: created_at collaborator time could not be retrieved from GET REST API call response
#! @result GET_UPDATED_AT_FAILURE: updated_at collaborator time could not be retrieved from GET REST API call response
#!!#
####################################################

namespace: io.cloudslang.cloud.heroku.collaborators

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
    - trust_keystore: ${get_sp('io.cloudslang.base.http.trust_keystore')}
    - trust_password: ${get_sp('io.cloudslang.base.http.trust_password')}
    - keystore: ${get_sp('io.cloudslang.base.http.keystore')}
    - keystore_password: ${get_sp('io.cloudslang.base.http.keystore_password')}

  workflow:
    - details_app_collaborator:
        do:
          rest.http_client_get:
            - url: ${'https://api.heroku.com/apps/' + app_id_or_name +'/collaborators/' + collaborator_email_or_id}
            - username
            - password
            - headers: "Accept:application/vnd.heroku+json; version=3"
            - content_type: "application/json"
            - trust_all_roots: "false"
            - x_509_hostname_verifier: "strict"
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
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
            - json_path: ['id']
        publish:
          - id: ${value}
        navigate:
          - SUCCESS: get_created_at
          - FAILURE: GET_COLLABORATOR_ID_FAILURE

    - get_created_at:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['created_at']
        publish:
          - created_at: ${value}
        navigate:
          - SUCCESS: get_updated_at
          - FAILURE: GET_CREATED_AT_FAILURE

    - get_updated_at:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['updated_at']
        publish:
          - updated_at: ${value}
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
