########################################################################################################################
#!!
#! @description: This operation moves a drive item to a new parent item. To move a DriveItem to a new parent item, your
#!               app requests to update the parentReference of the DriveItem to move. Items cannot be moved between Drives.
#!               Note: Permissions
#!                     One of the following permissions is required to call this API.
#!
#!                     Permission type 	                          Permissions (from least to most privileged)
#!
#!                     Delegated (work or school account)	      Files.ReadWrite, Files.ReadWrite.All, Sites.ReadWrite.All
#!                     Delegated (personal Microsoft account)	  Files.ReadWrite, Files.ReadWrite.All
#!                     Application	                              Files.ReadWrite.All, Sites.ReadWrite.All
#!
#! @input auth_token: Token used to authenticate to Microsoft 365 Sharepoint.
#! @input site_id: The id of the site associated with the item that will be moved.
#!                 Optional
#! @input drive_id: The id of the drive associated with the item that will be moved. If this input is empty then the default(root)
#!                  drive will be taken.
#!                  Optional
#! @input item_id: The id of the item to be moved. If both site_id and drive_id inputs are empty,
#!                 the operation will look for permissions of the item in the signed-in user's drive, where delegated authentication is required.
#! @input json_body: In the request body, supply the new value for the parentReference property. Existing properties
#!                   that are not included in the request body will maintain their previous values or be recalculated
#!                   based on changes to other property values. For best performance you shouldn't include existing values that haven't changed.
#!                   Note: When moving items to the root of a drive your app cannot use the "id:" "root" syntax.
#!                         Your app needs to provide the actual ID of the root folder for the parent reference.
#!                   For more information on how to construct this body you can consult the Microsoft Graph REST API v1.0
#!                   Example:
#!{
#!  "parentReference": {
#!    "id": "{new-parent-folder-id}"
#!  },
#!  "name": "new-item-name.txt"
#!}
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
#! @output return_result: If successful returns the JSON response for the move request.
#! @output return_code: 0 if success, -1 otherwise.
#! @output status_code: The HTTP status code for the request.
#! @output exception: There was an error while trying to move the item.
#!
#! @result SUCCESS: The item was moved successfully.
#! @result FAILURE: There was an error while trying move the item.
#!!#
########################################################################################################################

namespace: io.cloudslang.microsoft.sharepoint.entities

operation:
  name: move_item

  inputs:
    - auth_token:
        sensitive: true
    - authToken:
        default: ${get('auth_token', '')}
        required: false
        private: true
        sensitive: true
    - site_id:
        required: false
    - siteId:
        default: ${get('site_id', '')}
        required: false
        private: true
    - drive_id:
        required: false
    - driveId:
        default: ${get('drive_id', '')}
        required: false
        private: true
    - item_id
    - itemId:
        default: ${get('item_id', '')}
        required: false
        private: true
    - json_body
    - jsonBody:
        default: ${get('json_body', '')}
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
    gav: 'io.cloudslang.content:cs-sharepoint:0.0.8'
    class_name: 'io.cloudslang.content.sharepoint.actions.entities.MoveItem'
    method_name: 'execute'

  outputs:
    - return_result: ${get('returnResult', '')}
    - return_code: ${get('returnCode', '')}
    - status_code: ${get('statusCode', '')}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode=='0'}
    - FAILURE