########################################################################################################################
#!!
#! @description: This flow returns a token based on user credentials.
#!
#! @input url: The URL of the host running Octane. The format should be <protocol>://host:port.
#! @input username: The user name used for the Octane server connection.
#! @input password: The password associated with the <username> input value.
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
#! @input body: String to include in body for HTTP POST operation.
#! @input content_type: Content type that should be set in the request header, representing the
#!                      MIME-type of the data in the message body.
#!                      Default: 'text/plain'
#!
#! @output return_code: The returnCode of the operation: 0 for success, -1 for failure.
#! @output status_code: The HTTP status code.
#! @output response_headers: The list containing the headers of the response message, separated by newline.
#! @output error_message: In case of success response, this result is empty. In case of failure response, this result contains the stack trace of the runtime exception.
#! @output cookie: The cookies for authentication
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.octane.v1.authentication
flow:
  name: authentication_test
  inputs:
    - url: 'http://mydtbld0220.swinfra.net:11127'
    - username: sa@nga
    - password:
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
        sensitive: true
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
    - body:
        required: false
    - content_type:
        default: application/json
        required: false
  workflow:
    - request_body_creator:
        do:
          io.cloudslang.microfocus.octane.v1.utils.request_body_creator:
            - username: '${username}'
            - password: '${password}'
        publish:
          - body
        navigate:
          - SUCCESS: auth
          - FAILURE: on_failure
    - auth:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${url+'/authentication/sign_in'}"
            - body: '${body}'
            - content_type: application/json
        publish:
          - return_result
          - error_message
          - return_code
          - status_code
          - response_headers
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
    - return_code: '${return_code}'
    - status_code: '${status_code}'
    - response_headers: '${response_headers}'
    - error_message: '${error_message}'
    - cookie: '${cookie}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      request_body_creator:
        x: 100
        'y': 150
      auth:
        x: 400
        'y': 150
      create_cookie:
        x: 700
        'y': 150
        navigate:
          60aa252d-3fb6-f52b-c3b2-16207c5ec3eb:
            targetId: dbd46c80-e764-46b3-ab37-c0700c062dd4
            port: SUCCESS
    results:
      SUCCESS:
        dbd46c80-e764-46b3-ab37-c0700c062dd4:
          x: 1000
          'y': 150
