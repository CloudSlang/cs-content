########################################################################################################################
#!!
#! @description: This operation returns the details of a specified deployment.
#!
#! @input host: The url of the service to which API calls are made.
#!              Example: https://api.domain:6443
#! @input auth_token: Token used to authenticate to the Openshift environment.
#! @input name: The name of the deployment.
#! @input namespace: The namespace where the specific deployment can be found.
#! @input proxy_host: The proxy server used to access the web site.
#!                    Optional
#! @input proxy_port: The proxy server port.
#!                    Default value: 8080
#!                    Optional
#! @input proxy_username: The username used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: The proxy server password associated with the 'proxy_username' input value.
#!                        Optional
#! @input tls_version: The version of TLS to use. The value of this input will be ignored if 'protocol' is set to 'HTTP'.
#!                     This capability is provided “as is”, please see product documentation for further
#!                     information.Valid values: TLSv1, TLSv1.1, TLSv1.2
#!                     Default value: TLSv1.2
#!                     Optional
#! @input allowed_ciphers: A list of ciphers to use. The value of this input will be ignored if 'tls_version' does not
#!                         contain 'TLSv1.2'. This capability is provided “as is”, please see product documentation for
#!                         further security considerations.In order to connect successfully to the target host, it
#!                         should accept at least one of the following ciphers. If this is not the case, it is the
#!                         user's responsibility to configure the host accordingly or to update the list of allowed
#!                         ciphers. 
#!                         Default value: TLS_DHE_RSA_WITH_AES_256_GCM_SHA384,
#!                         TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384, TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
#!                         TLS_DHE_RSA_WITH_AES_256_CBC_SHA256, TLS_DHE_RSA_WITH_AES_128_CBC_SHA256,
#!                         TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384, TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,
#!                         TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256, TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
#!                         TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384, TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384,
#!                         TLS_RSA_WITH_AES_256_GCM_SHA384, TLS_RSA_WITH_AES_256_CBC_SHA256,
#!                         TLS_RSA_WITH_AES_128_CBC_SHA256.
#!                         Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no
#!                         trusted certification authority issued it.
#!                         Default value: false
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to
#!                                 "allow_all" to skip any checking. For the value "browser_compatible" the hostname
#!                                 verifier works the same way as Curl and Firefox. The hostname must match either the
#!                                 first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of
#!                                 the subject-alts. The only difference between "browser_compatible" and "strict" is
#!                                 that a wildcard (such as "*.foo.com") with "browser_compatible" matches all
#!                                 subdomains, including "a.b.foo.com".
#!                                 Default value: strict
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that
#!                        you expect to communicate with, or from Certificate Authorities that you trust to identify
#!                        other parties.  If the protocol (specified by the 'url') is not 'https' or if 'trust_all_roots' is
#!                        'true' this input is ignored. 
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the TrustStore file. If 'trust_all_roots' is false and 'trust_keystore'
#!                        is empty, trustPassword default will be supplied.
#!                        Optional
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0'
#!                         represents an infinite timeout.
#!                         Default value: 60
#!                         Optional
#! @input execution_timeout: The amount of time (in seconds) to allow the client to complete the execution of an API
#!                           call. A value of '0' disables this feature. 
#!                           Default value: 60
#!                           Optional
#!
#! @output return_result: A suggestive message in case of success or failure.
#! @output status_code: The HTTP status code for Openshift API request.
#! @output return_code: 0 if success, -1 if failure.
#! @output exception: An error message in case there was an error while reading the deployment details.
#! @output document: All the information related to a specific deployment in JSON format.
#! @output kind: The deployment kind.
#! @output deployment_name: The deployment name.
#! @output deployment_namespace: The deployment namespace.
#! @output uid: The deployment uid.
#! @output spec: The spec of the deployment in JSON format.
#! @output status: The status of the deployment in JSON format.
#!
#! @result SUCCESS: The request to read the details of the specified deployment was made successfully.
#! @result FAILURE: There was an error while trying to get the details of the deployment.
#!!#
########################################################################################################################

namespace: io.cloudslang.redhat.openshift.deployments

operation: 
  name: get_deployment_details
  
  inputs: 
    - host    
    - auth_token:
        sensitive: true
    - authToken: 
        default: ${get('auth_token', '')}  
        required: false 
        private: true
        sensitive: true
    - name
    - namespace
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
    - connect_timeout:
        default: '60'
        required: false  
    - connectTimeout: 
        default: ${get('connect_timeout', '')}  
        required: false 
        private: true 
    - execution_timeout:
        default: '60'
        required: false  
    - executionTimeout: 
        default: ${get('execution_timeout', '')}  
        required: false 
        private: true 

  java_action: 
    gav: 'io.cloudslang.content:cs-openshift:0.0.6'
    class_name: 'io.cloudslang.content.redhat.actions.GetDeploymentDetails'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - status_code: ${get('statusCode', '')} 
    - return_code: ${get('returnCode', '')} 
    - exception: ${get('exception', '')} 
    - document: ${get('document', '')} 
    - kind: ${get('kind', '')} 
    - deployment_name: ${get('deploymentName', '')}
    - deployment_namespace: ${get('deploymentNamespace', '')}
    - uid: ${get('uid', '')} 
    - spec: ${get('spec', '')}
    - status: ${get('status', '')}
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
