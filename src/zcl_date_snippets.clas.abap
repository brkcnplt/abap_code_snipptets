class ZCL_DATE_SNIPPETS definition
  public
  inheriting from ZCL_CODE_SNIPPETS
  final
  create public .

public section.

  methods CONVERT_DATE_TO_ISO
    importing
      value(IV_DATE) type SY-DATUM default SY-DATUM
    returning
      value(EV_CONVERTED_DATE) type STRING .
  methods CONVERT_DATE_TO_USER
    importing
      value(IV_DATE) type SY-DATUM default SY-DATUM
    returning
      value(EV_CONVERTED_DATE) type STRING .
  methods CONVERT_DATE_TO_ENVIRONMENT
    importing
      value(IV_DATE) type SY-DATUM default SY-DATUM
    returning
      value(EV_CONVERTED_DATE) type STRING .
  methods DAY_MONTH_YEAR_DIFF_BT_TWO_DAT
    importing
      value(IV_DATE_FROM) type VTBBEWE-DBERVON
      value(IV_DATE_TO) type VTBBEWE-DBERBIS
    exporting
      value(EV_DAY) type VTBBEWE-ATAGE
      value(EV_MONTH) type VTBBEWE-ATAGE
      value(EV_YEAR) type VTBBEWE-ATAGE
    exceptions
      EXCEPTION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_DATE_SNIPPETS IMPLEMENTATION.


  method CONVERT_DATE_TO_ENVIRONMENT.
       ev_converted_date = |{ iv_date DATE = ENVIRONMENT }|.
  endmethod.


  METHOD convert_date_to_iso.
    ev_converted_date = |{ iv_date DATE = ISO }|.
  ENDMETHOD.


  METHOD convert_date_to_user.
    ev_converted_date = |{ iv_date DATE = USER }|.
  ENDMETHOD.


  METHOD day_month_year_diff_bt_two_dat.

    IF iv_date_to LT iv_date_from.
      RAISE exception.
    ENDIF.

    CALL FUNCTION 'FIMA_DAYS_AND_MONTHS_AND_YEARS'
      EXPORTING
        i_date_from = iv_date_from
        i_date_to   = iv_date_to
      IMPORTING
        e_days      = ev_day
        e_months    = ev_month
        e_years     = ev_year.

  ENDMETHOD.
ENDCLASS.
