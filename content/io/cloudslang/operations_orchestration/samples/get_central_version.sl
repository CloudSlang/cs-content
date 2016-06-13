####################################################
#!!
#! @description: Performs an REST API call in order to get the version of installed and running Central.
#! @input host: the host where the Central is installed and running
#! @input port: optional - the port where the central GUI is exposed - Default: '8080'
#! @input protocol: optional - the protocol used to connect to Central - Valid: 'http', 'https' - Default: 'http'
#! @input username: optional - the username needed to connect to Central; for NTLM authentication - Format: 'domain\user' - Default: ''
#! @input password: optional - the password associated with <username> input used for authentication - Default: ''
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
#! @output return_result: response of operation in case of success, error message otherwise
#! @output error_message: return_result if statusCode is not '200'
#! @output return_code: '0' if success, '-1' otherwise
#! @output status_code: code returned by operation
#! @output response_headers: response headers string from the HTTP Client REST call
#!!#
####################################################

namespace: io.cloudslang.operations_orchestration.samples

imports:
  rest: io.cloudslang.base.http

flow:
  name: get_central_version
  inputs:
    - host
    - port:
        default: '8080'
        required: false
    - protocol:
        default: 'http'
        required: false
    - username:
        default: ''
        required: false
    - password:
        default: ''
        required: false
        sensitive: true
    - trust_keystore:
        default: ${get_sp('io.cloudslang.operations_orchestration.trust_keystore')}
        required: false
    - trust_password:
        default: ${get_sp('io.cloudslang.operations_orchestration.trust_password')}
        required: false
        sensitive: true
    - keystore:
        default: ${get_sp('io.cloudslang.operations_orchestration.keystore')}
        required: false
    - keystore_password:
        default: ${get_sp('io.cloudslang.operations_orchestration.keystore_password')}
        required: false
        sensitive: true

  workflow:
    - get_central_version:
        do:
          rest.http_client_get:
            - url: ${protocol + '://' + host + ':' + port + '/oo/rest/version/'}
            - username
            - password
            - trust_all_roots: "false"
            - x_509_hostname_verifier: "strict"
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - headers: 'Authorization: Basic'
            - content_type: 'application/json'

        publish:
          - return_result
          - error_message
          - return_code
          - status_code
          - response_headers

  outputs:
    - return_result
    - error_message
    - return_code
    - status_code
    - response_headers
