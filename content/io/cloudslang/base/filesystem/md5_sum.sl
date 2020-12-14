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
#! @description: Calculates a checksum for a file and compares it to a given checksum.
#!
#! @input source: The file for which to create the checksum.
#! @input compare_to: A checksum to compare the file's checksum to.
#!
#! @output checksum: The file's calculated checksum.
#! @output return_result: The result of the comparison between the file's size and the compare_to, if the operation succeeded.
#!                        Otherwise it will contain the exception message.
#! @output return_code: It is -1 for failure, 1 if the checksum matched the specified checksum
#!                      and 0 if checksum did not match the specified checksum.
#! @output exception: The exception's stack trace if operation failed. Empty otherwise.
#!
#! @result FAILURE: The operation failed.
#! @result NOT_EQUAL: The file's checksum was calculated, but did not match the specified checksum.
#! @result EQUAL_TO: The files checksum matched the specified checksum.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.filesystem

operation:
  name: md5_sum

  inputs:
    - source
    - compare_to
    - compareTo:
        default: ${get("compare_to", "")}
        required: false
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-filesystem:1.1.1-SNAPSHOT'
    class_name: io.cloudslang.content.filesystem.actions.MD5SumAction
    method_name: execute

  outputs:
    - checksum: ${checksum}
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get('exception', '')}

  results:
    - NOT_EQUAL: ${returnCode == '0'}
    - EQUAL_TO: ${returnCode == '1'}
    - FAILURE