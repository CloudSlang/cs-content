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
#! @description: Performs a search in the response_headers to get the specified header value.
#!
#! @input response_headers: Response headers string from an HTTP Client REST call.
#! @input header_name: Name of header to get value for.
#!
#! @output result: Specified header value in case of success, error message otherwise.
#! @output error_message: Exception if occurs.
#!
#! @result SUCCESS: Retrieved specified header value.
#! @result FAILURE: There was an error retrieving header value.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.http

operation:
  name: get_header_value

  inputs:
    - response_headers
    - header_name

  python_action:
    script: |
      result = ''
      error_message = ''
      try:
        begin_index = response_headers.find(header_name + ':')
        if begin_index != -1:
          response_headers = response_headers[begin_index + len(header_name) + 2:]
          result = response_headers.split(' ')[0]
        else:
          error_message = 'Could not find specified header: ' + header_name
          result = error_message
      except Exception as exception:
        error_message = exception

  outputs:
    - result
    - error_message

  results:
    - SUCCESS: ${error_message == ''}
    - FAILURE
