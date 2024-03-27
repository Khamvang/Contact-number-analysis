

-- Update branch before export 
update contact_numbers_to_lcc cntl inner join file_details fd on (fd.id = cntl.file_id)
set cntl.branch_name = 
	case when cntl.province_eng = 'ATTAPUE' then 'Attapue'
		when cntl.province_eng = 'BORKEO' then 'Bokeo'
		when cntl.province_eng = 'BORLIKHAMXAY' then 'Paksan'
		when cntl.province_eng = 'CHAMPASACK' then 'Pakse'
		when cntl.province_eng = 'HUAPHAN' then 'Houaphan'
		when cntl.province_eng = 'KHAMMOUAN' then 'Thakek'
		when cntl.province_eng = 'LUANG PRABANG' then 'Luangprabang'
		when cntl.province_eng = 'LUANGNAMTHA' then 'Luangnamtha'
		when cntl.province_eng = 'OUDOMXAY' then 'Oudomxay'
		when cntl.province_eng = 'PHONGSALY' then 'Oudomxay'
		when cntl.province_eng = 'SALAVANH' then 'Salavan'
		when cntl.province_eng = 'SAVANNAKHET' then 'Savannakhet'
		when cntl.province_eng = 'VIENTIANE CAPITAL' then 'Head office'
		when cntl.province_eng = 'VIENTIANE PROVINCE' then 'Vientiane province'
		when cntl.province_eng = 'XAYABOULY' then 'Xainyabuli'
		when cntl.province_eng = 'XAYSOMBOUN' then 'Xiengkhouang'
		when cntl.province_eng = 'XEKONG' then 'Attapue'
		when cntl.province_eng = 'XIENGKHUANG' then 'Xiengkhouang'
		else fd.branch_name
	end
where cntl.province_eng is not null or cntl.branch_name is null;



-- ____________________________________ Export to report source all that not yet call last month ____________________________________ --
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
		end `result` 
	from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
	where cntl.id in (select id from contact_for_202301_lcc where status_updated is not null) -- to export the rank F & G the SMS success
	) t
group by branch_name , province_eng , `type` , category , category2 , `address`, `car_info`, `result` ;


-- ____________________________________ Export to report each telecom ____________________________________ --
select * , count(*) from
	(
	select case when CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190302', '1290202') then 'ETL'
			when CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190305', '1290205') then 'LTC'
			when CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190307', '1290207') then 'Beeline'
			when CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1290202','1290208') then 'Besttelecom'
			when CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190304', '1190309', '1290209') then 'Unitel'
		end `telecom`,
		left( contact_no, 4) `numbers`,
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
		end `result` 
	from contact_numbers_to_lcc cntl 
		) t
group by `telecom`, `numbers`, `result` ;


-- ____________________________________ Export to report source all telecom check ____________________________________ --
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
		end `result` 
	from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
	where cntl.id in (select id from temp_sms_chairman tean where status = 1 ) -- SMS check
		or cntl.id in (select id from temp_etl_active_numbers tean2 ) -- ETL active
	) t
group by branch_name , province_eng , `type` , category , category2 , `address`, `car_info`, `result` ;


-- ____________________________________ Export to report source all SMS success and ETL active ____________________________________ --
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
		end `result` 
	from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
	 where cntl.id in (select id from temp_sms_chairman tean where status = 1) -- to export the rank F & G the SMS success
	 	or cntl.id in (select id from temp_etl_active_numbers tean2 ) -- ETL active
	) t
group by branch_name , province_eng , `type` , category , category2 , `address`, `car_info`, `result` ;



-- ____________________________________ Export to report SMS status ____________________________________ --
select date_created, telecom, old_status , status , count(*) 
from temp_sms_chairman -- where date_updated >= '2022-09-01' 
group by date_created, telecom, old_status, status ;

-- ____________________________________ Export to report Pending for SMS checking ____________________________________ --
select case when CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190302', '1290202') then 'ETL'
		when CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190305', '1290205') then 'LTC'
		when CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190307', '1290207') then 'Beeline'
		when CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1290208') then 'Besttelecom'
		when CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190304', '1190309', '1290209') then 'Unitel'
	end `telecom`,
	count(case when status in ('F') then 1 end) 'F',
	count(case when status in ('G','G1','G2') then 1 end) 'G',
	count(case when status is null then 1 end) 'null'
from contact_numbers_to_lcc 
where (status is null or status in ('F','G','G1','G2')) and id not in (select id from temp_sms_chairman) --  where status in (1,2)
	and CONCAT(LENGTH(contact_no), left( contact_no, 5)) not in ('1190302', '1290202') 
group by telecom;



/* ___________________________ Order 2023-01-13 ___________________________ */
-- 1_) Sales partner list
select id, null 'G-Dept', null 'Branch', null 'Department', null 'Unit', null 'Staff Status', staff_no , staff_name, staff_tel , concat(broker_name, ' ',broker_tel) 'broker_key',  broker_name, broker_tel, company_name , category2, category, `type`, date_received, number_of_original_file,
	number_of_unique_contact 'unique_numbers', cntl.`numbers` 'now_unique_number', null 'can_contact_numbers', 
	null ' staff status', null 'Sales/Internal', null 'current_staff_no', null 'current_staff_name'
from file_details fd 
left join (select file_id, count(*) `numbers` from contact_numbers_to_lcc cntl group by file_id ) cntl on (fd.id = cntl.file_id)
order by id desc;


-- 2_)
select file_id , count(*) 
from contact_numbers cn  
group by file_id ;


-- 3_)
select file_id , count(*) 
from contact_numbers_to_lcc cntl 
group by file_id ;

-- 4_)
select file_id , count(*) 
from contact_numbers_to_lcc cntl 
where cntl.contact_id in (select contact_id from contact_for_202303_lcc ) -- valid numbers
		or cntl.status is null -- new number
group by file_id ;



-- 5 Draft: Add the numbers for table file_details 
select fd.id, cn.`numbers`, icn.`numbers`, aucn.`numbers`, p.`numbers`
from file_details fd 
left join (select file_id, count(*) `numbers` from contact_numbers group by file_id ) cn on (fd.id = cn.file_id)
left join (select file_id, count(*) `numbers` from invalid_contact_numbers icn group by file_id ) icn on (fd.id = icn.file_id)
left join (select file_id, count(*) `numbers` from all_unique_contact_numbers aucn group by file_id ) aucn on (fd.id = aucn.file_id)
left join (select file_id, count(*) `numbers` from payment p group by file_id ) p on (fd.id = p.file_id)


-- 6) Count number with name, address and car info
select *, count(*)  from (
select 
	fd.id `file_id`, concat(fd.broker_name, ' ', fd.broker_tel) `broker_key`, fd.branch_name, fd.`type` , fd.category , fd.date_received, fd.company_name ,
	concat( 
	case when cntl.name != '' then 1 else 0 end , -- customer name
	case when ((cntl.province_eng != '' or cntl.province_laos != '') and (cntl.district_eng != '' or cntl.district_laos != '') and cntl.village != '') != '' then 1 else 0 end , -- address
	case when (cntl.maker != '' or cntl.model != '' or cntl.`year` != '') != '' then 1 else 0 end -- car
		) `code`
from file_details fd left join contact_numbers cntl on (fd.id = cntl.file_id)
) t
group by file_id, code;


-- Hattori request for Yoshi -- ative
select *, count(*) from 
	(
select 
	case when cntl.maker != '' or cntl.model != '' then 'have_car' end `have_car`,
	case when fd.category = '①GOVERNMENT' then 'business_owner' end `business_owner`,
	case when cntl.province_eng != '' and cntl.district_eng != '' and cntl.village != '' then 'have_address' end `have_address`,
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
		end `result` 
from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
where cntl.id in (select id from temp_sms_chairman tean where status = 1) -- to export the rank F & G the SMS success
	 	or cntl.id in (select id from temp_etl_active_numbers tean2 ) -- ETL active
) t
group by `have_car`, `business_owner`, `have_address`, `result`;


-- Hattori request for Yoshi -- all source
select *, count(*) from 
	(
select 
	case when cntl.maker != '' or cntl.model != '' then 'have_car' end `have_car`,
	case when fd.category = '①GOVERNMENT' then 'business_owner' end `business_owner`,
	case when cntl.province_eng != '' and cntl.district_eng != '' and cntl.village != '' then 'have_address' end `have_address`,
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
		end `result` 
from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
) t
group by `have_car`, `business_owner`, `have_address`, `result`;



-- ____________________________________ Export to report original soure update 2023-04-05 ____________________________________ -- 
select * , count(*) from 
	(
	select  cntl.province_eng , cntl.`type` , fd.category , fd.category2, fd.date_received, cntl.remark_1 `priority`, null `condition`,
		case when cntl.province_eng is not null and cntl.district_eng is not null and cntl.village is not null then 'have_address' else 'no_address' end `address`,
		case when fd.category = '①GOVERNMENT' then 'business_owner' else 'no' end `business_owner`,
		case when cntl.maker is not null or cntl.model is not null then 'have_car' else 'no_car' end `car_info`,
		case when cntl.name is not null or cntl.name != '' then 'have_name' else 'no_name' end `name_info`
	from contact_numbers cntl left join file_details fd on (fd.id = cntl.file_id)
	) t
group by  province_eng , `type` , category , category2, date_received, `priority`, `condition`, `address`, `business_owner`, `car_info`, `name_info` ;





-- ____________________________________ Export to report source monthly update 2024-03-01 ____________________________________ -- 
select * , count(*) from 
	(
	select  cntl.branch_name , cntl.province_eng , cntl.`type` , fd.category , 
		case when cntl.`type` = 'prospect' then cntl.status else fd.category2 end `category2`, 
		case when cntl.`type` = 'prospect' then '2023-08-01' else fd.date_received end `date_received`, 
		cntl.remark_1 `priority`, cntl.`condition`,
		case when cntl.province_eng is not null and cntl.district_eng is not null and cntl.village is not null then 'have_address' else 'no_address' end `address`,
		case when fd.category = '①GOVERNMENT' then 'business_owner' else 'no' end `business_owner`,
		case when cntl.maker is not null or cntl.model is not null then 'have_car' else 'no_car' end `car_info`,
		case when cntl.name is not null or cntl.name != '' then 'have_car' else 'no_car' end `name_info`,
		case when cntl.remark_3 = 'contracted' then 'contracted'
			when cntl.remark_3 = 'ringi_not_contract' then 'ringi_not_contract'
			when cntl.remark_3 = 'aseet_not_contract' then 'aseet_not_contract'
			when cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('S','A','B','C') then 'prospect_sabc'
			when cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('F') then 'prospect_f'
			when cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('G','G1','G2') then 'prospect_g'
			when cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('X') then 'contracted'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED' then 'ANSWERED'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'NO ANSWER' then 'NO ANSWER'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_active' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_inactive' then 'Telecom_inactive'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_success' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_Failed' then 'Telecom_inactive'
			when cntl.remark_3 = 'lcc' and cntl.status = 'Block need_to_block' then 'Block need_to_block'
			when cntl.remark_3 = 'lcc' and cntl.status = 'FF1 not_answer' then 'FF1 not_answer'
			when cntl.remark_3 = 'lcc' and cntl.status = 'FF2 power_off' then 'FF2 power_off'
			when cntl.remark_3 = 'lcc' and cntl.status in ('FFF can_not_contact', 'No have in telecom') then 'FFF can_not_contact'
			else cntl.remark_3 
		end `result`,
		case when cntl.remark_2 = 'contracted' and cntl.status_updated in ('Active', 'Refinance') then 'contracted'
			when cntl.remark_2 = 'contracted' and cntl.status_updated in ('Closed') then 'prospect_f'
			when cntl.remark_2 = 'ringi_not_contract' then 'ringi_not_contract'
			when cntl.remark_2 = 'aseet_not_contract' then 'aseet_not_contract'
			when cntl.remark_2 in ('prospect_sabc', 'lcc') and cntl.status_updated in ('S') then 'prospect_s'
			when cntl.remark_2 in ('prospect_sabc', 'lcc') and cntl.status_updated in ('A') then 'prospect_a'
			when cntl.remark_2 in ('prospect_sabc', 'lcc') and cntl.status_updated in ('B') then 'prospect_b'
			when cntl.remark_2 in ('prospect_sabc', 'lcc') and cntl.status_updated in ('C') then 'prospect_c'
			when cntl.remark_2 in ('prospect_sabc', 'lcc') and cntl.status_updated in ('F') then 'prospect_f'
			when cntl.remark_2 in ('prospect_sabc', 'lcc') and cntl.status_updated in ('G','G1','G2') then 'prospect_g'
			when cntl.remark_2 in ('prospect_sabc') and cntl.status_updated in ('X') then 'contracted'
			when cntl.remark_2 in ('lcc') and cntl.status_updated in ('X') then 'prospect_f' -- because there're wrong
			when cntl.remark_2 = 'pbx_cdr' and cntl.status_updated = 'ANSWERED' then 'ANSWERED'
			when cntl.remark_2 = 'pbx_cdr' and cntl.status_updated = 'NO ANSWER' then 'NO ANSWER'
			when cntl.remark_2 = 'Telecom' and cntl.status_updated = 'ETL_active' then 'Telecom_active'
			when cntl.remark_2 = 'Telecom' and cntl.status_updated = 'ETL_inactive' then 'Telecom_inactive'
			when cntl.remark_2 = 'Telecom' and cntl.status_updated = 'SMS_success' then 'Telecom_active'
			when cntl.remark_2 = 'Telecom' and cntl.status_updated = 'SMS_Failed' then 'Telecom_inactive'
			when cntl.remark_2 = 'lcc' and cntl.status_updated = 'Block need_to_block' then 'Block need_to_block'
			when cntl.remark_2 = 'lcc' and cntl.status_updated = 'FF1 not_answer' then 'FF1 not_answer'
			when cntl.remark_2 = 'lcc' and cntl.status_updated = 'FF2 power_off' then 'FF2 power_off'
			when cntl.remark_2 = 'lcc' and cntl.status_updated in ('FFF can_not_contact', 'No have in telecom') then 'FFF can_not_contact'
			else cntl.remark_2 
		end `new_result`
	from contact_for_202401_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
	) t
group by branch_name ,  province_eng , `type` , category , category2 , date_received, `priority`, `condition`, `address`, `business_owner`, `car_info`,`name_info` , `result`, `new_result` ;



-- ____________________________________ Export to report all valid source update 2024-02-20 ____________________________________ -- 
select * , count(*) from 
	(
	select  cntl.branch_name , cntl.province_eng , cntl.`type` , fd.category , fd.category2, fd.date_received, cntl.remark_1 `priority`, null `condition`,
		case when cntl.province_eng is not null and cntl.district_eng is not null and cntl.village is not null then 'have_address' 
			when cntl.province_eng is not null and cntl.district_eng is not null then 'only province & district' 
			when cntl.province_eng is not null then 'only province' 
			else 'no_address' 
		end `address`,
		case when fd.category = '①GOVERNMENT' then 'business_owner' else 'no' end `business_owner`,
		case when cntl.maker is not null or cntl.model is not null then 'have_car' else 'no_car' end `car_info`,
		case when cntl.name is not null or cntl.name != '' then 'have_name' else 'no_name' end `name_info`,
		case when cntl.remark_3 = 'contracted' then 'contracted'
			when cntl.remark_3 = 'ringi_not_contract' then 'ringi_not_contract'
			when cntl.remark_3 = 'aseet_not_contract' then 'aseet_not_contract'
			when cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('S','A','B','C') then 'prospect_sabc'
			when cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('F','SP will be salespartner') then 'prospect_f'
			when cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('G','G1','G2') then 'prospect_g'
			when cntl.remark_3 in ('prospect_sabc') and cntl.status in ('X') then 'contracted'
			when cntl.remark_3 in ('lcc') and cntl.status in ('X') then 'prospect_f' -- because there're wrong
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED' then 'ANSWERED'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'NO ANSWER' then 'NO ANSWER'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_active' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_inactive' then 'Telecom_inactive'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_success' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_Failed' then 'Telecom_inactive'
			when cntl.remark_3 = 'lcc' and cntl.status = 'Block need_to_block' then 'Block need_to_block'
			when cntl.remark_3 = 'lcc' and cntl.status = 'FF1 not_answer' then 'FF1 not_answer'
			when cntl.remark_3 = 'lcc' and cntl.status = 'FF2 power_off' then 'FF2 power_off'
			when cntl.remark_3 = 'lcc' and cntl.status in ('FFF can_not_contact', 'No have in telecom') then 'FFF can_not_contact'
			else cntl.remark_3 
		end `result`
	from contact_numbers_to_lcc cntl inner join file_details fd on (fd.id = cntl.file_id)
	where (cntl.remark_3 in ('contracted', 'ringi_not_contract', 'aseet_not_contract') ) -- already register on LMS
		or (cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('X','S','A','B','C', 'FF1 not_answer', 'FF2 power_off') ) -- already register on CRM and LCC
		or (cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED') -- Ever Answered in the past
		or (cntl.remark_3 = 'Telecom' and cntl.status in ('ETL_active', 'SMS_success') ) -- Ever sent SMS and success
		or cntl.status is null -- new number
		or cntl.contact_id in (select contact_id from temp_sms_chairman tean where status = 1 ) -- SMS check
		or cntl.contact_id in (select contact_id from temp_etl_active_numbers tean2 ) -- ETL active 
	) t
group by branch_name , province_eng , `type` , category , category2 , date_received, `priority`, `condition`, `address`, `business_owner`, `car_info`, `name_info`, `result` ;



-- ____________________________________ Export to report all source update 2023-11-02 ____________________________________ -- 
select * , count(*) from 
	(
	select  cntl.branch_name , cntl.province_eng , cntl.`type` , fd.category , fd.category2, fd.date_received, cntl.remark_1 `priority`, null `condition`,
		case when cntl.province_eng is not null and cntl.district_eng is not null and cntl.village is not null then 'have_address' else 'no_address' end `address`,
		case when fd.category = '①GOVERNMENT' then 'business_owner' else 'no' end `business_owner`,
		case when cntl.maker is not null or cntl.model is not null then 'have_car' else 'no_car' end `car_info`,
		case when cntl.name is not null or cntl.name != '' then 'have_name' else 'no_name' end `name_info`,
		case when cntl.remark_3 = 'contracted' then 'contracted'
			when cntl.remark_3 = 'ringi_not_contract' then 'ringi_not_contract'
			when cntl.remark_3 = 'aseet_not_contract' then 'aseet_not_contract'
			when cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('S','A','B','C') then 'prospect_sabc'
			when cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('F','SP will be salespartner') then 'prospect_f'
			when cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('G','G1','G2') then 'prospect_g'
			when cntl.remark_3 in ('prospect_sabc') and cntl.status in ('X') then 'contracted'
			when cntl.remark_3 in ('lcc') and cntl.status in ('X') then 'prospect_f' -- because there're wrong
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED' then 'ANSWERED'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'NO ANSWER' then 'NO ANSWER'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_active' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_inactive' then 'Telecom_inactive'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_success' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_Failed' then 'Telecom_inactive'
			when cntl.remark_3 = 'lcc' and cntl.status = 'Block need_to_block' then 'Block need_to_block'
			when cntl.remark_3 = 'lcc' and cntl.status = 'FF1 not_answer' then 'FF1 not_answer'
			when cntl.remark_3 = 'lcc' and cntl.status = 'FF2 power_off' then 'FF2 power_off'
			when cntl.remark_3 = 'lcc' and cntl.status in ('FFF can_not_contact', 'No have in telecom') then 'FFF can_not_contact'
			else cntl.remark_3 
		end `result`
	from contact_numbers_to_lcc cntl inner join file_details fd on (fd.id = cntl.file_id)
	) t
group by branch_name , province_eng , `type` , category , category2 , date_received, `priority`, `condition`, `address`, `business_owner`, `car_info`, `name_info`, `result` ;




--  and check data
select remark_2, status_updated, count(*) from contact_for_202305_lcc cntl  group by remark_2, status_updated 
order by field(remark_2, "contracted", "ringi_not_contract", "aseet_not_contract",
			"prospect_sabc", "pbx_cdr", "lcc") ,
		FIELD(`status_updated` , "Active", "Closed", "Refinance", "Disbursement Approval", "Pending Disbursement", "Pending Approval", "Pending",
		"Approved", "Pending Approval from Credit", "Asset Assessed", "Pending Assessment", "Draft", "Cancelled", "Deleted",
		"X", "S", "A", "B", "C", "F", "G", "G1", "G2", "SP will be salespartner", "ANSWERED", 
		"NO ANSWER", "Block need_to_block", "FF1 not_answer", "FF2 power_off", "FFF can_not_contact", "No have in telecom") ;



-- COO Yoshi requests How many call time from each number separate by category (0 time, less 5 times, less 10 times, over 10 times)
select *, count(*) from 
(
select fd.`type`, fd.category, fd.category2, 
	case when cntl.`condition` = 0 then '①0 time'
		when cntl.`condition` <= 5 then '②less 5 times'
		when cntl.`condition` <= 10 then '③less 10 times'
		when cntl.`condition` > 10 then '④over 10 times'
	end `call_time_type`
from file_details fd inner join contact_for_202403_lcc cntl on (fd.id = cntl.file_id)
) t
group by `type`, category, category2, `call_time_type`;


select fd.`type`, fd.category, fd.category2, cntl.condition `call_time_type`, count(*) 
from file_details fd inner join contact_for_202403_lcc cntl on (fd.id = cntl.file_id)
group by `type`, category, category2, cntl.condition;














