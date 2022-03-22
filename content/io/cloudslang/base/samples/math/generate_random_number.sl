########################################################################################################################
#!!
#! @description: This is a sample flow that demonstrates how to generate a random number using the random_number_generator operation from the math folder.
#!
#! @input min: The minimum number that can be generated.
#! @input max: The maximum number that can be generated.
#!
#! @output return_result: Random number between min and max (inclusive).
#! @output exception: The exception's stack trace if operation failed. Empty otherwise.
#!!#
########################################################################################################################
namespace: io.cloudslang.base.samples.math
flow:
  name: generate_random_number
  inputs:
    - min:
        default: '1'
    - max:
        default: '20'
  workflow:
    - random_number_generator:
        do:
          io.cloudslang.base.math.random_number_generator:
            - min: '${min}'
            - max: '${max}'
        publish:
          - return_result: '${random_number}'
          - exception: '${error_message}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result: '${return_result}'
    - exception: '${exception}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      random_number_generator:
        x: 100
        'y': 150
        navigate:
          bb226689-6842-9929-9082-c24a250b8ae2:
            targetId: 24a2e6ee-da8e-af43-556e-2d8a8427bf09
            port: SUCCESS
    results:
      SUCCESS:
        24a2e6ee-da8e-af43-556e-2d8a8427bf09:
          x: 400
          'y': 150
