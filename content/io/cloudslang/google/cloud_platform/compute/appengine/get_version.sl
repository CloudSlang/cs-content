#   (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Lists the versions of a service
#!
#! @input access_token: the access_token from Google Cloud Platform for which the access token should be granted
#!
#! @input project_id: the project in Google cloud for which the call is done
#!
#! @input service_id: the service in Google cloud for which the call is done
#!
#! @input version_id: the version in Google cloud for which the call is done
#!
#! @input proxy_host: Proxy server used to access the web site.
#!                    Optional
#! @input proxy_port: Proxy server port.
#!                    Default: '8080'
#!                    Optional
#! @input proxy_username: User name used when connecting to the proxy.
#!                        Optional
#! @input proxy_password: Proxy server password associated with the <proxy_username> input value.
#!                        Optional
#! @input trust_keystore: The pathname of the Java TrustStore file. This contains certificates from
#!                        other parties that you expect to communicate with, or from Certificate Authorities that
#!                        you trust to identify other parties.  If the protocol (specified by the 'url') is not
#!                       'https' or if trust_all_roots is 'true' this input is ignored.
#!                        Format: Java KeyStore (JKS)
#!                        Optional
#! @input trust_password: The password associated with the trust_keystore file. If trust_all_roots is false
#!                        and trust_keystore is empty, trust_password default will be supplied.
#!                        Optional
#! @input keystore: The pathname of the Java KeyStore file.
#!                  You only need this if the server requires client authentication.
#!                  If the protocol (specified by the 'url') is not 'https' or if trust_all_roots is 'true'
#!                  this input is ignored.
#!                  Format: Java KeyStore (JKS)
#!                  Optional
#! @input keystore_password: The password associated with the KeyStore file. If trust_all_roots is false and
#!                           keystore is empty, keystore_password default will be supplied.
#!                           Optional
#! @input connect_timeout: Time in seconds to wait for a connection to be established.
#!                         Default: '0' (infinite)
#!                         Optional
#! @input socket_timeout: Time in seconds to wait for data to be retrieved.
#!                        Default: '0' (infinite)
#!                        Optional
#!
#! @output return_result: The response of the operation in case of success or the error message otherwise.
#! @output error_message: return_result if status_code different than '200'.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output status_code: Status code of the HTTP call.
#! @output response_headers: Response headers string from the HTTP Client REST call.
#! @output message: If something went wrong this message would provide more info.
#! @output serving_status: If version exists its status is returned.
#! @output version_url: If version exists its url is returned.
#!
#! @result SUCCESS: Everything completed successfully.
#! @result FAILURE: Something went wrong.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.cloud_platform.compute.appengine

imports:
  http: io.cloudslang.base.http
  json: io.cloudslang.base.json

flow:
  name: get_version

  inputs:
    - access_token
    - project_id
    - service_id
    - version_id
    - proxy_host:
        required: false
    - proxy_port:
        required: false
    - proxy_username:
        required: false
    - proxy_password:
        required: false
    - trust_keystore:
        required: false
    - trust_password:
        required: false
    - keystore:
        required: false
    - keystore_password:
        required: false
    - connect_timeout:
        default: '0'
        required: false
    - socket_timeout:
        default: '0'
        required: false

  workflow:
    - interogate_google_cloud_platform:
        do:
          http.http_client_get:
            - url: "${'https://appengine.googleapis.com//v1/apps/' + project_id + '/services/' + service_id + '/versions/' + version_id}"
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
            - content_type: application/json
            - headers: "${'Authorization: Bearer ' + access_token}"
        publish:
          - return_result
          - return_code
          - error_message
          - status_code
          - response_headers
        navigate:
          - SUCCESS: get_message
          - FAILURE: get_message

    - get_message:
        do:
          json.json_path_query:
            - json_object: '${return_result}'
            - json_path: .message
        publish:
          - message: ${return_result}
        navigate:
          - SUCCESS: get_serving_status
          - FAILURE: get_serving_status

    - get_serving_status:
        do:
          json.json_path_query:
            - json_object: '${return_result}'
            - json_path: .servingStatus
        publish:
          - serving_status: ${return_result}
        navigate:
          - SUCCESS: get_version_url
          - FAILURE: on_failure

    - get_version_url:
        do:
          json.json_path_query:
            - json_object: '${return_result}'
            - json_path: .versionUrl
        publish:
          - version_url: ${return_result}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure

  outputs:
    - return_result
    - return_code
    - status_code
    - error_message
    - response_headers
    - message
    - serving_status
    - version_url

  results:
    - SUCCESS
    - FAILURE