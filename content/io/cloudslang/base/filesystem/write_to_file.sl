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
#! @description: Writes text to a file.
#!
#! @input file_path: Path of the file to write to.
#! @input text: Text to write to the file.
#!
#! @output message: Error message if error occurred.
#!
#! @result SUCCESS: Text was written to the file.
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.filesystem

operation:
  name: write_to_file

  inputs:
    - file_path
    - text

  python_action:
    script: |
      try:
        f = open(file_path, 'w')
        f.write(text)
        f.close()
        message = 'writing done successfully'
        res = True
      except IOError as e:
        message =  "ERROR: no such folder or permission denied: " + str(e)
        res = False
      except Exception as e:
        message =  e
        res = False

  outputs:
    - message

  results:
    - SUCCESS: ${res}
    - FAILURE
