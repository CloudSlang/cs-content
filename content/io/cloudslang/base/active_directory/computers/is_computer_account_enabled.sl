########################################################################################################################
#!!
#! @description: Checks to see if a computer account is enabled in Active Directory.
#!
#! @input host: The domain controller to connect to.
#! @input protocol: The protocol to use when connecting to the Active Directory server. Valid values: HTTP and HTTPS.
#!                  Optional
#! @input username: The user to connect to Active Directory as.
#! @input password: The password of the user to connect to Active Directory.
#! @input distinguished_name: The Organizational Unit DN or Common Name DN the computer is in (i.e. OU=OUTest1,DC=battleground,DC=ad).
#! @input computer_common_name: The name of the computer account to check.
#! @input proxy_host: The proxy server used to access the web site.
#!                    Optional
#! @input proxy_port: The proxy server port.Default value: 8080.
#!                    Optional
#! @input proxy_username: The username used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the 'proxyUsername' input value.
#!                        Optional
#! @input tls_version: The version of TLS to use. The value of this input will be ignored if 'protocol'is set to 'HTTP'. This capability is provided “as is”, please see product documentation for further information.Valid values: TLSv1, TLSv1.1, TLSv1.2.Default value: TLSv1.2.
#!                     Optional
#! @input allowed_ciphers: A list of ciphers to use. The value of this input will be ignored if 'tlsVersion' does
not contain 'TLSv1.2'. This capability is provided “as is”, please see product documentation for further security considerations. In order to connect successfully to the target host, it should accept at least one of the following ciphers. If this is not the case, it is
the user's responsibility to configure the host accordingly or to update the list of allowed ciphers.
Default value: TLS_DHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
TLS_DHE_RSA_WITH_AES_256_CBC_SHA256, TLS_DHE_RSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384, TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384, TLS_RSA_WITH_AES_256_GCM_SHA384, TLS_RSA_WITH_AES_256_CBC_SHA256,
TLS_RSA_WITH_AES_128_CBC_SHA256.
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's CommonName (CN) or subjectAltName field of the X.509 certificate. Set this to 'allow_all' to skip any checking, but you become vulnerable to attacks. For the value 'browser_compatible' the hostname verifier works the same way as Curland Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between 'browser_compatible' and 'strict' is that a wildcard (such as '*.foo.com') with 'browser_compatible' matches all subdomains, including 'a.b.foo.com'. From thesecurity perspective, to provide protection against possible Man-In-The-Middle attacks, we strongly recommend to use 'strict' option. Default value: strict.Valid values: strict, browser_compatible, allow_all.
#!                                 Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL. A SSL certificate is trust even if no trusted certification authority issued it.Valid values: true, falseDefault value: true
#!                         Optional
#! @input trust_keystore: The location of the TrustStore file.Example: %JAVA_HOME%/jre/lib/security/cacerts.
#!                        Optional
#! @input trust_password: The password associated with the TrustStore file.
#!                        Optional
#! @input timeout: Time in milliseconds to wait for the connection to complete.Default value: 60000.
#!                 Optional
#!
#! @output return_result: The return result of the operation.
#! @output computer_distinguished_name: The distinguished Name of the computer account.
#! @output return_code: The return code of the operation. 0 if the operation succeeded, -1 if the operation fails.
#! @output exception: The exception message if the operation fails.
#!
#! @result SUCCESS: The name of the OU the computer is in was retrieved successfully.
#! @result FAILURE: The computer account is disabled or something went wrong.
#!!#
########################################################################################################################

namespace: io.cloudslang.active_directory.computers

operation: 
  name: is_computer_account_enabled
  
  inputs: 
    - host    
    - protocol:  
        required: false  
    - username    
    - password:    
        sensitive: true
    - distinguished_name    
    - distinguishedName: 
        default: ${get('distinguished_name', '')}  
        required: false 
        private: true 
    - computer_common_name    
    - computerCommonName: 
        default: ${get('computer_common_name', '')}  
        required: false 
        private: true 
    - proxy_host:  
        required: false  
    - proxyHost: 
        default: ${get('proxy_host', '')}  
        required: false 
        private: true 
    - proxy_port:  
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
    - proxyPassword: 
        default: ${get('proxy_password', '')}  
        required: false 
        private: true 
    - tls_version:  
        required: false  
    - tlsVersion: 
        default: ${get('tls_version', '')}  
        required: false 
        private: true 
    - allowed_ciphers:  
        required: false  
    - allowedCiphers: 
        default: ${get('allowed_ciphers', '')}  
        required: false 
        private: true 
    - x_509_hostname_verifier:  
        required: false  
    - x509HostnameVerifier: 
        default: ${get('x_509_hostname_verifier', '')}  
        required: false 
        private: true 
    - trust_all_roots:  
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
    - timeout:  
        required: false  
    
  java_action: 
    gav: 'io.cloudslang.content:cs-active-directory:0.0.2-SNAPSHOT'
    class_name: 'io.cloudslang.content.active_directory.actions.computers.IsComputerAccountEnabledAction'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - computer_distinguished_name: ${get('computerDistinguishedName', '')} 
    - return_code: ${get('returnCode', '')} 
    - exception: ${get('exception', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
