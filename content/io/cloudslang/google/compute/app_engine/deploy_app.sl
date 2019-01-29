#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
#   All rights reserved. This program and the accompanying materials
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
#! @description: This flow is used to deploy an application to Google App Engine.
#!               The flow uses the Google App Engine Admin API and authenticates to Google, creates an app version
#!               based on an instance configuration file and with a version_id as read from the file,
#!               waits for the create operation to complete and retrieves application details like URL and status.
#!
#! @input json_token: Content of the Google Cloud service account JSON.
#! @input app_id: The App Engine application id.
#! @input service_id: The App Engine service id for which the call is done.
#! @input version_instance_conf: The app.json content for the application to be deployed.
#! @input proxy_host: Proxy server used to access the web site.
#!                    Optional
#! @input proxy_port: Proxy server port.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: User name used when connecting to the proxy server.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#!
#! @output return_result: If successful (status_code = 200), it contains a new instance of the operation
#!                        or the error message otherwise.
#! @output status_code: Status code of the deployment call.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output exception: An error message in case there was an error while generating the Bearer token.
#! @output error_message: The error message from the Google response or the error message when return_code = '-1'.
#! @output serving_status: If version exists its status is returned.
#! @output version_url: If version exists its url is returned.
#!
#! @result SUCCESS: The application was deployed successfully.
#! @result FAILURE: There was an error while trying to deploy the application.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.compute.app_engine

imports:
  gcauth: io.cloudslang.google.authentication
  gcappengineversions: io.cloudslang.google.compute.app_engine.services.versions
  utils: io.cloudslang.base.utils
  json: io.cloudslang.base.json

flow:
  name: deploy_app

  inputs:
    - json_token:
        sensitive: true
    - app_id
    - service_id
    - version_instance_conf
    - proxy_host:
        required: false
    - proxy_port:
        default: '8080'
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - seconds:
        default: '10'
        private: true

  workflow:
    - get_token:
        do:
          gcauth.get_access_token:
            - json_token
            - scopes: 'https://www.googleapis.com/auth/cloud-platform'
            - scopes_delimiter
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
        publish:
          - access_token: ${return_result}
          - return_code
          - exception
        navigate:
          - SUCCESS: deploy_app
          - FAILURE: FAILURE

    - deploy_app:
        do:
          gcappengineversions.create_version:
            - access_token
            - app_id
            - service_id
            - version_instance_conf
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - connect_timeout
            - socket_timeout
        publish:
          - return_result
          - return_code
          - error_message
          - status_code
        navigate:
          - SUCCESS: wait_for_deployment
          - FAILURE: FAILURE

    - wait_for_deployment:
        do:
          utils.sleep:
            - seconds
        navigate:
          - SUCCESS: get_version_id
          - FAILURE: on_failure

    - get_version_id:
        do:
          json.json_path_query:
            - json_object: '${version_instance_conf}'
            - json_path: .id
        publish:
          - version_id: "${''.join( c for c in return_result if  c not in '[]\"' )}"
          - exception
        navigate:
          - SUCCESS: get_version_details
          - FAILURE: on_failure

    - get_version_details:
        do:
          gcappengineversions.get_version:
            - access_token
            - app_id
            - service_id
            - version_id
            - proxy_host
            - proxy_port
            - proxy_username
            - proxy_password
            - trust_keystore
            - trust_password
            - keystore
            - keystore_password
            - connect_timeout
            - socket_timeout
        publish:
          - return_result
          - return_code
          - error_message
          - status_code
          - serving_status
          - version_url
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE

  outputs:
    - return_result
    - return_code
    - exception
    - error_message
    - status_code
    - serving_status
    - version_url

  results:
    - SUCCESS
    - FAILURE