####################################################
#!!
#! @description: Performs a REST API call to create/add a new domain on a specified application.
#! @input username: Heroku username
#!                  example: 'someone@mailprovider.com'
#! @input password: Heroku password used for authentication
#! @input app_id_or_name: ID or name of the Heroku application
#! @input hostname: full hostname of new domain to be created
#!                  example: 'subdomain.example.com'
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
#! @output error_message: return_result if status_code is not '201'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by the operation
#! @output id: ID of created domain
#!             example: '4517af43-3564-4c74-b0d0-da9344ee32c1'
#! @output created_at: exact time when domain was created
#!                     example: '2016-01-04T14:49:53Z'
#! @result SUCCESS: new domain was successfully created/added
#! @result INSERT_HOSTNAME_VALUE_FAILURE: insert 'hostname' key:value pair in a empty JSON step failed
#! @result CREATE_DOMAIN_FAILURE: create Heroku application domain REST API call failed
#! @result GET_ID_FAILURE: ID of newly created domain could not be retrieved from create REST API call response
#! @result GET_CREATED_AT_FAILURE: time when newly created domain was created could not be retrieved from create REST API call response
#!!#
####################################################
namespace: io.cloudslang.cloud.heroku.domains

imports:
  rest: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: create_domain
  inputs:
    - username
    - password:
        sensitive: true
    - app_id_or_name
    - hostname
    - trust_keystore: ${get_sp('io.cloudslang.base.http.trust_keystore')}
    - trust_password: ${get_sp('io.cloudslang.base.http.trust_password')}
    - keystore: ${get_sp('io.cloudslang.base.http.keystore')}
    - keystore_password: ${get_sp('io.cloudslang.base.http.keystore_password')}

  workflow:
    - insert_hostname_value:
        do:
          json.add_value:
            - json_input: "{}"
            - json_path: ['hostname']
            - value: ${hostname}
        publish:
          - body_json: ${json_output}
          - return_result
          - error_message
          - return_code
        navigate:
          - SUCCESS: create_domain
          - FAILURE: INSERT_HOSTNAME_VALUE_FAILURE

    - create_domain:
        do:
          rest.http_client_post:
            - url: ${'https://api.heroku.com/apps/' + app_id_or_name +'/domains'}
            - username
            - password
            - headers: "Accept:application/vnd.heroku+json; version=3"
            - body: ${body_json}
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
          - FAILURE: CREATE_DOMAIN_FAILURE

    - get_id:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['id']
        publish:
          - id: ${value}
        navigate:
          - SUCCESS: get_created_at
          - FAILURE: GET_ID_FAILURE

    - get_created_at:
        do:
          json.get_value:
            - json_input: ${return_result}
            - json_path: ['created_at']
        publish:
          - created_at: ${value}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: GET_CREATED_AT_FAILURE

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - id
    - created_at

  results:
    - SUCCESS
    - INSERT_HOSTNAME_VALUE_FAILURE
    - CREATE_DOMAIN_FAILURE
    - GET_ID_FAILURE
    - GET_CREATED_AT_FAILURE
