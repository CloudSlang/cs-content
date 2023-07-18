#   Copyright 2023 Open Text
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
#! @description: Retrieves the image ID from the response of the list_images operation of a given image by name.
#!
#! @input image_body: response of list_images operation
#! @input image_name: image name
#!
#! @output image_id: ID of specified image
#! @output return_result: was parsing was successful or not
#! @output return_code: '0' if success, '-1' otherwise
#! @output error_message: error message
#!
#! @result SUCCESS: parsing was successful (return_code == '0')
#! @result FAILURE: otherwise
#!!#
########################################################################################################################

namespace: io.cloudslang.openstack.images

operation:
  name: get_image_id

  inputs:
    - image_body
    - image_name

  python_action:
    script: |
      try:
        import json
        images = json.loads(image_body)['images']
        matched_image = next(image for image in images if image['name'] == image_name)
        image_id = matched_image['id']
        return_code = '0'
        return_result = 'Parsing successful.'
      except StopIteration:
        return_code = '-1'
        return_result = 'No images in list'
      except  ValueError:
        return_code = '-1'
        return_result = 'Parsing error.'

  outputs:
    - image_id
    - return_result
    - return_code
    - error_message: ${return_result if return_code == '-1' else ''}

  results:
    - SUCCESS: ${return_code == '0'}
    - FAILURE
