@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value help for inventory status'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_INVENTORY_STATUS_VH
  as select from zinv_status
{
  @Search.defaultSearchElement: true
  key inv_sts,
      inv_sts_desc
}
