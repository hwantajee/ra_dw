{% if var("projects_warehouse_timesheet_sources") %}
{{
    config(
        unique_key='timesheet_projects_pk',
        alias='timesheet_projects_dim'
    )
}}


WITH timesheet_projects AS
  (
  SELECT {{ dbt_utils.star(from=ref('int_timesheet_projects')) }}
  FROM   {{ ref('int_timesheet_projects') }}
),
companies_dim as (
    SELECT {{ dbt_utils.star(from=ref('wh_companies_dim')) }}
    from {{ ref('wh_companies_dim') }}
)
SELECT
   GENERATE_UUID() as timesheet_project_pk,
   c.company_pk,
   p.timesheet_project_id,
   p.project_name,
   p.project_code,
   p.project_delivery_start_ts,
   p.project_delivery_end_ts,
   p.project_is_active,
   p.project_is_billable,
   p.project_hourly_rate,
   p.project_cost_budget,
   p.project_is_fixed_fee,
   p.project_is_expenses_included_in_cost_budget,
   p.project_fee_amount,
   p.project_budget_amount,
   p.project_over_budget_notification_pct,
   p.project_budget_by
FROM
   timesheet_projects p
   JOIN companies_dim c
      ON cast(p.company_id as string) IN UNNEST(c.all_company_ids)

{% else %}

{{config(enabled=false)}}

{% endif %}
