########################################################################################################################
#!!
#! @description: Workflow that tests quote_check
#!
#! @input file_path: path for the file containing the quotes
#! @input default_quote: default quote to be displayed
#!
#! @result SUCCESS_PRINTING_DEFAULT: quote printed successfully
#! @result QUOTE_EXISTS: the random quote was generated successfully
#! @result FILE_DOESNT_OPEN: the file can't be open
#! @result CANT_CHECK_RANDOM_QUOTE: the random quote wasn't generated
#! @result FAILURE: failure
#!!#
########################################################################################################################

namespace: test.io.cloudslang.base.examples

imports:
  strings: io.cloudslang.base.strings
  base: io.cloudslang.base.print
  quote_generator: io.cloudslang.base.examples.yoda
  utils: io.cloudslang.base.utils
  fs: io.cloudslang.base.filesystem

flow:
    name: test_quote_check

    inputs:
      - default_quote:
          default: "Do or do not, there is no try!"
          private: true
      - file_path

    workflow:
      - print_quote:
          do:
            utils.is_true:
              - bool_value: ${str(get_sp('io.cloudslang.base.examples.yoda.default_quote', 'false'))}
          navigate:
              - 'TRUE': print_default_quote
              - 'FALSE': print_random_quote

      - print_default_quote:
          do:
            base.print_text:
              - text: ${default_quote}
          navigate:
            - SUCCESS: SUCCESS_PRINTING_DEFAULT

      - print_random_quote:
          do:
            quote_generator.generate_random_quote:
              - file_path
          publish:
              - random_quote
          navigate:
            - SUCCESS: CHECK_RANDOM_QUOTE
            - FAILURE: CANT_CHECK_RANDOM_QUOTE

      - CHECK_RANDOM_QUOTE:
          do:
            fs.read_from_file:
              - file_path: ${file_path}
              - random_quote

          publish:
            - read_text
          navigate:
            - SUCCESS: check_quote_exists
            - FAILURE: FILE_DOESNT_OPEN

      - check_quote_exists:
          do:
            strings.string_occurrence_counter:
                - string_in_which_to_search: ${read_text}
                - string_to_find: ${random_quote}
          navigate:
            - SUCCESS: QUOTE_EXISTS
            - FAILURE: FAILURE

    results:
      - SUCCESS_PRINTING_DEFAULT
      - QUOTE_EXISTS
      - FILE_DOESNT_OPEN
      - CANT_CHECK_RANDOM_QUOTE
      - FAILURE
