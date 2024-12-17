@EndUserText.label: 'Data model for inventory'
@AccessControl.authorizationCheck: #NOT_REQUIRED

define root view entity ZI_INVENTORY
  as select from zinventory as ZI_INVENTORY_DD
{
  key mykey,
      comp_code,
      asset_no,
      asset_subno,
      inv_num,
      inv_num_desc,
      inv_sts,
      inv_sts_desc,
      inv_appr,
      inv_appr_desc
}
