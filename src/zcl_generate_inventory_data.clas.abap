CLASS zcl_generate_inventory_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GENERATE_INVENTORY_DATA IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*    DATA itab TYPE TABLE OF zinventory.
*    itab = VALUE #(
*        ( mykey         = '02D5290E594C1EDA93815057FD946624'
*          comp_code     = '1100'
*          asset_no      = '000010000000'
*          asset_subno   = '0000'
*          inv_num       = '100'
*          inv_num_desc  = 'code 100'
*          inv_sts       = 'A'
*          inv_sts_desc  = '未実施'
*          inv_appr      = '1'
*          inv_appr_desc = '未承認'
*        )
*        ( mykey         = '02D5290E594C1EDA93815C50CD7AE62A'
*          comp_code     = '1100'
*          asset_no      = '000020000000'
*          asset_subno   = '0000'
*          inv_num       = '200'
*          inv_num_desc  = 'code 200'
*          inv_sts       = 'A'
*          inv_sts_desc  = '未実施'
*          inv_appr      = '1'
*          inv_appr_desc = '未承認'
*        )
*        ( mykey         = '02D5290E594C1EDA93858EED2DA2EB0B'
*          comp_code     = '1100'
*          asset_no      = '000030000000'
*          asset_subno   = '0000'
*          inv_num       = '300'
*          inv_num_desc  = 'code 300'
*          inv_sts       = 'A'
*          inv_sts_desc  = '未実施'
*          inv_appr      = '1'
*          inv_appr_desc = '未承認'
*        )
*    ).
*    DELETE FROM zinventory.
*    INSERT zinventory FROM TABLE @itab.
    "DELETE FROM zinventory.

*    DATA itab TYPE TABLE OF zinv_status.
*    itab = VALUE #(
*      ( inv_sts = 'A'
*        inv_sts_desc = '未実施'
*      )
*      ( inv_sts = 'B'
*        inv_sts_desc = '実施中'
*      )
*      ( inv_sts = 'C'
*        inv_sts_desc = '実施済'
*      )
*    ).
*    DELETE FROM zinv_status.
*    INSERT zinv_status FROM TABLE @itab.

    DATA itab TYPE TABLE OF zinv_approval.
    itab = VALUE #(
      ( inv_appr = '1'
        inv_appr_desc = '未承認'
      )
      ( inv_appr = '2'
        inv_appr_desc = '承認済'
      )
      ( inv_appr = '3'
        inv_appr_desc = '差戻し'
      )
    ).
    DELETE FROM zinv_approval.
    INSERT zinv_approval FROM TABLE @itab.

    out->write( |{ sy-dbcnt } entries inserted| ).

  ENDMETHOD.
ENDCLASS.
