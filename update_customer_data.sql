
-- 1) export customers info form LMS to contact_data_db
select 
	null`id`,null `file_id`, 
	case when left (right (REPLACE ( cu.main_contact_no, ' ', '') ,8),1) = '0' then CONCAT('903',right (REPLACE ( cu.main_contact_no, ' ', '') ,8))
    	when length (REPLACE ( cu.main_contact_no, ' ', '')) = 7 then CONCAT('9030',REPLACE ( cu.main_contact_no, ' ', ''))
   		else CONCAT('9020', right(REPLACE ( cu.main_contact_no, ' ', '') , 8))
	end `contact_no`,
	convert(cast(convert(concat (cu.customer_first_name_lo, " " ,customer_last_name_lo)using latin1)as binary)using utf8)`name`,
	case when cu.address_province =  1 then 'ATTAPUE' 
		when cu.address_province =2 then 'BORKEO' 
		when cu.address_province =3 then 'BORLIKHAMXAY' 
		when cu.address_province =4 then 'CHAMPASACK'
		when cu.address_province =5 then 'HUAPHAN'
		when cu.address_province =6 then 'KHAMMOUAN'
		when cu.address_province =7 then 'LUANGNAMTHA' 
		when cu.address_province =8 then 'LUANG PRABANG'
		when cu.address_province =9 then 'OUDOMXAY'
		when cu.address_province =10 then 'PHONGSALY'
		when cu.address_province =11 then 'SALAVANH' 
		when cu.address_province =12 then 'SAVANNAKHET'
		when cu.address_province =13 then 'VIENTIANE CAPITAL'
		when cu.address_province =14 then 'VIENTIANE PROVINCE'
		when cu.address_province =15 then 'XAYABOULY' 
		when cu.address_province =16 then 'XAYSOMBOUN'
		when cu.address_province =17 then 'XEKONG'
		when cu.address_province =18 then 'XIENGKHUANG'  
		else null 
	end `province_eng`,
	null `province_laos`,
	t.city_name `district_eng`,
	null `district_laos`,
	CASE WHEN cu.address_village_id != 0 and CONVERT(CAST(CONVERT(v.village_name_lao using latin1) as binary) using utf8) IS NULL THEN v.village_name 
		WHEN cu.address_village_id != 0 THEN CONVERT(CAST(CONVERT(v.village_name_lao using latin1) as binary) using utf8)
		ELSE CONVERT(CAST(CONVERT(cu.address_village using latin1) as binary) using utf8) 
	END `village`,
	null `type`,
	car.car_make  `maker`, car.car_model `model`, av.collateral_year  `year`,
	null `remark_1`, null `remark_2`, null `remark_3`, null `branch_name`, null `status`, null `file_no`, null `date_received`, null `date_updated`, null `pbxcdr_time`
from tblcustomer cu 
left join tblcity t on (cu.address_city=t.id)
left join tblprospect p on (p.customer_id=cu.id)
left join tblcontract c on (c.prospect_id = p.id)
left join tblprospectasset pa on (pa.prospect_id=p.id)
left join tblassetvaluation av on (pa.assetvaluation_id=av.id)
left join tblcar car on (car.id=av.collateral_car_id)
left join tblvillage v on (v.id=cu.address_village_id)
group by cu.id;



-- 2) export customers info form lalcodb to contact_data_db















