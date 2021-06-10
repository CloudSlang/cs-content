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
#! @description: Creates a user in AD.
#!
#! @input archive_name: Name of archive to be created (without the .zip extension).
#! @input folder_path: Path to folder to be zipped (zipped file will be created in this folder).
#!
#! @output message: Error message in case of error.
#!
#! @result SUCCESS: Archive was successfully created.
#! @result FAILURE: Archive was not created due to an error.
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
        default: ${get("user_common_name", "")}
        private: true
    - sam_account_name
    - sAMAccountName:
        default: ${get("sam_account_name", "")}
        private: true
    - user_password
    - userPassword:
        default: ${get("user_password", "")}
        private: true
    - username:
        required: false
    - password:
        required: false
    - use_ssl:
    - useSSL:
        default: ${get("use_ssl", "")}
        private: true
        required: false
    - trust_all_roots
    - trustAllRoots:
        default: ${get("trust_all_roots", "")}
        private: true
        required: false
    - key_store
    - keyStore:
        default: ${get("key_store", "")}
        private: true
        required: false
    - key_store_password:
    - keyStorePassword:
        default: ${get("key_store_password", "")}
        private: true
        required: false
    - trust_keystore
    - trustKeystore:
        default: ${get("trust_keystore", "")}
        private: true
        required: false
    - trust_password
    - trustPassword:
        default: ${get("trust_password", "")}
        private: true
        required: false
    - escape_chars:
        required: false

  java_action:
    gav: 'io.cloudslang.content:cs-ldap:0.0.52'
    class_name: io.cloudslang.content.ldap.actions.users.CreateUserAction
    method_name: execute

    outputs:
      - return_result: ${get('returnResult', '')}
      - return_code: ${get('returnCode', '')}
      - exception: ${get('exception', '')}

    results:
      - SUCCESS: ${returnCode == '0'}
      - FAILURE