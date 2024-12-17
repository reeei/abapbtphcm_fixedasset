@EndUserText.label: 'Projection view for inventory'
@AccessControl.authorizationCheck: #NOT_REQUIRED

@Search.searchable: true //エンティティ検索可能

define root view entity ZC_INVENTORY
  as projection on ZI_INVENTORY as ZC_INVENTORY_DD
{
      -- 全体設定＋詳細画面の有効化
      @UI.facet: [ {
        id:              'general',
        purpose:         #STANDARD,
        type:            #IDENTIFICATION_REFERENCE,
        label:           'Inventory',
        position:        10 } ]

      @UI.hidden: true
  key mykey,

      @UI: {
        selectionField: [ { position: 10 } ],  -- 検索項目への表示
        lineItem:       [ { position: 10, importance: #MEDIUM },  -- 列への表示
                            -- Action Lineitem
                            -- This property has to be assigned to some arbitrary element.
                            -- It is thereby irrelevant if the property refers to the element to which the property is assigned.
                          { type: #FOR_ACTION, dataAction: 'updInventoryStatus',  label: '棚卸状況更新' },
                          { type: #FOR_ACTION, dataAction: 'apprInventoryStatus', label: '承認ステータス更新' },
                          { type: #FOR_ACTION, dataAction: 'initFixedAsset',      label: '初期登録' } ],
        identification: [ { position: 10 } ] }  -- 詳細画面への表示
      @Search.defaultSearchElement: true -- 検索条件1番左の曖昧検索BOXでの引っ掛けを有効化
      //@ObjectModel.text.element: ['<data element name>']  -- ラベル上書き、割当にデータエレメントの作成が必要
      comp_code,

      @UI: {
        selectionField: [ { position: 20 } ],
        lineItem:       [ { position: 20, importance: #MEDIUM } ],
        identification: [ { position: 20 } ] }
      @Search.defaultSearchElement: true
      asset_no,

      @UI: {
        selectionField: [ { position: 30 } ],
        lineItem:       [ { position: 30, importance: #MEDIUM } ],
        identification: [ { position: 30 } ] }
      @Search.defaultSearchElement: true
      asset_subno,

      @UI: {
        selectionField: [ { position: 40 } ],
        lineItem:       [ { position: 40, importance: #MEDIUM } ],
        identification: [ { position: 40 } ] }
      @Search.defaultSearchElement: true
      inv_num,
      
      @UI: {
        selectionField: [ { position: 50 } ],
        lineItem:       [ { position: 50, importance: #MEDIUM } ],
        identification: [ { position: 50 } ] }
      @Search.defaultSearchElement: true
      inv_num_desc,

      @UI: {
        selectionField: [ { position: 60 } ],
        lineItem:       [ { position: 60, importance: #MEDIUM } ],
        identification: [ { position: 60 } ] }
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [ { entity:{ name: 'ZI_INVENTORY_STATUS_VH', element: 'inv_sts' } } ]
      inv_sts,

      @UI: {
        selectionField: [ { position: 70 } ],
        lineItem:       [ { position: 70, importance: #MEDIUM } ],
        identification: [ { position: 70 } ] }
      @Search.defaultSearchElement: true      
      inv_sts_desc,

      @UI: {
        selectionField: [ { position: 80 } ],
        lineItem:       [ { position: 80, importance: #MEDIUM } ],
        identification: [ { position: 80 } ] }
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [ { entity:{ name: 'ZI_INVENTORY_APPROVAL_VH', element: 'inv_appr' } } ]      
      inv_appr,
      
      @UI: {
        selectionField: [ { position: 90 } ],
        lineItem:       [ { position: 90, importance: #MEDIUM } ],
        identification: [ { position: 90 } ] }
      @Search.defaultSearchElement: true      
      inv_appr_desc
}
