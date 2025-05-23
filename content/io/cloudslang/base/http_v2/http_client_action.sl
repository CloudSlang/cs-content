########################################################################################################################
#!!
#! @description: Executes a REST call based on the method provided.
#!
#! @input url: URL to which the call is made.
#! @input method: HTTP method used.
#! @input auth_type: Optional - Type of authentication used to execute the request on the target server. Valid: 'basic', 'digest', 'ntlm', 'anonymous' (no authentication) Default: 'basic'
#! @input username: Optional - Username used for URL authentication; for NTLM authentication.Format: 'domain\user
#! @input password: Optional - Password used for URL authentication.
#! @input preemptive_auth: Optional - If 'true' authentication info will be sent in the first request, otherwise a request with no authentication info will be made and if server responds with 401 and a header. like WWW-Authenticate: Basic realm="myRealm" only then will the authentication info will be sent. Default: 'true'
#! @input body: Optional - String to include in body for HTTP POST operation. If both <source_file> and body will be provided, the body input has priority over <source_file>; should not be provided for method=GET, HEAD, TRACE.
#! @input trust_all_roots: Optional - Specifies whether to enable weak security over SSL. Default: 'false'
#! @input form_data: Optional - List containing body which should be sent as form data. Examples: 'formKey1=formValue1&formkey2=formValue2'
#! @input query_params: Optional - List containing query parameters to append to the URL. Examples: 'parameterName1=parameterValue1&parameterName2=parameterValue2;'
#! @input proxy_scheme: Optional - Proxy scheme for https proxy url.
#! @input proxy_host: Optional - Proxy server used to access the web site.
#! @input proxy_port: Optional - Proxy server port. Default: '8080'
#! @input proxy_user: Optional - User used when connecting to the proxy.
#! @input proxy_password: Optional - Proxy server password associated with the <proxy_username> input value.
#! @input headers: Optional - List containing the headers to use for the request separated by new line (CRLF); header name - value pair will be separated by ":". Format: According to HTTP standard for headers (RFC 2616) Example: 'Accept:text/plain'
#! @input tls_version: Optional - This input allows a list of comma separated values of the specific protocols to be used. Valid: TLSv1.2, TLSv1.3. Default: 'TLSv1.3'
#! @input allowed_ciphers: Optional - A comma delimited list of ciphers to use. The value of this input will be ignored if 'tlsVersion' does not contain 'TLSv1.2' or 'TLSv1.3'.This capability is provided “as is”, please see product documentation for further security considerations. In order to connect successfully to the target host, it should accept at least one of the following ciphers. If this is not the case, it is the user's responsibility to configure the host accordingly or to update the list of allowed ciphers. Default: TLS_AES_256_GCM_SHA384,TLS_CHACHA20_POLY1305_SHA256,TLS_AES_128_GCM_SHA256
#! @input keep_alive: Optional - Specifies whether to create a shared connection that will be used in subsequent calls. Default: 'true'
#! @input keystore: Optional - Location of the KeyStore file. Format: a URL or the local path to it. This input is empty if no HTTPS client authentication is used
#! @input keystore_password: Optional - Password associated with the KeyStore file.
#! @input trust_keystore: Optional - Location of the TrustStore file. Format: a URL or the local path to it
#! @input trust_password: Optional - Password associated with the trust_keystore file.
#! @input x_509_hostname_verifier: Optional - Specifies the way the server hostname must match a domain name in the subject's Common Name (CN) or subjectAltName field of the X.509 certificate. Valid: 'strict', 'browser_compatible', 'allow_all' Default: 'allow_all'
#! @input connections_max_per_route: Optional - Maximum limit of connections on a per route basis. Default: '2'
#! @input connections_max_total: Optional - Maximum limit of connections in total. Default: '20'
#! @input use_cookies: Optional - Specifies whether to enable cookie tracking or not. Default: 'true'
#! @input follow_redirects: Optional - Specifies whether the 'Get' command automatically follows redirects.
#! @input destination_file: Optional - Absolute path of a file on disk where the entity returned by the response will be saved to.
#! @input request_character_set: Optional - Character encoding to be used for the HTTP response. Default: 'UTF-8'
#! @input content_type: Optional - Content type that should be set in the request header, representing the MIME-type of the data in the message body. Default: 'application/json'
#! @input connect_timeout: Optional - Time in seconds to wait for a connection to be established. When 0 value is used, there is no limit on the amount of time allowed for the connection to be established. Default: '300'
#! @input execution_timeout: Optional - Time in seconds to wait for the operation to finish executing. When 0 value is used, there is no limit on the amount of time allowed for the operation to finish executing. Default: '300'
#! @input socket_timeout: Optional - Time in seconds to wait for data to be retrieved (maximum period inactivity. between two consecutive data packets) When 0 value is used, there is no limit on the amount of time allowed for the data to be retrieved. Default: '300'
#! @input valid_http_status_codes: Optional - List/array of HTTP status codes considered to be successful. Example: [202, 204] Default: 'range(200, 300)'
#!
#! @output return_result: Response of the operation.
#! @output status_code: Status code of the HTTP call.
#! @output return_code: '0' if success, '-1' otherwise.
#! @output response_headers: Response headers string from the HTTP Client REST call.
#! @output final_location: The final location after redirects.
#!                         Format: URL
#! @output reason_phrase: The reason phrase from the origin HTTP response. This depends on the status code and are according to RFC 1945 and RFC 2048
#!                        Examples: Values (HTTP 1.1): Continue, Temporary Redirect, Method Not Allowed, Conflict, Precondition Failed, Request Too Long, Request-URI Too Long, Unsupported Media Type, Multiple Choices, See Other, Use Proxy, Payment Required, Not Acceptable, Proxy Authentication Required, Request Timeout, Switching Protocols, Non Authoritative Information, Reset Content, Partial Content, Gateway Timeout, Http Version Not Supported, Gone, Length Required, Requested Range Not Satisfiable, Expectation Failed
#! @output protocol_version: The HTTP protocol version. Examples: HTTP/1.1
#! @output exception: Stacktrace in case of failure.
#!
#! @result SUCCESS: Operation succeeded (statusCode is contained in valid_http_status_codes list).
#! @result FAILURE: Operation failed (statusCode is not contained in valid_http_status_codes list).
#!!#
########################################################################################################################
namespace: io.cloudslang.base.http_v2
operation:
  name: http_client_action
  inputs:
    - url:
        required: true
    - method:
        required: true
    - auth_type:
        required: true
        default: BASIC
    - username:
        required: false
    - password:
        required: false
        sensitive: true
    - preemptive_auth:
        required: true
        default: 'true'
    - body:
        required: false
    - trust_all_roots:
        required: true
        default: 'false'
    - form_data:
        required: false
    - query_params:
        required: false
    - proxy_scheme:
        required: false
    - proxy_host:
        required: false
    - proxy_port:
        required: true
        default: '8080'
    - proxy_user:
        required: false
    - proxy_password:
        required: false
    - headers:
        required: false
    - tls_version:
        required: false
        default: TLSv1.3
    - allowed_ciphers:
        required: false
        default: 'TLS_AES_256_GCM_SHA384,TLS_CHACHA20_POLY1305_SHA256,TLS_AES_128_GCM_SHA256'
    - keep_alive:
        required: true
        default: 'true'
    - keystore:
        required: false
    - keystore_password:
        required: false
        sensitive: true
    - trust_keystore:
        required: false
    - trust_password:
        required: false
        sensitive: true
    - x_509_hostname_verifier:
        required: true
        default: allow_all
    - connections_max_per_route:
        required: true
        default: '2'
    - connections_max_total:
        required: true
        default: '20'
    - use_cookies:
        required: true
        default: 'true'
    - follow_redirects:
        required: false
    - destination_file:
        required: false
    - request_character_set:
        required: true
        default: UTF-8
    - content_type:
        required: false
        default: application/json
    - connect_timeout:
        required: false
        default: '300'
    - execution_timeout:
        required: false
        default: '300'
    - socket_timeout:
        required: true
        default: '300'
    - valid_http_status_codes:
        required: false
        default: 'str(list(range(200, 300)))'
  python_action:
    use_jython: false
    script: "import requests\nimport ssl\nimport traceback\nfrom requests.adapters import HTTPAdapter\nfrom urllib3.poolmanager import PoolManager\nimport json\nimport os\nimport ast\nfrom http import HTTPStatus\n\nclass TLSAdapter(HTTPAdapter):\n    def __init__(self, ssl_context=None, max_connections=10, max_connections_per_host=10):\n        self.ssl_context = ssl_context\n        self._pool_maxsize = max_connections\n        self._max_connections_per_host = max_connections_per_host\n        super().__init__()\n\n    def init_poolmanager(self, connections, maxsize, block=False, **kwargs):\n        kwargs['ssl_context'] = self.ssl_context\n        return super().init_poolmanager(connections, maxsize, block=block, **kwargs)\n\n\ndef execute(url, method, auth_type, preemptive_auth, username, password, body, trust_all_roots,\n            form_data, query_params, proxy_scheme, proxy_host, proxy_port, proxy_user, proxy_password,\n            headers, tls_version, allowed_ciphers, destination_file, execution_timeout,\n            connect_timeout, socket_timeout, keep_alive, keystore, keystore_password,\n            trust_keystore, trust_password, x_509_hostname_verifier, connections_max_per_route,\n            connections_max_total, use_cookies, follow_redirects, request_character_set, content_type,valid_http_status_codes):\n\n    try:\n        session = requests.Session()\n        \n        def validate_boolean(val, name, default=False):\n            if val is None or str(val).strip() == \"\":\n                return default\n            val = str(val).lower()\n            if val not in [\"true\", \"false\"]:\n                raise ValueError(f\"Invalid boolean value for {name}: {val}. Must be 'true' or 'false'.\")\n            return val == \"true\"\n\n\n        trust_all_roots = validate_boolean(str(trust_all_roots).lower(), \"trust_all_roots\")\n        preemptive_auth = validate_boolean(str(preemptive_auth).lower(), \"preemptive_auth\")\n        use_cookies = validate_boolean(str(use_cookies).lower(), \"use_cookies\")\n        follow_redirects = validate_boolean(str(follow_redirects).lower(), \"follow_redirects\")\n        keep_alive = validate_boolean(str(keep_alive).lower(), \"keep_alive\")\n\n        method = method.upper()\n        if method not in [\"GET\", \"POST\", \"PUT\", \"DELETE\", \"PATCH\", \"TRACE\", \"HEAD\" , \"OPTIONS\"]:\n            raise ValueError(f\"Invalid HTTP method: {method}\")\n\n        valid_auth_types = [\"basic\", \"digest\", \"ntlm\", \"anonymous\"]\n        if auth_type and auth_type.lower() not in valid_auth_types:\n            raise ValueError(f\"Invalid auth_type: {auth_type}. Must be one of {', '.join(valid_auth_types)}\")\n        \n        auth = None\n        if auth_type and auth_type.lower() == \"basic\" and username and password:\n            auth = (username, password)\n            \n        \n        if x_509_hostname_verifier:\n            valid_verifiers = [\"strict\", \"allow_all\"]\n            if x_509_hostname_verifier.lower() not in valid_verifiers:\n                raise ValueError(f\"Invalid x_509_hostname_verifier: {x_509_hostname_verifier}. Valid values are: {', '.join(valid_verifiers)}\")\n                \n        \n        if url.lower().startswith(\"https\") and not trust_all_roots:\n            ks = (keystore or \"\").strip()\n            ks_pass = (keystore_password or \"\").strip()\n            trust_ks = (trust_keystore or \"\").strip()\n            trust_pass = (trust_password or \"\").strip()\n        \n            if not ks and not trust_ks:\n                raise ValueError(\"trust_all_roots is set to false, but both keystore and truststore are empty. Please provide at least one.\")\n        \n            if ks and not os.path.isfile(ks):\n                raise ValueError(f\"Provided keystore path does not exist or is not a file: {ks}\")\n            if trust_ks and not os.path.isfile(trust_ks):\n                raise ValueError(f\"Provided trustKeystore path does not exist or is not a file: {trust_ks}\")\n\n\n        params = {}\n        if query_params:\n            for pair in query_params.split(\"&\"):\n                if \"=\" not in pair:\n                    raise ValueError(f\"Invalid query parameter: {pair}\")\n                k, v = pair.split(\"=\", 1)\n                params[k.strip()] = v.strip()\n\n        headers_dict = {}\n        if headers:\n            try:\n                if headers.strip().startswith(\"{\") and headers.strip().endswith(\"}\"):\n                    headers_dict = json.loads(headers)\n                else:\n                    lines = headers.strip().splitlines()\n                    for line in lines:\n                        if \":\" not in line:\n                            raise ValueError(f\"Invalid header format: '{line}' (missing ':')\")\n                        k, v = line.split(\":\", 1)\n                        k = k.strip()\n                        v = v.strip()\n                        if not k:\n                            raise ValueError(f\"Header name is empty in: '{line}'\")\n                        headers_dict[k] = v\n            except Exception as e:\n                raise ValueError(f\"Invalid headers format: {e}\")\n                \n        if content_type:\n            headers_dict[\"Content-Type\"] = content_type\n\n        data = None\n        if form_data:\n            try:\n                pairs = form_data.split(\"&\")\n                data = {}\n                for pair in pairs:\n                    if not pair.strip():\n                        raise ValueError(f\"Invalid form data format: empty pair in '{form_data}'\")\n                    if \"=\" not in pair:\n                        raise ValueError(f\"Invalid form data format: '{pair}' (missing '=')\")\n                    k, v = pair.split(\"=\", 1)\n                    k = k.strip()\n                    v = v.strip()\n                    if not k:\n                        raise ValueError(f\"Invalid form data format: empty key in '{pair}'\")\n                    if not v:\n                        raise ValueError(f\"Invalid form data format: empty value in '{pair}'\")\n                    data[k] = v\n            except Exception as e:\n                raise ValueError(f\"Invalid form data format: {e}\")\n        elif body:\n            if headers_dict.get(\"Content-Type\", \"\").lower() == \"application/json\":\n                try:\n                    data = json.loads(body)  # Validate it's valid JSON\n                except json.JSONDecodeError:\n                    raise ValueError(\"Body format is not valid.\")\n            else:\n                data = body  \n\n        proxies = None\n        if proxy_host:\n            if not proxy_scheme or not proxy_port:\n                raise ValueError(\"Incomplete proxy configuration.\")\n            proxy_auth = f\"{proxy_user}:{proxy_password}@\" if proxy_user and proxy_password else \"\"\n            proxy_url = f\"{proxy_scheme}://{proxy_auth}{proxy_host}:{proxy_port}\"\n            proxies = {\n                \"http\": proxy_url,\n                \"https\": proxy_url\n            }\n\n        ssl_context = ssl.create_default_context()\n        verify = not trust_all_roots\n\n        if not verify:\n            ssl_context.check_hostname = False\n            ssl_context.verify_mode = ssl.CERT_NONE\n\n        # Normalize and prepare list of TLS versions\n        tls_versions_map = {\n            \"tlsv1.2\": ssl.TLSVersion.TLSv1_2,\n            \"tlsv1.3\": ssl.TLSVersion.TLSv1_3,\n            # \"tlsv1\": ssl.TLSVersion.TLSv1,  # Deprecated, uncomment if needed\n            # \"tlsv1.1\": ssl.TLSVersion.TLSv1_1,\n        }\n        \n        if tls_version:\n            raw_versions = [v.strip().lower() for v in tls_version.split(\",\") if v.strip()]\n            tls_versions = []\n            for version in raw_versions:\n                if version not in tls_versions_map:\n                    raise ValueError(f\"Invalid TLS version: {version}. Supported: {', '.join(tls_versions_map.keys())}\")\n                tls_versions.append(tls_versions_map[version])\n        else:\n            tls_versions = [ssl.TLSVersion.TLSv1_3, ssl.TLSVersion.TLSv1_2]  # Default order\n\n        \n        if allowed_ciphers:\n            JAVA_TO_OPENSSL_CIPHER_MAP = {\n                \"TLS_DHE_RSA_WITH_AES_256_GCM_SHA384\": \"DHE-RSA-AES256-GCM-SHA384\",\n                \"TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256\": \"ECDHE-RSA-AES128-GCM-SHA256\",\n                \"TLS_DHE_RSA_WITH_AES_256_CBC_SHA256\": \"DHE-RSA-AES256-SHA256\",\n                \"TLS_DHE_RSA_WITH_AES_128_CBC_SHA256\": \"DHE-RSA-AES128-SHA256\",\n                \"TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384\": \"ECDHE-RSA-AES256-SHA384\",\n                \"TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256\": \"ECDHE-RSA-AES128-SHA256\",\n                \"TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256\": \"ECDHE-ECDSA-AES128-SHA256\",\n                \"TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256\": \"ECDHE-ECDSA-AES128-GCM-SHA256\",\n                \"TLS_RSA_WITH_AES_256_GCM_SHA384\": \"AES256-GCM-SHA384\",\n                \"TLS_RSA_WITH_AES_256_CBC_SHA256\": \"AES256-SHA256\",\n                \"TLS_RSA_WITH_AES_128_CBC_SHA256\": \"AES128-SHA256\",\n            }\n        \n            valid_tls13_ciphers = {\n                \"TLS_AES_256_GCM_SHA384\",\n                \"TLS_CHACHA20_POLY1305_SHA256\",\n                \"TLS_AES_128_GCM_SHA256\"\n            }\n        \n            # Normalize input ciphers and mapping keys to uppercase for case-insensitive matching\n            cipher_list = [cipher.strip().upper() for cipher in allowed_ciphers.split(\",\") if cipher.strip()]\n            cipher_map_upper = {k.upper(): v for k, v in JAVA_TO_OPENSSL_CIPHER_MAP.items()}\n        \n            # Ensure at least one supported TLS version is provided\n            supported_tls_versions = {ssl.TLSVersion.TLSv1_2, ssl.TLSVersion.TLSv1_3}\n            unsupported_versions = [v for v in tls_versions if v not in supported_tls_versions]\n            if unsupported_versions:\n                raise ValueError(\"Cipher validation is only supported for TLSv1.2 and TLSv1.3.\")\n        \n            tls13_requested = ssl.TLSVersion.TLSv1_3 in tls_versions\n            tls12_requested = ssl.TLSVersion.TLSv1_2 in tls_versions\n        \n            # if tls13_requested:\n            #     invalid_tls13 = [c for c in cipher_list if c not in valid_tls13_ciphers]\n            #     if invalid_tls13:\n            #         raise ValueError(\n            #             f\"Invalid TLSv1.3 ciphers: {', '.join(invalid_tls13)}. \"\n            #             f\"Allowed: {', '.join(valid_tls13_ciphers)}\"\n            #         )\n        \n            # if tls12_requested:\n            #     for cipher in cipher_list:\n            #         if cipher not in cipher_map_upper:\n            #             raise ValueError(f\"Unsupported TLSv1.2 cipher: {cipher}\")\n\n\n\n        try:\n            if connections_max_per_route:\n                connections_max_per_route = int(connections_max_per_route)\n                if connections_max_per_route <= 0:\n                    raise ValueError(\"connections_max_per_route must be a positive integer.\")\n            else:\n                connections_max_per_route = 10 \n\n            if connections_max_total:\n                connections_max_total = int(connections_max_total)\n                if connections_max_total <= 0:\n                    raise ValueError(\"connections_max_total must be a positive integer.\")\n            else:\n                connections_max_total = 50 \n        except Exception:\n            raise ValueError(\"Invalid value for connection limits. Must be positive integers.\")\n\n        adapter = TLSAdapter(\n            ssl_context=ssl_context,\n            max_connections=connections_max_total,\n            max_connections_per_host=connections_max_per_route\n        )\n\n        session.mount('https://', adapter)\n        session.mount('http://', adapter)\n\n\n        try:\n            connect = float(connect_timeout) if connect_timeout else float(execution_timeout or 60)\n            read = float(socket_timeout) if socket_timeout else float(execution_timeout or 60)\n\n            if connect <= 0 or read <= 0:\n                raise ValueError(\"Timeout values must be positive.\")\n            timeout_tuple = (connect, read)\n        except Exception:\n            raise ValueError(\"Invalid timeout configuration. Must be positive numbers.\")\n        \n        try:\n            code_str = valid_http_status_codes.strip()\n        \n            if code_str.startswith(\"str(list(range(\") and code_str.endswith(\")))\"):\n                start = code_str.find(\"range(\") + len(\"range(\")\n                end = code_str.rfind(\")))\")\n                range_args = code_str[start:end].rstrip(\")\")\n                parts = [int(x.strip()) for x in range_args.split(\",\")]\n                if len(parts) == 2:\n                    valid_codes_set = set(range(parts[0], parts[1]))\n                elif len(parts) == 3:\n                    valid_codes_set = set(range(parts[0], parts[1], parts[2]))\n                else:\n                    raise ValueError(\"Invalid range() format inside str(list(...))\")\n        \n            elif code_str.startswith(\"range(\") and code_str.endswith(\")\"):\n                range_args = code_str[len(\"range(\"):-1].rstrip(\")\")\n                parts = [int(x.strip()) for x in range_args.split(\",\")]\n                if len(parts) == 2:\n                    valid_codes_set = set(range(parts[0], parts[1]))\n                elif len(parts) == 3:\n                    valid_codes_set = set(range(parts[0], parts[1], parts[2]))\n                else:\n                    raise ValueError(\"Invalid range() format.\")\n        \n            elif code_str.startswith(\"[\") and code_str.endswith(\"]\"):\n                parsed = ast.literal_eval(code_str)\n                if isinstance(parsed, list) and all(isinstance(code, int) for code in parsed):\n                    valid_codes_set = set(parsed)\n                else:\n                    raise ValueError(\"List must contain only integers.\")\n        \n            else:\n                raise ValueError(\"Unsupported format.\")\n        \n        except Exception:\n            raise ValueError(\"valid_http_status_codes must be a list or range, e.g. '[200, 204]' or 'range(200, 300)' or 'str(list(range(200, 300)))'\")\n\n\n\n        if not use_cookies:\n            session.cookies.clear()\n        allow_redirects = bool(follow_redirects)\n\n        cert = None  \n\n        last_exception = None\n        for version in tls_versions:\n            try:\n                # Create a new SSL context for this attempt\n                ssl_context = ssl.create_default_context()\n        \n                if trust_all_roots:\n                    ssl_context.check_hostname = False\n                    ssl_context.verify_mode = ssl.CERT_NONE\n                else:\n                    ssl_context.check_hostname = True\n                    ssl_context.verify_mode = ssl.CERT_REQUIRED\n        \n                ssl_context.minimum_version = version\n                ssl_context.maximum_version = version\n                \n                if allowed_ciphers:\n                    cipher_list = [c.strip().upper() for c in allowed_ciphers.split(\",\")]\n        \n                    if version == ssl.TLSVersion.TLSv1_3:\n                        invalid_tls13 = [c for c in cipher_list if c not in valid_tls13_ciphers]\n                        if invalid_tls13:\n                            raise ValueError(\n                                f\"Invalid TLSv1.3 ciphers: {', '.join(invalid_tls13)}. \"\n                                f\"Allowed: {', '.join(valid_tls13_ciphers)}\"\n                            )\n                    \n                if version == ssl.TLSVersion.TLSv1_2 and allowed_ciphers:\n                    openssl_cipher_list = []\n                    cipher_map_upper = {k.upper(): v for k, v in JAVA_TO_OPENSSL_CIPHER_MAP.items()}\n                    for cipher in [c.strip().upper() for c in allowed_ciphers.split(\",\")]:\n                        if cipher not in cipher_map_upper:\n                            raise ValueError(f\"Unsupported TLSv1.2 cipher: {cipher}\")\n                        openssl_cipher_list.append(cipher_map_upper[cipher])\n                    ssl_context.set_ciphers(\":\".join(openssl_cipher_list))\n\n        \n                adapter = TLSAdapter(\n                    ssl_context=ssl_context,\n                    max_connections=connections_max_total,\n                    max_connections_per_host=connections_max_per_route\n                )\n        \n                session.adapters.clear() \n                session.mount('https://', adapter)\n                session.mount('http://', adapter)\n        \n                # Make the request\n                response = session.request(\n                    method=method,\n                    url=url,\n                    headers=headers_dict,\n                    params=params,\n                    json=data if headers_dict.get(\"Content-Type\", \"\").lower() == \"application/json\" and isinstance(data, dict) else None,\n                    data=None if headers_dict.get(\"Content-Type\", \"\").lower() == \"application/json\" and isinstance(data, dict) else data,\n                    auth=auth,\n                    proxies=proxies,\n                    timeout=timeout_tuple,\n                    verify=not trust_all_roots,\n                    cert=None,\n                    allow_redirects=allow_redirects,\n                    stream=bool(destination_file)\n                )\n        \n                # If request was successful, break out of loop\n                break\n        \n            except Exception as e:\n                last_exception = e\n        else:\n            raise ValueError(f\"Failed to establish HTTPS connection using any of the specified TLS versions. Last error: {last_exception}\")\n\n\n\n\n        response.encoding = request_character_set or response.encoding\n        content = response.text\n        \n        if response.status_code not in valid_codes_set:\n            try:\n                status_description = HTTPStatus(response.status_code).phrase\n            except ValueError:\n                status_description = \"Unknown Status\"\n        \n            return {\n                \"return_result\": f\"HTTP {response.status_code} - {status_description}\",\n                \"status_code\": str(response.status_code),\n                \"return_code\": \"-1\",\n                \"response_headers\": \"\\n\".join(f\"{k}: {v}\" for k, v in response.headers.items()),\n                \"final_location\": response.url,\n                \"reason_phrase\": response.reason,\n                \"protocol_version\": f\"HTTP/{response.raw.version / 10:.1f}\" if hasattr(response.raw, \"version\") else \"HTTP/1.1\",\n                \"exception\": \"\",\n            }\n\n\n        if destination_file:\n            with open(destination_file, \"wb\") as f:\n                for chunk in response.iter_content(8192):\n                    if chunk:\n                        f.write(chunk)\n            content = f\"Response saved to {destination_file}\"\n        else:\n            response.encoding = request_character_set or response.encoding\n            content = response.text\n\n        return {\n            \"return_result\": content,\n            \"status_code\": str(response.status_code),\n            \"return_code\": \"0\",\n            \"response_headers\": \"\\n\".join(f\"{k}: {v}\" for k, v in response.headers.items()),\n            \"final_location\": response.url,\n            \"reason_phrase\": response.reason,\n            \"protocol_version\": f\"HTTP/{response.raw.version / 10:.1f}\" if hasattr(response.raw, \"version\") else \"HTTP/1.1\",\n            \"exception\": \"\",\n        }\n\n    except requests.RequestException as e:\n        error_map = {\n            requests.exceptions.MissingSchema: (\"400\", \"Bad Request\"),\n            requests.exceptions.InvalidURL: (\"400\", \"Bad Request\"),\n            requests.exceptions.InvalidSchema: (\"400\", \"Bad Request\"),\n            requests.exceptions.ConnectionError: (\"404\", \"Not Found\"),\n            requests.exceptions.Timeout: (\"504\", \"Gateway Timeout\"),\n        }\n\n        status_code = \"520\"\n        reason = \"Unknown Error\"\n\n        for exc_type, (code, msg) in error_map.items():\n            if isinstance(e, exc_type):\n                status_code = code\n                reason = msg\n                break\n\n        return {\n            \"return_result\": f\"HTTP request failed: {str(e)}\",\n            \"status_code\": status_code,\n            \"return_code\": \"-1\",\n            \"response_headers\": \"\",\n            \"final_location\": \"\",\n            \"reason_phrase\": reason,\n            \"protocol_version\": \"\",\n            \"exception\": traceback.format_exc(),\n        }\n\n\n    except ValueError as e:\n        return {\n            \"return_result\": f\"Input validation error: {str(e)}\",\n            \"status_code\": \"\",\n            \"return_code\": \"-1\",\n            \"response_headers\": \"\",\n            \"final_location\": \"\",\n            \"reason_phrase\": \"\",\n            \"protocol_version\": \"\",\n            \"exception\": traceback.format_exc(),\n        }\n\n    except Exception as e:\n        return {\n            \"return_result\": f\"Unexpected error: {str(e)}\",\n            \"status_code\": \"\",\n            \"return_code\": \"-1\",\n            \"response_headers\": \"\",\n            \"final_location\": \"\",\n            \"reason_phrase\": \"\",\n            \"protocol_version\": \"\",\n            \"exception\": traceback.format_exc(),\n        }"
  outputs:
    - return_result
    - status_code
    - return_code
    - response_headers
    - final_location
    - reason_phrase
    - protocol_version
    - exception
  results:
    - SUCCESS: "${(return_code == '0') and (str(status_code) in valid_http_status_codes)}"
    - FAILURE