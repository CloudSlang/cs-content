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
#! @description: Example of using a parallel loop.
#!               The flow creates directories in a parallel loop.
#!
#! @input base_dir_name: Path of base name of created directories.
#! @input num_of_directories: Number of directories to create
#!                            Default: 10
#!
#! @result SUCCESS: Directories created successfully
#! @result FAILURE: Something went wrong
#!!#
########################################################################################################################


namespace: io.cloudslang.base.examples.parallel_loop

imports:
  print: io.cloudslang.base.print
  examples: io.cloudslang.base.examples

flow:
  name: create_directories

  inputs:
    - base_dir_name
    - num_of_directories:
        default: '10'

  workflow:
    - print_start:
        do:
          print.print_text:
            - text: ${'Starting creating directories with base name ' + base_dir_name}
        navigate:
          - SUCCESS: create_directories

    - create_directories:
        parallel_loop:
          for: suffix in range(1, int(num_of_directories) + 1)
          do:
            examples.parallel_loop.create_directory:
              - directory_name: ${base_dir_name + str(suffix)}
        publish:
          - errors:  ${filter(lambda x:'folder created' not in x, map(lambda x:str(x['error_msg']), branches_context))}

    - on_failure:
      - print_errors:
          loop:
            for: error in errors
            do:
              print.print_text:
                - text: ${error}
            break: []
