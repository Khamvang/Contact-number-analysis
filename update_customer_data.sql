#================ How to update contact data as address, car info by sync data from LALCO portal, LALCO moneymax, LALCO CRM, LALCO LCC =============
-- I. Create tabel for inporting data from LMS LALCO, Moneymax, CRM, LCC
create table `temp_imort_data_from_lms_crm` (
  `id` int(11) not null auto_increment COMMENT 'use phone number int=7 for 030 and int=8 for 020',
  `contact_no` varchar(255) default null,
  `name` varchar(255) default null,
  `province_eng` varchar(255) default null,
  `province_laos` varchar(255) default null,
  `district_eng` varchar(255) default null,
  `district_laos` varchar(255) default null,
  `village` varchar(255) default null,
  `village_id` varchar(255) default null,
  `maker` varchar(255) default null,
  `model` varchar(255) default null,
  `year` varchar(255) default null,
  `priority` int not null COMMENT '1=Lalco LMS, 2=Moneymax LMS, 3=CRM, 4=LCC',
  primary key (`id`)
) engine=InnoDB auto_increment=1 default CHARSET=utf8mb4;











-- 1) export customer info form LMS to contact_data_db
select 
	null`id`,
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
	car.car_make  `maker`, car.car_model `model`, av.collateral_year  `year`, 1 `priority`
from tblcustomer cu 
left join tblcity t on (cu.address_city=t.id)
left join tblprospect p on (p.customer_id=cu.id)
left join tblcontract c on (c.prospect_id = p.id)
left join tblprospectasset pa on (pa.prospect_id=p.id)
left join tblassetvaluation av on (pa.assetvaluation_id=av.id)
left join tblcar car on (car.id=av.collateral_car_id)
left join tblvillage v on (v.id=cu.address_village_id);



-- 2) export customer info form Moneymax to contact_data_db
select 
	null`id`,
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
	car.car_make  `maker`, car.car_model `model`, av.collateral_year  `year`, 2 `priority`
from tblcustomer cu 
left join tblcity t on (cu.address_city=t.id)
left join tblprospect p on (p.customer_id=cu.id)
left join tblcontract c on (c.prospect_id = p.id)
left join tblprospectasset pa on (pa.prospect_id=p.id)
left join tblassetvaluation av on (pa.assetvaluation_id=av.id)
left join tblcar car on (car.id=av.collateral_car_id)
left join tblvillage v on (v.id=cu.address_village_id);



-- 3) export customers info form lalcodb to contact_data_db
select 
	null"id",
	case
		when left(right (translate (c.tel, translate(c.tel, '0123456789', ''), ''), 8), 1)= '0' then CONCAT('903', right (translate (c.tel, translate(c.tel, '0123456789', ''), ''), 8))
		when LENGTH( translate (c.tel, translate(c.tel, '0123456789', ''), '')) = 7 then CONCAT('9030', right (translate (c.tel, translate(c.tel, '0123456789', ''), ''), 8))
		else CONCAT('9020', right (translate (c.tel, translate(c.tel, '0123456789', ''), ''), 8))
	end "contact_no",
	concat (firstname, ' ' ,lastname) "name",
	case when province ='Attapeu' then 'ATTAPUE'
		when province ='Bokeo' then 'BORKEO'
		when province ='Bolikhamxai' then 'BORLIKHAMXAY '
		when province ='Champasak' then 'CHAMPASACK'
		when province ='Houaphan' then 'HUAPHAN'
		when province ='Khammouan' then 'KHAMMOUAN'
		when province ='Louang Namtha' then 'LUANGNAMTHA '
		when province ='Louangphrabang' then 'LUANG PRABANG'
		when province ='Oudomxai' then 'OUDOMXAY'
		when province ='Phongsali' then 'PHONGSALY'
		when province ='Saravan' then 'SALAVANH '
		when province ='Savannakhet' then 'SAVANNAKHET'
		when province ='Vientiane Cap' then 'VIENTIANE CAPITAL'
		when province ='Vientiane province' then 'VIENTIANE PROVINCE'
		when province ='Xaignabouri' then 'XAYABOULY '
		when province ='Xaisomboun' then 'XAYSOMBOUN'
		when province ='Xekong' then 'XEKONG'
		when province ='Xiangkhoang' then 'XIENGKHUANG  '
		else null 
	end "province_eng",
	null "province_laos", null "district_eng", district "district_laos", addr "village", village_id ,
	maker  "maker", model  "model", "year",
	3 "priority"
from custtbl c;














