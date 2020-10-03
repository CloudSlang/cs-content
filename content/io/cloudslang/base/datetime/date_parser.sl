#!!
#! @description: This operation converts the date input value from one date/time format (specified by dateFormat) to another date/time format (specified by outFormat) using locale settings (language and country).
#!
#!  Notes:
#!      The following character strings can be used to format the date:
#!                %b: Returns the first three characters of the month name.
#!                %d: Returns day of the month, from 1 to 31.
#!                %Y: Returns the year in four-digit format.
#!                %H: Returns the hour.
#!                %M: Returns the minute, from 00 to 59.
#!                %S: Returns the second, from 00 to 59.
#!                %a: Returns the first three characters of the weekday, e.g. Wed.
#!                %A: Returns the full name of the weekday, e.g. Wednesday.
#!                %B: Returns the full name of the month, e.g. September.
#!                %w: Returns the weekday as a number, from 0 to 6, with Sunday being 0.
#!                %m: Returns the month as a number, from 01 to 12.
#!                %p: Returns AM/PM for time.
#!                %y: Returns the year in two-digit format, that is, without the century. For example, "18" instead of "2018".
#!                %f: Returns microsecond from 000000 to 999999.
#!                %Z: Returns the timezone.
#!                %z: Returns UTC offset.
#!                %j: Returns the number of the day in the year, from 001 to 366.
#!                %W: Returns the week number of the year, from 00 to 53, with Monday being counted as the first day of the week.
#!                %U: Returns the week number of the year, from 00 to 53, with Sunday counted as the first day of each week.
#!                %c: Returns the local date and time version.
#!                %x: Returns the local version of date.
#!                %X: Returns the local version of time.
#!
#!      Country and region strings can be combined with a language string to create a locale. The locale format depends on the OS you are running the operation on.
#!      Example of locale for Linux: en, nl_NL, de_DE, fr_CA, fr_FR
#!      Example of locale for Windows: en-US, en-GB, zh-CN, fr-FR, fr-CA
#!
#! @input date: The date to parse/convert.
#! @input date_format: The format of the input date.
#!                  Example: Date format: '%Y %m %d %H:%M:%S %Z%z' The date equivalent to the format: '1997 07 16 19:20:30 GMT+01:00'
#! @input date_locale: Optional - The locale of the input dateFormat string.
#!                  Examples: 'en-US', 'fr-FR', 'zh-CN'
#! @input out_format: The format of the output date/time.
#!                  Example: '%a %b %d %Y %M:%S:%H %p %z %Z'
#! @input out_locale: Optional - The locale for the output string.
#!                  Example: '%a %b %d %Y %M:%S:%H %p %z %Z'
#!
#! @output return_result: Contains the parsed/converted date, exception otherwise.
#!                        Example: 'July 1, 2016 2:32:09 PM EEST'
#! @output return_code: 0 if success, -1 if failure.
#!
#! @result SUCCESS: The date was parsed/converted successfully.
#! @result FAILURE: Otherwise.
#!!#
########################################################################################################################

namespace: io.cloudslang.base.datetime

operation:
  name: date_parser
  inputs:
    - date
    - date_format
    - date_locale:
        required: false
    - out_format
    - out_locale:
        required: false
  python_action:
    use_jython: false
    script: "from datetime import datetime\nimport locale\nimport sys\n\ndef execute(date, date_format, date_locale, out_format, out_locale): \n    try:\n        locale.setlocale(locale.LC_ALL, date_locale)\n        date_time_obj_in = datetime.strptime(date, date_format)\n        locale.setlocale(locale.LC_ALL, out_locale)\n        date_time_obj_out = date_time_obj_in.strftime(out_format)\n        return_code = 0\n        return{\"return_result\": date_time_obj_out, \"return_code\": return_code}\n    except:\n        e = sys.exc_info()\n        return_code = -1\n        return{\"return_result\": e, \"return_code\": return_code}"
  outputs:
    - return_result
    - return_code
  results:
    - SUCCESS: "${return_code == '0'}"
    - FAILURE
