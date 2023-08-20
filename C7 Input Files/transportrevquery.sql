WITH RevenueCTE AS (
	SELECT
        dist_code,
        month,
        documents_registered_rev,
        estamps_challans_rev,
        documents_registered_cnt,
        estamps_challans_cnt,
        CASE
            WHEN month BETWEEN '2019-04-01' AND '2020-03-31' THEN '2019_2020'
            WHEN month BETWEEN '2020-04-01' AND '2021-03-31' THEN '2020_2021'
            WHEN month BETWEEN '2021-04-01' AND '2022-03-31' THEN '2021_2022'
            ELSE NULL
        END AS fiscal_year
    FROM fact_stamps
),
AggregatedRevenue AS (
	SELECT
        dist_code,
        month,
        fiscal_year,
        SUM(documents_registered_rev) AS doc_revenue,
        SUM(estamps_challans_rev) AS estamp_revenue,
        SUM(documents_registered_cnt) AS doc_count,
        SUM(estamps_challans_cnt) AS estamp_count
    FROM RevenueCTE
    GROUP BY dist_code, month, fiscal_year
),
CategorizedRevenue AS (
    SELECT
        dist_code,
        month,
        SUM(CASE WHEN fiscal_year = '2021_2022' THEN doc_revenue ELSE 0 END) +
        SUM(CASE WHEN fiscal_year = '2021_2022' THEN estamp_revenue ELSE 0 END) AS total_revenueFY22
    FROM AggregatedRevenue
    GROUP BY dist_code, month
)
SELECT
    CR.dist_code,
    CR.month,
    CR.total_revenueFY22,
    CASE
        WHEN CR.total_revenueFY22 >= 500000 THEN 'High'
        WHEN CR.total_revenueFY22 >= 250000 THEN 'Medium'
        ELSE 'Low'
    END AS revenue_category,
    AR.doc_revenue AS doc_revenue_2019_2020,
    AR.doc_revenue AS doc_revenue_2020_2021,
    AR.doc_revenue AS doc_revenue_2021_2022,
    AR.estamp_revenue AS estamp_revenue_2019_2020,
    AR.estamp_revenue AS estamp_revenue_2020_2021,
    AR.estamp_revenue AS estamp_revenue_2021_2022,
    AR.doc_count AS doc_count_2019_2020,
    AR.doc_count AS doc_count_2020_2021,
    AR.doc_count AS doc_count_2021_2022,
    AR.estamp_count AS estamp_count_2019_2020,
    AR.estamp_count AS estamp_count_2020_2021,
    AR.estamp_count AS estamp_count_2021_2022
FROM CategorizedRevenue CR
JOIN AggregatedRevenue AR ON CR.dist_code = AR.dist_code AND CR.month = AR.month;