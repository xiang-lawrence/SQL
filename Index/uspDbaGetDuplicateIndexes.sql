USE [Prod_DFEnt_v32]
GO
/****** Object:  StoredProcedure [dbo].[uspDbaGetDuplicateIndexes]    Script Date: 08/28/2007 12:03:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

/**********************************************************************************
*   Name:      			uspDbaGetDuplicateIndexes
*   Author:           	Bob Delamater
*   Creation Date:    	04/04/2007
*   Description:     	This procedure searches (rather crudely) 
*						for situations where columns 
*						have been duplicate indexes.
*		     	
*   Parameters: 		None
*	Requirements:		None
*   Returns: 			List of columns by table that may have been 
*						indexed more than once.
*
*************************************************************************************/

CREATE PROCEDURE [dbo].[uspDbaGetDuplicateIndexes] AS

DECLARE @tWrk TABLE
(
	TableName VARCHAR(255),
	IndexName VARCHAR(255),
	col1 VARCHAR(255),
	col2 VARCHAR(255),
	col3 VARCHAR(255),
	col4 VARCHAR(255),
	col5 VARCHAR(255),
	col6 VARCHAR(255),
	col7 VARCHAR(255),
	col8 VARCHAR(255),
	col9 VARCHAR(255),
	col10 VARCHAR(255),
	col11 VARCHAR(255),
	col12 VARCHAR(255),
	col13 VARCHAR(255),
	col14 VARCHAR(255),
	col15 VARCHAR(255),
	col16 VARCHAR(255),
	dpages VARCHAR(255),
	used	VARCHAR(255),
	rowcnt	INT
)

INSERT INTO @tWrk
SELECT tbl.[name] AS TableName,
	idx.[name] AS IndexName,
	INDEX_COL( tbl.[name], idx.indid, 1 ) AS col1,
	INDEX_COL( tbl.[name], idx.indid, 2 ) AS col2,
	INDEX_COL( tbl.[name], idx.indid, 3 ) AS col3,
	INDEX_COL( tbl.[name], idx.indid, 4 ) AS col4,
	INDEX_COL( tbl.[name], idx.indid, 5 ) AS col5,
	INDEX_COL( tbl.[name], idx.indid, 6 ) AS col6,
	INDEX_COL( tbl.[name], idx.indid, 7 ) AS col7,
	INDEX_COL( tbl.[name], idx.indid, 8 ) AS col8,
	INDEX_COL( tbl.[name], idx.indid, 9 ) AS col9,
	INDEX_COL( tbl.[name], idx.indid, 10 ) AS col10,
	INDEX_COL( tbl.[name], idx.indid, 11 ) AS col11,
	INDEX_COL( tbl.[name], idx.indid, 12 ) AS col12,
	INDEX_COL( tbl.[name], idx.indid, 13 ) AS col13,
	INDEX_COL( tbl.[name], idx.indid, 14 ) AS col14,
	INDEX_COL( tbl.[name], idx.indid, 15 ) AS col15,
	INDEX_COL( tbl.[name], idx.indid, 16 ) AS col16,
	dpages,
	used,
	rowcnt
FROM SYSINDEXES idx
	JOIN SYSOBJECTS tbl 
		ON idx.[id] = tbl.[id]
WHERE 
	indid > 0 
	AND INDEXPROPERTY( tbl.[id], idx.[name], 'IsStatistics') = 0


-- Determine dupes
SELECT l1.tablename, 
	l1.indexname, 
	l2.indexname AS overlappingIndex, 
	l1.col1, 
	l1.col2, 
	l1.col3, 
	l1.col4, 
	l1.col5, 
	l1.col6, 
	l1.col7, 
	l1.col8, 
	l1.col9, 
	l1.col10, 
	l1.col11, 
	l1.col12, 
	l1.col13, 
	l1.col14, 
	l1.col15, 
	l1.col16,	
	l1.dpages,
	l1.used,
	l1.rowcnt
FROM @tWrk l1 
INNER JOIN @tWrk l2 ON l1.tablename = l2.tablename
	AND l1.indexname <> l2.indexname
	AND l1.col1 = l2.col1
	AND (l1.col2 IS NULL OR l2.col2 IS NULL OR l1.col2 = l2.col2)
	AND (l1.col3 IS NULL OR l2.col3 IS NULL OR l1.col3 = l2.col3)
	AND (l1.col4 IS NULL OR l2.col4 IS NULL OR l1.col4 = l2.col4)
	AND (l1.col5 IS NULL OR l2.col5 IS NULL OR l1.col5 = l2.col5)
	AND (l1.col6 IS NULL OR l2.col6 IS NULL OR l1.col6 = l2.col6)
	AND (l1.col7 IS NULL OR l2.col7 IS NULL OR l1.col7 = l2.col7)
	AND (l1.col8 IS NULL OR l2.col8 IS NULL OR l1.col8 = l2.col8)
	AND (l1.col9 IS NULL OR l2.col9 IS NULL OR l1.col9 = l2.col9)
	AND (l1.col10 IS NULL OR l2.col10 IS NULL OR l1.col10 = l2.col10)
	AND (l1.col11 IS NULL OR l2.col11 IS NULL OR l1.col11 = l2.col11)
	AND (l1.col12 IS NULL OR l2.col12 IS NULL OR l1.col12 = l2.col12)
	AND (l1.col13 IS NULL OR l2.col13 IS NULL OR l1.col13 = l2.col13)
	AND (l1.col14 IS NULL OR l2.col14 IS NULL OR l1.col14 = l2.col14)
	AND (l1.col15 IS NULL OR l2.col15 IS NULL OR l1.col15 = l2.col15)
	AND (l1.col16 IS NULL OR l2.col16 IS NULL OR l1.col16 = l2.col16)
ORDER BY
	l1.tablename,
	l1.indexname

