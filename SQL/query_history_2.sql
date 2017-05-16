update accounting_summary set `origin_member_id` = 199 where origin_address_id like 636;
update accounting_summary_30 set `origin_member_id` = 199 where origin_address_id like 636;
update accounting_summary_120 set `origin_member_id` = 199 where origin_address_id like 636;
update accounting_summary_120 set term_member_id = 199 where term_address_id like 636;
update accounting_summary_30 set term_member_id = 199 where term_address_id like 636;
update accounting_summary set term_member_id = 199 where term_address_id like 636;
update accounting_members set member_id = 199 where address_id like 636;
select * from accounting_summary where origin_address_id like 636;
select a.id, a.address, c.name from accounting_ip a 
right outer join accounting_members b on b.address_id = a.id
inner join accounting_members_name c on c.id = b.member_id
 where address like '213.144%';
select * from accounting_ip where id between 1477 and 1479;
update accounting_summary_120 set term_member_id = 199 where term_address_id between 1477 and 1479;
update accounting_summary_30 set term_member_id = 199 where term_address_id between 1477 and 1479;
update accounting_summary set term_member_id = 199 where term_address_id between 1477 and 1479;
update accounting_summary_24h set origin_member_id = 199 where origin_address_id between 1477 and 1479;
update accounting_summary_120 set origin_member_id = 199 where origin_address_id between 1477 and 1479;
update accounting_summary_30 set origin_member_id = 199 where origin_address_id between 1477 and 1479;
update accounting_summary set origin_member_id = 199 where origin_address_id between 1477 and 1479;
select * from accounting_members_name where name like 'STE';
select * from accounting_members where member_id = 199;
select * from accounting_members where member_id = 97