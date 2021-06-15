########################################################################################################################
#!!
#! @description: Creates a new user in Active Directory.
#!
#! @input host: The domain controller to connect to.
#! @input distinguished_name: The Organizational Unit DN or Common Name DN to add the computer to.
#!                            Example: OU=OUTest1,DC=battleground,DC=ad.
#! @input user_common_name: The CN, generally the full name of user.
#!                          Example: Bob Smith
#! @input user_password: The password for the new user. It must meet the following requirements:
#!                       - is at least six characters long
#!                       - contains characters from at least three of the following five categories: English uppercase
#!                       characters ('A' - 'Z'), English lowercase characters ('a' - 'z'), base 10
#!                       digits ('0' - '9'), non-alphanumeric (For example: '!', '$', '#', or '%'), unicode characters
#!                       - does not contain three or more characters from the user's account name
#! @input s_am_account_name: Computer's sAMAccountName (ex. MYHYPNOS$). If not provided it will be assigned from
#!                           computerCommonName.
#!                           Optional
#! @input username: The user to connect to Active Directory as.
#!                  Optional
#! @input password: The password of the user to connect to Active Directory.
#!                  Optional
#! @input protocol: The protocol to use when connecting to the Active Directory server.
#!                  Valid values: 'HTTP' and 'HTTPS'.
#!                  Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL. A SSL certificate is trust even if no
#!                         trusted certification authority issued it.
#!                         Valid values: true, false.
#!                         Default value: true
#!                         Optional
#! @input trust_keystore: The location of the TrustStore file.
#!                        Example: %JAVA_HOME%/jre/lib/security/cacerts.
#!                        Optional
#! @input trust_password: The password associated with the TrustStore file.
#!                        Optional
#! @input escape_chars: Specifies whether to escape the special Active Directory
#!                      characters: '#','=','"','<','>',',','+',';','\','"''.
#!                      Default value: false.
#!                      Valid values: true, false.
#!                      Optional
#! @input connection_timeout: Time in milliseconds to wait for the connection to be made.
#!                            Default value: 10000.
#!                            Optional
#! @input execution_timeout: Time in milliseconds to wait for the connection to complete.
#!                           Default value: 90000.
#!                           Optional
#!
#! @output return_result: A message with the common name of the newly created user in case of success or the error
#!                        message in case of failure.
#! @output user_distinguished_name: The distinguished name of the newly created user.
#! @output return_code: The return code of the operation. 0 if the operation succeeded, -1 if the operation fails.
#! @output exception: The exception message if the operation fails.
#!
#! @result SUCCESS: The user was created successfully.
#! @result FAILURE: Failed to create the user.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.ldap.users

operation: 
  name: create_user
  
  inputs: 
    - host    
    - distinguished_name    
    - distinguishedName: 
        default: ${get('distinguished_name', '')}  
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
    - protocol:  
        required: false  
    - trust_all_roots:
        default: 'true'
        required: false  
    - trustAllRoots: 
        default: ${get('trust_all_roots', '')}  
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
        sensitive: true
    - escape_chars:
        default: 'false'
        required: false  
    - escapeChars: 
        default: ${get('escape_chars', '')}  
        required: false 
        private: true 
    - connection_timeout:
        default: '10000'
        required: false  
    - connectionTimeout: 
        default: ${get('connection_timeout', '')}  
        required: false 
        private: true 
    - execution_timeout:
        default: '90000'
        required: false  
    - executionTimeout: 
        default: ${get('execution_timeout', '')}  
        required: false 
        private: true 
    
  java_action: 
    gav: 'io.cloudslang.content:cs-ldap:0.0.1-RC3'
    class_name: 'io.cloudslang.content.ldap.actions.users.CreateUserAction'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - user_distinguished_name: ${get('userDistinguishedName', '')} 
    - return_code: ${get('returnCode', '')} 
    - exception: ${get('exception', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
