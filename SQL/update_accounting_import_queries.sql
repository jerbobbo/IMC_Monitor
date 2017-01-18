update accounting_import a
inner join accounting_members d on a.origin_address_id = d.address_id
set a.last_origin_attempt =
  (case when a.seiz_id =
    (select max(seiz_id)
      from (select * from accounting_import) b
      where b.conf_id = a.conf_id and b.origin_address_id = a.origin_address_id and b.disconnect_time in (
      select max(disconnect_time) from (select * from accounting_import) f where f.conf_id = a.conf_id))
      then 1 else 0 end)

update accounting_import a
inner join accounting_members d on a.term_address_id = d.address_id
set a.last_term_attempt =
  (case when a.seiz_id =
    (select max(seiz_id) from (select * from accounting_import) b
    where b.conf_id = a.conf_id
    and b.term_address_id in (select c.address_id from accounting_members c where c.member_id = d.member_id )
    and b.disconnect_time in (
    select max(disconnect_time) from (select * from accounting_import) f where f.conf_id = a.conf_id and f.term_address_id in (select g.address_id from accounting_members g where g.member_id = d.member_id) ))
    then 1 else 0 end)

    `update accounting_import a
    inner join accounting_members d on a.originAddressId = d.address_id
    set a.lastOriginAttempt =
      (case when a.seizId =
        (select max(seizId)
          from (select * from accounting_import) b
          where b.confid = a.confid and b.originAddressId = a.originAddressId and b.disconnectTime in (
          select max(disconnectTime) from (select * from accounting_import) f where f.confId = a.confId))
          then 1 else 0 end)`,
    `update accounting_import a
    inner join accounting_members d on a.termAddressId = d.address_id
    set a.lastTermAttempt =
      (case when a.seizId =
        (select max(seizId) from (select * from accounting_import) b
        where b.confid = a.confid
        and b.termAddressId in (select c.address_id from accounting_members c where c.member_id = d.member_id )
        and b.disconnectTime in (
        select max(disconnectTime) from (select * from accounting_import) f where f.confId = a.confId and f.termAddressId in (select g.address_id from accounting_members g where g.member_id = d.member_id) ))
        then 1 else 0 end)`

select a.batch_num, b.member_id as origin_member_id, c.member_id as term_member_id,
country_code, region_name_id, gw_id,
sum(case when a.last_origin_attempt = true then 1 else 0 end) as origin_seizures,
sum(case when a.last_term_attempt = true then 1 else 0 end) as term_seizures,
sum(case when a.call_duration > 0 then 1 else 0 end) as completed,
sum(case when a.last_origin_attempt = true and d.asrm_group = false then 1 else 0 end) as origin_asrm_seiz,
sum(case when a.last_term_attempt = true and d.asrm_group = false then 1 else 0 end) as term_asrm_seiz,
sum(case when a.last_origin_attempt = true and d.ner_group = true then 1 else 0 end) as origin_ner_seiz,
sum(case when a.last_term_attempt = true and d.ner_group = true then 1 else 0 end) as term_ner_seiz,
sum(origin_in_packet_loss) as orig_in_packet_loss, sum(origin_in_jitter) as origin_jitter,
sum(term_in_packet_loss) as term_packet_loss, sum(term_in_jitter) as term_jitter,
sum(call_duration/60.0) as conn_minutes,
sum(case when a.last_origin_attempt = true then post_dial_delay else 0 end) as origin_ans_del,
sum(case when a.last_origin_attempt = true and disconnect_cause = 34 then post_dial_delay else 0 end) as origin_adj_ans_del,
sum(case when a.last_term_attempt = true then post_dial_delay else 0 end) as term_ans_del,
sum(case when a.last_term_attempt = true and disconnect_cause = 34 then post_dial_delay else 0 end) as term_adj_ans_del,
sum(case when d.disconnect_group = 1 and a.last_origin_attempt = true then 1 else 0 end) as origin_normal_disc,
sum(case when d.disconnect_group = 2 and a.last_origin_attempt = true then 1 else 0 end) as origin_failure_disc,
sum(case when d.disconnect_group = 3 and a.last_origin_attempt = true then 1 else 0 end) as origin_no_circ_disc,
sum(case when d.id = 44 and a.last_origin_attempt = true then 1 else 0 end) as origin_no_req_circ_disc,
sum(case when d.disconnect_group = 1 and a.last_term_attempt = true then 1 else 0 end) as term_normal_disc,
sum(case when d.disconnect_group = 2 and a.last_term_attempt = true then 1 else 0 end) as term_failure_disc,
sum(case when d.disconnect_group = 3 and a.last_term_attempt = true then 1 else 0 end) as term_no_circ_disc,
sum(case when d.id = 44 and a.last_term_attempt = true then 1 else 0 end) as term_no_req_circ_disc,
min(disconnect_time) as min_time, max(disconnect_time) as max_time,
count(*) as all_calls
from accounting_import a
join accounting_members b on a.origin_address_id = b.address_id
join accounting_members c on a.term_address_id = c.address_id
join disconnect_text_master d on a.`disconnect_cause` = d.id
group by a.batch_num, country_code, region_name_id, gw_id, origin_member_id, b.member_id, c.member_id
