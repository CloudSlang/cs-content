####################################################
#!!
#! @description: Builds HTML list item for a result retrieved from a query reponse.
#!
#! @input item_text: HTML text of a result retrieved from the query response
#! @input query_result: result object retrieved from the query response
#! @output index: index in the results of the found term
#! @output snippet_radius: number of words to display surrounding found term
#!                         (snippet will be twice the size of this number)
#!                         default: 5
#! @result item_added: <item_text> with new list item added
#!!#
####################################################

namespace: io.cloudslang.haven_on_demand.examples.video_text_search

operation:
  name: build_result

  inputs:
    - item_text
    - query_result
    - index
    - snippet_radius:
        default: 5
        required: false

  python_action:
    script: |
      snippet_start = max(0, index - snippet_radius)
      snippet_end = min(len(query_result['text']), index + snippet_radius)
      snippet = ' '.join(query_result['text'][snippet_start : snippet_end])

      link = query_result['url'][0]
      seconds = str(int(query_result['offset'][index]) / 1000)
      link += '#t=' + seconds + 's'

      item = '<a href="' + link + '">' + snippet + '</a>'

      item_text += '<li>...' + item + '...</li>'

  outputs:
    - item_added: ${item_text}
