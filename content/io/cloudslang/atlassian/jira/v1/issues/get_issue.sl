namespace: io.cloudslang.atlassian.jira.v1.issues
flow:
  name: get_issue_test
  inputs:
    - domain: 'https://jira-server2.atlassian.net'
    - user: alexandru.presecan@microfocus.com
    - password: sFwSClhmfTvAsBoYmmZd43A6
    - proxy: web-proxy.eu.softwaregrp.net
    - cnt: '50'
  workflow:
    - get_issue:
        do:
          io.cloudslang.atlassian.jira.v1.issues.get_issue:
            - url: '${domain}'
            - username: '${user}'
            - password:
                value: '${password}'
                sensitive: true
            - issue_id_or_key: TES-7
            - proxy_host: '${proxy}'
        publish:
          - output_0: '${issue_id}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
    - FAILURE
extensions:
  graph:
    steps:
      get_issue:
        x: 280
        'y': 240
        navigate:
          e4de92a8-1112-e195-a79b-8961fd8b9e5d:
            targetId: 58d64497-3d30-3bfc-aac1-811dec275023
            port: SUCCESS
    results:
      SUCCESS:
        58d64497-3d30-3bfc-aac1-811dec275023:
          x: 480
          'y': 240

