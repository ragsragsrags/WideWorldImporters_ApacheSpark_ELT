WITH Vars AS (
    SELECT DATETIME('2025-01-01') AS NewCutoff
)
SELECT
	-- City Count
	(
		SELECT
			COUNT(*) 
		FROM
			(
				SELECT
					C.CityID,
					C.StateProvinceID
				FROM
					Cities C JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(C.ValidFrom) AND 
					(
						DATETIME(C.ValidTo) OR 
						DATETIME(C.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					CA.CityID,
					CA.StateProvinceID
				FROM
					Cities_Archive CA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(CA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(CA.ValidTo) OR 
						DATETIME(CA.ValidTo) IS NULL
					)
			) C LEFT JOIN
			(
				SELECT
					SP.StateProvinceID,
					SP.CountryID
				FROM
					StateProvinces SP JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(SP.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(SP.ValidTo) OR
						DATETIME(SP.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					SPA.StateProvinceID,
					SPA.CountryID
				FROM
					StateProvinces_Archive SPA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(SPA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(SPA.ValidTo) OR
						DATETIME(SPA.ValidTo) IS NULL
					)
			) SP ON
				SP.StateProvinceID = C.StateProvinceID LEFT JOIN
			(
				SELECT
					C.CountryID 
				FROM
					Countries C JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(C.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(C.ValidTo) OR
						DATETIME(C.ValidTo) IS NULL
					) 
	
				UNION
	
				SELECT
					CA.CountryID
				FROM
					Countries_Archive CA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(CA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(CA.ValidTo) OR
						DATETIME(CA.ValidTo) IS NULL
					) 
			) CA ON
				CA.CountryID = SP.CountryID
	) AS City_Count,
	-- Customer_Count
	(
		SELECT
			COUNT(*)
		FROM
			(
				SELECT 
					C.CustomerID,
					C.BillToCustomerID,
					C.CustomerCategoryID,
					C.PrimaryContactPersonID,
					C.BuyingGroupID
				FROM
					Customers C JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(C.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(C.ValidTo) OR
						DATETIME(C.ValidTo) IS NULL
					)
		
				UNION
		
				SELECT 
					CA.CustomerID,
					CA.BillToCustomerID,
					CA.CustomerCategoryID,
					CA.PrimaryContactPersonID,
					CA.BuyingGroupID
				FROM
					Customers_Archive CA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(CA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(CA.ValidTo) OR
						DATETIME(CA.ValidTo) IS NULL
					)
			) C LEFT JOIN
			(
				SELECT 
					C.CustomerID
				FROM
					Customers C JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(C.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(C.ValidTo) OR
						DATETIME(C.ValidTo) IS NULL
					)
		
				UNION
		
				SELECT 
					CA.CustomerID
				FROM
					Customers_Archive CA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(CA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(CA.ValidTo) OR
						DATETIME(CA.ValidTo) IS NULL
					)
			) BC ON
				BC.CustomerID = C.BillToCustomerID LEFT JOIN
			(
				SELECT
					CC.CustomerCategoryID
				FROM
					CustomerCategories CC  JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(CC.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(CC.ValidTo) OR
						DATETIME(CC.ValidTo) IS NULL
					)
		
				UNION
		
				SELECT
					CCA.CustomerCategoryID
				FROM
					CustomerCategories_Archive CCA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(CCA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(CCA.ValidTo) OR
						DATETIME(CCA.ValidTo) IS NULL
					)
			) CC ON
				CC.CustomerCategoryID = C.CustomerCategoryID LEFT JOIN
			(
				SELECT
					P.PersonID
				FROM
					People P JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(P.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(P.ValidTo) OR
						DATETIME(P.ValidTo) IS NULL
					)
		
				UNION
		
				SELECT
					PA.PersonID
				FROM
					People_Archive PA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(PA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(PA.ValidTo) OR
						DATETIME(PA.ValidTo) IS NULL
					)
			) PA ON
				PA.PersonID = C.PrimaryContactPersonID LEFT JOIN
			(
				SELECT
					BG.BuyingGroupID
				FROM
					BuyingGroups BG JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(BG.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(BG.ValidTo) OR
						DATETIME(BG.ValidTo) IS NULL
					)
		
				UNION
		
				SELECT
					BGA.BuyingGroupID 
				FROM
					BuyingGroups_Archive BGA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(BGA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(BGA.ValidTo) OR
						DATETIME(BGA.ValidTo) IS NULL
					)
			) BG ON
				BG.BuyingGroupID = C.BuyingGroupID
	) AS Customer_Count,
	-- Employee Count
	(
		SELECT
			COUNT(*)
		FROM
		(
			SELECT 
				P.PersonID
			FROM 
				People P JOIN
				Vars V ON
					1 = 1
			WHERE
				P.IsEmployee = 1 AND
				DATETIME(V.NewCutoff) >= DATETIME(P.ValidFrom) AND 
				(
					DATETIME(V.NewCutoff) <= DATETIME(P.ValidTo) OR
					DATETIME(P.ValidTo) IS NULL
				)
	
			UNION
	
			SELECT 
				PA.PersonID
			FROM 
				People_Archive PA JOIN
				Vars V ON
					1 = 1
			WHERE
				PA.IsEmployee = 1 AND
				DATETIME(V.NewCutoff) >= DATETIME(PA.ValidFrom) AND 
				(
					DATETIME(V.NewCutoff) <= DATETIME(PA.ValidTo) OR
					DATETIME(PA.ValidTo) IS NULL
				)
		) E
	) AS Employee_Count,
	-- Payment Method Count
	(
		SELECT
			COUNT(*)
		FROM
		(
			SELECT
				PM.PaymentMethodID
			FROM
				PaymentMethods PM JOIN
				Vars V ON
					1 = 1
			WHERE
				DATETIME(V.NewCutoff) >= DATETIME(PM.ValidFrom) AND 
				(
					DATETIME(V.NewCutoff) <= DATETIME(PM.ValidTo) OR
					DATETIME(PM.ValidTo) IS NULL
				)
	
			UNION
	
			SELECT
				PMA.PaymentMethodID
			FROM
				PaymentMethods_Archive PMA JOIN
				Vars V ON
					1 = 1
			WHERE
				DATETIME(V.NewCutoff) >= DATETIME(PMA.ValidFrom) AND 
				(
					DATETIME(V.NewCutoff) <= DATETIME(PMA.ValidTo) OR
					DATETIME(PMA.ValidTo) IS NULL
				)
		) PM
	) AS PaymentMethod_Count,
	-- Stock Item Count
	(
		SELECT
			COUNT(*)
		FROM
			(
				SELECT
					SI.StockItemID,
					SI.ColorID,
					SI.OuterPackageID,
					SI.UnitPackageID
				FROM
					StockItems SI JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(SI.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(SI.ValidTo) OR
						DATETIME(SI.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					SIA.StockItemID,
					SIA.ColorID,
					SIA.OuterPackageID,
					SIA.UnitPackageID
				FROM
					StockItems_Archive SIA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(SIA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(SIA.ValidTo) OR
						DATETIME(SIA.ValidTo) IS NULL
					)
			) SI LEFT JOIN
			(
				SELECT
					C.ColorID
				FROM
					Colors C JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(C.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(C.ValidTo) OR
						DATETIME(C.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					CA.ColorID
				FROM
					Colors_Archive CA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(CA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(CA.ValidTo) OR
						DATETIME(CA.ValidTo) IS NULL
					)
			) C ON
				C.ColorID = SI.ColorID LEFT JOIN
			(
				SELECT
					PT.PackageTypeID
				FROM
					PackageTypes PT JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(PT.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(PT.ValidTo) OR
						DATETIME(PT.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					PTA.PackageTypeID
				FROM
					PackageTypes_Archive PTA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(PTA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(PTA.ValidTo) OR
						DATETIME(PTA.ValidTo) IS NULL
					)
			) SP ON
				SP.PackageTypeID = SI.UnitPackageID LEFT JOIN
			(
				SELECT
					PT.PackageTypeID
				FROM
					PackageTypes PT JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(PT.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(PT.ValidTo) OR
						DATETIME(PT.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					PTA.PackageTypeID
				FROM
					PackageTypes_Archive PTA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(PTA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(PTA.ValidTo) OR
						DATETIME(PTA.ValidTo) IS NULL
					)
			) BP ON
				BP.PackageTypeID = SI.OuterPackageID
	) AS StockItem_Count,
	(
		SELECT
			COUNT(*)
		FROM
			(
				SELECT 
					S.SupplierID,
					S.SupplierCategoryID,
					S.PrimaryContactPersonID
				FROM 
					Suppliers S JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(S.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(S.ValidTo) OR
						DATETIME(S.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					SA.SupplierID,
					SA.SupplierCategoryID,
					SA.PrimaryContactPersonID
				FROM
					Suppliers_Archive SA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(SA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(SA.ValidTo) OR
						DATETIME(SA.ValidTo) IS NULL
					)
			) S LEFT JOIN
			(
				SELECT 
					SC.SupplierCategoryID
				FROM
					SupplierCategories SC JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(SC.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(SC.ValidTo) OR
						DATETIME(SC.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					SCA.SupplierCategoryID
				FROM
					SupplierCategories_Archive SCA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(SCA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(SCA.ValidTo) OR
						DATETIME(SCA.ValidTo) IS NULL
					)
			) SC ON
				SC.SupplierCategoryID = S.SupplierCategoryID LEFT JOIN
			(
				SELECT
					P.PersonID
				FROM
					People P JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(P.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(P.ValidTo) OR
						DATETIME(P.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					PA.PersonID
				FROM
					People_Archive PA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(PA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(PA.ValidTo) OR
						DATETIME(PA.ValidTo) IS NULL
					)
			) P ON
				P.PersonID = S.PrimaryContactPersonID
	) AS Supplier_Count,
	-- Transaction Type Count
	(
		SELECT
			COUNT(*)
		FROM
		(
			SELECT
				TT.TransactionTypeID
			FROM
				TransactionTypes TT JOIN
				Vars V ON
					1 = 1
			WHERE
				DATETIME(V.NewCutoff) >= DATETIME(TT.ValidFrom) AND 
				(
					DATETIME(V.NewCutoff) <= DATETIME(TT.ValidTo) OR
					DATETIME(TT.ValidTo) IS NULL
				)
	
			UNION 
	
			SELECT
				TTA.TransactionTypeID
			FROM
				TransactionTypes_Archive TTA JOIN
				Vars V ON
					1 = 1
			WHERE
				DATETIME(V.NewCutoff) >= DATETIME(TTA.ValidFrom) AND 
				(
					DATETIME(V.NewCutoff) <= DATETIME(TTA.ValidTo) OR
					DATETIME(TTA.ValidTo) IS NULL
				)
		) TT
	) AS TransactionType_Count,
	-- Movement Count
	(
		SELECT
			COUNT(*)
		FROM
			StockItemTransactions SIT JOIN
			Vars V ON
				1 = 1 LEFT JOIN
			(
				SELECT
					SI.StockItemID,
					SI.StockItemName
				FROM
					StockItems SI JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(SI.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(SI.ValidTo) OR
						DATETIME(SI.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					SIA.StockItemID,
					SIA.StockItemName
				FROM
					StockItems_Archive SIA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(SIA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(SIA.ValidTo) OR
						DATETIME(SIA.ValidTo) IS NULL
					)
			) SI ON
				SI.StockItemID = SIT.StockItemID LEFT JOIN
			(
				SELECT
					C.CustomerID,
					C.CustomerName
				FROM
					Customers C JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(C.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(C.ValidTo) OR
						DATETIME(C.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					CA.CustomerID,
					CA.CustomerName
				FROM
					Customers_Archive CA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(CA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(CA.ValidTo) OR
						DATETIME(CA.ValidTo) IS NULL
					)
			) C ON 
				C.CustomerID = SIT.CustomerID LEFT JOIN
			(
				SELECT
					S.SupplierID,
					S.SupplierName
				FROM
					Suppliers S JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(S.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(S.ValidTo) OR
						DATETIME(S.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					SA.SupplierID,
					SA.SupplierName
				FROM
					Suppliers_Archive SA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(SA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(SA.ValidTo) OR
						DATETIME(SA.ValidTo) IS NULL
					)
			) S ON 
				S.SupplierID = SIT.SupplierID LEFT JOIN
			(
				SELECT
					TT.TransactionTypeID,
					TT.TransactionTypeName
				FROM
					TransactionTypes TT JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(TT.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(TT.ValidTo) OR
						DATETIME(TT.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					TTA.TransactionTypeID,
					TTA.TransactionTypeName
				FROM
					TransactionTypes_Archive TTA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(TTA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(TTA.ValidTo) OR
						DATETIME(TTA.ValidTo) IS NULL
					)
			) TT ON 
				TT.TransactionTypeID = SIT.TransactionTypeID
		WHERE
			SIT.LastEditedWhen <= DATETIME(V.NewCutoff)
	) AS Movement_Count,
	-- Order Count
	(
		SELECT
			COUNT(*)
		FROM
			Orders O JOIN
			Vars V ON
				1 = 1 LEFT JOIN
			OrderLines OL ON
				OL.OrderID = O.OrderID LEFT JOIN 
			(
				SELECT
					C.CustomerID,
					C.DeliveryCityID
				FROM
					Customers C JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(C.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(C.ValidTo) OR
						DATETIME(C.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					CA.CustomerID,
					CA.DeliveryCityID
				FROM
					Customers_Archive CA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(CA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(CA.ValidTo) OR
						DATETIME(CA.ValidTo) IS NULL
					)
			) C ON
				C.CustomerID = O.CustomerID LEFT JOIN
			(
				SELECT
					C.CityID
				FROM
					Cities C JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(C.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(C.ValidTo) OR
						DATETIME(C.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					CA.CityID
				FROM
					Cities_Archive CA  JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(CA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(CA.ValidTo) OR
						DATETIME(CA.ValidTo) IS NULL
					)
			) CI ON
				CI.CityID = C.DeliveryCityID LEFT JOIN
			(
				SELECT
					SI.StockItemID
				FROM
					StockItems SI JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(SI.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(SI.ValidTo) OR
						DATETIME(SI.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					SIA.StockItemID
				FROM
					StockItems_Archive SIA  JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(SIA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(SIA.ValidTo) OR
						DATETIME(SIA.ValidTo) IS NULL
					)
			) SI ON
				SI.StockItemID = OL.StockItemID LEFT JOIN
			(
				SELECT
					P.PersonID,
					P.FullName
				FROM
					People P  JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(P.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(P.ValidTo) OR
						DATETIME(P.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					PA.PersonID,
					PA.FullName
				FROM
					People_Archive PA  JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(PA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(PA.ValidTo) OR
						DATETIME(PA.ValidTo) IS NULL
					)
			) P ON
				P.PersonID = O.SalespersonPersonID LEFT JOIN
			(
				SELECT
					P.PersonID,
					P.FullName
				FROM
					People P JOIN
					Vars V ON
						1 = 1 
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(P.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(P.ValidTo) OR
						DATETIME(P.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					PA.PersonID,
					PA.FullName
				FROM
					People_Archive PA  JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(PA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(PA.ValidTo) OR
						DATETIME(PA.ValidTo) IS NULL
					)
			) P2 ON
				P2.PersonID = O.PickedByPersonID LEFT JOIN
			(
				SELECT
					PT.PackageTypeID,
					PT.PackageTypeName
				FROM
					PackageTypes PT  JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(PT.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(PT.ValidTo) OR
						DATETIME(PT.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					PTA.PackageTypeID,
					PTA.PackageTypeName
				FROM
					PackageTypes_Archive PTA  JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(PTA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(PTA.ValidTo) OR
						DATETIME(PTA.ValidTo) IS NULL
					)
			) PT ON
				PT.PackageTypeID = OL.PackageTypeID
		WHERE
			O.LastEditedWhen <= DATETIME(V.NewCutoff) OR
			OL.LastEditedWhen <= DATETIME(V.NewCutoff)
	) AS Order_Count,
	-- Purchase Count
	(
		SELECT
			COUNT(*)
		FROM
			PurchaseOrders PO JOIN
			Vars V ON
				1 = 1 LEFT JOIN
			PurchaseOrderLines POL ON
				POL.PurchaseOrderID = PO.PurchaseOrderID LEFT JOIN
			(
				SELECT 
					S.SupplierID
				FROM
					Suppliers S JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(S.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(S.ValidTo) OR
						DATETIME(S.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT 
					SA.SupplierID
				FROM
					Suppliers_Archive SA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(SA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(SA.ValidTo) OR
						DATETIME(SA.ValidTo) IS NULL
					)
			) S ON
				S.SupplierID = PO.SupplierID LEFT JOIN
			(
				SELECT
					SI.StockItemID
				FROM
					StockItems SI JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(SI.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(SI.ValidTo) OR
						DATETIME(SI.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					SIA.StockItemID
				FROM
					StockItems_Archive SIA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(SIA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(SIA.ValidTo) OR
						DATETIME(SIA.ValidTo) IS NULL
					)
			) SI ON
				SI.StockItemID = POL.StockItemID LEFT JOIN
			(
				SELECT
					PT.PackageTypeID
				FROM
					PackageTypes PT JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(PT.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(PT.ValidTo) OR
						DATETIME(PT.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					PTA.PackageTypeID
				FROM
					PackageTypes_Archive PTA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(PTA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(PTA.ValidTo) OR
						DATETIME(PTA.ValidTo) IS NULL
					)
			) PT ON
				PT.PackageTypeID = POL.PackageTypeID
		WHERE
			PO.LastEditedWhen <= DATETIME(V.NewCutoff) OR
			POL.LastEditedWhen <= DATETIME(V.NewCutoff)
	) AS Purchase_Count,
	-- Sale Count
	(
		SELECT
			COUNT(*)
		FROM
			Invoices I JOIN
			Vars V ON
				1 = 1 LEFT JOIN
			InvoiceLines IL ON
				IL.InvoiceID = I.InvoiceID LEFT JOIN
			(
				SELECT
					C.CustomerID,
					C.DeliveryCityID
				FROM
					Customers C JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(C.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(C.ValidTo) OR
						DATETIME(C.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					CA.CustomerID,
					CA.DeliveryCityID
				FROM
					Customers_Archive CA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(CA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(CA.ValidTo) OR
						DATETIME(CA.ValidTo) IS NULL
					)
			) CU ON
				CU.CustomerID = I.CustomerID LEFT JOIN
			(
				SELECT
					C.CityID
				FROM
					Cities C JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(C.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(C.ValidTo) OR
						DATETIME(C.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					CA.CityID
				FROM
					Cities_Archive CA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(CA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(CA.ValidTo) OR
						DATETIME(CA.ValidTo) IS NULL
					)
			) C ON
				C.CityID = CU.DeliveryCityID LEFT JOIN
			(
				SELECT
					C.CustomerID
				FROM
					Customers C JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(C.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(C.ValidTo) OR
						DATETIME(C.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					CA.CustomerID
				FROM
					Customers_Archive CA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(CA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(CA.ValidTo) OR
						DATETIME(CA.ValidTo) IS NULL
					)
			) BCU ON
				BCU.CustomerID = I.BillToCustomerID LEFT JOIN
			(
				SELECT
					SI.StockItemID
				FROM
					StockItems SI JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(SI.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(SI.ValidTo) OR
						DATETIME(SI.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					SIA.StockItemID
				FROM
					StockItems_Archive SIA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(SIA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(SIA.ValidTo) OR
						DATETIME(SIA.ValidTo) IS NULL
					)
			) SI ON
				SI.StockItemID = IL.StockItemID LEFT JOIN
			(
				SELECT
					P.PersonID
				FROM
					People P JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(P.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(P.ValidTo) OR
						DATETIME(P.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					PA.PersonID
				FROM
					People_Archive PA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(PA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(PA.ValidTo) OR
						DATETIME(PA.ValidTo) IS NULL
					)
			) SP ON
				SP.PersonID = I.SalespersonPersonID LEFT JOIN
			(
				SELECT
					PT.PackageTypeID
				FROM
					PackageTypes PT JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(PT.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(PT.ValidTo) OR
						DATETIME(PT.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					PTA.PackageTypeID
				FROM
					PackageTypes_Archive PTA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(PTA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(PTA.ValidTo) OR
						DATETIME(PTA.ValidTo) IS NULL
					)
			) PT ON
				PT.PackageTypeID = IL.PackageTypeID
		WHERE
			I.LastEditedWhen <= DATETIME(V.NewCutoff) OR
			IL.LastEditedWhen <= DATETIME(V.NewCutoff)
	) AS Sale_Count,
	-- Stock Holding Count
	(
		SELECT 
			COUNT(*)
		FROM
			StockItemHoldings SIH JOIN
			(
				SELECT
					SI.StockItemID
				FROM
					StockItems SI JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(SI.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(SI.ValidTo) OR
						DATETIME(SI.ValidTo) IS NULL
					)
	
				UNION
	
				SELECT
					SIA.StockItemID
				FROM
					StockItems_Archive SIA JOIN
					Vars V ON
						1 = 1
				WHERE
					DATETIME(V.NewCutoff) >= DATETIME(SIA.ValidFrom) AND 
					(
						DATETIME(V.NewCutoff) <= DATETIME(SIA.ValidTo) OR
						DATETIME(SIA.ValidTo) IS NULL
					)
			) SI ON
				SI.StockItemID = SIH.StockItemID
	) AS StockHolding_Count,
	-- Transaction Count
	(
		SELECT
			COUNT(*)
		FROM
		(
			SELECT
				CT.TransactionDate,
				CT.CustomerTransactionID,
				CAST(NULL AS INT) AS SupplierTransactionID
			FROM
				CustomerTransactions CT JOIN
				Vars V ON
					1 = 1 LEFT JOIN
				Invoices I ON
					I.InvoiceID = CT.InvoiceID LEFT JOIN
				(
					SELECT
						C.CustomerID
					FROM
						Customers C JOIN
						Vars V ON
							1 = 1
					WHERE
						DATETIME(V.NewCutoff) >= DATETIME(C.ValidFrom) AND 
						(
							DATETIME(V.NewCutoff) <= DATETIME(C.ValidTo) OR
							DATETIME(C.ValidTo) IS NULL
						)
	
					UNION 
	
					SELECT
						CA.CustomerID
					FROM
						Customers_Archive CA  JOIN
						Vars V ON
							1 = 1
					WHERE
						DATETIME(V.NewCutoff) >= DATETIME(CA.ValidFrom) AND 
						(
							DATETIME(V.NewCutoff) <= DATETIME(CA.ValidTo) OR
							DATETIME(CA.ValidTo) IS NULL
						)
				) C ON
					C.CustomerID = COALESCE(I.CustomerID, CT.CustomerID) LEFT JOIN
				(
					SELECT
						C.CustomerID
					FROM
						Customers C  JOIN
						Vars V ON
							1 = 1
					WHERE
						DATETIME(V.NewCutoff) >= DATETIME(C.ValidFrom) AND 
						(
							DATETIME(V.NewCutoff) <= DATETIME(C.ValidTo) OR
							DATETIME(C.ValidTo) IS NULL
						)
	
					UNION 
	
					SELECT
						CA.CustomerID
					FROM
						Customers_Archive CA  JOIN
						Vars V ON
							1 = 1
					WHERE
						DATETIME(V.NewCutoff) >= DATETIME(CA.ValidFrom) AND 
						(
							DATETIME(V.NewCutoff) <= DATETIME(CA.ValidTo) OR
							DATETIME(CA.ValidTo) IS NULL
						)
				) BC ON
					BC.CustomerID = CT.CustomerID LEFT JOIN
				(
					SELECT
						TT.TransactionTypeID
					FROM
						TransactionTypes  TT  JOIN
						Vars V ON
							1 = 1
					WHERE
						DATETIME(V.NewCutoff) >= DATETIME(TT.ValidFrom) AND 
						(
							DATETIME(V.NewCutoff) <= DATETIME(TT.ValidTo) OR
							DATETIME(TT.ValidTo) IS NULL
						)
	
					UNION 
	
					SELECT
						TTA.TransactionTypeID
					FROM
						TransactionTypes_Archive  TTA  JOIN
						Vars V ON
							1 = 1
					WHERE
						DATETIME(V.NewCutoff) >= DATETIME(TTA.ValidFrom) AND 
						(
							DATETIME(V.NewCutoff) <= DATETIME(TTA.ValidTo) OR
							DATETIME(TTA.ValidTo) IS NULL
						)
				) TT ON
					TT.TransactionTypeID = CT.TransactionTypeID LEFT JOIN
				(
					SELECT
						PM.PaymentMethodID
					FROM
						PaymentMethods PM JOIN
						Vars V ON
							1 = 1 
					WHERE
						DATETIME(V.NewCutoff) >= DATETIME(PM.ValidFrom) AND 
						(
							DATETIME(V.NewCutoff) <= DATETIME(PM.ValidTo) OR
							DATETIME(PM.ValidTo) IS NULL
						)
	
					UNION 
	
					SELECT
						PMA.PaymentMethodID
					FROM
						PaymentMethods_Archive PMA JOIN
						Vars V ON
							1 = 1
					WHERE
						DATETIME(V.NewCutoff) >= DATETIME(PMA.ValidFrom) AND 
						(
							DATETIME(V.NewCutoff) <= DATETIME(PMA.ValidTo) OR
							DATETIME(PMA.ValidTo) IS NULL
						)
				) PM ON
					PM.PaymentMethodID = CT.PaymentMethodID
			WHERE
				CT.LastEditedWhen <= DATETIME(V.NewCutoff)
	
			UNION ALL
	
			SELECT
				ST.TransactionDate,
				CAST(NULL AS INT),
				ST.SupplierTransactionID
			FROM
				SupplierTransactions ST JOIN
				Vars V ON
					1 = 1 LEFT JOIN
				(
					SELECT
						S.SupplierID
					FROM
						Suppliers S  JOIN
						Vars V ON
							1 = 1 
					WHERE
						DATETIME(V.NewCutoff) >= DATETIME(S.ValidFrom) AND 
						(
							DATETIME(V.NewCutoff) <= DATETIME(S.ValidTo) OR
							DATETIME(S.ValidTo) IS NULL
						)
	
					UNION 
	
					SELECT
						SA.SupplierID
					FROM
						Suppliers_Archive SA JOIN
						Vars V ON
							1 = 1 
					WHERE
						DATETIME(V.NewCutoff) >= DATETIME(SA.ValidFrom) AND 
						(
							DATETIME(V.NewCutoff) <= DATETIME(SA.ValidTo) OR
							DATETIME(SA.ValidTo) IS NULL
						)
				) S ON
					S.SupplierID = ST.SupplierID LEFT JOIN
				(
					SELECT
						TT.TransactionTypeID
					FROM
						TransactionTypes  TT  JOIN
						Vars V ON
							1 = 1
					WHERE
						DATETIME(V.NewCutoff) >= DATETIME(TT.ValidFrom) AND 
						(
							DATETIME(V.NewCutoff) <= DATETIME(TT.ValidTo) OR
							DATETIME(TT.ValidTo) IS NULL
						)
	
					UNION 
	
					SELECT
						TTA.TransactionTypeID
					FROM
						TransactionTypes_Archive  TTA  JOIN
						Vars V ON
							1 = 1
					WHERE
						DATETIME(V.NewCutoff) >= DATETIME(TTA.ValidFrom) AND 
						(
							DATETIME(V.NewCutoff) <= DATETIME(TTA.ValidTo) OR
							DATETIME(TTA.ValidTo) IS NULL
						)
				) TT ON
					TT.TransactionTypeID = ST.TransactionTypeID LEFT JOIN
				(
					SELECT
						PM.PaymentMethodID
					FROM
						PaymentMethods PM JOIN
						Vars V ON
							1 = 1 
					WHERE
						DATETIME(V.NewCutoff) >= DATETIME(PM.ValidFrom) AND 
						(
							DATETIME(V.NewCutoff) <= DATETIME(PM.ValidTo) OR
							DATETIME(PM.ValidTo) IS NULL
						)
	
					UNION 
	
					SELECT
						PMA.PaymentMethodID
					FROM
						PaymentMethods_Archive PMA JOIN
						Vars V ON
							1 = 1
					WHERE
						DATETIME(V.NewCutoff) >= DATETIME(PMA.ValidFrom) AND 
						(
							DATETIME(V.NewCutoff) <= DATETIME(PMA.ValidTo) OR
							DATETIME(PMA.ValidTo) IS NULL
						)
				) PM ON
					PM.PaymentMethodID = ST.PaymentMethodID
			WHERE
				ST.LastEditedWhen <= DATETIME(V.NewCutoff)
		) T
	) AS Transaction_Count