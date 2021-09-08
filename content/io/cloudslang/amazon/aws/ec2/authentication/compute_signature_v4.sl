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
#! @description: Computes the AWS Signature Version 4 used to authenticate requests by using the authorization header.
#!               For this signature type the checksum of the entire payload is computed.
#!               Note: This operation uses Signature V4 mechanism. The 'authorizationHeader' output's value should be added
#!                     in the 'Authorization' header. For more information see:
#!                     http://docs.aws.amazon.com/general/latest/gr/sigv4-add-signature-to-request.html#sigv4-add-signature-auth-header
#!
#! @input endpoint: Optional - Service endpoint used to compute the signature.
#!                  Example: 'ec2.amazonaws.com', 's3.amazonaws.com'
#!                  Default: 'ec2.amazonaws.com'
#! @input identity: ID of the secret access key associated with your Amazon AWS or IAM account.
#! @input credential: Secret access key associated with your Amazon AWS or IAM account.
#! @input amazon_api: Corresponding Amazon API micro service where the request is send.
#!                   Examples: 'ec2', 's3'
#! @input uri: Optional - Request's relative URI. The URI should be from the service endpoint to the query params.
#!             Default: '/' (slash)
#! @input http_verb: Method used for the request. You need to specify this with upper case. Because the integration is
#!                   Query API based then 'GET' method should be used.
#!                   Valid values: GET, PUT
#!                   Default: 'GET'
#! @input payload_hash: Optional - Payload's hash that will be included in the signature. The hashing should be computed
#!                      using the 'SHA-256' hashing algorithm and then hex encoded.
#!                      Default: ''
#! @input security_token: URI-encoded session token. The string you received from AWS STS when you obtained temporary
#!                        security credentials.
#! @input date: Date of the request. The date should be also included in the 'x-amz-date' header and should be in the in
#!              the YYYYMMDD'T'HHMMSS'Z' format form UTC time zone.
#!              Example: 20150416T112043Z for April 16, 2015 11:20:43 AM UTC
#!              Default: The current date and time in UTC time zone
#! @input headers: Optional - String containing the headers to use for the request separated by new line (CRLF). The header name-value
#!                 pair will be separated by ':' (colon).
#!                 Format: Conforming with HTTP standard for headers (RFC 2616)
#!                 Example: 'Accept:text/plain'
#!                 Default: ''
#! @input query_params: Optional - String containing query parameters that will be appended to the URL. The names and the
#!                      values must not be URL encoded because if they are encoded then a double encoded will occur. The
#!                      separator between name-value pairs is '&' (ampersand) symbol. The query name will be separated from
#!                      query value by '=' (equal).
#!                      Examples: 'parameterName1=parameterValue1&parameterName2=parameterValue2'
#!                      Default: ''
#!
#! @output signature: Signature result using Amazon Signature V4 mechanism
#! @output authorization_header: Value that should be added as a pair for 'Authorization' header in the request
#! @output return_result: outcome of the action in case of success, exception occurred otherwise
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise
#! @output exception: error message if there was an error when executing, empty otherwise
#!
#! @result SUCCESS: The operation executed successfully and the 'return_code' is 0.
#! @result FAILURE: The operation could not be executed or the value of the 'return_code' is different than 0.
#!!#
########################################################################################################################

namespace: io.cloudslang.amazon.aws.ec2.authentication

operation:
  name: compute_signature_v4

  inputs:
    - endpoint:
        default: 'https://ec2.amazonaws.com'
        required: false
    - identity
    - credential:
        sensitive: true
    - amazon_api
    - amazonApi:
        default: ${get("amazon_api", "")}
        required: false
        private: true
    - uri:
        default: '/'
        required: false
    - http_verb:
        default: 'GET'
    - httpVerb:
        default: $(get("http_verb", "")}
        required: false
        private: true
    - payload_hash:
        required: false
    - payloadHash:
        default: ${get("payload_hash", "")}
        required: false
        private: true
    - security_token:
        required: false
    - securityToken:
        default: ${get("security_token", "")}
        required: false
        private: true
    - date
    - headers:
        default: ''
        required: false
    - query_params:
        required: false
    - queryParams:
        default: ${get("query_params", "")}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-amazon:1.0.18'
    class_name: io.cloudslang.content.amazon.actions.signature.ComputeSignatureV4
    method_name: execute

  outputs:
    - signature
    - authorization_header: ${authorizationHeader}
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get("exception", "")}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE