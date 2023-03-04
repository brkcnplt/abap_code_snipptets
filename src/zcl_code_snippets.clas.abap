class ZCL_CODE_SNIPPETS definition
  public
  create public .

public section.
protected section.
private section.

  methods GET_CONFIRMED_VALUES
    exporting
      value(EV_VSTELLE) type STRING
      value(ER_VSTELLE) type ref to CL_CRM_BOL_ENTITY
      value(EV_BUAG_ID) type CRMT_BUAG_EI_ID
      value(ER_BUAG_ID) type ref to CL_CRM_BOL_ENTITY
      value(EV_PARTNER) type BU_PARTNER
      value(ER_PARTNER) type ref to CL_CRM_BOL_ENTITY .
ENDCLASS.



CLASS ZCL_CODE_SNIPPETS IMPLEMENTATION.


  METHOD get_confirmed_values.
    DATA:
      lr_context TYPE REF TO if_crm_ui_data_context,
      lr_entity  TYPE REF TO cl_crm_bol_entity.

    TRY .
        lr_context = cl_crm_ui_data_context_srv=>get_instance( ).

        IF ev_vstelle IS REQUESTED OR
           er_vstelle IS REQUESTED.
          lr_entity ?= lr_context->get_entity( name = cl_iuicmd_cucomd_impl=>gc_currentpremise ).
          er_vstelle ?= lr_entity.
          IF lr_entity IS BOUND.
            CALL METHOD lr_entity->get_property_as_value
              EXPORTING
                iv_attr_name = 'VS_VSTELLE'
              IMPORTING
                ev_result    = ev_vstelle.
          ENDIF.
        ENDIF.

        IF ev_buag_id IS REQUESTED.
          lr_entity ?= lr_context->get_entity( name = cl_iuicmd_cucomd_impl=>gc_currentbuag ).
          er_buag_id = lr_entity.
          IF lr_entity IS BOUND.
            CALL METHOD lr_entity->get_property_as_value
              EXPORTING
                iv_attr_name = 'BUAG_ID'
              IMPORTING
                ev_result    = ev_buag_id.
          ENDIF.
        ENDIF.

        IF ev_partner IS REQUESTED OR
           er_partner IS REQUESTED.
          lr_entity ?= lr_context->get_entity( name = cl_iuicmd_cucomd_impl=>gc_currentcustomer ).
          er_partner = lr_entity.
          IF lr_entity IS BOUND.
            CALL METHOD lr_entity->get_property_as_value
              EXPORTING
                iv_attr_name = 'BP_NUMBER'
              IMPORTING
                ev_result    = ev_partner.
          ENDIF.
        ENDIF.


      CATCH cx_root.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
