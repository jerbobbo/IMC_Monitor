select @@session.bulk_insert_buffer_size

set global max_allowed_packet = 1024 * 1024 * 32

select @@global.innodb_buffer_pool_size

select @@global.max_allowed_packet

select distinct `batchNum` from accounting_cdr

select batchnum, max(setuptime) from accounting_cdr group by batchnum order by batchnum

truncate table accounting_cdr

set optimizer_switch='index_condition_pushdown=on';
EXPLAIN select count(a.setuptime) as numCalls, sum(a.`callDuration`) as connectSec, a.gwId, a.termAddressId, a.originMemberId, a.`batchNum`, a.countryCode, d.regionName from accounting_cdr a
join accounting_region d on d.regionid = a.regionId
where a.countryCode = '967' and d.prefix = '967'
group by a.gwId, a.termAddressId, a.batchNum, a.countryCode, a.originMemberId, d.regionName

EXPLAIN select c.*, b.regionName
from (select count(a.setuptime) as numCalls, sum(a.`callDuration`) as connectSec, a.gwId, a.termAddressId, a.originMemberId, a.`batchNum`, a.countryCode, a.regionId from accounting_cdr a
where countrycode = '291'
group by a.gwId, a.termAddressId, a.batchNum, a.countryCode, a.originMemberId, a.regionid) c
inner join (select * from accounting_region where regionName like 'Mobile%') b on c.regionid = b.regionid

select count(a.setuptime) as numCalls, sum(a.`callDuration`) as connectSec, a.`batchNum`, a.gwId, a.termMemberId, a.originMemberId, a.regionnameid, b.regionName from accounting_cdr a
inner join (select * from accounting_region_name where regionName like 'Mobile%' and countrycode = '291') b on a.regionnameid = b.id
group by a.batchNum, a.gwId, a.termMemberId, a.originMemberId, a.regionnameid, b.regionName

EXPLAIN select count(a.setuptime) as numCalls, sum(a.`callDuration`) as connectSec, a.gwId, a.termAddressId, a.originMemberId, a.`batchNum`, a.countryCode, a.regionId from accounting_cdr a
where countrycode = '961'
group by a.gwId, a.termAddressId, a.batchNum, a.countryCode, a.originMemberId, a.regionid


explain select setuptime, countrycode, gwid from accounting_cdr where originmemberid = 176

select sum(a.`callDuration`) as connectSec, a.`batchNum` from accounting_cdr a
inner join accounting_members_name c on c.id = a.originMemberId
inner join accounting_region d on d.regionid = a.regionId
where a.countryCode = '967'
group by  a.batchNum

update accounting_cdr a, accounting_region b set a.regionNameId= b.regionNameid
where a.`regionid` = b.regionid



insert into accounting_region_name(countryCode, RegionName) select distinct prefix, regionname from accounting_region

explain select count(a.setuptime) as numCalls, sum(a.`SessionTime`) as connectSec, a.gwIp, a.RemoteAddress, a.countryCode, a.import_id from tempaccounting_inArchive a
where a.countryCode = '961'
group by a.gwIp, a.remoteaddress, a.countryCode, a.import_id


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
update accounting_members_t_import set pricing_plan = 'Plan' where pricing_plan like 'Plan
';
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

select countryCode, count(*) as calls from accounting_cdr group by countryCode order by calls desc


select count(a.setuptime) as numCalls, sum(a.`callDuration`) as connectSec, a.gwId, a.termAddressId, a.originMemberId, a.`batchNum`, a.countryCode, a.regionId from accounting_cdr a
group by a.gwId, a.termAddressId, a.batchNum, a.countryCode, a.originMemberId, a.regionid

select count(*) as calls, regionnameid, batchnum, originmemberid, gwid, termmemberid from accounting_cdr group by regionnameid, batchnum, originmemberid, gwid, termmemberid

select originmemberid, origincallednumb, regionid from accounting_cdr where originmemberid = 267
