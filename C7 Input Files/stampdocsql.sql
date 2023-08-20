WITH RevenueCTE AS (
    SELECT
        dist_code,
        month,
        documents_registered_rev,
        estamps_challans_rev,
        CASE
            WHEN month BETWEEN '2019-04-01' AND '2020-03-31' THEN '2019_2020'
            WHEN month BETWEEN '2020-04-01' AND '2021-03-31' THEN '2020_2021'
            WHEN month BETWEEN '2021-04-01' AND '2022-03-31' THEN '2021_2022'
            ELSE NULL
        END AS fiscal_year
    FROM fact_stamps
)
SELECT
    dist_code,
    SUM(CASE WHEN fiscal_year = '2019_2020' THEN documents_registered_rev ELSE 0 END) AS doc_revenue_2019_2020,
    SUM(CASE WHEN fiscal_year = '2020_2021' THEN documents_registered_rev ELSE 0 END) AS doc_revenue_2020_2021,
    SUM(CASE WHEN fiscal_year = '2021_2022' THEN documents_registered_rev ELSE 0 END) AS doc_revenue_2021_2022,
    SUM(CASE WHEN fiscal_year = '2019_2020' THEN estamps_challans_rev ELSE 0 END) AS estamp_revenue_2019_2020,
    SUM(CASE WHEN fiscal_year = '2020_2021' THEN estamps_challans_rev ELSE 0 END) AS estamp_revenue_2020_2021,
    SUM(CASE WHEN fiscal_year = '2021_2022' THEN estamps_challans_rev ELSE 0 END) AS estamp_revenue_2021_2022
FROM RevenueCTE
GROUP BY dist_code;
