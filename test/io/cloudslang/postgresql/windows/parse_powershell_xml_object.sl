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
#! @description: Extract exception message from powershell xml objects. Several types of outputs:
#!              - #< CLIXML some exception <Objs Version></Objs>
#!              - #< CLIXML <Objs Version><S S="Error">description</S></Objs>
#!              - <Objs Version><S S="Error">description</S></Objs>
#!
#! @input xml_object: powershell xml object
#!
#! @output exception: exception message
#!
#! @result SUCCESS
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.windows

operation:
  name: parse_powershell_xml_object

  inputs:
    - xml_object:
        required: true
  python_action:
    script: |
      result = ''
      temp = xml_object
      if '#< CLIXML' in temp:
        temp = temp[10:]
        if '<Objs Version' in temp:
           if '<S S="Error"' in temp:
              firstErrorElement = temp.split('<S S="Error">')[1].strip()
              result = firstErrorElement[0: len(firstErrorElement)-4]
           else:
             result = temp.split('<Objs Version')[0].strip()
        else:
          result = temp
      elif '<Objs Version' in temp:
         if '<S S="Error"' in temp:
            firstErrorElement = temp.split('<S S="Error">')[1].strip()
            result = firstErrorElement[0: len(firstErrorElement)-4]
         else:
           result = temp.split('<Objs Version')[0].strip()
      else:
         result = xml_object
  outputs:
    - exception_message: ${result}
  results:
    - SUCCESS
