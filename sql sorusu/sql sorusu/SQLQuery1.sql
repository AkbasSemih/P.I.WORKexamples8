WITH country_median AS (
    SELECT country, 
           CASE 
               WHEN PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY daily_vaccinations) IS NULL THEN 0
               ELSE PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY daily_vaccinations)
           END AS median_vaccination
    FROM country_vaccination_stats
    GROUP BY country
)
UPDATE country_vaccination_stats t1
SET daily_vaccinations = (
    SELECT median_vaccination 
    FROM country_median t2 
    WHERE t1.country = t2.country
)
WHERE daily_vaccinations IS NULL;