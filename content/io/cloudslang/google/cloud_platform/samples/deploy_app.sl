#   (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: This flow is used to deploy applications to Google App Engine by using the Admin API.
#!
#! @input json_token: Content of the Google Cloud service account JSON.
#! @input json_app_conf: the app.json content for the application to be deployed
#! @input project_id: the project in Google cloud for which the deployment is done
#! @input service_id: the service in Google cloud for which the deployment is done
#! @input version_id: the version in Google cloud that will be deployed
#!                    Default: 'staging'
#! @input timeout: URL of the login authority that should be used when retrieving the Authentication Token.
#!                 Default: 'https://sts.windows.net/common'
#! @input proxy_host: Proxy server used to access the web site.
#!                    Optional
#! @input proxy_port: Proxy server port.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: User name used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#!
#! @output return_result: The entire result of the call.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output exception: An error message in case there was an error while generating the Bearer token.
#! @output error_message: Error message in case of deployment error
#! @output status_code: Status code of the deployment call.
#! @output message: If something went wrong this message would provide more info.
#! @output serving_status: If version exists its status is returned.
#! @output version_url: If version exists its url is returned.
#!
#! @result SUCCESS: The application was deployed successfully.
#! @result FAILURE: There was an error while trying to retrieve Bearer token.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.cloud_platform.samples

imports:
  gcauth: io.cloudslang.google.cloud_platform.authentication
  gcappengine: io.cloudslang.google.cloud_platform.compute.appengine
  utils: io.cloudslang.base.utils

flow:
  name: deploy_app

  inputs:
    - json_token:
        sensitive: true
    - json_app_conf
    - project_id
    - service_id
    - version_id:
        default: 'staging'
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false

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
          gcappengine.create_version:
            - access_token
            - json_app_conf
            - project_id
            - service_id
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
            - seconds: '15'
        navigate:
          - SUCCESS: get_version_details
          - FAILURE: on_failure

    - get_version_details:
        do:
          gcappengine.get_version:
            - access_token
            - project_id
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
          - message
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
    - message

  results:
    - SUCCESS
    - FAILURE