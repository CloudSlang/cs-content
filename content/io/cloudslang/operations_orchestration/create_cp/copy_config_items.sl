#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Copies YAML configuration files to the system properties folder.
#!
#! @input source_dir: Path of source directory.
#! @input target_dir: Path of target directory.
#!
#! @result SUCCESS: Configuration files successfully copied to the system properties folder.
#! @result FAILURE: There was an error while trying to copy the configuration files.
#!!#
########################################################################################################################

namespace: io.cloudslang.operations_orchestration.create_cp

operation:
  name: copy_config_items

  inputs:
    - source_dir
    - target_dir

  python_action:
    script: |
          import shutil
          import os
          for subdir, dirs, files in os.walk(source_dir):
              for file in files:
                  filepath = subdir + os.sep + file

                  if filepath.endswith(".yaml"):
                      shutil.move(filepath, target_dir+file)

  results:
    - SUCCESS
