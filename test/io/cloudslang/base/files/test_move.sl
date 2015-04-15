namespace: io.cloudslang.base.files

imports:
  files: io.cloudslang.base.files

flow:
  name: test_move
  inputs:
    - move_source
    - move_destination
  workflow:
    - test_move_operation:
        do:
          files.move:
            - source: move_source
            - destination: move_destination
    - move_back:
        do:
          files.move:
            - source: move_destination
            - destination: move_source
  results:
    - SUCCESS
    - FAILURE

