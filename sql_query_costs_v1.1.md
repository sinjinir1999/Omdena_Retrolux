# SQL QUERY TO PICK THE DATA FROM PROJECTS AND OPTIONS




```

select prj.company_id,
	com.name as company_name,
	ops.project_id,
	prop.id as proposal_id,
	opcals.id as option_calc_id,
	opcals.option_id,
	---
	(
		opcals.total_replacement_cost / total_savings_per_year
	) as calc_simple_payback,
	(
		100 / (
			opcals.total_replacement_cost / total_savings_per_year
		)
	) as simple_payback_roi,
	--      opcals.total_replacement_cost
	opcals.net_replacement_cost,
	total_incentives,
	opcals.replacement_cost_per_year,
	total_replacement_cost_post_financing,
	net_replacement_cost_post_financing,
	total_fixture_cost,
	total_fixture_cost_no_markup,
	original_cost_per_year,
	total_labor_cost,
	total_misc_cost,
	total_tax_cost,
	total_cogs,
	original_energy_cost_per_year,
	original_maintenance_cost_per_year,
	replacement_energy_cost_per_year,
	payback,
	internal_return,
	existing_kw,
	proposed_kw,
	existing_kwh,
	proposed_kwh,
	annual_energy_usage,
	annual_energy_savings,
	upfront_project_cost,
	current_annual_energy_cost,
	annual_service_cost,
	industry_type,
	client_name,
	monthly_revenue,
	maintenance_revenue,
	ops.rebates,
	--	fixture_total_cost,
	total_cost_per_year,
	energy_charge,
	demand_charge,
	opcalfix.simple_payback,
	proposed_quantity,
	existing_quantity,
	--	energy_cost, opcalyr.maintenance_cost, demand_cost,
	annual_hours,
	kwh_cost,
	kwh_cost_simple,
	kw_demand_cost
from projects prj
	join companies com on prj.company_id = com.id
	join options ops on prj.id = ops.project_id
	join proposals prop on ops.project_id = prop.project_id
	join option_calculations opcals on ops.id = opcals.option_id
	join project_financing_estimates prjfinest on ops.project_id = prjfinest.project_id
	join option_calc_fixtures opcalfix on opcals.id = opcalfix.option_calculation_id
	join option_calc_lightings opcallight on opcals.id = opcallight.option_calculation_id --join option_calc_years opcalyr on opcals.id = opcalyr.option_calculation_id
	join operating_schedules opsc on ops.project_id = opsc.project_id
	join rate_schedules rsc on ops.project_id = rsc.project_id
where --prj.company_id = 32
	--		and opcals.id = 4221
	--		and fixture_total_cost != 0
	--		and energy_cost !=0 and demand_cost !=0 and opcalyr.maintenance_cost !=0
	prj.active = true
	and ops.active = true
	and prop.active = true
	and opsc.active = true
	and total_savings_per_year > 0
	and opcals.net_replacement_cost > 0
limit 1000

```
