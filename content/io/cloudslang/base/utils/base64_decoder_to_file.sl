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
#! @description: This operation convert bytes to a file using a given file path.
#!
#! @input file_path: The absolute path with file name and extension that will be converted
#! @input content_bytes: The representation in bytes of the file that will be decoded
#!
#! @output return_result: The path of the decoded file or error message in case of failure.
#! @output return_code: 0 the query succeeded, -1 otherwise.
#! @output exception: An error message in case there was an error while decoding the file.
#! @output return_path: The path to the decoded file.
#!
#! @result SUCCESS: Operation completed successfully.
#! @result FAILURE: Operation failed.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.utils

operation:
  name: base64_decoder_to_file

  inputs:
    - file_path
    - filePath:
        default: ${get('file_path', '')}
        required: true
        private: true
    - content_bytes
    - contentBytes:
        default: ${get('content_bytes', '')}
        required: true
        private: true

  java_action:
    gav: 'io.cloudslang.content:cs-utilities:0.1.24-RC2'
    class_name: io.cloudslang.content.utilities.actions.Base64DecoderToFile
    method_name: execute

  outputs:
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - return_path: ${returnPath}
    - exception

  results:
    - SUCCESS: ${ returnCode == '0'}
    - FAILURE
