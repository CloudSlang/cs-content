#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
####################################################
# This flow create a content pack which can be deployed in OO Central
#
# Inputs:
#   - cp_name - The content pack name (e.g. "base")
#   - cp_version - The content pack version (e.g. "0.1")
#   - cslang_folder - The cloud slang content folder to pack (e.g. "C:/cslang-cli/cslang/content/io/cloudslang/base")
#   - cp_publisher - The content pack publisher (e.g. "Customer")
#   - cp_location - The location for the content pack jar file (e.g. "c:/content_packs")
#   - cp_folder -  A temporary folder for the package. This folder is archived and deleted. There is no need to change this input value.
#
# Results:
#   - SUCCESS
#   - FAILURE
#
#
####################################################
namespace: io.cloudslang.operations_orchestration.createCP

imports:
  files: io.cloudslang.base.files

flow:
  name: create_package
  inputs:
    - cp_name: "base"
    - cp_version: "0.1"
    - cslang_folder: "C:/cslang-cli/cslang/content/io/cloudslang/base"
    - cp_publisher: "Customer"
    - cp_location: "c:/content_packs"
    - cp_folder: ${cp_location + "/" + cp_name + "-cp-" + cp_version}
  workflow:
    - create_Lib_folder:
        do:
          files.create_folder_tree:
            - folder_name: ${cp_folder + "/Lib"}
        navigate:
            SUCCESS: populate_Lib_folder
            FAILURE: CREATE_LIB_FOLDER_FAILURE
    - populate_Lib_folder:
        do:
          files.write_to_file:
            - file_path: ${cp_folder + "/Lib/placeHolder"}
            - text: " "
        navigate:
            SUCCESS: create_system_Properties_folder
            FAILURE: POPULATE_LIB_FOLDER_FAILURE
    - create_system_Properties_folder:
        do:
          files.create_folder_tree:
            - folder_name: ${cp_folder + "/Content/Configuration/System Properties"}
        navigate:
            SUCCESS: create_Library_Structure
            FAILURE: CREATE_SYSTEM_PROPERTIES_FAILURE
    - create_Library_Structure:
        do:
           files.create_folder_tree:
            - folder_name: ${cp_folder + "/Content/Library/Community/cslang/"}
        navigate:
            SUCCESS: copy_content
            FAILURE: CREATE_LIBRARY_STRUCTURE_FAILURE
    - copy_content:
        do:
          files.copy:
            - source: ${cslang_folder}
            - destination: ${cp_folder + "/Content/Library/Community/cslang/" + cp_name}
        navigate:
            SUCCESS: move_config_items
            FAILURE: COPY_CONTENT_FAILURE
    - move_config_items:
        do:
           copy_config_items:
            - source_dir: ${cp_folder + "/Content/Library/Community/cslang/" + cp_name}
            - target_dir: ${cp_folder + "/Content/Configuration/System Properties/"}
        navigate:
            SUCCESS: create_cp_properties
            FAILURE: MOVE_CONFIG_ITEMS_FAILURE
    - create_cp_properties:
        do:
           files.write_to_file:
             - file_path: ${cp_folder + "/contentpack.properties"}
             - text: ${"content.pack.name=" + cp_name + "\n" + "content.pack.version=" + cp_version + "\n" + "content.pack.description=" + cp_name + "\n" + "content.pack.publisher=" + cp_publisher}
        navigate:
            SUCCESS: create_archive
            FAILURE: CREATE_CP_PROPERTIES_FAILURE
    - create_archive:
        do:
           files.zip_folder:
             - folder_path: ${cp_folder}
             - archive_name: ${cp_name + "-cp-" + cp_version}
        navigate:
            SUCCESS: create_jar
            FAILURE: CREATE_ARCHIVE_FAILURE
    - create_jar:
        do:
           files.move:
             - source: ${cp_folder + "/" + cp_name + "-cp-" + cp_version + ".zip"}
             - destination: ${cp_location + "/" + cp_name + "-cp-" + cp_version + ".jar"}
        navigate:
            SUCCESS: clean_folder
            FAILURE: CREATE_JAR_FAILURE
    - clean_folder:
        do:
           files.delete:
             - source: ${cp_folder}
        navigate:
             SUCCESS: SUCCESS
             FAILURE: CLEAN_FOLDER_FAILURE
  results:
    - SUCCESS
    - CREATE_LIB_FOLDER_FAILURE
    - POPULATE_LIB_FOLDER_FAILURE
    - CREATE_SYSTEM_PROPERTIES_FAILURE
    - CREATE_LIBRARY_STRUCTURE_FAILURE
    - COPY_CONTENT_FAILURE
    - MOVE_CONFIG_ITEMS_FAILURE
    - CREATE_CP_PROPERTIES_FAILURE
    - CREATE_ARCHIVE_FAILURE
    - CREATE_JAR_FAILURE
    - CLEAN_FOLDER_FAILURE
