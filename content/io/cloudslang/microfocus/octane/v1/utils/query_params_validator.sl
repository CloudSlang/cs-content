########################################################################################################################
#!!
#!   (c) Copyright 2022 Micro Focus, L.P.
#!   All rights reserved. This program and the accompanying materials
#!   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#!
#!   The Apache License is available at
#!   http://www.apache.org/licenses/LICENSE-2.0
#!
#!   Unless required by applicable law or agreed to in writing, software
#!   distributed under the License is distributed on an "AS IS" BASIS,
#!   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#!   See the License for the specific language governing permissions and
#!   limitations under the License.
#!!#
########################################################################################################################
namespace: io.cloudslang.microfocus.octane.v1.utils
operation:
  name: query_params_validator
  inputs:
    - limit:
        required: false
    - offset:
        required: false
    - total_count:
        required: false
    - order_by:
        required: false
  python_action:
    use_jython: false
    script: "def execute(limit, offset, total_count, order_by):\n    query_params = \"\"\n    return_code = 0\n    error_message = \"\"\n    \n    try:\n        \n        if limit and query_params:\n            query_params = query_params + \"&limit=\" + limit\n        elif limit and not query_params:\n            query_params = \"limit=\" + limit\n    \n        if offset and query_params:\n            query_params = query_params + \"&offset=\" + offset\n        elif offset and not query_params:\n            query_params = \"offset=\" + offset\n    \n        if total_count and query_params:\n            query_params = query_params + \"&total_count=\" + total_count\n        elif total_count and not query_params:\n            query_params = \"total_count=\" + total_count\n        \n        if order_by and query_params:\n            query_params = query_params + \"&order_by=\" + order_by\n        elif order_by and not query_params:\n            query_params = \"order_by=\" + order_by\n\n    except Exception as e:\n        return_code = 1\n        error_message = str(e)\n        \n    return {\"query_params\": query_params, \"return_code\":return_code, \"error_message\":error_message}"
  outputs:
    - query_params
    - return_code
    - error_message
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
