########################################################################################################################
#!!
#! @description: This operation retrieves the details of a site for which the id was provided.
#!               Note: Permissions
#!                     One of the following permissions is required to call this API.
#!
#!                     Permission type	                          Permissions (from least to most privileged)
#!
#!                     Delegated (work or school account)	      Sites.Read.All, Sites.ReadWrite.All
#!                     Delegated (personal Microsoft account)     Not supported.
#!                     Application	                              Sites.Read.All, Sites.ReadWrite.All
#!
#! @input auth_token: Token used to authenticate to Microsoft 365 Sharepoint.
#! @input site_id: The id of the site from which to retrieve the details.
#! @input proxy_host: Proxy server used to access the Office 365 service.
#!                    Optional
#! @input proxy_port: Proxy server port used to access the Office 365 service.
#!                    Default value: 8080
#!                    Optional
#! @input proxy_username: Proxy server user name.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the proxy_username input value.
#!                        Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL/TSL. A certificate is trusted even if no
#!                         trusted certification authority issued it.
#!                         Default value: false
#!                         Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate. Set this to
#!                                 "allow_all" to skip any checking.
#!                                 Default value: strict
#!                                 Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that
#!                        you expect to communicate with, or from Certificate Authorities that you trust to identify
#!                        other parties.  If the protocol (specified by the 'url') is not 'https' or if trustAllRoots is
#!                        'true' this input is ignored.
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the TrustStore file. If trustAllRoots is false and trustKeystore
#!                        is empty, trustPassword default will be supplied.
#!                        Optional
#! @input tls_version: The version of TLS to use. The value of this input will be ignored if 'protocol' is set to 'HTTP'.
#!                     This capability is provided “as is”, please see product documentation for further
#!                     information.
#!                     Valid values: TLSv1, TLSv1.1, TLSv1.2, TLSv1.3
#!                     Default value: TLSv1.2
#!                     Optional
#! @input allowed_ciphers: A list of ciphers to use. The value of this input will be ignored if 'tlsVersion' does not
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
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of '0'
#!                         represents an infinite timeout.
#!                         Default value: 60
#!                         Optional
#! @input execution_timeout: The amount of time (in seconds) to allow the client to complete the execution. A value of
#!                           '0' disables this feature.
#!                           Default value: 60
#!                           Optional
#!
#! @output return_result: Details of the site.
#! @output return_code: 0 if success, -1 otherwise.
#! @output status_code: The HTTP status code for the request.
#! @output exception: There was an error while trying to retrieve the site details.
#! @output web_url: Web url of the site.
#! @output site_id_output: Id of the site.
#! @output site_name: Name of the site.
#! @output site_display_name: Display name of the site.
#!
#! @result SUCCESS: Site details were returned successfully.
#! @result FAILURE: There was an error while trying to retrieve the site details.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.sharepoint.sites

operation: 
  name: get_site_details
  
  inputs: 
    - auth_token:    
        sensitive: true
    - authToken: 
        default: ${get('auth_token', '')}  
        required: false 
        private: true 
        sensitive: true
    - site_id    
    - siteId: 
        default: ${get('site_id', '')}  
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
        default: '8080'
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
    - trust_all_roots:
        required: false
        default: 'false'
    - trustAllRoots:
        default: ${get('trust_all_roots', '')}
        required: false
        private: true
    - x_509_hostname_verifier:
        required: false
        default: 'strict'
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
    - tls_version:
        required: false
        default: 'TLSv1.2'
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
    - connect_timeout:
        required: false
        default: '60'
    - connectTimeout:
        default: ${get('connect_timeout', '')}
        required: false
        private: true
    - execution_timeout:
        required: false
        default: '60'
    - executionTimeout:
        default: ${get('execution_timeout', '')}
        required: false
        private: true

  java_action:
    gav: 'iio.cloudslang.content:cs-sharepoint:0.0.1-RC20'
    class_name: 'io.cloudslang.content.sharepoint.actions.sites.GetSiteDetails'
    method_name: 'execute'
  
  outputs: 
    - return_result: ${get('returnResult', '')} 
    - return_code: ${get('returnCode', '')} 
    - status_code: ${get('statusCode', '')} 
    - exception: ${get('exception', '')} 
    - web_url: ${get('webUrl', '')} 
    - site_id_output: ${get('siteId', '')} 
    - site_name: ${get('siteName', '')} 
    - site_display_name: ${get('siteDisplayName', '')} 
  
  results: 
    - SUCCESS: ${returnCode=='0'} 
    - FAILURE
