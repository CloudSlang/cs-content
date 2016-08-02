
####################################################
#!!
#! @description: Example of using a parallel loop.
#! The flow creates directories in a parallel loop.
#! @input base_dir_name: path of base name of created directories
#! @input num_of_directories: number of directories to create - Default: 10
#!!#
####################################################


namespace: io.cloudslang.base.examples.parallel_loop

imports:
  print: io.cloudslang.base.print
  examples: io.cloudslang.base.examples

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
        parallel_loop:
          for: suffix in range(1, num_of_directories + 1)
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
