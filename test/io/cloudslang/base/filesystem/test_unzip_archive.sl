#   (c) Copyright 2022 Micro Focus, L.P.
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
#! @description: Workflow to test unzip operation.
#! @input path: path to the archive
#! @input out_folder: path of folder to place unzipped files from archive
#! @result SUCCESS: archive unziped successfully
#! @result ZIPFAILURE: ziping archive failed
#! @result UNZIPFAILURE: unziping operation failed
#! @result DELETEFAILURE: deleting archive failed
#!!#
####################################################
namespace: io.cloudslang.base.filesystem

imports:
  files: io.cloudslang.base.filesystem
  print: io.cloudslang.base.print

flow:
  name: test_unzip_archive
  inputs:
    - name
    - path
    - out_folder
  workflow:
    - prerquest_for_zip_creation:
        loop:
          for: f in [path + '/' + name + '.zip', path + '/' + name, name, name + '.zip', out_folder]
          do:
            files.delete:
              - source: ${f}
          break: []
        navigate:
          - SUCCESS: test_folder_creation
          - FAILURE: test_folder_creation

    - test_folder_creation:
        loop:
          for: folder in [path, out_folder]
          do:
            files.create_folder:
              - folder_name: ${folder}
          break: []
        navigate:
          - SUCCESS: test_file_creation
          - FAILURE: test_file_creation

    - test_file_creation:
        do:
          files.write_to_file:
            - file_path: ${path + '/test.txt'}
            - text: 'Workflow to test unzip operation'
        navigate:
          - SUCCESS: zip_folder
          - FAILURE: PREREQUESTFAILURE

    - zip_folder:
        do:
          files.zip_folder:
            - archive_name: ${name.split('.')[0]}
            - folder_path: ${path}
        navigate:
          - SUCCESS: unzip_folder
          - FAILURE: ZIPFAILURE

    - unzip_folder:
        do:
          files.unzip_archive:
            - archive_path: ${path + '/' + name}
            - output_folder: ${out_folder}
        publish:
            - unzip_message: ${message}
        navigate:
          - SUCCESS: delete_output_folder
          - FAILURE: UNZIPFAILURE

    - delete_output_folder:
        do:
          files.delete:
            - source: ${out_folder}
        navigate:
          - SUCCESS: delete_test_folder
          - FAILURE: DELETEFAILURE

    - delete_test_folder:
        do:
          files.delete:
            - source: ${path}
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: DELETEFAILURE

  outputs:
    - unzip_message

  results:
    - SUCCESS
    - ZIPFAILURE
    - PREREQUESTFAILURE
    - UNZIPFAILURE
    - DELETEFAILURE
