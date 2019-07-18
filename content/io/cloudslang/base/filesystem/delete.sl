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
#! @description: Deletes a file or folder.
#!
#! @input source: Path of source file or folder to be deleted.
#!
#! @output message: Error message in case of error.
#!
#! @result SUCCESS: File or folder was successfully deleted.
#! @result FAILURE: File or folder was not deleted due to error.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.filesystem

operation:
  name: delete
  
  inputs:
    - source

  python_action:
    script: |
        import shutil, sys, os
        try:
          if os.path.isfile(source):
            os.remove(source)
            message = source + " was removed"
            result = True
          elif os.path.isdir(source):
            shutil.rmtree(source)
            message = source + " was removed"
            result = True
          else:
            message = "No such file or folder"
            result = False
        except Exception as e:
          message = e
          result = False

  outputs:
    - message

  results:
    - SUCCESS: ${result}
    - FAILURE
