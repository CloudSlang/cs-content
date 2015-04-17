#   (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Checks if all_images_list and used_images_list are empty
#
# Inputs:
#   - all_images_list - all Docker images
#   - used_images_list - images that are used by containers
# Results:
#   - USED_EMPTY - used_images_list is empty
#   - BOTH_EMPTY - both lists are empty
#   - NONE_EMPTY - neither of the lists are not empty
####################################################

namespace: io.cloudslang.docker.utils

imports:
 base_strings: io.cloudslang.base.strings

flow:
  name: check_lists
  inputs:
    - all_images_list
    - used_images_list
  workflow:
      - check_all_images:
          do:
            base_strings.string_equals:
              - first_string: all_images_list
              - second_string: "''"
          navigate:
            SUCCESS: BOTH_EMPTY
            FAILURE: check_used_images
      - check_used_images:
          do:
            base_strings.string_equals:
              - first_string: used_images_list
              - second_string: "''"
          navigate:
            SUCCESS: USED_EMPTY
            FAILURE: NONE_EMPTY

  results:
    - BOTH_EMPTY
    - USED_EMPTY
    - NONE_EMPTY