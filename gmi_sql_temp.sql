SELECT
'{api}' as "API",
'{api}' as "API Alias",
if(value like "%esponseDescription%",
substring_index(substring_index(replace(value,'"',''),'esponseDescription:',-1),',',1),
substring_index(substring_index(value,'Response Message:[',-1),'],RequestBody: ',1))  as "Distinct Error Text ",
count(*) as count,
if(value like "%responseDescription%",
 substring_index(substring_index(value,'"responseDescription":',-1),'"requestID"',1),
 substring_index(substring_index(value,'Response Message:[',-1),'],RequestBody: ',1))  as "Error Detail"
FROM audit_log
where log_time >= {lower_time} AND log_time <= {current_time}
and tracking_message_header in (select tracking_message_header from audit_log where parent_api_name =  replace('{api}'," ","") and log_time >= {lower_time} AND log_time <= {current_time})
and audit_log.name like "%End Node API%"
and (audit_log.is_successful= 0 )
group by tracking_message_header

if(value like "%esponseDescription%",
substring_index(substring_index(replace(value,'"',''),'esponseDescription:',-1),',',1),
substring_index(substring_index(value,'Response Message:[',-1),'],RequestBody: ',1))


SELECT
'{api}' as "API",
'{api}' as "API Alias",
 value as "Error Detail",
count(*) as count,
if(value like "%responseDescription%",
 substring_index(substring_index(value,'"responseDescription":',-1),'"requestID"',1),
 substring_index(substring_index(value,'Response Message:[',-1),'],RequestBody: ',1)) as "Error Value"
FROM audit_log
where  log_time >= {lower_time} AND log_time <= {current_time}
and tracking_message_header in (select tracking_message_header from audit_log where parent_api_name =  replace('{api}'," ","") and log_time >= {lower_time} AND log_time <= {current_time})
and audit_log.name like "%End Node API%"
and (audit_log.is_successful= 0  )
group by if(value like "%responseDescription%",
 substring_index(substring_index(value,'"responseDescription":',-1),'"requestID"',1),
 substring_index(substring_index(value,'Response Message:[',-1),'],RequestBody: ',1))