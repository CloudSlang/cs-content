#   Copyright 2023 Open Text
#   This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
#!!
#! @description: Creates issues and, where the option to create subtasks is enabled in Jira, subtasks. Transitions may be applied, to move the issues or subtasks to a workflow step other than the default start step, and issue properties set.
#!                
#!               The content of each issue or subtask is defined using update and fields. The fields that can be set in the issue or subtask are determined using the Get create issue metadata. These are the same fields that appear on the issues' create screens. Note that the description, environment, and any textarea type custom fields (multi-line text fields) take Atlassian Document Format content. Single line custom fields (textfield) accept a string and don't handle Atlassian Document Format content.
#!                
#!               Creating a subtask differs from creating an issue as follows:
#!                
#!               issueType must be set to a subtask issue type (use Get create issue metadata to find subtask issue types).
#!               parent the must contain the ID or key of the parent issue.
#!
#! @input url: URL to which the call is made.
#! @input username: Username used for URL authentication
#! @input password: Password used for URL authentication
#! @input issue_data: Issue data in json format.
#!                    ex:'{
#!                    "issueUpdates": [
#!                    {
#!                    "update": {
#!                    "worklog": [
#!                    {
#!                    "add": {
#!                    "timeSpent": "60m",
#!                    "started": "2019-07-05T11:05:00.000+0000"
#!                    }
#!                    }
#!                    ]
#!                    },
#!                    "fields": {
#!                    "summary": "Main order flow broken",
#!                    "issuetype": {
#!                    "id": "10000"
#!                    },
#!                    "components": [
#!                    {
#!                    "id": "10000"
#!                    }
#!                    ],
#!                    "customfield_20000": "06/Jul/19 3:25 PM",
#!                    "customfield_40000": {
#!                    "type": "doc",
#!                    "version": 1,
#!                    "content": [
#!                    {
#!                    "type": "paragraph",
#!                    "content": [
#!                    {
#!                    "text": "Occurs on all orders",
#!                    "type": "text"
#!                    }
#!                    ]
#!                    }
#!                    ]
#!                    },
#!                    "customfield_70000": [
#!                    "jira-administrators",
#!                    "jira-software-users"
#!                    ],
#!                    "project": {
#!                    "id": "10000"
#!                    },
#!                    "description": {
#!                    "type": "doc",
#!                    "version": 1,
#!                    "content": [
#!                    {
#!                    "type": "paragraph",
#!                    "content": [
#!                    {
#!                    "text": "Order entry fails when selecting supplier.",
#!                    "type": "text"
#!                    }
#!                    ]
#!                    }
#!                    ]
#!                    },
#!                    "reporter": {
#!                    "id": "5b10a2844c20165700ede21g"
#!                    },
#!                    "fixVersions": [
#!                    {
#!                    "id": "10001"
#!                    }
#!                    ],
#!                    "customfield_10000": "09/Jun/19",
#!                    "priority": {
#!                    "id": "20000"
#!                    },
#!                    "labels": [
#!                    "bugfix",
#!                    "blitz_test"
#!                    ],
#!                    "timetracking": {
#!                    "remainingEstimate": "5",
#!                    "originalEstimate": "10"
#!                    },
#!                    "customfield_30000": [
#!                    "10000",
#!                    "10002"
#!                    ],
#!                    "customfield_80000": {
#!                    "value": "red"
#!                    },
#!                    "security": {
#!                    "id": "10000"
#!                    },
#!                    "environment": {
#!                    "type": "doc",
#!                    "version": 1,
#!                    "content": [
#!                    {
#!                    "type": "paragraph",
#!                    "content": [
#!                    {
#!                    "text": "UAT",
#!                    "type": "text"
#!                    }
#!                    ]
#!                    }
#!                    ]
#!                    },
#!                    "versions": [
#!                    {
#!                    "id": "10000"
#!                    }
#!                    ],
#!                    "duedate": "2011-03-11",
#!                    "customfield_60000": "jira-software-users",
#!                    "customfield_50000": {
#!                    "type": "doc",
#!                    "version": 1,
#!                    "content": [
#!                    {
#!                    "type": "paragraph",
#!                    "content": [
#!                    {
#!                    "text": "Could impact day-to-day work.",
#!                    "type": "text"
#!                    }
#!                    ]
#!                    }
#!                    ]
#!                    },
#!                    "assignee": {
#!                    "id": "5b109f2e9729b51b54dc274d"
#!                    }
#!                    }
#!                    }
#!                    ]
#!                    }'
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy port used to access the web site.
#! @input proxy_username: Optional - Proxy usernameused to access the web site.
#! @input proxy_password: Optional - Proxy password used to access the web site.
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
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL.
#!                         Default: 'false'
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's
#!                                 Common Name (CN) or subjectAltName field of the X.509 certificate.
#!                                 Valid: 'strict', 'browser_compatible', 'allow_all'
#!                                 Default: 'strict'
#! @input trust_keystore: Optional - The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                        'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Default value: ''
#!                        Format: Java KeyStore (JKS)
#! @input trust_password: Optional - The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#! @input connect_timeout: Optional - Time in seconds to wait for a connection to be established
#!                         Default: '0' (infinite)
#! @input socket_timeout: Optional - Time in seconds to wait for data to be retrieved
#!                        Default: '0' (infinite)
#! @input worker_group: When a worker group name is specified in this input, all the steps of the flow run on that worker group.
#!                      Default: 'RAS_Operator_Path'
#!
#! @output response_headers: Jira bulk create issue response headers
#! @output status_code: 201 - Returned if the request is successful.
#!                      400 - Returned if the request:
#!                      	is missing required fields.
#!                      	contains invalid field values.
#!                      	contains fields that cannot be set for the issue type.
#!                      	is by a user who does not have the necessary permission.
#!                      	is to create a subtype in a project different that of the parent issue.
#!                      	is for a subtask when the option to create subtasks is disabled.
#!                      	is invalid for any other reason.
#!                      401 - Returned if the authentication credentials are incorrect or missing.
#!                      403 - Returned if the user does not have the necessary permission.
#! @output error_message: Error message
#! @output return_result: Data regarding the newly created issues
#! @output return_code: 0 - success, -1 - failure
#! @output issue_ids: List of ids belonging to the newly created issues.
#!
#! @result FAILURE: Execution failed
#! @result SUCCESS: status_code == 201
#!!#
########################################################################################################################
namespace: io.cloudslang.atlassian.jira.v1.issues
flow:
  name: bulk_create_issue
  inputs:
    - url
    - username:
        required: true
    - password:
        required: true
        sensitive: true
    - issue_data:
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
    - tls_version:
        required: false
    - allowed_cyphers:
        required: false
    - trust_all_roots:
        default: 'false'
        required: false
    - x_509_hostname_verifier:
        default: strict
        required: false
    - trust_keystore:
        default: "${get_sp('io.cloudslang.base.http.trust_keystore')}"
        required: false
    - trust_password:
        default: "${get_sp('io.cloudslang.base.http.trust_password')}"
        required: false
        sensitive: true
    - connect_timeout:
        default: '0'
        required: false
    - socket_timeout:
        default: '0'
        required: false
    - worker_group:
        required: false
  workflow:
    - http_client_post:
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${url + '/rest/api/3/issue/bulk'}"
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
            - request_character_set: utf-8
            - connect_timeout: '${connect_timeout}'
            - socket_timeout: '${socket_timeout}'
            - headers: 'Accept: application/json'
            - body: '${issue_data}'
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
            - array_name: issues
        publish:
          - issue_ids: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
  outputs:
    - response_headers: '${response_headers}'
    - status_code: '${status_code}'
    - error_message: "${error_message if error_message != '' else (return_result if status_code != '201' else '')}"
    - return_result: "${return_result if status_code == '201' else ''}"
    - return_code: '${return_code}'
    - issue_ids: '${issue_ids}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_post:
        x: 200
        'y': 200
      test_for_http_error:
        x: 200
        'y': 360
      get_ids_from_json_array:
        x: 360
        'y': 200
        navigate:
          ea2678bb-5d51-e117-f03a-3038cd80b4c0:
            targetId: 70f668aa-93d0-2a16-254a-384531eef6e7
            port: SUCCESS
    results:
      SUCCESS:
        70f668aa-93d0-2a16-254a-384531eef6e7:
          x: 480
          'y': 200
