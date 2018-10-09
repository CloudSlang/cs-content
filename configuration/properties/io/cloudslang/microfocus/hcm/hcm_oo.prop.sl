#   (c) Copyright 2018 Micro Focus, L.P.
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
namespace: io.cloudslang.microfocus.hcm
properties:
  - rest_uri: 'https://localhost:8444/csa/rest'
  - user: 'admin'
  - password:
      value: 'cloud'
      sensitive: true
  - auth_type:
      value: 'basic'
  - trust_all_roots:
      valuue: 'true'
  - x_509_hostname_verifier:
      value: 'allow_all'
  - trust_keystore
  - trust_password
  - keystore
  - keystore_password
  - connect_timeout:
      value: '10'
  - socket_timeout:
      value: '0'
  - use_cookies:
      value: 'true'
  - keep_alive:
      value: 'true'