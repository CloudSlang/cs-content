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
#! @description: Check if the list contains ints or strings.
#!
#! @input list: List to check.
#!              Example: "el1,el2"
#! @input delimiter: The list delimiter.
#!
#! @output result: Message indicating whether the list contains int or string elements.
#! @output error_message: List contains int and strings.
#!
#! @result SUCCESS: All elements in the list are ints or strings.
#! @result FAILURE: List contains both ints and string elements.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.lists

operation:
  name: check_list_type

  inputs:
    - list
    - delimiter:
        required: false
        default: ','

  python_action:
    script: |
      def representsInt(s):
          try:
              int(s)
              return True
          except ValueError:
              return False

      error_message = ""
      message = ""
      list = list.split(delimiter)
      if all(representsInt(item) for item in list):
        message = "All elements in list are INT"
      elif any(representsInt(item) for item in list):
        error_message = "List contains STR and INT elements"
      else:
        message = "All elements in list are STR"

  outputs:
    - result: ${message}
    - error_message

  results:
    - SUCCESS: ${error_message == ""}
    - FAILURE
