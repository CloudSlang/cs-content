# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# Poll host repeatedly until TCP port is open
#
# Inputs:
#   - host - hostname or IP to check
#   - port - TCP port number to check
#   - timeout - optional - timeout for each check, throttles the polling (in seconds)
#             - Default: 10 sec
#   - tries - optional - total number of tries - total wait time = timeout x tries
#           - Default: 30
# Results:
#   - SUCCESS - Connection successful, host is active and listening on port
#   - FAILURE - Host is not listening, port is closed or host down
####################################################

namespace: io.cloudslang.base.network

operation:
  name: wait_port_open
  inputs:
    - host
    - port
    - timeout:
        default: "'10'"
        required: false
    - tries:
        default: "'30'"
        required: false    

  action:
    python_script: |
      import socket, time, sys
      is_open = False

      for t in range(0, int(tries)):
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        sock.settimeout(float(timeout))
        res = sock.connect_ex((host, int(port)))
        if res in [0, 10056]:
          is_open = True
          break
        elif res != None: 
          time.sleep(float(timeout))

      sock.close()
      del sock

  results:
    - SUCCESS: is_open == True
    - FAILURE
