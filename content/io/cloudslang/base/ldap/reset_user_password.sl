#   (c) Copyright 2020 Micro Focus, L.P.
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
#! @description: This operation resets a user's password in Active Directory.
#!
#! @input host: The IP or host name of the domain controller. The port number can be mentioned as well, along
#!              with the host (hostNameOrIP:PortNumber).
#!              Examples: test.example.com,  test.example.com:636, <IPv4Address>, <IPv6Address>,
#!              [<IPv6Address>]:<PortNumber> etc.
#!              Value format: The format of an IPv4 address is: [0-225].[0-225].[0-225].[0-225]. The format of an
#!              IPv6 address is ####:####:####:####:####:####:####:####/### (with a prefix), where each #### is
#!              a hexadecimal value between 0 to FFFF and the prefix /### is a decimal value between 0 to 128.
#!              The prefix length is optional.
#! @input user_dn: Distinguished name of the user whose password you want to change.
#!            Example: CN=User, OU=OUTest1, DC=battleground, DC=ad.
#! @input user_password: The new password.
#! @input username: User to connect to Active Directory as.
#! @input password: Password to connect to Active Directory as.
#! @input use_ssl: If true, the operation uses the Secure Sockets Layer (SSL) or Transport Layer Security (TLS) protocol
#!                  to establish a connection to the remote computer. By default, the operation tries to establish a
#!                  secure connection over TLSv1.2. Default port for SSL/TLS is 636.
#!                  Default value: false
#!                  Valid values: true, false.
#! @input trust_all_roots: Specifies whether to enable weak security over SSL. A SSL certificate is trusted even if no
#!                          trusted certification authority issued it.
#!                          Default value: true.
#!                          Valid values: true, false.
#! @input key_store: The location of the KeyStore file.
#!                   Example: %JAVA_HOME%/jre/lib/security/cacerts
#! @input key_store_password: The password associated with the KeyStore file.
#! @input trust_keystore: The location of the TrustStore file.
#!                        Example: %JAVA_HOME%/jre/lib/security/cacerts
#! @input trust_password: The password associated with the TrustStore file.
#!
#! @output return_result: The message 'Password Changed' in case of success or the error in case of failure.
#! @output return_code: The returnCode of the operation: 0 for success, -1 for failure.
#! @output exception: In case of success response, this result is empty. In case of failure response, this result
#!                    contains the java stack trace of the runtime exception.
#!
#! @result SUCCESS: The operation completed successfully.
#! @result FAILURE: An error occurred during execution.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.ldap

operation:
  name: reset_user_password

  inputs:
    - host
    - user_dn
    - userDN:
        default: ${get('user_dn', '')}
        required: false
        private: true
    - user_password:
        sensitive: true
    - userPassword:
        default: ${get('user_password', '')}
        required: false
        private: true
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - use_ssl:
        default: 'false'
        required: false
    - useSSL:
        default: ${get('use_ssl', '')}
        required: false
        private: true
    - trust_all_roots:
        default: 'true'
        required: false
    - trustAllRoots:
        default: ${get('trust_all_roots', '')}
        required: false
        private: true
    - key_store:
        required: false
    - keyStore:
        default: ${get('key_store', '')}
        required: false
        private: true
    - key_store_password:
        required: false
        sensitive: true
    - keyStorePassword:
        default: ${get('key_store_password', '')}
        required: false
        private: true
    - trust_keystore:
        required: false
    - trustKeystore:
        default: ${get('trust_keystore', '')}
        required: false
        private: true
    - trust_password:
        required: false
        sensitive: true
    - trustPassword:
        default: ${get('trust_password', '')}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-ldap:0.0.1-RC2'
    class_name: 'io.cloudslang.content.ldap.actions.ResetUserPasswordAction'
    method_name: 'execute'

  outputs:
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE