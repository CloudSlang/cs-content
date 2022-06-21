#   (c) Copyright 2022 Micro Focus, L.P.
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
#! @description: Converst the images desciption in json to required xml format.
#!
#! @input json_data: Json data file.
#!
#! @output describe_images_list: returns list of images in xl format.
#!!#
########################################################################################################################
namespace: io.cloudslang.amazon.aws.ec2.images
operation:
  name: create_describe_images_xml
  inputs:
    - json_data
  python_action:
    use_jython: false
    script: "import json\n\ndef execute(json_data):\n    return_code = 0\n    error_message = ''\n    images_start = '<Images>'\n    images_end = '</Images>'\n    image_start = '<Image>'\n    image_end = '</Image>'\n    platform_start = '<Platform>'\n    platform_end = '</Platform>'\n    os_start = '<OSName>'\n    os_end = '</OSName>'\n    ami_start = '<AmiId>'\n    ami_end = '</AmiId>'\n    platforms_start = '<Platforms>'\n    platforms_end = '</Platforms>'\n    name_start = '<Name>'\n    name_end = '</Name>'\n    images_description=''\n    platform_types = ''\n    platform_set = set()\n\n    \n    isArray = \"[\" in json_data\n    try:\n        json_load = (json.loads(json_data))\n        data=json_load['DescribeImagesResponse']['imagesSet']['item']\n        if (isArray):\n            for x in data:\n                platform_set.add(x['platform'])\n        for val in platform_set:\n            platform_types += platform_start + name_start + val + name_end + platform_end + '\\n'\n        platform_types = platforms_start + '\\n' + platform_types + platforms_end\n                \n        if (isArray):\n            for x in data:\n                images_description += image_start + '\\n'+ platform_start+ x['platform'] + platform_end + '\\n' + os_start+ x['description'] + os_end + '\\n' + ami_start+ x['imageId'] + ami_end + '\\n' +  image_end + '\\n'\n              \n            images_description = images_start + platform_types +'\\n' + images_description + images_end\n        else:\n            images_description = image_start + '\\n'+ platform_start+ data['platform'] + platform_end + '\\n' + os_start+ data['platform'] + os_end + '\\n' + ami_start+ data['platform'] + ami_end + '\\n' +  image_end + '\\n'\n         \n            images_description = images_start + platform_types  +'\\n' + images_description + images_end\n            \n    except Exception as e:\n        return_code = 1\n        error_message = str(e)\n    return{\"describe_images_list\":images_description, \"return_code\": return_code, \"error_message\": error_message}"
  outputs:
    - describe_images_list
  results:
    - SUCCESS


