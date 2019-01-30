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
#! @description: Creates a folder.
#!
#! @input folder_name: Name of folder to be created.
#!                     Example:
#!                     'c:/path1/path2/folder_name' will create the folder in the full path provided
#!                     '%AppData%/folder_name' will create the folder in the environment variable provided
#!                     'folder_name' will create the folder in %CENTRAL_HOME%/bin, %CLI_HOME%/bin
#!                     Note: When creating a folder, there is a difference between Windows and Linux,
#!                     regarding illegal characters: "<>:"/\|?*". While Windows is more restrictive and
#!                     does not allow creating folders with these illegal characters, Linux allows most of them.
#!                     Example of Windows illegal folder: "<>:"/\|?*"
#!                     Example of Linux illegal folder: "\0" - null character
#!                     Do not use the following reserved names for the name of a file (for Windows):
#!                     CON, PRN, AUX, NUL, COM1, COM2, COM3, COM4, COM5, COM6, COM7, COM8,
#!                     COM9, LPT1, LPT2, LPT3, LPT4, LPT5, LPT6, LPT7, LPT8, and LPT9
#!
#! @output message: Error message in case of an error.
#!
#! @result SUCCESS: Folder was successfully created.
#! @result FAILURE: Folder was not created due to an error.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.filesystem

operation:
  name: create_folder

  inputs:
    - folder_name

  python_action:
    script: |
        import os
        message = None
        result = None
        try:
          if os.path.exists(os.path.expandvars(folder_name)):
            message = ("folder already exists")
            result = False
          else:
            os.makedirs(os.path.expandvars(folder_name))
            message = ("folder created")
            result = True
        except Exception as e:
          message = e
          result = False

  outputs:
    - message

  results:
    - SUCCESS: ${result == True}
    - FAILURE
