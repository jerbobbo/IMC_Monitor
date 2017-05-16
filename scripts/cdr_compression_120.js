'use strict';
const mysql = require('promise-mysql');
const config = require('../config/db-config');
const Promise = require('bluebird');

const pool = mysql.createPool( {
	host: 'localhost',
	user: config.DATABASE_USER,
	password: config.DATABASE_PASS,
	database: config.DATABASE_URI,
  connectionLimt: 10
});

const insertQuery = `
insert into accounting_summary_120 select
batch_time_120,
max(batch_num) as batch_num,
origin_member_id,
term_member_id,
origin_address_id,
term_address_id,
country_code,
route_code_id,
gw_id,
sum(raw_seizures) as raw_seizures,
sum(origin_seizures) as origin_seizures,
sum(term_seizures) as term_seizures,
sum(completed) as completed,
sum(origin_asrm_seiz) as origin_asrm_seiz,
sum(term_asrm_seiz) as term_asrm_seiz,
sum(origin_ner_seiz) as origin_ner_seiz,
sum(term_ner_seiz) as term_ner_seiz,
sum(origin_packet_loss) as origin_packet_loss,
sum(origin_jitter) as origin_jitter,
sum(term_packet_loss) as term_packet_loss,
sum(term_jitter) as term_jitter,
sum(conn_minutes) as conn_minutes,
sum(origin_ans_del) as origin_ans_del,
sum(origin_adj_ans_del) as origin_adj_ans_del,
sum(term_ans_del) as term_ans_del,
sum(term_adj_ans_del) as term_adj_ans_del,
sum(origin_normal_disc) as origin_normal_disc,
sum(origin_failure_disc) as origin_failure_disc,
sum(origin_no_circ_disc) as origin_no_circ_disc,
sum(origin_no_req_circ_disc) as origin_no_req_circ_disc,
sum(term_normal_disc) as term_normal_disc,
sum(term_failure_disc) as term_failure_disc,
sum(term_no_circ_disc) as term_no_circ_disc,
sum(term_no_req_circ_disc) as term_no_req_circ_disc,
min(min_time) as min_time,
max(max_time) as max_time,
sum(origin_fsr_seiz) as origin_fsr_seiz,
sum(term_fsr_seiz) as term_fsr_seiz
from accounting_summary
where batch_num > (select max(batch_num) from accounting_summary_120)
group by batch_time_120,
origin_member_id,
term_member_id,
origin_address_id,
term_address_id,
country_code,
route_code_id,
gw_id;
`;


const deleteSummary120Query = `
  delete from accounting_summary_120
  where TIMESTAMPDIFF(DAY, (select max(batch_time_120)
  from accounting_summary), batch_time_120) < -65;
  `;


const summaryPrimaryTruncate = `
	truncate table accounting_summary_primary
	`;

const summaryPrimaryRegen = `
	insert into accounting_summary_primary
	(origin_member_id, term_member_id, origin_address_id,
		term_address_id, country_code, route_code_id, gw_id)
	select origin_member_id, term_member_id, origin_address_id,
	term_address_id, country_code, route_code_id, gw_id
	from accounting_summary_120 group by origin_member_id,
	term_member_id, origin_address_id, term_address_id,
	country_code, route_code_id, gw_id
	`;

var conn;
pool.getConnection()
.then( (_conn) => {
  conn = _conn;
  return conn.query(insertQuery);
})
.then( () => conn.query(deleteSummary120Query) )
.then( () => conn.query(summaryPrimaryTruncate) )
.then( () => conn.query(summaryPrimaryRegen) )
.then( () => {
  console.log('cdr_commpression_120 ran successfully');
  return pool.end();
})
.catch(console.log);
