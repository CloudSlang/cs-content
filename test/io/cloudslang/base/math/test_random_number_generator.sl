#   (c) Copyright 2014-2017 EntIT Software LLC, a Micro Focus company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
########################################################################################################################
namespace: io.cloudslang.base.math

imports:
  math: io.cloudslang.base.math
  comparisons: io.cloudslang.base.comparisons

flow:
  name: test_random_number_generator

  inputs:
    - min
    - max

  workflow:
    - execute_random_number_generator:
        do:
          math.random_number_generator:
            - min
            - max
        publish:
          - random_number
        navigate:
          - SUCCESS: output_greater_than_min
          - FAILURE: FAILURE

    - output_greater_than_min:
        do:
          comparisons.less_than_percentage:
            - first_percentage: ${ str(int(min) - 1) }
            - second_percentage: ${ str(random_number) }
        navigate:
          - LESS: output_less_than_max
          - MORE: OUTPUT_OUTSIDE_BOUNDS
          - FAILURE: COMPARISON_FAILURE
    - output_less_than_max:
        do:
          comparisons.less_than_percentage:
            - first_percentage: ${ str(random_number) }
            - second_percentage: ${ str(int(max) + 1) }
        navigate:
          - LESS: SUCCESS
          - MORE: OUTPUT_OUTSIDE_BOUNDS
          - FAILURE: COMPARISON_FAILURE

  results:
    - SUCCESS
    - FAILURE
    - OUTPUT_OUTSIDE_BOUNDS
    - COMPARISON_FAILURE
