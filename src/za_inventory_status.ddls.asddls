@EndUserText.label: 'Abstract for inventory status'
define abstract entity ZA_INVENTORY_STATUS
{
  @Consumption.valueHelpDefinition: [ { entity:{ name: 'ZI_INVENTORY_STATUS_VH', element: 'inv_sts' } } ]
  inv_sts : ze_invsts;
}
