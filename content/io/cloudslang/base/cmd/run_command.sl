#   Copyright 2024 Open Text
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
#! @description: Runs a shell command locally.
#!
#! @input command: Command to run.
#! @input cwd: Current working directory.
#!            If cwd is not None, the child’s current directory will be changed to cwd before it is executed.
#!            Note that this directory is not considered when searching the executable,
#!            so you can’t specify the program’s path relative to cwd.
#! @input timeout: Time to wait in second for command to complete.
#!                 Default value: 1800
#! @output return_result: Output of the command.
#! @output error_message: error in case something went wrong.
#! @output return_code: 0 if command runs with success, -1 in case of failure.
#!
#! @result SUCCESS: The operation executed successfully and the 'return_code' is 0.
#! @result FAILURE: The operation could not be executed or the value of the 'return_code' is different than 0.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.cmd

operation:
  name: run_command

  inputs:
    - command
    - cwd:
        required: false
        default: null
    - timeout:
        default: '1800'
        required: false

  python_action:
    use_jython: false
    script: |-
      import os
      import subprocess
      def execute(command, cwd, timeout):
          return_code = 0
          cwd = os.getcwd() if cwd is None else cwd
          try:
              res = subprocess.Popen(command,cwd=cwd,stdout=subprocess.PIPE,stderr=subprocess.PIPE,shell=True);
              output,error = res.communicate(timeout=timeout)
              if output:
                  return {"return_result":output,"return_code":res.returncode}
              if error:
                  return {"error_message":error.strip(),"return_code":res.returncode}

          except Exception as e:
                  return {"error_message":e,"return_code":-1}
          

  outputs:
    - return_result
    - return_code: ${ str(return_code) }
    - error_message

  results:
    - SUCCESS: ${return_code == 0}
    - FAILURE
