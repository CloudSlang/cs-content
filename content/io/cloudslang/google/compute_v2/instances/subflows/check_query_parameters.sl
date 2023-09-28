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
#! @description: This operation is used to form the query parameters string based on the provided inputs.
#!
#! @input filter: A filter expression that filters resources listed in the response. Most Compute resources support two
#!                types of filter expressions: expressions that support regular expressions and expressions that follow
#!                API improvement proposal AIP-160.
#!                If you want to use AIP-160, your expression must specify the field name, an operator, and the value
#!                that you want to use for filtering. The value must be a string, a number, or a boolean.
#!                The operator must be either =, !=, >, <, <=, >= or :.
#!                For example, if you are filtering Compute Engine instances, you can exclude instances named
#!                example-instance by specifying name != example-instance.
#!                The : operator can be used with string fields to match substrings. For non-string fields it is
#!                equivalent to the = operator. The :* comparison can be used to test whether a key has been defined.
#!                Optional
#! @input page_token: Specifies a page token to use. Set pageToken to the nextPageToken returned by a previous list
#!                    request to get the next page of results.
#!                    Optional
#! @input max_results: The maximum number of results per page that should be returned. If the number of available
#!                     results is larger than maxResults, Compute Engine returns a nextPageToken that can be used to get
#!                     the next page of results in subsequent list requests. Acceptable values are 0 to 500, inclusive.
#!                     Optional
#! @input order_by: Sorts list results by a certain order. By default, results are returned in alphanumerical order
#!                  based on the resource name.
#!                  You can also sort results in descending order based on the creation timestamp using
#!                  orderBy="creationTimestamp desc". This sorts results based on the creationTimestamp field in reverse
#!                  chronological order (newest result first). Use this to sort resources like operations so that the
#!                  newest operation is returned first.
#!                  Currently, only sorting by name or creationTimestamp desc is supported.
#!                  Optional
#!
#! @output return_result: The query parameters string.
#! @output return_code: '0' if operation was successfully executed, '-1' otherwise.
#!
#! @result SUCCESS: The query parameters string formed successfully.
#!!#
########################################################################################################################
namespace: io.cloudslang.google.compute_v2.instances.subflows
operation:
  name: check_query_parameters
  inputs:
    - filter:
        required: false
    - max_results:
        required: false
    - page_token:
        required: false
    - order_by:
        required: false
  python_action:
    use_jython: false
    script: "# do not remove the execute function\r\ndef execute(filter,max_results,page_token,order_by):\r\n    return_code = 0\r\n    return_result = ''\r\n    query_params = ''\r\n        \r\n    if (filter == '' and max_results == '' and page_token == '' and order_by == ''):\r\n        return_code =-1\r\n        return_result = query_params\r\n    else:\r\n        if filter != '':\r\n            return_result = 'filter='+filter\r\n    if max_results != '':\r\n        if return_result != '':\r\n            return_result = return_result+'&maxResults='+max_results\r\n        else:\r\n            return_result = 'maxResults='+max_results\r\n    if page_token != '':\r\n        if return_result != '':\r\n            return_result = return_result+'&pageToken='+page_token\r\n        else:\r\n            return_result = 'pageToken='+page_token\r\n    if order_by != '':\r\n        if return_result != '':\r\n            return_result = return_result+'&orderBy='+order_by\r\n        else:\r\n            return_result = 'orderBy='+order_by\r\n    return{\"return_code\": return_code, \"return_result\": return_result}"
  outputs:
    - return_result
    - return_code
  results:
    - SUCCESS
