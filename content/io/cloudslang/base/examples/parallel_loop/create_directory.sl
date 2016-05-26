####################################################
#!!
#! @description: Wrapper over the files/create_folder operation.
#!
#! @input directory_name: name of directory to be created
#! @output error_msg: error message
#!!#
####################################################

namespace: io.cloudslang.base.examples.parallel_loop

imports:
  files: io.cloudslang.base.files
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

    - create_directory:
        do:
          files.create_folder:
            - folder_name : ${directory_name}
        publish:
         - message

  outputs:
    - error_msg: ${'Failed to create directory with name ' + directory_name + ',error is ' + message}
