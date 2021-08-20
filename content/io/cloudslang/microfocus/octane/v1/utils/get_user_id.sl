namespace: io.cloudslang.microfocus.octane.v1.utils
operation:
  name: get_user_id
  inputs:
    - return_result
  python_action:
    use_jython: false
    script: "# do not remove the execute function\ndef execute(return_result):\n    # code goes here\n    \n    text=return_result.split('id\":\"')\n    text=text[1].split('\"')\n    id=text[0]\n    return locals()\n# you can add additional helper methods below."
  outputs:
    - id
  results:
    - SUCCESS
