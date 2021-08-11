########################################################################################################################
#!!
#! @description: This flow deletes a workspace
#!
#! @input url: The URL of the host running Octane. This should look like this: protocol>://host:port.
#! @input cookie: The LSSWO cookie generated for a user after the authentication step which allows to access data using the REST API.
#! @input auth_type: The authentication type. The defauld it 'basic'
#! @input proxy_host: The user name used for Octane server connection.
#! @input proxy_port: The user name used for Octane server connection.
#! @input proxy_username: The proxy server username used to access the web site
#! @input proxy_password: The proxy server password associated with the username used to access the web site
#! @input trust_all_roots: Specifies whether to enable weak security over TLS. A ceritficate is trusted even if no trusted certification authority issued it
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. The hostname verification system prevents communication with other hosts other than the ones you intended. This is done by checking that the hostname is in the subject alternative name extension of the certificate. This system is designed to ensure that, if an attacker (Man-In-The-Middle) redirects traffic to his machine, the client will not accept the connection. If you set this input to "allow_all", this verification is ignored and you become vulnerable to security attacks. For the value "browser_compatible" the hostname verifier works the same way as Curl and Firefox. The hostname must match either the first CN, or any of the subject-alts. A wildcard can occur in the CN, and in any of the subject-alts. The only difference between "browser_compatible" and "strict" is that a wildcard (such as "*.foo.com") with "browser_compatible" matches all subdomains, including "a.b.foo.com". From the security perspective, to provide protection against possible Man-In-The-Middle attacks, we strongly recommend to use "strict" option.
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from other parties that you expect to communicate with, or from Certificate Authorities that you trust to identify other parties.  If the protocol (specified by the URL) is not HTTPS or if trustAllRoots is "true" this input is ignored.
#! @input trust_password: The password associated with the TrustStore file. If trustAllRoots is false and trustKeystore is empty, trustPassword default will be supplied
#! @input connect_timeout: The time to wait for a connection to be established, in seconds. A timeout value of 0 represents an infinite timeout.
#! @input socket_timeout: The timeout for waiting for data (a maximum period inactivity between two consecutive data packets), in seconds. A socketTimeout value of 0 represents an infinite timeout.
#! @input shared_space_id: The id of the shared space in the site
#!
#! @output response_headers: The header in JSON format containing the list of defects
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.octane.v1.workspaces
flow:
  name: delete_a_workspace
  inputs:
    - url:
        prompt:
          type: text
        default: 'http://mydtbld0220.swinfra.net:11127'
    - cookie: 'cookie: OCTANE_USER=c2FAbmdh; LWSSO_COOKIE_KEY=SDcCvYTUIddFtd8UJAG152vORNA4YX9mj5KiztbxH-qAlI9H9maN4go3X5assJOv7OYyeLBKKcPIcm6nl1qRf9pYPVGiOMICdRpuKkB3oiI0RY4wHmbU6BZOg_L-rF2ZAI6pcUmOl0QY3rVEz1sjp2F8BZTvXrV1389B87H6yfy38wS87vf_6HvFF8o3h16wYG6LbpmRxelMCctKwLN2uCFRzcvnFRjJqDqkjbGMEbj5tm2R5uR9PV7EswqNzoyGDdmCFzoy1DBhbP-z77S9zA..'
    - auth_type:
        default: anonymous
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
    - shared_space_id: '1001'
    - workspace_id:
        prompt:
          type: text
        default: '1009'
  workflow:
    - http_client_delete:
        do:
          io.cloudslang.base.http.http_client_delete:
            - url: "${url + '/api/shared_spaces/' + shared_space_id + '/workspaces/' + workspace_id}"
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
            - headers: '${cookie}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - response_headers: '${response_headers}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_delete:
        x: 99
        'y': 151
        navigate:
          753c8e43-886d-592c-4e88-f4ec1c121393:
            targetId: e24c390b-4e09-8d27-abc4-58e9d2e7dc32
            port: SUCCESS
    results:
      SUCCESS:
        e24c390b-4e09-8d27-abc4-58e9d2e7dc32:
          x: 400
          'y': 150
