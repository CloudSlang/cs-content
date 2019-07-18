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
#! @description: Builds HTML list item for a result retrieved from a query reponse.
#!
#! @input item_text: HTML text of a result retrieved from the query response
#! @input query_result: result object retrieved from the query response
#! @input index: index in the results of the found term
#! @input snippet_radius: number of words to display surrounding found term
#!                         (snippet will be twice the size of this number)
#!                         default: 5
#!
#! @output item_added: <item_text> with new list item added
#!
#! @result SUCCESS: HTML list item built successfully
#! @result FAILURE: There was an error while trying to build the HTML list item
#!!#
########################################################################################################################

namespace: io.cloudslang.haven_on_demand.examples.video_text_search

operation:
  name: build_result

  inputs:
    - item_text
    - query_result
    - index
    - snippet_radius:
        default: "5"
        required: false

  python_action:
    script: |
      index = int(index)
      query_result = eval(query_result)
      
      snippet_start = max(0, index - int(snippet_radius))
      snippet_end = min(len(query_result['text']), index + int(snippet_radius))
      snippet = ' '.join(query_result['text'][snippet_start : snippet_end])

      link = query_result['url'][0]
      seconds = str(int(query_result['offset'][index]) / 1000)
      link += '#t=' + seconds + 's'

      item = '<a href="' + link + '">' + snippet + '</a>'

      item_text += '<li>...' + item + '...</li>'

  outputs:
    - item_added: ${item_text}
