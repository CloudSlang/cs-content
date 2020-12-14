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
#! @description: Gets a list of files and folders that reside in a directory.
#!
#! @input source: The directory for which to get the children.
#! @input delimiter: A delimiter to put in between each child of the provided directory in the response.
#!
#! @output count: The total number of children of the provided directory.
#! @output return_result: The list of paths to each child of the provided directory in case of success
#!                        or an error message in case of failure.
#! @output return_code: 0 for success and -1 for failure.
#! @output exception: The exception's stack trace if operation failed. Empty otherwise.
#!
#! @result FAILURE: The operation failed.
#! @result SUCCESS: The directory's children retrieved successfully.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.filesystem

operation:
  name: get_children

  inputs:
    - source
    - delimiter

  java_action:
    gav: 'io.cloudslang.content:cs-filesystem:1.12.11-SNAPSHOT'
    class_name: io.cloudslang.content.filesystem.actions.GetChildrenAction
    method_name: execute

  outputs:
    - count: ${count}
    - return_result: ${returnResult}
    - return_code: ${returnCode}
    - exception: ${get('exception', '')}

  results:
    - SUCCESS: ${returnCode == '0'}
    - FAILURE