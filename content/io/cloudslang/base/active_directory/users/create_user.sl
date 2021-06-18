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
#! @input sam_account_name: Computer's sAMAccountName (ex. MYHYPNOS$). If not provided it will be assigned from
#!                          computerCommonName.
#!                          Optional
#! @input username: The user to connect to Active Directory as.
#!                  Optional
#! @input password: The password of the user to connect to Active Directory.
#!                  Optional
#! @input protocol: The protocol to use when connecting to the Active Directory server.
#!                  Valid values: 'HTTP' and 'HTTPS'.
#!                  Optional
#! @input proxy_host: The proxy server used to access the web site.
#!                    Optional
#! @input proxy_port: The proxy server port.
#!                    Default value: 8080
#!                    Optional
#! @input proxy_username: The username used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the 'proxyUsername' input value.
#!                        Optional
#! @input tls_version: The version of TLS to use. The value of this input will be ignored if 'protocol' is set to 'HTTP'.
#!                     Valid values: SSLv3, TLSv1, TLSv1.1, TLSv1.2.
#!                     Default value: TLSv1.2
#!                     Optional
#! @input allowed_ciphers: A list of ciphers to use. The value of this input will be ignored if 'tlsVersion' does not contain 'TLSv1.2.
#!                         Default value: TLS_DHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
#!                         TLS_DHE_RSA_WITH_AES_256_CBC_SHA256, TLS_DHE_RSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,
#!                         TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
#!                         TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384, TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384, TLS_RSA_WITH_AES_256_GCM_SHA384, TLS_RSA_WITH_AES_256_CBC_SHA256,
#!                         TLS_RSA_WITH_AES_128_CBC_SHA256.
#!                         Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL. A SSL certificate is trust even if no
#!                         trusted certification authority issued it.
#!                         Valid values: true, false.
#!                         Default value: false
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. The hostname
#!                                 verification system prevents communication with other hosts other than the ones you
#!                                 intended. This is done by checking that the hostname is in the subject alternative
#!                                 name extension of the certificate. This system is designed to ensure that, if an
#!                                 attacker(Man In The Middle) redirects traffic to his machine, the client will not
#!                                 accept the connection. If you set this input to "allow_all", this verification is
#!                                 ignored and you become vulnerable to security attacks. For the value
#!                                 "browser_compatible" the hostname verifier works the same way as Curl and Firefox.
#!                                 The hostname must match either the first CN, or any of the subject-alts. A wildcard
#!                                 can occur in the CN, and in any of the subject-alts. The only difference between
#!                                 "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with
#!                                 "browser_compatible" matches all subdomains, including "a.b.foo.com". From the
#!                                 security perspective, to provide protection against possible Man-In-The-Middle
#!                                 attacks, we strongly recommend to use "strict" option.
#!                                 Valid values: strict, browser_compatible, allow_all
#!                                 Default: strict
#!                                 Optional
#! @input trust_keystore: The location of the TrustStore file.
#!                        Example: %JAVA_HOME%/jre/lib/security/cacerts.
#!                        Optional
#! @input trust_password: The password associated with the TrustStore file.
#!                        Optional
#! @input timeout: Time in milliseconds to wait for the connection to complete.
#!                 Default value: 60000.
#!                 Optional
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
    - sam_account_name:
        required: false  
    - sAMAccountName: 
        default: ${get('sam_account_name', '')}
        required: false 
        private: true 
    - username:  
        required: false  
    - password:  
        required: false  
        sensitive: true
    - protocol:  
        required: false
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get('proxy_host', '')}
        required: false
        private: true
    - proxy_port:
        default: '8080'
        required: false
    - proxyPort:
        default: ${get('proxy_port', '')}
        required: false
        private: true
    - proxy_username:
        required: false
    - proxyUsername:
        default: ${get('proxy_username', '')}
        required: false
        private: true
    - proxy_password:
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get('proxy_password', '')}
        required: false
        private: true
        sensitive: true
    - tls_version:
        default: 'TLSv1.2'
        required: false
    - tlsVersion:
        default: ${get('tls_version', '')}
        required: false
        private: true
    - allowed_ciphers:
        default: 'TLS_DHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
        TLS_DHE_RSA_WITH_AES_256_CBC_SHA256, TLS_DHE_RSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,
        TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
        TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384, TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384, TLS_RSA_WITH_AES_256_GCM_SHA384,
        TLS_RSA_WITH_AES_256_CBC_SHA256, TLS_RSA_WITH_AES_128_CBC_SHA256'
        required: false
    - allowedCiphers:
        default: ${get('allowed_ciphers', '')}
        required: false
        private: true
    - trust_all_roots:
        default: 'false'
        required: false
    - trustAllRoots:
        default: ${get('trust_all_roots', '')}
        required: false
        private: true
    - x_509_hostname_verifier:
        default: 'strict'
        required: false
    - x509HostnameVerifier:
        default: ${get('x_509_hostname_verifier', '')}
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
    - timeout:
        default: '60000'
        required: false
    
  java_action: 
    gav: 'io.cloudslang.content:cs-ldap:0.0.1-RC6'
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
