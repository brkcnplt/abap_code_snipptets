class ZCL_NEW_SYNTAX_SNIPPETS definition
  public
  inheriting from ZCL_CODE_SNIPPETS
  final
  create public .

public section.

  methods SPLIT_WORD_VIA_SEGMENT_FUNC .
protected section.
private section.
ENDCLASS.



CLASS ZCL_NEW_SYNTAX_SNIPPETS IMPLEMENTATION.


  METHOD split_word_via_segment_func.

    " when sy-index = 1 result = abcd , when sy-index = 2 result = ef
    " this 'do' while will work until all members will pass
    DATA: result TYPE string,
          lv_val TYPE string VALUE 'abcd,ef,gh,ijkl,mnop,qr,stuv,w,xyz'.
    DO.
      TRY.
          result = segment( val = lv_val
                            index = sy-index
                            sep = ',' ).

        CATCH cx_sy_strg_par_val.
          EXIT.
      ENDTRY.
    ENDDO.
  ENDMETHOD.
ENDCLASS.
