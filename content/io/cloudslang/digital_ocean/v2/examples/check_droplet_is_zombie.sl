#   Copyright 2024 Open Text
#   This program and the accompanying materials
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
#!!
#! @description: Checks whether a droplet is considered a zombie.
#!
#! @input droplet_name: Name of the droplet.
#! @input creation_time_as_string: Creation time (UTC timezone) of the droplet as a string value.
#!                                 Format (used by DigitalOcean): '2015-09-27T18:47:19Z'
#! @input time_to_live: Threshold in minutes to compare the droplet's lifetime to.
#! @input name_pattern: Regex pattern for zombie droplet names.
#!                      Example: 'ci-([0-9]+)-coreos-([0-9]+)'
#!
#! @result ZOMBIE: Droplet is considered zombie.
#! @result NOT_ZOMBIE: Droplet is not considered zombie.
#! @result FAILURE: Error occurred.
#!!#
########################################################################################################################

namespace: io.cloudslang.digital_ocean.v2.examples

imports:
  utils: io.cloudslang.digital_ocean.v2.utils
  strings: io.cloudslang.base.strings

flow:
  name: check_droplet_is_zombie

  inputs:
    - droplet_name
    - creation_time_as_string
    - time_to_live
    - name_pattern

  workflow:
    - check_droplet_name:
        do:
          strings.match_regex:
            - text: ${droplet_name}
            - regex: ${name_pattern}
        navigate:
          - MATCH: check_droplet_lifetime
          - NO_MATCH: NOT_ZOMBIE

    - check_droplet_lifetime:
        do:
          utils.check_droplet_lifetime:
            - creation_time_as_string
            - threshold: ${time_to_live}
        navigate:
          - FAILURE: FAILURE
          - ABOVE_THRESHOLD: ZOMBIE
          - BELOW_THRESHOLD: NOT_ZOMBIE

  results:
    - ZOMBIE
    - NOT_ZOMBIE
    - FAILURE
