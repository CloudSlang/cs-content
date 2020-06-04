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
#! @description: Converts each item in a list to a string and concatenates them.
#!
#! @input list: List of items that will be converted to string and concatenated.
#!              Example: 1,2,3,a,b,c -> 123abc
#! @input delimiter: Optional - The list delimiter.
#!                   Default: ','
#! @input strip_whitespaces: Optional - Removes whitespace both leading and trailing an list item.
#!                           Default: True
#! @input double_quotes: Optional - If true, list items will be double quoted.
#!                       Default: False
#! @input result_delimiter: Optional - If true, will be appended after every list item (except the last one).
#!                          Default: ""
#! @input result_to_lowercase: Optional - If true, list items will be lower cased.
#!                             Default: False
#!
#! @output result: String that results from concatenation of list elements
#! @output error_message: Error message if error occurred
#! @output return_code: 0 if success, -1 if failure
#!
#! @result SUCCESS: List converted to string successfully.
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.lists

operation:
  name: convert_list_to_string

  inputs:
    - list
    - double_quotes:
        default: "False"
        required: false
    - delimiter:
        default: ','
        required: false
    - strip_whitespaces:
        default: "True"
        required: false
    - result_delimiter:
        default: ''
        required: false
    - result_to_lowercase:
        default: "False"
        required: false

  python_action:
    script: |
      def validBool(element):
          if str(element).lower() == "false": return ""
          if str(element).lower() == "true": return "true"
          return "error"

      result = ''
      error_message = ''
      return_code = '0'
      try:
          if list.startswith('[') is True and list.endswith(']') is True:
              list = list[1:len(list) - 1]
          list = list.split(delimiter)
          result_to_lowercase = validBool(result_to_lowercase)
          double_quotes = validBool(double_quotes)
          strip_whitespaces = validBool(strip_whitespaces)
          if double_quotes == "error" or result_to_lowercase == "error" or strip_whitespaces == "error":
              raise TypeError("Invalid boolean input!")
          else:
              list_length = len(list)
              for item in list:
                  if strip_whitespaces.lower() == "true":
                      item = item.strip(' ')
                  if bool(double_quotes):
                      result += '\"' + item + '\"'
                  else:
                      result += item
                  list_length -= 1
                  if list_length > 0 and result_delimiter != '':
                      result += result_delimiter
              if bool(result_to_lowercase):
                  result = result.lower()
      except BaseException as error:
          return_code = '-1'
          result = str(error)
          error_message = str(error)

  outputs:
    - result
    - error_message
    - return_code

  results:
    - SUCCESS: ${error_message == ""}
    - FAILURE