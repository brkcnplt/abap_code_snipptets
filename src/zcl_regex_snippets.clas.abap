CLASS zcl_regex_snippets DEFINITION
  PUBLIC
  INHERITING FROM zcl_code_snippets
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS validate_email
      IMPORTING
        VALUE(iv_mail_address) TYPE char100 OPTIONAL
      RETURNING
        VALUE(ev_valid)        TYPE abap_bool .
    METHODS validate_tel_number
      IMPORTING
        VALUE(iv_tel_number) TYPE string DEFAULT '+90 555 123 12 12'
      RETURNING
        VALUE(ev_valid)      TYPE abap_bool .
protected section.
private section.
ENDCLASS.



CLASS ZCL_REGEX_SNIPPETS IMPLEMENTATION.


  METHOD validate_email.

*  Explaination of using RegEx: \b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b
*  \b : This is a word boundary anchor which matches the beginning or end of a word.
*In this case, it is used to ensure that the email address is not part of a larger string.
*  [A-Za-z0-9._%+-]+: This matches one or more occurrences of letters, digits, and the characters ._%+-.
*This is the first part of the email address before the @ symbol.
*  @: This matches the @ symbol, which is required in all valid email addresses.
*  [A-Za-z0-9.-]+: This matches one or more occurrences of letters, digits, and the character - before the domain extension.
*  \.: This matches a literal . character, which is used to separate the domain name from the domain extension.
*  [A-Za-z]{2,}: This matches two or more occurrences of letters that make up the domain extension.
*This ensures that the domain extension is at least two letters long and can include both upper and lowercase letters.
*  \b: This is another word boundary anchor, which ensures that the email address is not part of a larger string.


    DATA:   lo_matcher TYPE REF TO cl_abap_matcher.

    TRY .

        DATA(lo_regex) = NEW cl_abap_regex( pattern = '\b[A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b'
                                            ignore_case = abap_true ).

        CHECK iv_mail_address IS NOT INITIAL.

        iv_mail_address = to_lower( iv_mail_address ).

        lo_matcher = lo_regex->create_matcher( text = iv_mail_address ) .

        IF lo_matcher->match( ) IS INITIAL.
          ev_valid = abap_false.
        ELSE.
          ev_valid = abap_true.
        ENDIF.

      CATCH cx_sy_regex_too_complex INTO DATA(lo_exceotion).
        DATA(lv_err_msg) = lo_exceotion->get_text( ).
    ENDTRY.

  ENDMETHOD.


  METHOD validate_tel_number.

*    RegEx : '^(0\d{10}|5\d{9}|\+\d{12})$'
* ^ : Matches the beginning of the expression.
* (0\d{10}|5\d{9}|\+\d{12}) : Contains three alternatives.
* The first alternative is a string that starts with "0" followed by 10 digits
* The second alternative is a string that starts with "5" followed by 9 digits.
* The third alternative is a string that starts with "+" followed by 12 digits
* $ : Matches the end of the expression.


    DATA:   lo_matcher TYPE REF TO cl_abap_matcher.

    TRY .

        DATA(lo_regex) = NEW cl_abap_regex( pattern = '^(0\d{10}|5\d{9}|\+\d{12})$' ).

        CHECK iv_tel_number IS NOT INITIAL.

        CONDENSE iv_tel_number NO-GAPS.



        lo_matcher = lo_regex->create_matcher( text = iv_tel_number ) .

        IF lo_matcher->match( ) IS INITIAL. "  Check given variable contain pattern (CP Operation)
          ev_valid = abap_false.
        ELSE.
          ev_valid = abap_true.
        ENDIF.

      CATCH cx_sy_regex_too_complex INTO DATA(lo_exceotion).
        DATA(lv_err_msg) = lo_exceotion->get_text( ).
    ENDTRY.


  ENDMETHOD.
ENDCLASS.
