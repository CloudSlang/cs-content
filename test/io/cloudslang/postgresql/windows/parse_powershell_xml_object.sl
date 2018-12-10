########################################################################################################################
#!!
#! @description: Extract exception message from powershell xml objects. Several types of outputs:
#!              - #< CLIXML some exception <Objs Version></Objs>
#!              - #< CLIXML <Objs Version><S S="Error">description</S></Objs>
#!              - <Objs Version><S S="Error">description</S></Objs>
#!
#! @input xml_object: powershell xml object
#!
#! @output exception: exception message
#!
#! @result SUCCESS
#!!#
########################################################################################################################

namespace: io.cloudslang.postgresql.windows

operation:
  name: parse_powershell_xml_object

  inputs:
    - xml_object:
        required: true
  python_action:
    script: |
      result = ''
      temp = xml_object
      if '#< CLIXML' in temp:
        temp = temp[10:]
        if '<Objs Version' in temp:
           if '<S S="Error"' in temp:
              firstErrorElement = temp.split('<S S="Error">')[1].strip()
              result = firstErrorElement[0: len(firstErrorElement)-4]
           else:
             result = temp.split('<Objs Version')[0].strip()
        else:
          result = temp
      elif '<Objs Version' in temp:
         if '<S S="Error"' in temp:
            firstErrorElement = temp.split('<S S="Error">')[1].strip()
            result = firstErrorElement[0: len(firstErrorElement)-4]
         else:
           result = temp.split('<Objs Version')[0].strip()
      else:
         result = xml_object
  outputs:
    - exception_message: ${result}
  results:
    - SUCCESS
