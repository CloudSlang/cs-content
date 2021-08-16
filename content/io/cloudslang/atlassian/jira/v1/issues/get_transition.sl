########################################################################################################################
#!!
#! @description: Returns either all transitions or a transition that can be performed by the user on an issue, based on the issue's status.
#!
#! @input url: URL to which the call is made.
#! @input username: Username used for URL authentication
#! @input password: Password used for URL authentication
#! @input issue_id_or_key: Issue id or key
#! @input expand: Use expand to include additional information about transitions in the response. This parameter accepts transitions.fields, which returns information about the fields in the transition screen for each transition. Fields hidden from the screen are not returned. Use this information to populate the fields and update fields in Transition issue.
#! @input skip_remote_only_condition: Whether transitions with the condition Hide From User Condition are included in the response.
#! @input transition_id: The ID of the transition.
#! @input include_unavailable_transitions: Whether details of transitions that fail a condition are included in the response
#! @input sort_by_ops_bar_and_status: Whether the transitions are sorted by ops-bar sequence value first then category order (Todo, In Progress, Done) or only by ops-bar sequence value.
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy port used to access the web site.
#! @input proxy_username: Optional - Proxy usernameused to access the web site.
#! @input proxy_password: Optional - Proxy password used to access the web site.
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate.
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#! @input connect_timeout: Optional - Time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#! @input socket_timeout: Optional - Time in seconds to wait for data to be retrieved
#!                        Default: '0' (infinite)
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#! @input tls_version: Optional - This input allows a list of comma separated values of the specific protocols to be used.
#!                     Valid: SSLv3, TLSv1, TLSv1.1, TLSv1.2.
#!                     Default: 'TLSv1.2'
#! @input allowed_cyphers: Optional - A comma delimited list of cyphers to use. The value of this input will be ignored
#!                         if 'tlsVersion' does not contain 'TLSv1.2'.This capability is provided “as is”, please see product
#!                         documentation for further security considerations. In order to connect successfully to the target
#!                         host, it should accept at least one of the following cyphers. If this is not the case, it is the
#!                         user's responsibility to configure the host accordingly or to update the list of allowed cyphers.
#!                         Default: TLS_DHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
#!                         TLS_DHE_RSA_WITH_AES_256_CBC_SHA256,TLS_DHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384,
#!                         TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256,TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256,
#!                         TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_256_CBC_SHA256,TLS_RSA_WITH_AES_128_CBC_SHA256
#! @input trust_keystore: Optional - The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Format: Java KeyStore (JKS)
#!                        Default value: ''
#! @input trust_password: Optional - The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!
#! @output response_headers: Jira get transition response headers
#! @output status_code: 200 - Returned if the request is successful.
#!                      401 - Returned if the authentication credentials are incorrect or missing.
#!                      404 - Returned if the issue is not found or the user does not have permission to view it..
#! @output error_message: Error message
#! @output return_result: Json containing data regarding the transitions
#! @output return_code: 0 - success, -1 - failure
#! @output transition_ids: List of transition ids delimited by ,
#!
#! @result SUCCESS: status_code == 200
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.v1.issues
flow:
  name: get_transition
  inputs:
    - url
    - username:
        required: true
    - password:
        required: true
        sensitive: true
    - issue_id_or_key
    - expand:
        required: false
    - skip_remote_only_condition:
        default: 'false'
        required: false
    - transition_id:
        required: false
    - include_unavailable_transitions:
        default: 'false'
        required: false
    - sort_by_ops_bar_and_status:
        default: 'false'
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
        default: strict
        required: false
    - connect_timeout:
        default: '0'
        required: false
    - socket_timeout:
        default: '0'
        required: false
    - worker_group:
        required: false
    - tls_version:
        required: false
    - allowed_cyphers:
        required: false
    - trust_keystore:
        default: "${get_sp('io.cloudslang.base.http.trust_keystore')}"
        required: false
    - trust_password:
        default: "${get_sp('io.cloudslang.base.http.trust_password')}"
        required: false
        sensitive: true
  workflow:
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${url + '/rest/api/3/issue/' + issue_id_or_key + '/transitions'}"
            - auth_type: basic
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
            - tls_version: '${tls_version}'
            - allowed_cyphers: '${allowed_cyphers}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - trust_keystore: '${trust_keystore}'
            - trust_password:
                value: '${trust_password}'
                sensitive: true
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - headers: 'Accept: application/json'
            - query_params: |-
                ${(
                    ('expand=' + expand + '&' if expand is not None else '') +
                    ('transitionId=' + transition_id + '&' if transition_id is not None else '') +
                    ('skipRemoteOnlyCondition=' + skip_remote_only_condition + '&' if skip_remote_only_condition is not None else '') +
                    ('includeUnavailableTransitions=' + include_unavailable_transitions + '&' if include_unavailable_transitions is not None else '') +
                    ('sortByOpsBarAndStatus=' + sort_by_ops_bar_and_status + '&' if sort_by_ops_bar_and_status is not None else '')
                )[:-1] if (
                    ('expand=' + expand + '&' if expand is not None else '') +
                    ('transitionId=' + transition_id + '&' if transition_id is not None else '') +
                    ('skipRemoteOnlyCondition=' + skip_remote_only_condition + '&' if skip_remote_only_condition is not None else '') +
                    ('includeUnavailableTransitions=' + include_unavailable_transitions + '&' if include_unavailable_transitions is not None else '') +
                    ('sortByOpsBarAndStatus=' + sort_by_ops_bar_and_status + '&' if sort_by_ops_bar_and_status is not None else '')
                ) != '' else ''}
            - content_type: application/json
            - worker_group: '${worker_group}'
        publish:
          - return_result: '${return_result}'
          - return_code: '${return_code}'
          - status_code: '${status_code}'
          - response_headers: '${response_headers}'
          - error_message
        navigate:
          - SUCCESS: get_ids_from_json_array
          - FAILURE: test_for_http_error
    - test_for_http_error:
        do:
          io.cloudslang.atlassian.jira.v1.utils.test_for_http_error:
            - return_result: '${return_result}'
        publish:
          - error_message
        navigate:
          - FAILURE: on_failure
    - get_ids_from_json_array:
        do:
          io.cloudslang.atlassian.jira.v1.utils.get_ids_from_json_array:
            - data_json: '${return_result}'
            - array_name: transitions
        publish:
          - transition_ids: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - response_headers: '${response_headers}'
    - status_code: '${status_code}'
    - error_message: "${error_message if error_message != '' else (return_result if status_code != '200' else '')}"
    - return_result: "${return_result if status_code == '200' else ''}"
    - return_code: '${return_code}'
    - transition_ids: '${transition_ids}'
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      http_client_get:
        x: 240
        'y': 200
      test_for_http_error:
        x: 240
        'y': 360
      get_ids_from_json_array:
        x: 400
        'y': 200
        navigate:
          24bb5ee2-2451-ec3f-7603-6b749530b161:
            targetId: 70f668aa-93d0-2a16-254a-384531eef6e7
            port: SUCCESS
    results:
      SUCCESS:
        70f668aa-93d0-2a16-254a-384531eef6e7:
          x: 520
          'y': 200
