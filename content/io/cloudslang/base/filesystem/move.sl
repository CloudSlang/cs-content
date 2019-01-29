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
#! @description: Moves a file or folder.
#!
#! @input source: Path of source file or folder to be moved.
#! @input destination: Path to move file or folder to.
#!
#! @output message: Error message in case of error.
#!
#! @result SUCCESS: File or folder was successfully moved.
#! @result FAILURE: File or folder was not moved due to an error.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.filesystem

operation:
  name: move
  
  inputs:
    - source
    - destination

  python_action:
    script: |
        import shutil, sys
        try:
          shutil.move(source,destination)
          message = ("moving done successfully")
          result = True
        except Exception as e:
          message = e
          result = False

  outputs:
    - message: ${ str(message) }

  results:
    - SUCCESS: ${result}
    - FAILURE
