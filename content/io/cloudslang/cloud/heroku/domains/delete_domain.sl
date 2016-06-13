####################################################
#!!
#! @description: performs a REST API call to delete an existing application domain.
#! @input username: Heroku username
#!                  example: 'someone@mailprovider.com'
#! @input password: Heroku password used for authentication
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
#! @input app_id_or_name: ID or name of the Heroku application
#! @input domain_id_or_hostname: ID or hostname of the domain that will be deleted
#! @output return_result: response of the operation in case of success, error message otherwise
#! @output error_message: return_result if status_code is not '200'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by the operation
#!!#
####################################################
namespace: io.cloudslang.cloud.heroku.domains

imports:
  rest: io.cloudslang.base.http

flow:
  name: delete_domain
  inputs:
    - username
    - password:
        sensitive: true
    - app_id_or_name
    - domain_id_or_hostname
    - trust_keystore:
        default: ${get_sp('io.cloudslang.cloud.heroku.http.trust_keystore')}
        required: false
    - trust_password:
        default: ${get_sp('io.cloudslang.cloud.heroku.trust_password')}
        required: false
        sensitive: true
    - keystore:
        default: ${get_sp('io.cloudslang.cloud.heroku.keystore')}
        required: false
    - keystore_password:
        default: ${get_sp('io.cloudslang.cloud.heroku.keystore_password')}
        required: false
        sensitive: true

  workflow:
    - delete_app_domains:
        do:
          rest.http_client_delete:
            - url: ${'https://api.heroku.com/apps/' + app_id_or_name +'/domains/' + domain_id_or_hostname}
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

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
