####################################################
#!!
#! @description: Flow_description
#!
#! @input input_name: input_description
#!                    input_description
#! @input input_name: input_description
#! @output output_name: output_description
#! @result result_name: result_description
#!!#
####################################################

namespace: io.cloudslang.base.examples.asyncLoop

imports:
  base: io.cloudslang.base
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

    - create-directory:
        do:
          files.create_folder:
            - folder_name : ${directory_name}

        publish:
         - message

  outputs:
    - error_msg: ${'Failed to create directory with name ' + directory_name + ',error is ' + message}
