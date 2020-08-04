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
#! @description: Writes text to a file.
#!
#! @input file_path: Path of the file to write to.
#! @input text: Text to write to the file.
#! @input encode_type: Encode type used to write to file.
#!              Examples: ascii, big5, big5hkscs, cp037, cp424, cp437, cp500, cp737, cp775, cp850, cp852, cp855, cp856,
#!              cp857, cp860, cp861, cp862, cp863, cp864, cp865, cp866, cp869, cp874, cp875, cp932, cp949, cp950, cp1006,
#!              cp1026, cp1140, cp1250, cp1251, cp1252, cp1253, cp1254, cp1255, cp1256, cp1257, cp1258, euc_jp, euc_jis_2004,
#!              euc_jisx0213, euc_kr, gb2312, gbk, gb18030, hz, iso2022_jp, iso2022_jp_1, iso2022_jp_2, iso2022_jp_2004,
#!              iso2022_jp_3, iso2022_jp_ext, iso2022_kr, latin_1, iso8859_2, iso8859_3, iso8859_4, iso8859_5, iso8859_6,
#!              iso8859_7, iso8859_8, iso8859_9, iso8859_10, iso8859_13, iso8859_14, iso8859_15, johab, koi8_r, koi8_u,
#!              mac_cyrillic, mac_greek, mac_iceland, mac_latin2, mac_roman, mac_turkish, ptcp154, shift_jis,
#!              shift_jis_2004, shift_jisx0213, utf_16, utf_16_be, utf_16_le, utf_7, utf_8.
#!              Optional
#!
#! @output message: Error message if error occurred.
#!
#! @result SUCCESS: Text was written to the file.
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.filesystem

operation:
  name: write_to_file

  inputs:
    - file_path
    - text
    - encode_type:
        required: false

  python_action:
    script: |
      try:
        f = open(file_path, 'w')
        if encode_type != None:
          f.write(text.encode(encode_type))
        else:
          f.write(text.encode('utf-8'))
        f.close()
        message = 'writing done successfully'
        res = True
      except IOError as e:
        message =  "ERROR: no such folder or permission denied: " + str(e)
        res = False
      except Exception as e:
        message =  e
        res = False

  outputs:
    - message

  results:
    - SUCCESS: ${res}
    - FAILURE
