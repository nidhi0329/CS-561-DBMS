WITH CTE1 AS (
--This statement calculates the frequency of any quantity
SELECT
		PROD,
		QUANT,
		COUNT(*) AS FREQUENCY
	FROM SALES
		GROUP BY
			PROD,
			QUANT
		ORDER BY
			PROD,
			QUANT
), CTE2 AS (
--This statement calculates the ranks. It assigns the same ranks for the same values.
SELECT
		A.PROD,
		A.QUANT,
		SUM(B.FREQUENCY) AS RANK
	FROM CTE1 A
		LEFT JOIN CTE1 B
			ON A.PROD = B.PROD AND A.QUANT >= B.QUANT
		GROUP BY
			A.PROD,
			A.QUANT
		ORDER BY
			A.PROD,
			A.QUANT
), CTE3 AS (
--Getting half of max rank value
SELECT
		A.PROD,
		MAX(A.RANK)/2 AS MAX_RANK_HALF
	FROM CTE2 A
		GROUP BY
			A.PROD
), CTE4 as (
--Finding new middle value to find median
SELECT
		A.PROD,
		A.QUANT,
		A.RANK,
		B.MAX_RANK_HALF,
		(CASE WHEN (B.MAX_RANK_HALF % 2) = 0 THEN (B.MAX_RANK_HALF + 1) ELSE (B.MAX_RANK_HALF + 0.5) END) AS NEW_MAX_HALF
	FROM CTE2 A
		LEFT JOIN CTE3 B
			ON A.PROD = B.PROD
)
--Finding average of values which falls between half of max rank and new rank
SELECT
		A.PROD,
		round(AVG(A.QUANT)) AS MEDIAN
	FROM CTE4 A
		WHERE
			A.RANK BETWEEN A.MAX_RANK_HALF AND A.NEW_MAX_HALF
		GROUP BY
			A.PROD
		ORDER BY
			A.PROD
;


