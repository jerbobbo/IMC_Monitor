select * from accounting_members_t_import a
inner join accounting_ip b on b.address = a.ip
inner join accounting_members_name c on c.name = a.name
inner join accounting_vtr d on d.type = a.v_t
inner join accounting_type e on e.type = a.type
left outer join accounting_plan f on f.pricing_plan = a.pricing_plan
order by b.address;
select * from accounting_members_t_import a
inner join accounting_ip b on b.address = a.ip
inner join accounting_members_name c on c.name = a.name
inner join accounting_vtr d on d.type = a.v_t
inner join accounting_type e on e.type = a.type
left outer join accounting_plan f on f.pricing_plan = a.pricing_plan;
select b.id as address_id, c.id as member_id, e.id as type_id, d.id as vtr_id, f.id as plan_id from accounting_members_t_import a
inner join accounting_ip b on b.address = a.ip
inner join accounting_members_name c on c.name = a.name
inner join accounting_vtr d on d.type = a.v_t
inner join accounting_type e on e.type = a.type
left outer join accounting_plan f on f.pricing_plan = a.pricing_plan;
select distinct pricing_plan from accounting_members_t_import where  pricing_plan is not null;
update accounting_members_t_import set pricing_plan = 'Plan' where pricing_plan like 'Plan';
select * from accounting_members_t_import where  pricing_plan is not null;
select * from accounting_members_t_import where type pricing_plan not null;
select * from accounting_members_t_import where type pricing_plan is not null;
update accounting_members_t_import set pricing_plan = 'Plan2' where pricing_plan like 'Plan2%';
update accounting_members_t_import set pricing_plan = 'Plan3' where pricing_plan like 'Plan3%';
update accounting_members_t_import set pricing_plan = 'Plan1' where pricing_plan like 'Plan1%';
update accounting_members_t_import set pricing_plan = NULL where pricing_plan like 'NULL%';
update accounting_members a, accounting_plan b set a.plan_id = b.id where a.pricing_plan = b.pricing_plan;
insert into accounting_plan(pricing_plan) select distinct pricing_plan from accounting_members where pricing_plan is not NULL order by pricing_plan;
insert into accounting_plan(pricing_plan) select distinct pricing_plan from accounting_members where pricing_plan not NULL order by pricing_plan;
select b.id as address_id, c.id as member_id, e.id as type_id, d.id as vtr_id from accounting_members_t_import a
inner join accounting_ip b on b.address = a.ip
inner join accounting_members_name c on c.name = a.name
inner join accounting_vtr d on d.type = a.v_t
inner join accounting_type e on e.type = a.type;
select b.id as address_id, c.id as member_id, d.id as vtr_id from accounting_members_t_import a
inner join accounting_ip b on b.address = a.ip
inner join accounting_members_name c on c.name = a.name
inner join accounting_vtr d on d.type = a.v_t;
select b.id as address_id, c.id as member_id, d.id as vtr_id from accounting_members_t_import a
inner join accounting_ip b on b.address = a.ip
inner join accounting_members_name c on c.name = a.name
inner join accounting_vtr d on d.vtr = a.v_t;
select b.id as address_id, c.id as member_id, d.id as vtr_id from accounting_members_t_import a
inner join accounting_ip b on b.address = a.ip
inner join accounting_members_name c on c.name = a.name
inner join accounting_vtr d on d.vtr = a v_t;
select b.id as address_id, c.id as member_id from accounting_members_t_import a
inner join accounting_ip b on b.address = a.ip
inner join accounting_members_name c on c.name = a.name