####################################################
#!!
#! @description: Performs a search in the response_headers in order to get the specified header value.
#! @input response_headers: the response headers string that came from HTTP Client REST call
#! @input header_name: the name of the header to get value for
#! @output return_result: specified header value in case of success, error message otherwise
#! @output error_message: exception if occurs
#!!#
####################################################

namespace: io.cloudslang.base.network.utils

operation:
  name: get_header_value
  inputs:
    - response_headers
    - header_name

  action:
    python_script: |
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