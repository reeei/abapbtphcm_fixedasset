"! <p class="shorttext synchronized">Consumption model for client proxy - generated</p>
"! This class has been generated based on the metadata with namespace
"! <em>YY1_FIXEDASSET_API_CDS</em>
CLASS zfa_scm_s4hc_demo DEFINITION
  PUBLIC
  INHERITING FROM /iwbep/cl_v4_abs_pm_model_prov
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      "! <p class="shorttext synchronized">YY1_FixedAsset_APIType</p>
      BEGIN OF tys_yy_1_fixed_asset_apitype,
        "! <em>Key property</em> CompanyCode
        company_code            TYPE c LENGTH 4,
        "! <em>Key property</em> MasterFixedAsset
        master_fixed_asset      TYPE c LENGTH 12,
        "! <em>Key property</em> FixedAsset
        fixed_asset             TYPE c LENGTH 4,
        "! Inventory
        inventory               TYPE c LENGTH 25,
        "! FixedAssetDescription
        fixed_asset_description TYPE c LENGTH 50,
      END OF tys_yy_1_fixed_asset_apitype,
      "! <p class="shorttext synchronized">List of YY1_FixedAsset_APIType</p>
      tyt_yy_1_fixed_asset_apitype TYPE STANDARD TABLE OF tys_yy_1_fixed_asset_apitype WITH DEFAULT KEY.


    CONSTANTS:
      "! <p class="shorttext synchronized">Internal Names of the entity sets</p>
      BEGIN OF gcs_entity_set,
        "! YY1_FixedAsset_API
        "! <br/> Collection of type 'YY1_FixedAsset_APIType'
        yy_1_fixed_asset_api TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'YY_1_FIXED_ASSET_API',
      END OF gcs_entity_set .

    CONSTANTS:
      "! <p class="shorttext synchronized">Internal names for entity types</p>
      BEGIN OF gcs_entity_type,
        "! <p class="shorttext synchronized">Internal names for YY1_FixedAsset_APIType</p>
        "! See also structure type {@link ..tys_yy_1_fixed_asset_apitype}
        BEGIN OF yy_1_fixed_asset_apitype,
          "! <p class="shorttext synchronized">Navigation properties</p>
          BEGIN OF navigation,
            "! Dummy field - Structure must not be empty
            dummy TYPE int1 VALUE 0,
          END OF navigation,
        END OF yy_1_fixed_asset_apitype,
      END OF gcs_entity_type.


    METHODS /iwbep/if_v4_mp_basic_pm~define REDEFINITION.


  PRIVATE SECTION.

    "! <p class="shorttext synchronized">Model</p>
    DATA mo_model TYPE REF TO /iwbep/if_v4_pm_model.


    "! <p class="shorttext synchronized">Define YY1_FixedAsset_APIType</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized">Gateway Exception</p>
    METHODS def_yy_1_fixed_asset_apitype RAISING /iwbep/cx_gateway.

ENDCLASS.



CLASS ZFA_SCM_S4HC_DEMO IMPLEMENTATION.


  METHOD /iwbep/if_v4_mp_basic_pm~define.

    mo_model = io_model.
    mo_model->set_schema_namespace( 'YY1_FIXEDASSET_API_CDS' ) ##NO_TEXT.

    def_yy_1_fixed_asset_apitype( ).

  ENDMETHOD.


  METHOD def_yy_1_fixed_asset_apitype.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'YY_1_FIXED_ASSET_APITYPE'
                                    is_structure              = VALUE tys_yy_1_fixed_asset_apitype( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'YY1_FixedAsset_APIType' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'YY_1_FIXED_ASSET_API' ).
    lo_entity_set->set_edm_name( 'YY1_FixedAsset_API' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'COMPANY_CODE' ).
    lo_primitive_property->set_edm_name( 'CompanyCode' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'MASTER_FIXED_ASSET' ).
    lo_primitive_property->set_edm_name( 'MasterFixedAsset' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 12 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FIXED_ASSET' ).
    lo_primitive_property->set_edm_name( 'FixedAsset' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ) ##NUMBER_OK.
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'INVENTORY' ).
    lo_primitive_property->set_edm_name( 'Inventory' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 25 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FIXED_ASSET_DESCRIPTION' ).
    lo_primitive_property->set_edm_name( 'FixedAssetDescription' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 50 ) ##NUMBER_OK.
    lo_primitive_property->set_is_nullable( ).

  ENDMETHOD.
ENDCLASS.
