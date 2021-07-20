SELECT
	B.project_id,
	C.proposal_id,
	A.option_id,
	A.id as option_calculation_id,	
	ROUND(A.net_replacement_cost) AS net_replacement_cost,
	ROUND(A.total_savings_per_year) AS total_savings_per_year,
	A.total_savings_per_year/A.net_replacement_cost AS ROI,
	DATE(A.created_at) AS created_at,
	ROUND(A.existing_kwh) as existing_kwh,
	ROUND(A.proposed_kwh) as proposed_kwh,
	ROUND(A.kwh_proposed_annual_savings) as kwh_proposed_annual_savings,
	E.sum_sqft,
	E.count_areas_sqft_null,
	E.count_areas_sqft_not_null,
	A.existing_kwh/E.sum_sqft AS lightning_intensity_kwh_over_sqft

FROM
	option_calculations as A
INNER JOIN
	options as B ON B.id = A.option_id
LEFT JOIN
	proposal_options as C ON C.option_id = B.id
LEFT JOIN
(
	SELECT 
	A.option_calculation_id, 
	--A.area_id, 
	--A.solution_id,
	--B.name as area_name,
	sum(B.sqft) as sum_sqft,
	--B.name_with_parents,
	sum(case when B.sqft is null then 1 else 0 end) as count_areas_sqft_null,
	sum(case when B.sqft is null then 0 else 1 end) as count_areas_sqft_not_null
	FROM public.option_calc_areas as A
	LEFT JOIN areas as B ON A.area_id = B.id
	GROUP BY A.option_calculation_id
) E ON A.id = E.option_calculation_id
WHERE
	A.net_replacement_cost > 0 AND
	E.count_areas_sqft_null = 0 AND
	A.total_savings_per_year > 0 AND
	A.proposed_kwh > 0
ORDER By
	ROI