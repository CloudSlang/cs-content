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
########################################################################################################################
#!!
#! @description: Substring of a string from begin_index to end_index.
#!
#! @input origin_string: Origin string.
#!                       Example: 'good morning'
#! @input begin_index: Position in string from which we want to cut.
#!                     Example: 0 (the first index = 0)
#! @input end_index: Position in string to which we want to cut.
#!                   Example: 4 (new string will not include end_index)
#!
#! @output new_string: New string.
#!                     Example: 'good'
#! @output error_message: Something went wrong.
#!
#! @result SUCCESS: If error_message is empty and new_string returns a value.
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

 namespace: io.cloudslang.base.strings

 operation:
   name: substring

   inputs:
     - origin_string
     - begin_index:
        default: '0'
     - end_index:
         default: '0'

   python_action:
     script: |
        error_message = ""
        try:
           word_length = len(origin_string)
           begin_index = int(begin_index)
           end_index = int(end_index)
           if end_index == 0:
              new_string = origin_string[begin_index:]
           elif end_index < 0 or begin_index < 0:
              error_message = "Indexes must be positive integers"
           elif begin_index >= word_length or end_index > word_length:
              error_message = "Indexes must be - begin_index < " + str(word_length) + ", end_index <= " + str(word_length)
           elif end_index < begin_index:
              error_message = "Indexes must be - end_index > begin_index"
           else:
              new_string = origin_string[begin_index : end_index]
        except (ValueError, TypeError, NameError):
           error_message = "Invalid values"

   outputs:
      - new_string
      - error_message

   results:
      - SUCCESS: ${error_message=='' and new_string != ''}
      - FAILURE
