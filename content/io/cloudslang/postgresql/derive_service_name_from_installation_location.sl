########################################################################################################################
#!!
#! @description: Derive the service name from home directory
#!
#! @input installation_location: installation_location
#!
#! @output service_name: service name
#!
#! @result SUCCESS: String is found at least once.
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql

operation:
  name: derive_service_name_from_installation_location

  inputs:
    - installation_location:
        required: true

  python_action:
    script: |
       if installation_location.count('10') > 0:
         service_name = 'postgresql-10.service'
       elif installation_location.count('9.5') > 0:
         service_name = 'postgresql-95.service'
       else:
         service_name ='postgresql-96.service'
  outputs:
    - service_name
  results:
    - SUCCESS: true
