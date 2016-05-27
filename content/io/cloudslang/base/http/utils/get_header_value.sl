####################################################
#!!
#! @description: Performs a search in the response_headers to get the specified header value.
#! @input response_headers: response headers string from an HTTP Client REST call
#! @input header_name: name of header to get value for
#! @output return_result: specified header value in case of success, error message otherwise
#! @output error_message: exception if occurs
#!!#
####################################################

namespace: io.cloudslang.base.http.utils

operation:
  name: get_header_value
  inputs:
    - response_headers
    - header_name

  python_action:
    script: |
      result = ''
      error_message = ''
      try:
        begin_index = response_headers.find(header_name + ':')
        if begin_index != -1:
          response_headers = response_headers[begin_index + len(header_name) + 2:]
          result = response_headers.split(' ')[0]
        else:
          error_message = 'Could not find specified header: ' + header_name
          result = error_message
      except Exception as exception:
        error_message = exception
  outputs:
    - result
    - error_message
  results:
    - SUCCESS: ${error_message == ''}
    - FAILURE
