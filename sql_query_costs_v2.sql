SELECT
	prj.id,
	opcalcs.id,
	(opcalcs.net_replacement_cost / total_savings_per_year) AS simple_payback,
	(100 / (opcalcs.net_replacement_cost / total_savings_per_year)) AS simple_payback_roi,
	total_savings_per_year,
	opcalcs.net_replacement_cost,
	net_replacement_cost_post_financing,
	total_savings_per_year,
	opcalfix.total_replacement_cost,
	total_cogs,
	payback,
	internal_return,
	total_incentives,
	opcalcs.net_replacement_cost,
	opcalcs.created_at
FROM
	option_calculations as opcalcs
	INNER JOIN "options" ON "options".id = opcalcs.option_id 
	inner join projects prj on prj.id = "options".project_id 
	inner join companies on companies.id = prj.company_id
	inner join proposals on proposals.project_id = prj.id
	inner join project_financing_estimates prjfinest on "options".project_id = prjfinest.project_id
	inner join option_calc_fixtures opcalfix on opcalcs.id = opcalfix.option_calculation_id
	inner join operating_schedules opsc on opsc.project_id =  prj.id
	inner join rate_schedules rsc on rsc.project_id = prj.id
WHERE
	prj.active = true
	and "options".active = true
	and proposals.active = true
	and opsc.active = true
	and total_savings_per_year > 0
	and opcalcs.net_replacement_cost > 0
ORDER BY
	simple_payback DESC;