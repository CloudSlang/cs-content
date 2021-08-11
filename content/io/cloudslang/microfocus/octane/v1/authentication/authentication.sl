########################################################################################################################
#!!
#! @description: This flow authenticates a user based on the credentials given as input parameters.
#!
#! @input url: The URL of the host running Octane. This should look like this: protocol>://host:port.
#! @input auth_type: The authentication type. The defauld it 'basic'
#! @input username: The user name used for Octane server connection.
#! @input password: The user name used for Octane server connection.
#! @input proxy_host: The user name used for Octane server connection.
#! @input proxy_port: The user name used for Octane server connection.The user name used for Octane server connection.
#! @input proxy_username: The proxy server username used to access the web site
#! @input proxy_password: The proxy server password associated with the username used to access the web site
#! @input trust_all_roots: Specifies whether to enable weak security over TLS. A ceritficate is trusted even if no trusted certification authority issued it
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. The hostname verification system prevents communication with other hosts other than the ones you intended. This is done by checking that the hostname is in the subject alternative name extension of the certificate. This system is designed to ensure that, if an attacker (Man-In-The-Middle) redirects traffic to his machine, the client will not accept the connection. If you set this input to "allow_all", this verification is ignored and you become vulnerable to security attacks. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". From the security perspective, to provide protection against possible Man-In-The-Middle attacks, we strongly recommend to use "strict" option.
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that you expect to communicate with, or from Certificate Authorities that you trust to identify other parties.  If the protocol (specified by the URL) is not HTTPS or if trustAllRoots is "true" this input is ignored.
#! @input trust_password: The password associated with the TrustStore file. If trustAllRoots is false and trustKeystore is empty, trustPassword default will be supplied
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of 0 represents an infinite timeout.
#! @input socket_timeout: The timeout for waiting for data (a maximum period inactivity between two consecutive data packets), in seconds. A socketTimeout value of 0 represents an infinite timeout.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.octane.v1.authentication
flow:
  name: authentication
  inputs:
    - url:
        prompt:
          type: text
        default: 'http://mydtbld0220.swinfra.net:11127'
    - auth_type:
        default: Basic
        required: false
    - username:
        prompt:
          type: text
        default: sa@nga
    - password:
        prompt:
          type: text
        default: Welcome1
        sensitive: true
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: strict
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
    - connect_timeout:
        required: false
    - socket_timeout:
        required: false
  workflow:
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${url + '/authentication/sign_in'}"
            - auth_type: '${auth_type}'
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - proxy_username: '${proxy_username}'
            - proxy_password:
                value: '${proxy_password}'
                sensitive: true
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - body: |-
                ${{
                     "user": username,
                     "password": password
                }}
            - content_type: application/json
        publish:
          - response_headers
          - return_code
          - return_result
        navigate:
          - SUCCESS: create_cookie
          - FAILURE: on_failure
    - create_cookie:
        do:
          io.cloudslang.microfocus.octane.v1.utils.create_cookie:
            - response_headers: '${response_headers}'
        publish:
          - cookie
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - cookie: '${cookie}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_post:
        x: 103
        'y': 165
      create_cookie:
        x: 400
        'y': 150
        navigate:
          fb5b8930-f402-4db6-6e15-671c35191664:
            targetId: d3cae9ef-1d60-1e3e-83f7-88cde414ebdc
            port: SUCCESS
    results:
      SUCCESS:
        d3cae9ef-1d60-1e3e-83f7-88cde414ebdc:
          x: 700
          'y': 150
