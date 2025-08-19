# WideWorldImporters Extract-Load-Transform (ELT) in Apache Spark

This is an attempt to simulate an ELT in Apache Spark to warehouse Microsoft's WideWorldImporters sample OLTP database found here: https://learn.microsoft.com/en-us/sql/samples/wide-world-importers-perform-etl?view=sql-server-ver17.  I'm using the Azure Data Studio, for the meantime, to reduce cost since I'm just practicing.  But it's best to work directly from the IDE.

In Azure, you could easily automate copying of data from Azure SQL Database to Apache Spark SQL Pool using this link: https://learn.microsoft.com/en-us/azure/synapse-analytics/quickstart-copy-activity-load-sql-pool.  To simulate this, I've loaded a sample OLTP database first to an SQLITE database which is supported by the Apache Spark.  You need to load it using this notebook: LoadWideWorldImportersDW.ipynb

For relevant sites, please see the following:
     - https://spark.apache.org/docs/latest/api/python/getting_started/index.html
     - https://spark.apache.org/docs/latest/api/python/tutorial/python_packaging.html

It's just one notebook to do the warehousing: ProcessWideWorldImportersDW.ipynb.  To simulate the date, update the new_cutoff date to increase in date say from 2013-01-01 then to 2013-01-02 or you could jump directly to 2015-01-01.  In the IDE, you could probably pass parameter on the database if you schedule it to update everyday.  

<img width="887" height="437" alt="image" src="https://github.com/user-attachments/assets/d526246d-c7d1-4d77-97ab-ffdcc3cfd476" />
