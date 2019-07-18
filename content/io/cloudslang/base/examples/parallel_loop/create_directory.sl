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
#! @description: Wrapper over the files/create_folder operation.
#!
#! @input directory_name: Name of directory to be created.
#!
#! @output error_msg: An error message in case something went wrong.
#!
#! @result SUCCESS: Directory created successfully.
#! @result FAILURE: Something went wrong.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.examples.parallel_loop

imports:
  files: io.cloudslang.base.filesystem
  print: io.cloudslang.base.print

flow:
  name: create_directory

  inputs:
    - directory_name

  workflow:
    - print_start:
       do:
          print.print_text:
            - text: ${'Creating directory ' + directory_name}
       navigate:
         - SUCCESS: create_directory

    - create_directory:
        do:
          files.create_folder:
            - folder_name : ${directory_name}
        publish:
         - message
        navigate:
         - SUCCESS: SUCCESS
         - FAILURE: FAILURE

  outputs:
    - error_msg: ${'Failed to create directory with name ' + directory_name + ',error is ' + message}
