


-- ____________________________________ Export to report source monthly update 2025-02-28 ____________________________________ -- 
select * , count(*) from 
	(
	select  cntl.branch_name , cntl.province_eng , cntl.`type` , 
		CASE 
			WHEN cntl.`type` = 'F' THEN 'F rank' 
			WHEN cntl.`type` = 'G' THEN 'G rank' 
			ELSE fd.category 
		END AS `category`, 
		case when cntl.`type` = 'prospect' then cntl.status else fd.category2 end `category2`, 
		case when cntl.`type` = 'prospect' then '2023-08-01' else fd.date_received end `date_received`, 
		cntl.remark_1 `priority`, 
		CASE WHEN cntl.`condition` IS NULL OR cntl.`condition` = '' THEN 0 ELSE cntl.`condition` END AS `condition`,
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
		end `new_result`,
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end `called_in`
	from contact_for_202505_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
	left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
	) t
group by branch_name ,  province_eng , `type` , category , category2 , date_received, `priority`, `condition`, `address`, `business_owner`, `car_info`,`name_info` , `result`, `new_result`, `called_in` ;




show index from contact_numbers_to_lcc ;

CREATE INDEX idx_date_updated ON contact_numbers_to_lcc (`date_updated`);


-- check query
select 
	cntl.id ,
	cntl.branch_name , 
	cntl.province_eng , 
	cntl.`type` , 
	CASE 
		WHEN cntl.`type` = 'F' THEN 'F rank' 
		WHEN cntl.`type` = 'G' THEN 'G rank' 
		ELSE fd.category 
	END AS `category`, 
	case when cntl.`type` = 'prospect' then cntl.status 
		else fd.category2 
	end `category2`
from contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '⑥OTHERS'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
;






-- Step 1: Create a temporary table to hold the top 14 IDs with row numbers
CREATE TEMPORARY TABLE temp_branch_update AS
SELECT 
	cntl.id,
	CASE 
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 1 AND 3479 THEN 'Kham'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 3480 AND 5739 THEN 'Mayparkngum'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 5740 AND 8935 THEN 'Chongmeg'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 8936 AND 13854 THEN 'Songkhone'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 13855 AND 17975 THEN 'Xanakharm'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 17976 AND 19519 THEN 'Feuang'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 19520 AND 19531 THEN 'Hongsa'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 19532 AND 26277 THEN 'Luangnamtha'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 26278 AND 26299 THEN 'Luangprabang'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 26300 AND 33684 THEN 'Oudomxay'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 33685 AND 38924 THEN 'Phongsary'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 38925 AND 38931 THEN 'Salavan'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 38932 AND 38967 THEN 'Savannakhet'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 38968 AND 38974 THEN 'Sekong'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 38975 AND 64152 THEN 'Head Office'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 64153 AND 65615 THEN 'Vientiane province'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 65616 AND 65619 THEN 'Xainyabuli'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 65620 AND 65620 THEN 'Xaisomboun'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 65621 AND 66294 THEN 'Xiengkhouang'
	END AS new_branch
FROM contact_for_202505_lcc cntl
LEFT JOIN file_details fd ON fd.id = cntl.file_id
WHERE 
	cntl.branch_name = 'Unknown'
	AND fd.category = '⑥OTHERS'
	AND (
	CASE 
		WHEN cntl.last_call_date >= '2024-11-01' THEN '3 months less'
		ELSE 'over 3 months'
	END
	) = 'over 3 months'
;



-- Step 2: Update all 3 tables at once using the temp table
UPDATE contact_for_202505_lcc cntl
LEFT JOIN temp_branch_update tbu ON tbu.id = cntl.id
LEFT JOIN contact_numbers_to_lcc cntl2 ON cntl2.id = cntl.id
LEFT JOIN contact_for_202504_lcc cntl04 ON cntl04.id = cntl.id
SET 
	cntl.branch_name = tbu.new_branch,
	cntl2.branch_name = tbu.new_branch,
	cntl04.branch_name = tbu.new_branch
WHERE tbu.new_branch IS NOT NULL;


-- Step 3: drop the TEMPORARY TABLE
DROP TEMPORARY TABLE IF EXISTS temp_branch_update;





-- Step 1: Create a temporary table to hold the top 14 IDs with row numbers
CREATE TEMPORARY TABLE temp_branch_update AS
SELECT 
	cntl.id,
	CASE 
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 1 AND 7 THEN 'Kham'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 8 AND 8525 THEN 'Vangvieng'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 8526 AND 13008 THEN 'Mayparkngum'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 13009 AND 18785 THEN 'Chongmeg'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 18786 AND 31959 THEN 'Nambak'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 31960 AND 35063 THEN 'Songkhone'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 35064 AND 35090 THEN 'Hongsa'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 35091 AND 56194 THEN 'Luangnamtha'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 56195 AND 56264 THEN 'Luangprabang'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 56265 AND 100720 THEN 'Oudomxay'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 100721 AND 120732 THEN 'Phongsary'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 120733 AND 120744 THEN 'Salavan'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 120745 AND 120775 THEN 'Savannakhet'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 120776 AND 120782 THEN 'Sekong'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 120783 AND 202092 THEN 'Head Office'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 202093 AND 219106 THEN 'Vientiane province'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 219107 AND 219180 THEN 'Xainyabuli'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 219181 AND 219183 THEN 'Xaisomboun'
		WHEN ROW_NUMBER() OVER (ORDER BY cntl.id) BETWEEN 219184 AND 223576 THEN 'Xiengkhouang'
	END AS new_branch
FROM contact_for_202505_lcc cntl
LEFT JOIN file_details fd ON fd.id = cntl.file_id
WHERE 
	cntl.branch_name = 'Unknown'
	AND fd.category = '④FINANCE∙LEASE'
	AND (
	CASE 
		WHEN cntl.last_call_date >= '2024-11-01' THEN '3 months less'
		ELSE 'over 3 months'
	END
	) = 'over 3 months'
;



-- Step 2: Update all 3 tables at once using the temp table
UPDATE contact_for_202505_lcc cntl
LEFT JOIN temp_branch_update tbu ON tbu.id = cntl.id
LEFT JOIN contact_numbers_to_lcc cntl2 ON cntl2.id = cntl.id
LEFT JOIN contact_for_202504_lcc cntl04 ON cntl04.id = cntl.id
SET 
	cntl.branch_name = tbu.new_branch,
	cntl2.branch_name = tbu.new_branch,
	cntl04.branch_name = tbu.new_branch
WHERE tbu.new_branch IS NOT NULL;


-- Step 3: drop the TEMPORARY TABLE
DROP TEMPORARY TABLE IF EXISTS temp_branch_update;







update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Luangnamtha' ,
	cntl2.branch_name = 'Luangnamtha' ,
	cntl04.branch_name = 'Luangnamtha'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '②INSURANCE'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 4
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Hongsa' ,
	cntl2.branch_name = 'Hongsa' ,
	cntl04.branch_name = 'Hongsa'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '②INSURANCE'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 3
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Chongmeg' ,
	cntl2.branch_name = 'Chongmeg' ,
	cntl04.branch_name = 'Chongmeg'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '②INSURANCE'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 3
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Vangvieng' ,
	cntl2.branch_name = 'Vangvieng' ,
	cntl04.branch_name = 'Vangvieng'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '②INSURANCE'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 4
;





-- update fd.category = '①GOVERNMENT'
update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Xiengkhouang' ,
	cntl2.branch_name = 'Xiengkhouang' ,
	cntl04.branch_name = 'Xiengkhouang'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '①GOVERNMENT'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 1293
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Xaisomboun' ,
	cntl2.branch_name = 'Xaisomboun' ,
	cntl04.branch_name = 'Xaisomboun'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '①GOVERNMENT'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 71
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Xainyabuli' ,
	cntl2.branch_name = 'Xainyabuli' ,
	cntl04.branch_name = 'Xainyabuli'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '①GOVERNMENT'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 336
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Vientiane province' ,
	cntl2.branch_name = 'Vientiane province' ,
	cntl04.branch_name = 'Vientiane province'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '①GOVERNMENT'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 1428
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Head Office' ,
	cntl2.branch_name = 'Head Office' ,
	cntl04.branch_name = 'Head Office'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '①GOVERNMENT'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 72121
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Sekong' ,
	cntl2.branch_name = 'Sekong' ,
	cntl04.branch_name = 'Sekong'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '①GOVERNMENT'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 154
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Sekong' ,
	cntl2.branch_name = 'Sekong' ,
	cntl04.branch_name = 'Sekong'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '①GOVERNMENT'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 154
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Savannakhet' ,
	cntl2.branch_name = 'Savannakhet' ,
	cntl04.branch_name = 'Savannakhet'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '①GOVERNMENT'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 255
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Salavan' ,
	cntl2.branch_name = 'Salavan' ,
	cntl04.branch_name = 'Salavan'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '①GOVERNMENT'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 151
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Phongsary' ,
	cntl2.branch_name = 'Phongsary' ,
	cntl04.branch_name = 'Phongsary'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '①GOVERNMENT'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 484
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Oudomxay' ,
	cntl2.branch_name = 'Oudomxay' ,
	cntl04.branch_name = 'Oudomxay'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '①GOVERNMENT'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 3132
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Luangprabang' ,
	cntl2.branch_name = 'Luangprabang' ,
	cntl04.branch_name = 'Luangprabang'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '①GOVERNMENT'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 535
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Luangnamtha' ,
	cntl2.branch_name = 'Luangnamtha' ,
	cntl04.branch_name = 'Luangnamtha'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '①GOVERNMENT'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 852
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Hongsa' ,
	cntl2.branch_name = 'Hongsa' ,
	cntl04.branch_name = 'Hongsa'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '①GOVERNMENT'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 466
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Songkhone' ,
	cntl2.branch_name = 'Songkhone' ,
	cntl04.branch_name = 'Songkhone'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '①GOVERNMENT'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 894
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Chongmeg' ,
	cntl2.branch_name = 'Chongmeg' ,
	cntl04.branch_name = 'Chongmeg'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '①GOVERNMENT'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 278
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Mayparkngum' ,
	cntl2.branch_name = 'Mayparkngum' ,
	cntl04.branch_name = 'Mayparkngum'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '①GOVERNMENT'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 749
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Kham' ,
	cntl2.branch_name = 'Kham' ,
	cntl04.branch_name = 'Kham'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '①GOVERNMENT'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 706
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Paksxong' ,
	cntl2.branch_name = 'Paksxong' ,
	cntl04.branch_name = 'Paksxong'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '①GOVERNMENT'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 7679
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Sukhuma' ,
	cntl2.branch_name = 'Sukhuma' ,
	cntl04.branch_name = 'Sukhuma'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '①GOVERNMENT'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 3572
;





-- update fd.category = '③CAR SHOP'
update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Xiengkhouang' ,
	cntl2.branch_name = 'Xiengkhouang' ,
	cntl04.branch_name = 'Xiengkhouang'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '③CAR SHOP'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 1915
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Xaisomboun' ,
	cntl2.branch_name = 'Xaisomboun' ,
	cntl04.branch_name = 'Xaisomboun'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '③CAR SHOP'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 4
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Xainyabuli' ,
	cntl2.branch_name = 'Xainyabuli' ,
	cntl04.branch_name = 'Xainyabuli'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '③CAR SHOP'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 13
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Vientiane province' ,
	cntl2.branch_name = 'Vientiane province' ,
	cntl04.branch_name = 'Vientiane province'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '③CAR SHOP'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 6598
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Head Office' ,
	cntl2.branch_name = 'Head Office' ,
	cntl04.branch_name = 'Head Office'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '③CAR SHOP'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 87430
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Sekong' ,
	cntl2.branch_name = 'Sekong' ,
	cntl04.branch_name = 'Sekong'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '③CAR SHOP'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 5
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Savannakhet' ,
	cntl2.branch_name = 'Savannakhet' ,
	cntl04.branch_name = 'Savannakhet'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '③CAR SHOP'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 10
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Salavan' ,
	cntl2.branch_name = 'Salavan' ,
	cntl04.branch_name = 'Salavan'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '③CAR SHOP'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 3
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Phongsary' ,
	cntl2.branch_name = 'Phongsary' ,
	cntl04.branch_name = 'Phongsary'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '③CAR SHOP'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 4208
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Oudomxay' ,
	cntl2.branch_name = 'Oudomxay' ,
	cntl04.branch_name = 'Oudomxay'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '③CAR SHOP'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 15686
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Luangprabang' ,
	cntl2.branch_name = 'Luangprabang' ,
	cntl04.branch_name = 'Luangprabang'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '③CAR SHOP'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 5
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Luangnamtha' ,
	cntl2.branch_name = 'Luangnamtha' ,
	cntl04.branch_name = 'Luangnamtha'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '③CAR SHOP'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 1765
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Hongsa' ,
	cntl2.branch_name = 'Hongsa' ,
	cntl04.branch_name = 'Hongsa'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '③CAR SHOP'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 133
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Chongmeg' ,
	cntl2.branch_name = 'Chongmeg' ,
	cntl04.branch_name = 'Chongmeg'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '③CAR SHOP'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 4791
;


update contact_for_202505_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
left join contact_for_202504_lcc cntl04 on (cntl04.id = cntl.id)
set cntl.branch_name = 'Vangvieng' ,
	cntl2.branch_name = 'Vangvieng' ,
	cntl04.branch_name = 'Vangvieng'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '③CAR SHOP'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 755
;


-- 1 update contact_for_202504_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
-- 2 update contact_for_202505_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
set cntl.branch_name = 'Kham',
	cntl2.branch_name = 'Kham'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '③CAR SHOP'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 3544
;


-- 1 update contact_for_202504_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
-- 2 update contact_for_202505_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
set cntl.branch_name = 'Sukhuma',
	cntl2.branch_name = 'Sukhuma'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '③CAR SHOP'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 1906
;


update contact_for_202504_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
-- update contact_for_202505_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
set cntl.branch_name = 'Vientiane province',
	cntl2.branch_name = 'Vientiane province'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '③CAR SHOP'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 12978
;




-- 
update contact_for_202505_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
set cntl.branch_name = 'Vientiane province',
	cntl2.branch_name = 'Vientiane province'
where 
	cntl.branch_name = 'Unknown'
	and fd.category = '③CAR SHOP'
	and 
		case when cntl.last_call_date >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end = 'over 3 months'
limit 12978
;


-- 
update contact_for_202504_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
set cntl.branch_name = 'Xainyabuli',
	cntl2.branch_name = 'Xainyabuli'
where 
	cntl.branch_name = 'Sainyabuli'
;


-- 
update contact_for_202505_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
set cntl.branch_name = 'Xainyabuli',
	cntl2.branch_name = 'Xainyabuli'
where 
	cntl.branch_name = 'Sainyabuli'
;











