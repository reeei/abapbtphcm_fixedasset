CLASS zcl_fixed_asset_obs_call DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS get_fixed_asset_list
      EXPORTING fixed_asset_list TYPE zt_zinventory.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_FIXED_ASSET_OBS_CALL IMPLEMENTATION.


  METHOD get_fixed_asset_list.

    DATA:
      lt_business_data TYPE TABLE OF zfa_scm_s4hc_demo=>tys_yy_1_fixed_asset_apitype,
      lo_http_client   TYPE REF TO if_web_http_client,
      lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request       TYPE REF TO /iwbep/if_cp_request_read_list,
      lo_response      TYPE REF TO /iwbep/if_cp_response_read_lst.

*   DATA:
*     lo_filter_factory   TYPE REF TO /iwbep/if_cp_filter_factory,
*     lo_filter_node_1    TYPE REF TO /iwbep/if_cp_filter_node,
*     lo_filter_node_2    TYPE REF TO /iwbep/if_cp_filter_node,
*     lo_filter_node_root TYPE REF TO /iwbep/if_cp_filter_node,
*     lt_range_COMPANY_CODE TYPE RANGE OF <element_name>,
*     lt_range_MASTER_FIXED_ASSET TYPE RANGE OF <element_name>.

    TRY.
        " Create http client
        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                                     comm_scenario  = 'ZFA_CS_S4HC_DEMO'
                                                     "comm_system_id = '<Comm System Id>'
                                                     service_id     = 'ZFA_OBS_S4HC_DEMO_REST' ).

        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).

        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          EXPORTING
             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      = 'ZFA_SCM_S4HC_DEMO'
                                                 proxy_model_version = '0001' )
            io_http_client             = lo_http_client
            iv_relative_service_root   = '' ).

        ASSERT lo_http_client IS BOUND.


        " Navigate to the resource and create a request for the read operation
        lo_request = lo_client_proxy->create_resource_for_entity_set( 'YY_1_FIXED_ASSET_API' )->create_request_for_read( ).

        " Create the filter tree
*       lo_filter_factory = lo_request->create_filter_factory( ).
*
*       lo_filter_node_1  = lo_filter_factory->create_by_range( iv_property_path     = 'COMPANY_CODE'
*                                                               it_range             = lt_range_COMPANY_CODE ).
*       lo_filter_node_2  = lo_filter_factory->create_by_range( iv_property_path     = 'MASTER_FIXED_ASSET'
*                                                               it_range             = lt_range_MASTER_FIXED_ASSET ).

*       lo_filter_node_root = lo_filter_node_1->and( lo_filter_node_2 ).
*       lo_request->set_filter( lo_filter_node_root ).

        lo_request->set_top( 10 )->set_skip( 0 ).

        " Execute the request and retrieve the business data
        lo_response = lo_request->execute( ).
        lo_response->get_business_data( IMPORTING et_business_data = lt_business_data ).

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        " Handle Exception

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        " Handle Exception
        RAISE SHORTDUMP lx_web_http_client_error.

    ENDTRY.

    fixed_asset_list = VALUE #(
      FOR ls_business_data IN lt_business_data (
        comp_code     = ls_business_data-company_code
        asset_no      = ls_business_data-master_fixed_asset
        asset_subno   = ls_business_data-fixed_asset
        inv_num       = ls_business_data-inventory
        inv_num_desc  = ls_business_data-fixed_asset_description
      )
    ).

  ENDMETHOD.
ENDCLASS.
