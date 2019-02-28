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
#! @description: Decodes an URL.
#!
#! @input url: URL string to decode.
#! @input param: Parameter to extract.
#!
#! @output return_result: Decoded URL string.
#! @output return_code: 0 if command runs with success, -1 in case of failure.
#!
#! @result SUCCESS: The operation executed successfully and the 'return_code' is 0.
#! @result FAILURE: The operation could not be executed or the value of the 'return_code' is different than 0.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.http

operation:
  name: url_decoder

  inputs:
    - url
    - param:
        default: ''
        required: false

  python_action:
    script: |
      try:
        import urllib
        from urlparse import urlparse
        from urlparse import parse_qs
        url = urllib.unquote(url).decode('utf8')
        res = urlparse(url)
        query = parse_qs(res.query)
        if param in query.keys():
          query_param = query[param]
          if len(query_param) > 0:
            return_result = str(query_param[0])
            return_code = 0
        elif param == '':
          return_result = str(urllib.unquote(url).decode('utf8'))
          return_code = 0
        else:
          return_result = '"' + param + '" is not present or does not have any value in the url' + "'" + 's query params : "' + url + '"'
          return_code = -1
      except Exception as e:
        return_result = e
        return_code = -1

  outputs:
    - return_result
    - return_code: ${ str(return_code) }

  results:
    - SUCCESS: ${return_code == 0}
    - FAILURE
