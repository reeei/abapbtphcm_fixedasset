@EndUserText.label: 'Abstract for inventory approval'
define abstract entity ZA_INVENTORY_APPROVAL
{
  @Consumption.valueHelpDefinition: [ { entity:{ name: 'ZI_INVENTORY_APPROVAL_VH', element: 'inv_appr' } } ]
  inv_appr : ze_invappr;
}
