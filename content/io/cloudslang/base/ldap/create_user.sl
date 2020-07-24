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
#! @description: This operation creates a new user in Active Directory.
#!
#! @input host: The IP or host name of the domain controller. The port number can be mentioned as well, along
#!              with the host (hostNameOrIP:PortNumber).
#!              Examples: test.example.com,  test.example.com:636, <IPv4Address>, <IPv6Address>,
#!              [<IPv6Address>]:<PortNumber> etc.
#!              Value format: The format of an IPv4 address is: [0-225].[0-225].[0-225].[0-225]. The format of an
#!              IPv6 address is ####:####:####:####:####:####:####:####/### (with a prefix), where each #### is
#!              a hexadecimal value between 0 to FFFF and the prefix /### is a decimal value between 0 to 128.
#!              The prefix length is optional.
#! @input OU: The Organizational Unit DN or Common Name DN to add the user to.
#!            Example: OU=OUTest1,DC=battleground,DC=ad
#! @input user_common_name: The CN, generally the full name of user.
#!                          Example: Bob Smith
#! @input sam_account_name - The sam_account_name. If this input is empty, the value will be assigned from input "user_common_name".
#! @input user_password - The password for the new user.
#! @input username - User to connect to Active Directory as.
#! @input password - Password to connect to Active Directory as.
#! @input use_ssl - If true, the operation uses the Secure Sockets Layer (SSL) or Transport Layer Security (TLS) protocol
#!                  to establish a connection to the remote computer. By default, the operation tries to establish a
#!                  secure connection over TLSv1.2. Default port for SSL/TLS is 636.
#!                  Default value: false
#!                  Valid values: true, false.
#! @input trust_all_roots - Specifies whether to enable weak security over SSL. A SSL certificate is trusted even if no
#!                          trusted certification authority issued it.
#!                          Default value: true.
#!                          Valid values: true, false.
#! @input key_store - The location of the KeyStore file.
#!                   Example: %JAVA_HOME%/jre/lib/security/cacerts
#! @input key_store_password - The password associated with the KeyStore file.
#! @input trust_keystore - The location of the TrustStore file.
#!                        Example: %JAVA_HOME%/jre/lib/security/cacerts
#! @input trust_password - The password associated with the TrustStore file.
#! @input escape_chars - Add this input and set to true if you want the operation to escape the special AD chars.
#!
#! @output return_result: A message with the cn name of the user in case of success or the error in case of failure.
#! @output return_code: The returnCode of the operation: 0 for success, -1 for failure.
#! @output user_dn - The distinguished name of the newly created user.
#! @output exception: In case of success response, this result is empty. In case of failure response, this result
#!                    contains the java stack trace of the runtime exception.
#!
#! @result SUCCESS: The operation completed successfully.
#! @result FAILURE: An error occurred during execution.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.ldap

operation:
  name: create_user

  inputs:
    - host
    - OU
    - user_common_name
    - userCommonName:
        default: ${get('user_common_name', '')}
        required: false
        private: true
    - sam_account_name
    - sAMAccountName:
        default: ${get('sam_account_name', '')}
        required: false
        private: true
    - user_password
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
    - escape_chars:
        required: false
    - escapeChars:
        default: ${get('escape_chars', '')}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-ldap:0.0.1-RC1'
    class_name: 'io.cloudslang.content.ldap.actions.CreateUserAction'
    method_name: 'execute'

  outputs:
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - exception: ${get('exception', '')}
    - user_dn: ${get('userDN', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE