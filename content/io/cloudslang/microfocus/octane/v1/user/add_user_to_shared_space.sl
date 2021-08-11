########################################################################################################################
#!!
#! @input url: The URL of the host running Octane. The format should be <protocol>://host:port.
#! @input auth_type: Type of authentication used to execute the request on the target server.Valid: 'basic', 'form', 'springForm', 'digest', 'ntlm', 'kerberos', 'anonymous' (no authentication)Default: 'anonymous'
#! @input shared_spaces: Shared space Id
#! @input email_new_user: New user email
#! @input password_new_user: New user password
#! @input last_name: New user last name
#! @input first_name: New user last name
#! @input name: New user name
#! @input phone: New user phone
#! @input proxy_host: The proxy server used to access the web site.
#! @input proxy_port: The proxy server port. Default value: 8080. Valid values: -1, and positive integer values. When the value is '-1' the default port of the scheme, specified in the 'proxyHost', will be used.
#! @input proxy_username: The user name used when connecting to the proxy. The "authType" input will be used to choose authentication type. The "Basic" and "Digest" proxy auth type are supported.
#! @input proxy_password: The proxy server password associated with the proxyUsername input value.
#! @input trust_all_roots: Specifies whether to enable weak security over TSL. A certificate is trusted even if no trusted certification authority issued it.
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. The hostname verification system prevents communication with other hosts other than the ones you intended. This is done by checking that the hostname is in the subject alternative name extension of the certificate. This system is designed to ensure that, if an attacker (Man-In-The-Middle) redirects traffic to his machine, the client will not accept the connection. If you set this input to "allow_all", this verification is ignored and you become vulnerable to security attacks. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". From the security perspective, to provide protection against possible Man-In-The-Middle attacks, we strongly recommend to use "strict" option.
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that you expect to communicate with, or from Certificate Authorities that you trust to identify other parties. If the protocol (specified by the URL) is not HTTPS or if trustAllRoots is "true" this input is ignored.
#! @input trust_password: The password associated with the TrustStore file. If trustAllRoots is false and trustKeystore is empty, trustPassword default will be supplied
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of 0 represents an infinite timeout.
#! @input socket_timeout: The timeout for waiting for data (a maximum period inactivity between two consecutive data packets), in seconds. A socketTimeout value of 0 represents an infinite timeout.
#! @input content_type: Content type that should be set in the request header, representing theMIME-type of the data in the message body.Default: 'application/json
#! @input body: String to include in body for HTTP POST operation.
#! @input header: List containing the headers to use for the request separated by new line (CRLF).Header name - value pair will be separated by ":"Format: According to HTTP standard for headers (RFC 2616)Example: 'Accept:text/plain'
#!
#! @output return_code: The returnCode of the operation: 0 for success, -1 for failure.
#! @output status_code: The HTTP status code.
#! @output response_headers: The list containing the headers of the response message, separated by newline.
#! @output error_message: In case of success response, this result is empty. In case of failure response, this result contains the stack trace of the runtime exception.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.octane.v1.user
flow:
  name: add_user_to_shared_space
  inputs:
    - url: 'http://mydtbld0220.swinfra.net:11127'
    - auth_type:
        default: anonymous
        required: false
    - shared_spaces:
        default: '1001'
        required: false
    - email_new_user
    - password_new_user:
        sensitive: true
    - last_name
    - first_name
    - name:
        required: false
    - phone:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
        sensitive: true
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
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
    - content_type:
        default: application/json
        required: false
    - body:
        required: false
    - header:
        default: 'cookie: OCTANE_USER:c2FAbmdh; LWSSO_COOKIE_KEY=kETGbTMM3SurctkaPHOcCv2e6af0d-OIE9EKNA3O10H3HnqOJVYaLkpWr72OfEOQe9rASI1Wb2uWXMyquuAmjFSlHY4E6ycLyug0-vzdAq0mKZ9AAHc1JEMq-xkETYBYeCcjaLhwKB2yeadeE2Mc5yNRWLBZOLPEkyRTLcyFBuc8caym_v3rN6VF3dufxn2PAH7OceZUpGsXuKwxxlkYPGkfwAy_9wtg1U7zeOQcKbNBrSihJ3-ZM2jfkyxsvVq-U3_8GLItSUiyb3dUFQYRAA..'
        required: false
  workflow:
    - create_body_add_user:
        do:
          io.cloudslang.microfocus.octane.v1.utils.create_body_add_user:
            - email: '${email_new_user}'
            - first_name: '${first_name}'
            - last_name: '${last_name}'
            - name: '${name}'
            - password:
                value: '${password_new_user}'
                sensitive: true
            - phone: '${phone}'
        publish:
          - body
          - error_mesage
          - return_code
        navigate:
          - SUCCESS: add_user
    - add_user:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${url+'/api/shared_spaces/'+shared_spaces+'/users'}"
            - auth_type: '${auth_type}'
            - headers: '${header}'
            - body: '${body}'
            - content_type: '${content_type}'
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
          - response_headers
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result: '${return_result}'
    - return_code: '${return_code}'
    - status_code: '${status_code}'
    - response_headers: '${response_headers}'
    - error_message: '${error_message}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      create_body_add_user:
        x: 402
        'y': 150
      add_user:
        x: 700
        'y': 150
        navigate:
          ba6719dc-1bf9-0ff8-f47b-2e70c3fc450f:
            targetId: 302fe25a-89fd-5ea0-b5c8-467d439de2b0
            port: SUCCESS
    results:
      SUCCESS:
        302fe25a-89fd-5ea0-b5c8-467d439de2b0:
          x: 1000
          'y': 150
