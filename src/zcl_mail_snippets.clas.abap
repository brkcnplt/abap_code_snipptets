class ZCL_MAIL_SNIPPETS definition
  public
  inheriting from ZCL_CODE_SNIPPETS
  final
  create public .

public section.

  methods SEND_SIMPLE_MAIL
    importing
      value(IT_RECEIVERS) type ZBP_TT_SIMPLE_MAIL_RECEIVERS
      value(IV_TEXT) type STRING optional
      value(IV_MAIL_HEADER) type SO_OBJ_NAM optional
      value(IV_MAIL_DESC) type SO_OBJ_DES optional .
  methods REGEX_TO_VALIDATE_MAIL
    importing
      value(IV_MAIL_ADDRESS) type AD_SMTPADR optional
    returning
      value(EV_VALID) type FLAG .
protected section.
private section.
ENDCLASS.



CLASS ZCL_MAIL_SNIPPETS IMPLEMENTATION.


  METHOD regex_to_validate_mail.

********************************************************************************
* GitHub Repository : https://www.github.com/brkcnplt
* Linkedin          : https://www.linkedin.com/in/berkcanpolat/
********************************************************************************
* Berk Can Polat - 04.03.2023 17:18:59
    " RegEx Pattern Explaination
*    \w+(\.\w+)*@(\w+\.)+(\w{2,4})
*The first part, in front of @, will accept any alphanumeric character or
*    characters with or without (.) dot. This part (\.\w+)
*    validates if there is a dot it must be followed by a character.

*\w+(\.\w+)*@(\w+\.)+(\w{2,4})
*Part following the @, allows the flexibility to have any name with following
*a (.) dot. This part (\w+\.) makes sure that there is at least one domain
* before the end part. If there are multiple, it would check for (.)
*dot after each part of the domain.

*\w+(\.\w+)*@(\w+\.)+(\w{2,4})
*The last part ensures that the email has at least
* 2 and maximum 4 characters after the last dot.
********************************************************************************

    DATA: regex              TYPE REF TO cl_abap_regex,       " Regex Object
          matcher            TYPE REF TO cl_abap_matcher,     " Matcher Object
          match              TYPE c LENGTH 1,                 " Match ?
          mail_to_check(100).                      " Email ID to check


    mail_to_check = iv_mail_address.

    ev_valid = abap_true.

* Instntiate Regex
    CREATE OBJECT regex
      EXPORTING
        pattern     = '\w+(\.\w+)*@(\w+\.)+(\w{2,4})'
        ignore_case = abap_true.

* Create the Matcher
    matcher = regex->create_matcher( text = mail_to_check ).

* Match not found, invalid
    IF matcher->match( ) IS INITIAL.
      ev_valid = abap_false.  "Email not valid
      EXIT.
    ENDIF.

  ENDMETHOD.


  METHOD send_simple_mail.


    DATA : receivers          TYPE TABLE OF somlreci1,
           mail_content       TYPE solisti1,
           mail_data          TYPE  sodocchgi1,
           mail_content_table TYPE TABLE OF solisti1.


    mail_data = VALUE #( obj_name = iv_mail_header
                         obj_langu = sy-langu
                         obj_descr = iv_mail_desc ).


    APPEND VALUE #( line = iv_text ) TO mail_content_table.


    receivers = VALUE #( FOR ls_receivers IN it_receivers
                        ( receiver = ls_receivers-receivers
                          rec_type = 'U'
                          com_type = 'INT' ) ).

    CALL FUNCTION 'SO_NEW_DOCUMENT_SEND_API1'
      EXPORTING
        document_data              = mail_data
      TABLES
        object_content             = mail_content_table
        receivers                  = receivers
      EXCEPTIONS
        too_many_receivers         = 1
        document_not_sent          = 2
        document_type_not_exist    = 3
        operation_no_authorization = 4
        parameter_error            = 5
        x_error                    = 6
        enqueue_error              = 7
        OTHERS                     = 8.

    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    COMMIT WORK.

  ENDMETHOD.
ENDCLASS.
