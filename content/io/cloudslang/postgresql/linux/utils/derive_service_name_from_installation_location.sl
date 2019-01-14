#   (c) Copyright 2019 Micro Focus, L.P.
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
#!!
#! @description: Derive the service name from home directory
#!
#! @input installation_location: installation_location
#!
#! @output service_name: service name
#!
#! @result SUCCESS: String is found at least once.
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.linux.utils

operation:
  name: derive_service_name_from_installation_location

  inputs:
    - installation_location:
        required: true

  python_action:
    script: |
       if installation_location.count('10') > 0:
         service_name = 'postgresql-10.service'
       elif installation_location.count('9.5') > 0:
         service_name = 'postgresql-95.service'
       else:
         service_name ='postgresql-96.service'
  outputs:
    - service_name
  results:
    - SUCCESS: true
