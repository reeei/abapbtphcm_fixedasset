@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value help for inventory approval'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_INVENTORY_APPROVAL_VH
  as select from zinv_approval
{
      @Search.defaultSearchElement: true
  key inv_appr,
      inv_appr_desc
}
