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
  methods CONVERT_TIMESTAMP_TO_DATE
    importing
      value(IV_TIMESTAMP) type TIMESTAMP
    exporting
      value(EV_DATE) type DATUM
      value(EV_TIME) type UZEIT .
  methods CONVERT_DATE_TO_TIMESTAMP
    importing
      value(IV_DATE) type DATUM default SY-DATUM
      value(IV_TIME) type UZEIT default SY-UZEIT
      value(EV_TIMESTAMP) type TIMESTAMP optional .
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


  METHOD convert_date_to_timestamp.
    CONVERT DATE iv_date TIME iv_time
     INTO TIME STAMP ev_timestamp
     TIME ZONE sy-zonlo.
  ENDMETHOD.


  METHOD convert_date_to_user.
    ev_converted_date = |{ iv_date DATE = USER }|.
  ENDMETHOD.


  METHOD convert_timestamp_to_date.
    CONVERT TIME STAMP iv_timestamp TIME ZONE sy-zonlo INTO
              DATE ev_date TIME ev_time.
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
