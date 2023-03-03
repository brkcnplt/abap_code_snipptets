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
protected section.
private section.
ENDCLASS.



CLASS ZCL_MAIL_SNIPPETS IMPLEMENTATION.


  METHOD send_simple_mail.


    DATA : receivers          TYPE TABLE OF somlreci1,
           mail_content       TYPE solisti1,
           mail_data          TYPE  sodocchgi1,
           mail_content_table TYPE TABLE OF solisti1.


    mail_data = VALUE #( obj_name = iv_mail_header
                         obj_langu = sy-langu
                         obj_descr = iv_mail_desc ).


    mail_content = iv_text.
    APPEND mail_content TO mail_content_table.


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
