#   (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: This operation can be used to retrieve an access token to be used in subsequent google compute
#!               operations.
#!
#! @input json_token: Content of the Google Cloud service account JSON.
#! @input scopes: Scopes that you might need to request to access Google Compute APIs, depending on the level of access
#!                you need. One or more scopes may be specified delimited by the <scopesDelimiter>.
#!                Example: 'https://www.googleapis.com/auth/compute.readonly'
#!                Note: It is recommended to use the minimum necessary scope in order to perform the requests.
#!                For a full list of scopes see https://developers.google.com/identity/protocols/googlescopes#computev1
#! @input scopes_delimiter: Delimiter that will be used for the <scopes> input.
#!                          Default: ','
#!                          Optional
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
#! @output return_result: The generated access token for Google Cloud Compute.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output exception: An error message in case there was an error while generating the Bearer token.
#!
#! @result SUCCESS: Access token generated successfully.
#! @result FAILURE: There was an error while trying to retrieve Bearer token.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.cloud_platform.authentication

operation:
  name: get_access_token

  inputs:
    - json_token
    - jsonToken:
        default: ${get('json_token', '')}
        required: false
        private: true
    - scopes
    - scopes_delimiter:
        default: ','
        required: false
    - scopesDelimiter:
        default: ${get('scopes_delimiter', ',')}
        required: false
        private: true
    - timeout:
        default: '0'
        required: false
    - proxy_host:
        required: false
    - proxyHost:
        default: ${get('proxy_host', '')}
        required: false
        private: true
    - proxy_port:
        required: false
    - proxyPort:
        default: ${get('proxy_port', '8080')}
        required: false
        private: true
    - proxy_username:
        required: false
    - proxyUsername:
        default: ${get('proxy_username', '')}
        required: false
        private: true
    - proxy_password:
        required: false
        sensitive: true
    - proxyPassword:
        default: ${get('proxy_password', '')}
        required: false
        private: true
        sensitive: true

  java_action:
      gav: 'io.cloudslang.content:cs-google-cloud:0.0.1-SNAPSHOT'
      class_name: io.cloudslang.content.gcloud.actions.compute.utils.GetAccessToken
      method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE