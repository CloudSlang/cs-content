########################################################################################################################
#!!
#! @description: This operation can be used to add tags to the given scope.
#!
#! @input scope: The resource scope
#! @input access_token: The authorization token for azure cloud.
#! @input proxy_host: Proxy server used to access the provider services.Optional
#! @input proxy_port: Proxy server port used to access the provider services.Optional
#! @input proxy_username: Proxy server user name.Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.Optional
#! @input trust_all_roots: Specifies whether to enable weak security over SSL.Default: 'false'Optional
#! @input x_509_hostname_verifier: Specifies the way the server hostname must match a domain name inthe subject's Common Name (CN) or subjectAltName field of the X.509 certificateValid: 'strict', 'browser_compatible', 'allow_all'Default: 'strict'Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates fromother parties that you expect to communicate with, or from Certificate Authorities thatyou trust to identify other parties.  If the protocol (specified by the 'url') is not'https' or if trust_all_roots is 'true' this input is ignored.Default value: '..JAVA_HOME/java/lib/security/cacerts'Format: Java KeyStore (JKS)Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is falseand trust_keystore is empty, trust_password default will be supplied.Optional
#!
#! @output return_result: This will contain the response entity.
#! @output status_code: 200 if request completed successfully, others in case something went wrong.
#! @output tags_json: A JSON containing the tags information.
#!
#! @result FAILURE: An error occurred while trying to send the request.
#! @result SUCCESS: The request to create tags has been successfully sent.
#!!#
########################################################################################################################
namespace: test.final
flow:
  name: create_tags_at_scope
  inputs:
    - scope: /subscriptions/<sub-id>/resourceGroups/<rg-name>
    - access_token: <auth-token>
    - proxy_host:
        default: <proxy>
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
        default: 'true'
        required: false
    - x_509_hostname_verifier:
        default: allow_all
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
    - Tenant_ID
    - Subscription_ID
    - Service_Instance_ID
    - Service_Component_ID
    - Owner
    - Email_ID
    - Cost_Center
    - CI_Instance_ID
  workflow:
    - api_call_to_add_tags:
        do:
          io.cloudslang.base.http.http_client_patch:
            - url: "${'https://management.azure.com/'+scope+'/providers/Microsoft.Resources/tags/default?api-version=2021-04-01'}"
            - auth_type: anonymous
            - proxy_host: '${proxy_host}'
            - proxy_port: '${proxy_port}'
            - trust_all_roots: '${trust_all_roots}'
            - x_509_hostname_verifier: '${x_509_hostname_verifier}'
            - request_character_set: utf-8
            - headers: "${'Authorization: '+access_token}"
            - body: "${body}"
            - content_type: application/json
        publish:
          - return_result
          - status_code
          - error_message
        navigate:
          - SUCCESS: set_success_message
          - FAILURE: on_failure
    - set_success_message:
        worker_group: '${worker_group}'
        do:
          io.cloudslang.base.utils.do_nothing:
            - message: The tags are sucessfully created
            - tags_json: '${return_result}'
        publish:
          - return_result: '${message}'
          - tags_json
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result
    - status_code
    - tags_json
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      api_call_to_add_tags:
        x: 200
        'y': 200
      set_success_message:
        x: 360
        'y': 200
        navigate:
          ed7c7b38-df18-5e0f-78ce-9be99fa19bb9:
            targetId: f1f62123-69ac-dd17-a1d9-3209ada7e80a
            port: SUCCESS
    results:
      SUCCESS:
        f1f62123-69ac-dd17-a1d9-3209ada7e80a:
          x: 560
          'y': 200

