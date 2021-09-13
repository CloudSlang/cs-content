namespace: io.cloudslang.microfocus.octane.v1.utils
operation:
  name: create_cookie
  inputs:
    - response_headers
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function
      def execute(response_headers):
          # code goes here
          string = response_headers.split("OCTANE_USER=")
          string = string[1].split(";Version")

          cookie = 'cookie: OCTANE_USER:' + string[0] + '; LWSSO_COOKIE_KEY='
          string = string[1].split("LWSSO_COOKIE_KEY=")
          cookie = cookie + string[1]
          return locals()
      # you can add additional helper methods below.
  outputs:
    - cookie
  results:
    - SUCCESS
