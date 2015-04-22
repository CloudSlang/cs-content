#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
namespace: io.cloudslang.base.utils

imports:
  utils: io.cloudslang.base.utils
  comparisons: io.cloudslang.base.comparisons

flow:
  name: test_random_number_generator
  inputs:
    - min
    - max
  workflow:
    - execute_random_number_generator:
        do:
          utils.random_number_generator:
            - min
            - max
        publish:
          - random_number
        navigate:
          SUCCESS: SUCCESS
          FAILURE: FAILURE
    - output_greater_than_min:
        do:
          comparisons.less_than_percentage:
            - first_percentage: min
            - second_percentage: number_generator
        navigate:
          LESS: OUTPUT_OUTSIDE_BOUNDS
          MORE: output_less_than_max
          FAILURE: COMPARISON_FAILURE
    - output_less_than_max:
        do:
          comparisons.less_than_percentage:
            - first_percentage: number_generator
            - second_percentage: max
        navigate:
          LESS: SUCCESS
          MORE: OUTPUT_OUTSIDE_BOUNDS
          FAILURE: COMPARISON_FAILURE

  results:
    - SUCCESS
    - FAILURE
    - OUTPUT_OUTSIDE_BOUNDS
    - COMPARISON_FAILURE