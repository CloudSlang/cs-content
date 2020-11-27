#   (c) Copyright 2020 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: Compares a file's size to a given threshold.
#!
#! @input source: The file to read. It must be an absolute path.
#! @input threshold: The threshold to compare the file size to (in bytes).
#!
#! @output size: The file's size in bytes.
#! @output return_result: The file's size in bytes if operation succeeded. Otherwise it will contain the message of the exception.
#! @output return_code: 0 if operation succeeded, -1 otherwise.
#! @output exception: The exception's stack trace if operation failed. Empty otherwise.
#!
#! @result FAILURE: The operation failed.
#! @result LESS_THAN: File's size is smaller than the threshold.
#! @result EQUAL_TO: File's size is the same as the threshold.
#! @result GREATER_THAN: File's size is the greater than the threshold.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.filesystem

operation:
  name: get_size
  
  inputs:
    - source
    - threshold

  java_action:
    gav: 'io.cloudslang.content:cs-filesystem:0.0.1-RC2'
    class_name: io.cloudslang.content.filesystem.actions.GetSizeAction
    method_name: execute

  outputs:
    - size: ${size}
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get('exception', '')}

  results:
    - FAILURE: ${returnCode == '-1'}
    - GREATER_THAN: ${size > threshold}
    - EQUAL_TO: ${size == threshold}
    - LESS_THAN