########################################################################################################################
#!!
#! @description: Generated description.
#!
#! @input host: Generated description.
#! @input ou: Generated description.
#! @input user_common_name: Generated description.
#! @input user_password: Generated description.
#! @input s_am_account_name: Generated description.
#!                           Optional
#! @input username: Generated description.
#!                  Optional
#! @input password: Generated description.
#!                  Optional
#! @input use_ssl: Generated description.
#!                 Optional
#! @input trust_all_roots: Generated description.
#!                         Optional
#! @input keystore: Generated description.
#!                  Optional
#! @input keystore_password: Generated description.
#!                           Optional
#! @input trust_keystore: Generated description.
#!                        Optional
#! @input trust_password: Generated description.
#!                        Optional
#! @input escape_chars: Generated description.
#!                      Optional
#!
#! @output return_result: Generated description.
#! @output user_dn: Generated description.
#! @output return_code: Generated description.
#! @output exception: Generated description.
#!
#! @result SUCCESS: Generated description.
#! @result FAILURE: Generated description.
#!!#
########################################################################################################################

namespace: io.cloudslang.ldap

operation:
  name: create_user

  inputs:
    - host
    - ou
    - OU:
        default: ${get('ou', '')}
        required: false
        private: true
    - user_common_name
    - userCommonName:
        default: ${get('user_common_name', '')}
        required: false
        private: true
    - user_password:
        sensitive: true
    - userPassword:
        default: ${get('user_password', '')}
        required: false
        private: true
        sensitive: true
    - s_am_account_name:
        required: false
    - sAMAccountName:
        default: ${get('s_am_account_name', '')}
        required: false
        private: true
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - use_ssl:
        required: false
    - useSSL:
        default: ${get('use_ssl', '')}
        required: false
        private: true
    - trust_all_roots:
        required: false
    - trustAllRoots:
        default: ${get('trust_all_roots', '')}
        required: false
        private: true
    - keystore:
        required: false
    - keystore_password:
        required: false
        sensitive: true
    - keystorePassword:
        default: ${get('keystore_password', '')}
        required: false
        private: true
        sensitive: true
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
        sensitive: true
    - escape_chars:
        required: false
    - escapeChars:
        default: ${get('escape_chars', '')}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-ldap:0.0.1-SNAPSHOT'
    class_name: 'io.cloudslang.content.ldap.actions.users.CreateUserAction'
    method_name: 'execute'

  outputs:
    - return_result: ${get('returnResult', '')}
    - user_dn: ${get('userDN', '')}
    - return_code: ${get('returnCode', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE