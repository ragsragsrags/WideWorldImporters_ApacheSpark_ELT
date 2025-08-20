SELECT 
	(SELECT COUNT(*) FROM DimCity) AS DimCity_Count,
	(SELECT COUNT(*) FROM DimCustomer) AS DimCustomer_Count,
	(SELECT COUNT(*) FROM DimEmployee) AS DimEmpmloyee_Count,
	(SELECT COUNT(*) FROM DimPaymentMethod) AS DimPaymentMethod_Count,
	(SELECT COUNT(*) FROM DimStockItem) AS DimStockItem_Count,
	(SELECT COUNT(*) FROM DimSupplier) AS DimSupplier_Count,
	(SELECT COUNT(*) FROM DimTransactionType) AS DimTransactionType_Count,
	(SELECT COUNT(*) FROM FctMovement) AS FctMovement_Count,
	(SELECT COUNT(*) FROM FctOrder) AS FctOrder_Count,
	(SELECT COUNT(*) FROM FctPurchase) AS FctPurchase_Count,
	(SELECT COUNT(*) FROM FctSale) AS FctSale_Count,
	(SELECT COUNT(*) FROM FctStockHolding) AS FctStockHolding_Count,
	(SELECT COUNT(*) FROM FctTransaction) AS FctTransaction_Count