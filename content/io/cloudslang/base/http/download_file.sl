#   (c) Copyright 2017 Hewlett-Packard Enterprise Development Company, L.P.
#   All rights reserved. This program and the accompanying materials
#   are made available under the terms of the Apache License v2.0 which accompany this distribution.
#
#   The Apache License is available at
#   http://www.apache.org/licenses/LICENSE-2.0
#
########################################################################################################################
#!!
#! @description: Download a file from a provided URL.
#!
#! @input url: URL to download file.
#! @input cwd: Current working directory.
#! @input file_path: FQDN with the location where the file will be downloaded.
#! @input proxy_type: Whether to use the 'http' or 'https' protocol to access the web site.
#!                    Valid values: 'http', 'https'
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port.
#!                    Default: '8080'
#!
#! @output return_result: Path to the file that was downloaded.
#! @output return_code: 0 if command runs with success, -1 in case of failure.
#!
#! @result SUCCESS: The operation executed successfully and the 'return_code' is 0.
#! @result FAILURE: The operation could not be executed or the value of the 'return_code' is different than 0.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.http

operation:
  name: download_file

  inputs:
    - url
    - cwd:
        default: ''
        required: false
    - proxy_type:
        default: 'http'
        required: false
    - proxy_host:
        default: ''
        required: false
    - proxy_port:
        default: '8080'
        required: false


  python_action:
    script: |
      import urllib2
      import os
      if cwd == '':
        cwd = os.getcwd()
      try:
        if not proxy_host == '':
          proxy = urllib2.ProxyHandler({proxy_type:proxy_type + "://" + proxy_host + ":" + proxy_port})
          opener = urllib2.build_opener(proxy)
          urllib2.install_opener(opener)

        file_name =  url.split('/')[-1]
        u = urllib2.urlopen(url)
        file_path = cwd + file_name
        f = open(file_path, 'wb')
        print file_path
        meta = u.info()
        file_size = int(meta.getheaders("Content-Length")[0])
        print "Downloading: %s Bytes: %s" % (file_path, file_size)

        file_size_dl = 0
        block_sz = 8192
        while True:
            buffer = u.read(block_sz)
            if not buffer:
                break

            file_size_dl += len(buffer)
            f.write(buffer)
            status = r"%10d  [%3.2f%%]" % (file_size_dl, file_size_dl * 100. / file_size)
            status = status + chr(8)*(len(status)+1)
            print status,

        f.close()
        return_code = 0
        return_result = file_path
      except Exception as e:
        return_result = str(e)
        return_code = -1

  outputs:
    - return_result
    - return_code: ${ str(return_code) }

  results:
    - SUCCESS: ${return_code == 0}
    - FAILURE
