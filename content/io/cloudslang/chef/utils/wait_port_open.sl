####################################################
# Chef content for CloudSlang
# Ben Coleman, Sept 2015, v1.0
####################################################
# Poll host until TCP port is open
####################################################

namespace: io.cloudslang.chef.utils

operation:
  name: wait_port_open
  inputs:
    - host
    - port
    - timeout
    - tries
  action:
    python_script: |
      import socket, time, sys
      isopen = False

      for i in range(0, tries):
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        sock.settimeout(float(timeout))
        res = sock.connect_ex((host, int(port)))
        if res in [0, 10056]:
          isopen = True
          break
        elif res != None: 
          time.sleep(float(timeout))

      sock.close()
      sock = None
      del sock
  outputs:
    - isopen
    - res    

  results:
    - SUCCESS: isopen == True
    - FAILURE      