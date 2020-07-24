#   (c) Copyright 2020 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: Disables a computer account in Active Directory.
#!
#! @input host: The domain controller to connect to.
#! @input OU: The Organizational Unit DN or Common Name DN to add the computer to.
#!            (i.e. OU=OUTest1,DC=battleground,DC=ad)
#! @input computer_common_name: The name of the computer (its CN).
#! @input username: Optional - The user to connect to AD as.
#! @input password: Optional - The password to connect to AD as.
#! @input use_ssl: Optional - If true, the operation uses the Secure Sockets Layer (SSL) or Transport Layer Security (TLS)
#!                            protocol to establish a connection to the remote computer. By default, the operation tries
#!                            to establish a secure connection over TLSv1.2. Default port for SSL/TLS is 636.
#!                 Valid: 'true', 'false'.
#!                 Default: 'false'.
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL. A SSL certificate is trusted
#!                                    even if no trusted certification authority issued it.
#!                         Valid: 'true', 'false'.
#!                         Default: 'false'.
#! @input key_store: Optional - The location of the KeyStore file.
#!                   Example: %JAVA_HOME%/jre/lib/security/cacerts.
#! @input key_store_password: Optional - The password associated with the KeyStore file.
#! @input trust_keystore: Optional - The location of the TrustStore file.
#!                        Example: %JAVA_HOME%/jre/lib/security/cacerts.
#! @input trust_password: Optional - The password associated with the TrustStore file.
#!
#! @output return_result: The return result of the operation.
#! @output computer_dn: The distinguished name of the computer account that was disabled.
#! @output return_code: The return code of the operation. 0 if the operation goes to success, -1 if the operation goes to failure.
#! @output exception: The exception message and stack trace if the operation goes to failure.
#!
#! @result SUCCESS: Operation succeeded.
#! @result FAILURE: Operation failed.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.ldap

operation:
  name: disable_computer_account

  inputs:
    - host
    - OU
    - computer_common_name
    - computerCommonName:
        default: ${get("computer_common_name","")}
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
        default:  ${get("use_ssl","")}
        private: true
        required: false
    - trust_all_roots:
        default: 'true'
        required: false
    - trustAllRoots:
        default: ${get("trust_all_roots", "")}
        required: false
        private: true
    - key_store:
        required: false
    - keyStore:
        default: ${get("key_store", "")}
        required: false
        private: true
    - key_store_password:
        required: false
        sensitive: true
    - keyStorePassword:
        default: ${get("key_store_password", "")}
        required: false
        private: true
        sensitive: true
    - trust_keystore:
        required: false
    - trustKeystore:
        default: ${get("trust_keystore", "")}
        required: false
        private: true
    - trust_password:
        required: false
        sensitive: true
    - trustPassword:
        default: ${get("trust_password", "")}
        required: false
        private: true
        sensitive: true

  java_action:
    gav: 'io.cloudslang.content:cs-ldap:0.0.1-RC1'
    class_name: io.cloudslang.content.ldap.actions.DisableComputerAccountAction
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - computer_dn: ${computerDN}
    - return_code: ${returnCode}
    - exception

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE