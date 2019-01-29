#   (c) Copyright 2019 EntIT Software LLC, a Micro Focus company, L.P.
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
#! @description: Verifies if a variable provided as input is null or not.
#!
#! @input variable: the variable to check.
#!
#! @result IS_NULL: the variable is NONE.
#! @result IS_NOT_NULL: the variable is not NONE.
#!!#
########################################################################################################################
namespace: io.cloudslang.base.utils

decision:
  name: is_null

  inputs:
    - variable:
        required: false

  results:
    - IS_NULL: ${variable is None}
    - IS_NOT_NULL
