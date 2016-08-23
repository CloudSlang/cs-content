#   (c) Copyright 2016 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Runs a python script provided through a inline script or the canonical path to the python file.
#!               Note: The 'script' and 'file_path' are mutually exclusive
#! @input script: The inline script to run.
#! @input file_path: The canonical path to the script file.
#!                   Note: The file should not be a symbolink link
#! @input argv: The arguments to be passed to the script with the delimiter " " (a space). They will be present in the
#!              script as an array named 'argv' and if the script is from a file, the file absolute path will be added
#!              as the first element otherwise the word 'script'
#!              Note: if you pass in the 'script' and the 'argv' "1 2 3 'the red fox'", in the script it will be as:
#!                    argv = ['script', '1', '2', '3', 'the red fox']
#!
#! @input timeout: How many seconds to wait for the command to finish (in seconds).
#!                 Default value: 0 (waits indefinitely).
#!                 Note: It's recommended to have a non-zero value
#! @output return_result: STDOUT of the script that was ran
#! @output return_code: The exit code or errno of the script if present, 0 if the script succeeded or -1 otherwise.
#! @output error_message: The error message of the script.
#! @output return_code: The return code of the script
#! @result SUCCESS: If the script ran successfully with no error messages
#! @result FAILURE: If the script was invalid, the timeout was suppressed  or an error occurred
#!!#
########################################################################################################################

namespace: io.cloudslang.base.scripts

operation:
  name: python_script
  inputs:
    - script:
        default: ""
        required: false
    - file_path:
        default: ""
        required: false
    - argv:
        default: ""
        required: false
    - timeout:
        default: 0
        required: false
  python_action:
    script: |
      from cStringIO import StringIO
      from threading import Thread
      from shlex import split
      import os, sys

      script_result = ""
      error_message = ""
      exit_code = "-1"

      def get_valid_string(string):
        return str(string) if string else ""

      def script_runner(script, is_file, argv, result_list):
        try:
          if is_file:
            execfile(script, {}, {'argv': [script] + argv})
          else:
            exec(script, {}, {'argv': ['script'] + argv})
          result_list.insert(0, "0")
        except Exception as e:
          sys.stderr.write(str(e) + "\n")
          if hasattr(e, 'errno'):
            result_list.insert(0, e.errno)
          else:
            result_list.insert(0, "-1")
        except SystemExit as se:
          result_list.insert(0, str(se))

      script = get_valid_string(script)
      file_path = get_valid_string(file_path)
      argv = get_valid_string(argv)

      argv = split(argv) if argv else []

      try:
        timeout = float(timeout)
        if timeout < 0:
          error_message += "The timeout must be a positive number\n"
        elif timeout == 0:
          timeout = None
      except:
        error_message += "The timeout is invalid\n"
        timeout = 0

      if script and not file_path:
        is_file = False
        if not script:
          error_message += "The script is invalid\n"
      elif file_path and not script:
        if not file_path or not os.path.isfile(file_path):
          error_message += "The " + file_path + " does not exits\n"
        elif not os.path.isabs(file_path):
          error_message += "The " + file_path + " is not absolute\n"
        elif os.path.islink(file_path):
          error_message += "The " + file_path + " is a symbolic link"
        is_file = True
        script = file_path
      else:
        error_message += "Either the script or the file_path must be provided\n"

      if not error_message:
        result_list = []
        thread = Thread(name='script_runner', target=script_runner, args=(script, is_file, argv, result_list, ))
        thread.setDaemon(True)

        old_stdout, old_stderr = sys.stdout, sys.stderr
        redirected_output, redirected_error = sys.stdout, sys.stderr = StringIO(), StringIO()

        thread.start()
        thread.join(timeout)

        sys.stdout, sys.stderr = old_stdout, old_stderr

        if thread.is_alive():
          error_message += "Timeout\n"
          exit_code = "-1"
        else:
          script_result = str(redirected_output.getvalue())
          error_message += str(redirected_error.getvalue())
          exit_code = str(result_list.pop())
        del thread
  outputs:
    - return_result: ${script_result}
    - return_code: ${exit_code}
    - error_message
  results:
    - SUCCESS: ${not error_message}
    - FAILURE
