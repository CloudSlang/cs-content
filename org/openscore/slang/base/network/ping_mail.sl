namespace: org.openscore.slang.base.network

imports:
  network: org.openscore.slang.base.network
  mail: org.openscore.slang.base.mail

flow:
  name: ping_mail

  inputs:
    - address_to_ping
    - hostname
    - port
    - from
    - to
    - username
    - password


  workflow:
    - check_address:
        do:
          network.ping:
            - address: address_to_ping
        publish:
            - message
        navigate:
          SUCCESS: mail_send
          FAILURE: FAILURE

    - mail_send:
        do:
          mail.send_mail:
            - hostname: hostname
            - port: port
            - from: from
            - to: to
            - subject: "'Ping Result'"
            - body: "'Result: ' + address_to_ping + ' is up'"
            - username: username
            - password: password