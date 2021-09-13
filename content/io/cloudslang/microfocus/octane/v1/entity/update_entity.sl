########################################################################################################################
#!!
#! @description: This flow updates an entity specified by it's id inside a workspace within a shared space given as input parameters by the user. The user also has to specify the type of entity used, from this list: defects, features, stories, epics.
#!
#! @input url: The URL of the host running Octane. This should look like this: protocol>://host:port.
#! @input cookie: The LSSWO cookie generated for a user after the authentication step which allows to access data using the REST API.
#! @input auth_type: The authentication type. The defauld it 'basic'
#! @input shared_space_id: The id of the shared space in the site
#! @input workspace_id: The id of the workspace found in the shared space
#! @input entity_id: The id of the entity that the user wants to update.
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
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group. Default: 'RAS_Operator_Path'
#!
#! @output response_headers: The header in JSON format containing the list of defects
#! @output return_result: The returned JSON containing information about the modified entities, which could be empty in case of deleting items.
#! @output error_message: The message given by the flow in case an error occured.
#! @output return_code: The code specifying 0 for success or -1 for failure.
#! @output status_code: The code that indicates whether a specific HTTP request has been successfully completed.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.octane.v1.entity
flow:
  name: update_entity
  inputs:
    - url
    - cookie
    - auth_type:
        required: false
    - shared_space_id
    - workspace_id
    - entity_id
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
    - worker_group:
        default: RAS_Operator_Path
        required: false
  workflow:
    - entity_body_updater:
        do:
          io.cloudslang.microfocus.octane.v1.utils.entity_body_updater: []
        publish:
          - json_body
          - my_entity
        navigate:
          - WRONG_OPTION: entity_body_updater
          - SUCCESS: http_client_action
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: '${url}'
            - auth_type: '${auth_type}'
            - headers: '${cookie}'
            - body: '${json_body}'
            - content_type: application/json
            - method: PUT
        publish:
          - return_result
          - error_message
          - status_code
          - return_code
          - response_headers
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - response_headers: '${response_headers}'
    - return_result: '${return_result}'
    - error_message: '${error_message}'
    - return_code: '${return_code}'
    - status_code: '${status_code}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      entity_body_updater:
        x: 100
        'y': 150
      http_client_action:
        x: 400
        'y': 150
        navigate:
          3b5fae81-4ffb-01bf-8394-65545b3d1521:
            targetId: 5f212ca6-3ade-8ff5-9ebd-15f490ce3f07
            port: SUCCESS
    results:
      SUCCESS:
        5f212ca6-3ade-8ff5-9ebd-15f490ce3f07:
          x: 700
          'y': 150