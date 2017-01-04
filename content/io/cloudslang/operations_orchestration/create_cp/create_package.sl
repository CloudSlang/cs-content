#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Creates a content pack from a CloudSlang content folder which can be deployed in OO Central.
#!
#! @input cp_name: Content pack name.
#!                 Example: "base"
#! @input cp_version: Content pack version.
#!                    Example: "0.1"
#! @input cslang_folder: CloudSlang content folder to pack.
#!                       Example: "C:/cslang-cli/cslang/content/io/cloudslang/base"
#! @input cp_publisher: Content pack publisher.
#!                      Example: "Customer"
#! @input cp_location: Location for the content pack jar file.
#!                     Example: "c:/content_packs"
#! @input cp_folder: Optional - Temporary folder for the package.
#!                   Default: <cp_location>/<cp_name>-cp-<cp_version>
#!
#! @result SUCCESS: Content pack created successfully.
#! @result CREATE_LIB_FOLDER_FAILURE: There was an error while creating the LIB folder.
#! @result POPULATE_LIB_FOLDER_FAILURE: There was an error while trying to populate the LIB folder.
#! @result CREATE_SYSTEM_PROPERTIES_FAILURE: There was an error while trying to create the system properties file.
#! @result CREATE_LIBRARY_STRUCTURE_FAILURE: There was an error while trying to create the library structure.
#! @result COPY_CONTENT_FAILURE: There was an error while trying to copy content.
#! @result MOVE_CONFIG_ITEMS_FAILURE: There was en error while trying to move the configuration items.
#! @result CREATE_CP_PROPERTIES_FAILURE: There was an error while trying to create CP properties.
#! @result CREATE_ARCHIVE_FAILURE: There was an error while trying to create the archive.
#! @result CREATE_JAR_FAILURE: There was an error while trying to create the JAR file.
#! @result CLEAN_FOLDER_FAILURE: There was an error while cleaning up the folder.
#!!#
########################################################################################################################

namespace: io.cloudslang.operations_orchestration.create_cp

imports:
  create_cp: io.cloudslang.operations_orchestration.create_cp
  files: io.cloudslang.base.filesystem

flow:
  name: create_package

  inputs:
    - cp_name
    - cp_version
    - cslang_folder
    - cp_publisher
    - cp_location
    - cp_folder: ${cp_location + "/" + cp_name + "-cp-" + cp_version}

  workflow:
    - create_Lib_folder:
        do:
          files.create_folder_tree:
            - folder_name: ${cp_folder + "/Lib"}
        navigate:
            - SUCCESS: populate_Lib_folder
            - FAILURE: CREATE_LIB_FOLDER_FAILURE

    - populate_Lib_folder:
        do:
          files.write_to_file:
            - file_path: ${cp_folder + "/Lib/placeHolder"}
            - text: " "
        navigate:
            - SUCCESS: create_system_Properties_folder
            - FAILURE: POPULATE_LIB_FOLDER_FAILURE

    - create_system_Properties_folder:
        do:
          files.create_folder_tree:
            - folder_name: ${cp_folder + "/Content/Configuration/System Properties"}
        navigate:
            - SUCCESS: create_Library_Structure
            - FAILURE: CREATE_SYSTEM_PROPERTIES_FAILURE

    - create_Library_Structure:
        do:
           files.create_folder_tree:
            - folder_name: ${cp_folder + "/Content/Library/Community/cslang/"}
        navigate:
            - SUCCESS: copy_content
            - FAILURE: CREATE_LIBRARY_STRUCTURE_FAILURE

    - copy_content:
        do:
          files.copy:
            - source: ${cslang_folder}
            - destination: ${cp_folder + "/Content/Library/Community/cslang/" + cp_name}
        navigate:
            - SUCCESS: move_config_items
            - FAILURE: COPY_CONTENT_FAILURE

    - move_config_items:
        do:
           create_cp.copy_config_items:
            - source_dir: ${cp_folder + "/Content/Library/Community/cslang/" + cp_name}
            - target_dir: ${cp_folder + "/Content/Configuration/System Properties/"}
        navigate:
            - SUCCESS: create_cp_properties

    - create_cp_properties:
        do:
           files.write_to_file:
             - file_path: ${cp_folder + "/contentpack.properties"}
             - text: >
                 ${"content.pack.name=" + cp_name + "\n" + "content.pack.version=" + cp_version + "\n" +
                 "content.pack.description=" + cp_name + "\n" + "content.pack.publisher=" + cp_publisher}
        navigate:
            - SUCCESS: create_archive
            - FAILURE: CREATE_CP_PROPERTIES_FAILURE

    - create_archive:
        do:
           files.zip_folder:
             - folder_path: ${cp_folder}
             - archive_name: ${cp_name + "-cp-" + cp_version}
        navigate:
            - SUCCESS: create_jar
            - FAILURE: CREATE_ARCHIVE_FAILURE

    - create_jar:
        do:
           files.move:
             - source: ${cp_folder + "/" + cp_name + "-cp-" + cp_version + ".zip"}
             - destination: ${cp_location + "/" + cp_name + "-cp-" + cp_version + ".jar"}
        navigate:
            - SUCCESS: clean_folder
            - FAILURE: CREATE_JAR_FAILURE

    - clean_folder:
        do:
           files.delete:
             - source: ${cp_folder}
        navigate:
             - SUCCESS: SUCCESS
             - FAILURE: CLEAN_FOLDER_FAILURE

  results:
    - SUCCESS
    - CREATE_LIB_FOLDER_FAILURE
    - POPULATE_LIB_FOLDER_FAILURE
    - CREATE_SYSTEM_PROPERTIES_FAILURE
    - CREATE_LIBRARY_STRUCTURE_FAILURE
    - COPY_CONTENT_FAILURE
    - CREATE_CP_PROPERTIES_FAILURE
    - CREATE_ARCHIVE_FAILURE
    - CREATE_JAR_FAILURE
    - CLEAN_FOLDER_FAILURE
