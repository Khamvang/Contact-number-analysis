
-- ____________________________________ Export to report source all valid number ____________________________________ --
select * , count(*) from
	(
	select  cntl.branch_name , cntl.province_eng , cntl.`type` , fd.category , fd.category2 ,
		case when cntl.province_eng is not null and cntl.district_eng is not null and cntl.village is not null then 'have_address' else 'no_address' end `address`,
		case when fd.category = '①GOVERNMENT' then 'business_owner' else 'no' end `business_owner`,
		case when cntl.maker is not null or cntl.model is not null then 'have_car' else 'no_car' end `car_info`,
		case when cntl.remark_3 = 'contracted' then 'contracted'
			when cntl.remark_3 = 'ringi_not_contract' then 'ringi_not_contract'
			when cntl.remark_3 = 'aseet_not_contract' then 'aseet_not_contract'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C') then 'prospect_sabc'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('F') then 'prospect_f'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('G','G1','G2') then 'prospect_g'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('X') then 'contracted'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED' then 'ANSWERED'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'NO ANSWER' then 'NO ANSWER'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_active' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_inactive' then 'Telecom_inactive'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_success' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_Failed' then 'Telecom_inactive'
			else cntl.remark_3 
		end `result` , 
		case when TIMESTAMPDIFF(MONTH, cntl.`date_updated`, date(now())) = 0 then 'Feb 2023' -- current month
			 when TIMESTAMPDIFF(MONTH, cntl.`date_updated`, date(now())) = 1 then 'Jan 2023' -- before current month
			 else 'Before Jan 2023'
		end `called_in_month`
	from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
	where (cntl.remark_3 = 'contracted' or cntl.remark_3 = 'ringi_not_contract' or cntl.remark_3 = 'aseet_not_contract' 
		or (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C'))
		or (cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED')
		or (cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_active')
		or (cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_success') ) -- 1
		or (
			( ( cntl.remark_3 = 'prospect_sabc' and cntl.status in ('F')) 
			or (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('G','G1','G2') )
			or (cntl.remark_3 = 'pbx_cdr' and cntl.status = 'NO ANSWER') )
			and (cntl.id in (select id from temp_sms_chairman tean where status = 1 ) -- SMS check
			or cntl.id in (select id from temp_etl_active_numbers tean2 ) ) 
			) -- 2
		or cntl.status is null -- new number
	) t
group by branch_name , province_eng , `type` , category , category2 , `address`, `car_info`, `result` ;

-- ____________________________________ Check and update the branch_name is null ____________________________________ --
update contact_numbers_to_lcc cntl set branch_name = 'Bokeo'
where branch_name is null
	and ( (cntl.remark_3 = 'contracted' or cntl.remark_3 = 'ringi_not_contract' or cntl.remark_3 = 'aseet_not_contract' 
		or (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C'))
		or (cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED')
		or (cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_active')
		or (cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_success') ) -- 1
		or (
			( ( cntl.remark_3 = 'prospect_sabc' and cntl.status in ('F')) 
			or (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('G','G1','G2') )
			or (cntl.remark_3 = 'pbx_cdr' and cntl.status = 'NO ANSWER') )
			and (cntl.id in (select id from temp_sms_chairman tean where status = 1 ) -- SMS check
			or cntl.id in (select id from temp_etl_active_numbers tean2 ) ) 
			) -- 2
		or cntl.status is null -- new number
		)

