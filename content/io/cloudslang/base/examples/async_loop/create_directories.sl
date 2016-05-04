
####################################################
#!!
#! @description: How Do I Asynch Loop Flow Example
#! The flow creates directories in asynch loop
#! @input base_dir_name: path of base name of created directories
#! @input num_of_directories: number of directories to create - Default: 10
#!!#
####################################################


namespace: io.cloudslang.base.examples.async_loop

imports:
  print: io.cloudslang.base.print

flow:
  name: create_directories

  inputs:
    - base_dir_name
    - num_of_directories:
        default: 10

  workflow:
    - print_start:
        do:
          print.print_text:
            - text: ${'Starting creating directories with base name ' + base_dir_name}

    - create_directories:
        async_loop:
          for: suffix in range(1, num_of_directories + 1)
          do:
            create_directory:
              - directory_name: ${base_dir_name + str(suffix)}
          publish:
            - error_msg
        aggregate:
          - errors:  ${filter(lambda x:'folder created' not in x, map(lambda x:str(x['error_msg']), branches_context))}

    - on_failure:
      - print_errors:
          loop:
            for: error in errors
            do:
              print.print_text:
                - text: ${error}
