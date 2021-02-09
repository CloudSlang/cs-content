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
#! @description: Adds two numbers as floating point values.
#!
#! @input value: First value as number or string.
#!
#! @output exception: Operation result or reason for failure.
#! @output return_code: Operation return code ('0' or '-1').
#!
#! @result SUCCESS: The operation completed successfully.
#! @result FAILURE: The operation failed.
#!!#
########################################################################################################################



namespace: io.cloudslang.base.math



operation:
  name: add_numbers
  inputs:
  - value
  python_action:
    use_jython: false
    script: "# do not remove the execute function \ndef execute(value): \n    x = int(value)\n    if x > 5:\n        return{\"return_code\":\"1\", \"exception\":'x should not exceed 5.'}\n    else:\n        return{\"return_code\":\"0\"}\n# you can add additional helper methods below."
  outputs:
  - return_code
  - exception
  results:
  - SUCCESS: '${return_code==0}'
  - FAILURE