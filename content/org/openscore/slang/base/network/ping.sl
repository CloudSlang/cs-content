# (c) Copyright 2014 Hewlett-Packard Development Company, L.P.
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
# The Apache License is available at
# http://www.apache.org/licenses/LICENSE-2.0
#
####################################################
# This operation copies file/folder
#
# Inputs:
# - address - address to ping send
# - ttl - TimeToLive ping parametr
# - size - ping buffer size
# - timeout - timeout in miliseconds to wait for reply
# Outputs:
# - message - error message in case of error
# Results:
# - SUCCESS - address is up
# - FAILURE - address is down
####################################################
namespace: org.openscore.slang.base.network

operation:
  name: ping

  inputs:
    - address
    - ttl:
        default: "'64'"
        required: false
    - size:
        default: "'32'"
        required: false
    - timeout:
        default: "'1000'"
        required: false

  action:
    python_script: |
        try:
          import os, smtplib
          is_up = False
          is_error = False
          if os.path.isdir('/usr'):
            response = os.system("ping -c 1 -t " + ttl + ' -s ' + size + ' -W ' + timeout + ' ' + address)
          else:
            response = os.system("ping -n 1 -i " + ttl + ' -l ' + size + ' -w ' + timeout + ' ' + address)
          if response == 0:
            message = (address + " is up! \n")
            is_up = True
          else:
            message = (address + " is down! \n")
        except Exception as e:
          message = e
          is_error = True

  outputs:
     - message
     - is_up

  results:
    - FAILURE: is_error
    - UP: is_up
    - DOWN: not is_up
