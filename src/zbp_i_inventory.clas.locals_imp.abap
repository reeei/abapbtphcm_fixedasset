CLASS lhc_ZI_INVENTORY DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

*----- Authorizations Control Methods -----*
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_inventory_bd RESULT result.

*----- Features Control Methods -----*
    METHODS get_global_features FOR GLOBAL FEATURES
      IMPORTING REQUEST requested_features FOR zi_inventory_bd RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_inventory_bd RESULT result.

*----- Actions Control Methods -----*
    "in the case factory action
*    METHODS initFixedAsset FOR MODIFY
*      IMPORTING keys FOR ACTION zi_inventory_bd~initFixedAsset.

    "in the case action
    METHODS initFixedAsset FOR MODIFY
      IMPORTING keys FOR ACTION zi_inventory_bd~initFixedAsset RESULT result.

    METHODS updInventoryStatus FOR MODIFY
      IMPORTING keys FOR ACTION zi_inventory_bd~updInventoryStatus RESULT result.

    METHODS apprInventoryStatus FOR MODIFY
      IMPORTING keys FOR ACTION zi_inventory_bd~apprInventoryStatus RESULT result.

ENDCLASS.

CLASS lhc_ZI_INVENTORY IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_features.

    "result-%delete = if_abap_behv=>fc-o-enabled.
    "result-%action-initFixedAsset = if_abap_behv=>fc-o-enabled.

  ENDMETHOD.

  METHOD get_instance_features.

    "選択済みの行データを取得
    READ ENTITIES OF zi_inventory IN LOCAL MODE
      ENTITY zi_inventory_bd
      FROM VALUE #(
        FOR key IN keys (
          %key-mykey        = key-mykey
          %control-inv_sts  = if_abap_behv=>mk-on
          %control-inv_appr = if_abap_behv=>mk-on
        )
      )
      RESULT DATA(lt_selected).

    "承認状況の区分により活性/非活性化を制御
    result = VALUE #(
                FOR ls_selected IN lt_selected (
                  %key                                  = ls_selected-%key
                  %features-%action-updInventoryStatus  = COND #(
                                                            WHEN ls_selected-inv_appr = '2'     "承認済
                                                              THEN if_abap_behv=>fc-o-disabled
                                                              ELSE if_abap_behv=>fc-o-enabled
                                                          )
                  %features-%action-apprInventoryStatus = COND #(
                                                            WHEN ls_selected-inv_sts = 'C'      "実施済
                                                              THEN if_abap_behv=>fc-o-enabled
                                                              ELSE if_abap_behv=>fc-o-disabled
                                                          )
                )
             ).

  ENDMETHOD.

  METHOD initFixedAsset.

    "データ0件じゃないと実行できないようにする感じ
    SELECT * FROM zinventory INTO TABLE @DATA(lt_zinventory_init_check).
    IF sy-subrc = 0.
      APPEND VALUE #(
        %msg = new_message(
          id        = 'ZCL_MSG_INVENTORY'
          number    = 000
          severity  = if_abap_behv_message=>severity-error
        )
      ) TO reported-zi_inventory_bd.
      RETURN.
    ENDIF.

    "S4HCからの固定資産マスタデータ取得
    DATA lt_fixed_asset_list TYPE zt_zinventory.
    DATA(ins_fixed_asset_obs_call) = NEW zcl_fixed_asset_obs_call(  ).
    ins_fixed_asset_obs_call->get_fixed_asset_list(
      IMPORTING fixed_asset_list = lt_fixed_asset_list
    ).

    "区部値の初期値を取得
    SELECT SINGLE * FROM zinv_status   WHERE inv_sts  = 'A' INTO @DATA(ls_zinv_status_init).
    SELECT SINGLE * FROM zinv_approval WHERE inv_appr = '1' INTO @DATA(ls_zinv_approval_init).

    DATA lt_itab_cr TYPE TABLE FOR CREATE zi_inventory.   "Data Definition root entity physical name
    LOOP AT lt_fixed_asset_list ASSIGNING FIELD-SYMBOL(<ls_fixed_asset_list>).
      APPEND VALUE #(
            %cid          = 'cid' && sy-tabix   "登録用にcontent idを何かしらの値で振る処理が必要
            comp_code     = <ls_fixed_asset_list>-comp_code
            asset_no      = <ls_fixed_asset_list>-asset_no
            asset_subno   = <ls_fixed_asset_list>-asset_subno
            inv_num       = <ls_fixed_asset_list>-inv_num
            inv_num_desc  = <ls_fixed_asset_list>-inv_num_desc
            inv_sts       = ls_zinv_status_init-inv_sts
            inv_sts_desc  = ls_zinv_status_init-inv_sts_desc
            inv_appr      = ls_zinv_approval_init-inv_appr
            inv_appr_desc = ls_zinv_approval_init-inv_appr_desc
       ) TO lt_itab_cr.
    ENDLOOP.

    MODIFY ENTITIES OF zi_inventory IN LOCAL MODE   "Data Definition root entity physical name
      ENTITY zi_inventory_bd                        "Behavior Definitions
        "CREATE OPERATION -- S/4環境から取得した固定資産データで初期化
        CREATE SET FIELDS WITH VALUE #(
          FOR ls_row_cr IN lt_itab_cr (
            %cid          = ls_row_cr-%cid
            comp_code     = ls_row_cr-comp_code
            asset_no      = ls_row_cr-asset_no
            asset_subno   = ls_row_cr-asset_subno
            inv_num       = ls_row_cr-inv_num
            inv_num_desc  = ls_row_cr-inv_num_desc
            inv_sts       = ls_row_cr-inv_sts
            inv_sts_desc  = ls_row_cr-inv_sts_desc
            inv_appr      = ls_row_cr-inv_appr
            inv_appr_desc = ls_row_cr-inv_appr_desc
          )
        )
      FAILED   failed
      REPORTED reported.

    "画面遷移をコントロールする
    "メッセージの件数を動的にする

    APPEND VALUE #(
      %msg = new_message(
        id        = 'ZCL_MSG_INVENTORY'
        number    = 001
        severity  = if_abap_behv_message=>severity-success
        v1        = 100
      )
    ) TO reported-zi_inventory_bd.

  ENDMETHOD.

  METHOD updInventoryStatus.

    "更新予定の区分値情報を取得
    DATA(ls_keys) = keys[ 1 ].
    SELECT SINGLE
      *
      FROM zinv_status
      WHERE inv_sts = @ls_keys-%param-inv_sts
      INTO @DATA(ls_zinv_status_upd).
    IF sy-subrc = 4.
      APPEND VALUE #(
        %msg = new_message(
          id        = 'ZCL_MSG_INVENTORY'
          number    = 002
          severity  = if_abap_behv_message=>severity-error
          v1        = ls_keys-%param-inv_sts
        )
      ) TO reported-zi_inventory_bd.
      RETURN.
    ENDIF.

    MODIFY ENTITIES OF zi_inventory IN LOCAL MODE
      ENTITY zi_inventory_bd
      UPDATE FROM VALUE #(
        FOR key IN keys (
          %key-mykey            = key-mykey
          inv_sts               = ls_zinv_status_upd-inv_sts
          inv_sts_desc          = ls_zinv_status_upd-inv_sts_desc
          %control-inv_sts      = if_abap_behv=>mk-on
          %control-inv_sts_desc = if_abap_behv=>mk-on
         )
      )
      FAILED   failed
      REPORTED reported.

    READ ENTITIES OF zi_inventory IN LOCAL MODE
      ENTITY zi_inventory_bd
      FROM VALUE #(
        FOR key IN keys (
          %key-mykey  = key-mykey
          %control    = VALUE #(
            inv_sts = if_abap_behv=>mk-on
          )
        )
      )
      RESULT DATA(lt_inventory).

    result = VALUE #(
      FOR ls_inventory IN lt_inventory (
        %key-mykey  = ls_inventory-mykey
        %param      = ls_inventory
      )
    ).

  ENDMETHOD.

  METHOD apprInventoryStatus.

    "更新予定の区分値情報を取得
    DATA(ls_keys) = keys[ 1 ].
    SELECT SINGLE
      *
      FROM zinv_approval
      WHERE inv_appr = @ls_keys-%param-inv_appr
      INTO @DATA(ls_zinv_approval_upd).
    IF sy-subrc = 4.
      APPEND VALUE #(
        %msg = new_message(
          id        = 'ZCL_MSG_INVENTORY'
          number    = 002
          severity  = if_abap_behv_message=>severity-error
          v1        = ls_keys-%param-inv_appr
        )
      ) TO reported-zi_inventory_bd.
      RETURN.
    ENDIF.

    MODIFY ENTITIES OF zi_inventory IN LOCAL MODE
      ENTITY zi_inventory_bd
      UPDATE FROM VALUE #(
        FOR key IN keys (
          %key-mykey              = key-mykey
          inv_appr                = ls_zinv_approval_upd-inv_appr
          inv_appr_desc           = ls_zinv_approval_upd-inv_appr_desc
          %control-inv_appr       = if_abap_behv=>mk-on
          %control-inv_appr_desc  = if_abap_behv=>mk-on
         )
      )
      FAILED   failed
      REPORTED reported.

    READ ENTITIES OF zi_inventory IN LOCAL MODE
      ENTITY zi_inventory_bd
      FROM VALUE #(
        FOR key IN keys (
          %key-mykey  = key-mykey
          %control    = VALUE #(
            inv_appr = if_abap_behv=>mk-on
          )
        )
      )
      RESULT DATA(lt_inventory).

    result = VALUE #(
      FOR ls_inventory IN lt_inventory (
        %key-mykey        = ls_inventory-mykey
        %param            = ls_inventory
      )
    ).

  ENDMETHOD.

ENDCLASS.
