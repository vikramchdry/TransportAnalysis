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
        fiscal_year,
        SUM(documents_registered_rev) AS doc_revenue,
        SUM(estamps_challans_rev) AS estamp_revenue,
        SUM(documents_registered_cnt) AS doc_count,
        SUM(estamps_challans_cnt) AS estamp_count
    FROM RevenueCTE
    GROUP BY dist_code, fiscal_year
),
GrowthCTE AS (
    SELECT
        dist_code,
        fiscal_year,
        doc_revenue,
        LAG(doc_revenue) OVER (PARTITION BY dist_code ORDER BY fiscal_year) AS prev_doc_revenue,
        estamp_revenue,
        LAG(estamp_revenue) OVER (PARTITION BY dist_code ORDER BY fiscal_year) AS prev_estamp_revenue,
        doc_count,
        estamp_count
    FROM AggregatedRevenue
)
SELECT
    dist_code,
    fiscal_year,
    doc_revenue,
    estamp_revenue,
    doc_count,
    estamp_count,
    doc_revenue - prev_doc_revenue AS doc_revenue_growth,
    (estamp_revenue / NULLIF(doc_revenue, 0)) * 100 AS estamp_contribution_percentage
FROM GrowthCTE;
