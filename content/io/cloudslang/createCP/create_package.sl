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
namespace: io.cloudslang.createCP

imports:
 base_files: io.cloudslang.base.files

flow:
  name: create_package
  inputs:
    - cp_name:
        default: "base"
        overridable: true
    - cp_version:
        default: "0.1"
        overridable: true
    - cslang_folder:
        default: "C:/cslang-cli/cslang/content/io/cloudslang/base"
        overridable: true
    - cp_publisher:
        default: "Customer"
        overridable: true
    - cp_location:
        default: "c:/content_packs"
        overridable: true
    - cp_folder: ${cp_location + "/" + cp_name + "-cp-" + cp_version}
  workflow:
    - create_Lib_folder:
        do:
          create_folder_tree:
            - folder_name: ${cp_folder + "/Lib"}
        publish:
            - SUCCESS
            - FAILURE
    - populate_Lib_folder:
        do:
          base_files.write_to_file:
            - file_path: ${cp_folder + "/Lib/placeHolder"}
            - text: " "
        publish:
            - SUCCESS
            - FAILURE
    - create_system_Properties_folder:
        do:
          create_folder_tree:
            - folder_name: ${cp_folder + "/Content/Configuration/System Properties"}
        publish:
            - SUCCESS
            - FAILURE
    - create_Library_Structure:
        do:
           create_folder_tree:
            - folder_name: ${cp_folder + "/Content/Library/Community/cslang/"}
        publish:
            - SUCCESS
            - FAILURE
    - copy_content:
        do:
          base_files.copy:
            - source: ${cslang_folder}
            - destination: ${cp_folder + "/Content/Library/Community/cslang/" + cp_name}
        publish:
            - SUCCESS
            - FAILURE
    - move_config_items:
        do:
           copy_config_items:
            - source_dir: ${cp_folder + "/Content/Library/Community/cslang/" + cp_name}
            - target_dir: ${cp_folder + "/Content/Configuration/System Properties/"}
        publish:
             - SUCCESS
             - FAILURE
    - create_cp_properties:
        do:
           base_files.write_to_file:
             - file_path: ${cp_folder + "/contentpack.properties"}
             - text: ${"content.pack.name=" + cp_name + "\n" + "content.pack.version=" + cp_version + "\n" + "content.pack.description=" + cp_name + "\n" + "content.pack.publisher=" + cp_publisher}
        publish:
             - SUCCESS
             - FAILURE
    - create_archive:
        do:
           base_files.zip_folder:
             - folder_path: ${cp_folder}
             - archive_name: ${cp_name + "-cp-" + cp_version}
        publish:
             - SUCCESS
             - FAILURE
    - create_jar:
        do:
           base_files.move:
             - source: ${cp_folder + "/" + cp_name + "-cp-" + cp_version + ".zip"}
             - destination: ${cp_location + "/" + cp_name + "-cp-" + cp_version + ".jar"}
        publish:
             - SUCCESS
             - FAILURE
    - clean_folder:
        do:
           base_files.delete:
             - source: ${cp_folder}
        publish:
             - SUCCESS
             - FAILURE
