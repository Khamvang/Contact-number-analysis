#================ How to update contact data as address, car info by sync data from LALCO portal, LALCO moneymax, LALCO CRM, LALCO LCC =============
-- 1) create table contact_for_updating for export data from contact_numbers_to_lcc doing update then inport to it again
CREATE TABLE `contact_for_updating` (
  `id` int NOT NULL AUTO_INCREMENT,
  `file_id` int DEFAULT NULL,
  `contact_no` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `province_eng` varchar(255) DEFAULT NULL,
  `province_laos` varchar(255) DEFAULT NULL,
  `district_eng` varchar(255) DEFAULT NULL,
  `district_laos` varchar(255) DEFAULT NULL,
  `village` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `maker` varchar(255) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `year` varchar(255) DEFAULT NULL,
  `remark_1` varchar(255) DEFAULT NULL,
  `remark_2` varchar(255) DEFAULT NULL,
  `remark_3` varchar(255) DEFAULT NULL,
  `branch_name` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `file_no` varchar(255) NOT NULL,
  `date_received` date NOT NULL,
  `date_updated` date NOT NULL DEFAULT '0000-00-00' ,
  `pbxcdr_time` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_file_id` (`file_id`),
  CONSTRAINT `contact_for_updating_ibfk_1` FOREIGN KEY (`file_id`) REFERENCES `file_details` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;

-- 2) create table temp_update_customer_data for import address and car data to update 
CREATE TABLE `temp_update_customer_data` (
	`id` int(11) not null auto_increment,
	`contact_no` varchar(255) DEFAULT NULL,
	`name` varchar(255) DEFAULT NULL,
	`province_eng` varchar(255) DEFAULT NULL,
	`province_laos` varchar(255) DEFAULT NULL,
	`district_eng` varchar(255) DEFAULT NULL,
	`district_laos` varchar(255) DEFAULT NULL,
	`village` varchar(255) DEFAULT NULL,
	`village_id` varchar(255) DEFAULT null,
	`maker` varchar(255) DEFAULT NULL,
	`model` varchar(255) DEFAULT null,
	`year` varchar(255) DEFAULT null,
	primary key (`id`)
) ENGINE=InnoDB auto_increment = 1 DEFAULT CHARSET=utf8mb4;

-- 3) Export data from LALCO portal to temp_update_customer_data 
-- 4) Export data from LALCO moneymax to temp_update_customer_data 
select 
	case when left (right (REPLACE ( cu.main_contact_no, ' ', '') ,8),1) = '0' then CONCAT('903',right (REPLACE ( cu.main_contact_no, ' ', '') ,8))
	    when length (REPLACE ( cu.main_contact_no, ' ', '')) = 7 then CONCAT('9030',REPLACE ( cu.main_contact_no, ' ', ''))
	    else CONCAT('9020', right(REPLACE ( cu.main_contact_no, ' ', '') , 8))
	end `contact_no`,
	convert(cast(convert(concat(cu.customer_first_name_lo, " ", cu.customer_last_name_lo) using latin1) as binary) using utf8) `name`,
	case cu.address_province 
		WHEN 1 THEN 'ATTAPUE'
		WHEN 2 THEN 'BORKEO'
		WHEN 3 THEN 'BORLIKHAMXAY'
		WHEN 4 THEN 'CHAMPASACK'
		WHEN 5 THEN 'HUAPHAN'
		WHEN 6 THEN 'KHAMMOUAN'
		WHEN 7 THEN 'LUANGNAMTHA'
		WHEN 8 THEN 'LUANG PRABANG'
		WHEN 9 THEN 'OUDOMXAY'
		WHEN 10 THEN 'PHONGSALY'
		WHEN 11 THEN 'SALAVANH'
		WHEN 12 THEN 'SAVANNAKHET'
		WHEN 13 THEN 'VIENTIANE CAPITAL'
		WHEN 14 THEN 'VIENTIANE PROVINCE'
		WHEN 15 THEN 'XAYABOULY'
		WHEN 16 THEN 'XAYSOMBOUN'
		WHEN 17 THEN 'XEKONG'
		WHEN 18 THEN 'XIENGKHUANG'
	end `province_eng`,
	null `province_laos`,
	ci.city_name `district_eng`,
	null `district_laos`,
	case when cu.address_village_id = 0 then convert(cast(convert(cu.address_village using latin1) as binary) using utf8)
		else v.village_name 
	end `village`,
	v.pvd_id `village_id`,
	car.car_make `maker`,
	car.car_model `model`,
	av.collateral_year `year`
from tblcustomer cu
left join tblprospect p on (p.customer_id = cu.id)
left join tblprospectasset pa on (pa.prospect_id = p.id)
left join tblassetvaluation av on (av.id = pa.assetvaluation_id)
left join tblcar car on (car.id = av.collateral_car_id)
left join tblcity ci on (ci.id = cu.address_city)
left join tblvillage v on (v.id = cu.address_village_id)

-- 5) Export data from LALCO CRM to temp_update_customer_data
select 
	case
		when left(right (translate (tel, translate(tel, '0123456789', ''), ''), 8), 1)= '0' then CONCAT('903', right (translate (tel, translate(tel, '0123456789', ''), ''), 8))
		when LENGTH( translate (tel, translate(tel, '0123456789', ''), '')) = 7 then CONCAT('9030', right (translate (tel, translate(tel, '0123456789', ''), ''), 8))
		else CONCAT('9020', right (translate (tel, translate(tel, '0123456789', ''), ''), 8))
	end"contact_no" ,
	translate (concat(firstname, ' ', lastname), '.,:,', '') "name" ,
	case
		when province = 'Attapeu' then 'ATTAPUE'
		when province = 'Bokeo' then 'BORKEO'
		when province = 'Bolikhamxai' then 'BORLIKHAMXAY'
		when province = 'Champasak' then 'CHAMPASACK'
		when province = 'Houaphan' then 'HUAPHAN'
		when province = 'Khammouan' then 'KHAMMOUAN'
		when province = 'Louang Namtha' then 'LUANGNAMTHA'
		when province = 'Louangphrabang' then 'LUANG PRABANG'
		when province = 'Oudomxai' then 'OUDOMXAY'
		when province = 'Phongsali' then 'PHONGSALY'
		when province = 'Saravan' then 'SALAVANH'
		when province = 'Savannakhet' then 'SAVANNAKHET'
		when province = 'Vientiane Cap' then 'VIENTIANE CAPITAL'
		when province = 'Vientiane province' then 'VIENTIANE PROVINCE'
		when province = 'Xaignabouri' then 'XAYABOULY'
		when province = 'Xaisomboun' then 'XAYSOMBOUN'
		when province = 'Xekong' then 'XEKONG'
		when province = 'Xiangkhoang' then 'XIENGKHUANG'
		else null
		end "province_eng" ,
	null "province_laos" ,
	translate (district, '.,:,', '') "district_eng" ,
	null "district_laos" ,
	translate (c.addr , '.,:,`', '') "village" ,
	village_id "village_id" ,
	translate (maker, '.,:,`', '') "maker" ,
	translate (model, '.,:,`', '') "model" ,
	"year" 
from custtbl c 

-- 6) Export data from LALCO LCC to temp_update_customer_data


-- 7) update convert customr contact_no 
update temp_update_customer_data set contact_no = 
	case when (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 9 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),3) = '021')
			or (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 8 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),2) = '21' )
			or (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 6)
		then concat('9021',right(regexp_replace(contact_no , '[^[:digit:]]', ''),6)) -- for 021
		when (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 11 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),3) = '020')
			or (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 10 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),2) = '20')
			or (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 8 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),1) in ('2','5','7','8','9'))
		then concat('9020',right(regexp_replace(contact_no , '[^[:digit:]]', ''),8)) -- for 020
		when (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 10 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),3) = '030')
			or (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 9 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),2) = '30')
			or (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 7 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),1) in ('2','4','5','7','9'))
		then concat('9030',right(regexp_replace(contact_no , '[^[:digit:]]', ''),7)) -- for 090
		when left (right (regexp_replace(contact_no , '[^[:digit:]]', ''),8),1) in ('0','1','') then concat('9030',right(regexp_replace(contact_no , '[^[:digit:]]', ''),7))
		when left (right (regexp_replace(contact_no , '[^[:digit:]]', ''),8),1) in ('2','5','7','8','9')
		then concat('9020',right(regexp_replace(contact_no , '[^[:digit:]]', ''),8))
		else concat('9020',right(regexp_replace(contact_no , '[^[:digit:]]', ''),8))
	end,
	name = replace(replace(name, ' .', ''), '- ', '')

-- 8) remove duplicate 
delete from temp_update_customer_data where id in (
select id from ( 
		select id , row_number() over (partition by contact_no order by id desc) as row_numbers  
		from temp_update_customer_data  
		) as t1
	where row_numbers > 1);

-- 9) remove invalid numbers 
-- select * from temp_update_customer_data 
delete from temp_update_customer_data 
where CONCAT(LENGTH(contact_no), left( contact_no, 5)) not in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290209')
	and CONCAT(LENGTH(contact_no), left( contact_no, 4)) not in ('109021')

-- 10) check and import data from contact_numbers_to_lcc to contact_for_updating 
select count(*) from temp_update_customer_data ; -- 1520562
select count(*) from contact_for_updating cfu left join temp_update_customer_data tucd on (cfu.contact_no = tucd.contact_no); -- 1311964

insert into contact_for_updating 
select * from contact_numbers_to_lcc where contact_no in (select contact_no from temp_update_customer_data )

-- 11) insert data to update -- this will take long time around 15 hours for update 751861 records
replace into contact_for_updating
select 
	cfu.`id`,
	cfu.`file_id`,
	cfu.`contact_no` ,
	case when tucd.name = '' or tucd.name is null then cfu.name 
		else tucd.name 
	end `name` ,
	case when tucd.province_eng = '' or tucd.province_eng is null then cfu.province_eng 
		else tucd.province_eng 
	end `province_eng` ,
	case when tucd.province_laos = '' or tucd.province_laos is null then cfu.province_laos 
		else tucd.province_laos 
	end `province_laos` ,
	case when tucd.district_eng = '' or tucd.district_eng is null then cfu.district_eng 
		else tucd.district_eng 
	end `district_eng` ,
	case when tucd.district_laos = '' or tucd.district_laos is null then cfu.district_laos 
		else tucd.district_laos 
	end `district_laos` ,
	case when tucd.village = '' or tucd.village is null then cfu.village 
		else tucd.village 
	end `village` ,
	cfu.`type` ,
	case when tucd.maker = '' or tucd.maker is null then cfu.maker 
		else tucd.maker 
	end `maker` ,
	case when tucd.model = '' or tucd.model is null then cfu.model 
		else tucd.model 
	end `model` ,
	case when tucd.`year` = '' or tucd.`year` is null then cfu.`year` 
		else tucd.`year`
	end `year` ,
 	cfu.`remark_1` ,
	cfu.`remark_2` ,
	cfu.`remark_3` ,
	cfu.`branch_name` ,
	cfu.`status` ,
	cfu.`file_no` ,
	cfu.`date_received` ,
	date(now()) `date_updated` ,
	cfu.`pbxcdr_time`
from contact_for_updating cfu left join temp_update_customer_data tucd on (cfu.contact_no = tucd.contact_no);

-- 12) export from contact_for_updating to contact_numbers_to_lcc 
alter table contact_numbers_to_lcc convert to character set utf8mb4 ; 

replace into contact_numbers_to_lcc select * from contact_for_updating ;

-- 13) check all data that updated
select count(*) from contact_numbers_to_lcc where date_updated >= '2022-03-22'; -- 1230407
select count(*) from contact_for_updating where date_updated >= '2022-03-22';





====================00 the step for update data 2022-07-27 00==========================
**----
After step -- 8) remove duplicate 
I do below here
---**

-- 1) check and last id for step "insert into temp_update_customer_data2...
select id from temp_update_customer_data2 order by id desc;

-- 2) delete or clear date from table before import new
delete from temp_update_customer_data2;
delete from contact_for_updating;

-- 3) imort 200,000 data from main table to table temp 
insert into temp_update_customer_data2 
select * from temp_update_customer_data tucd where priority in (3) and id >  11174845 -- 1st, 2nd 9158669, 3rd 9712703, 4th > 10210387, 5th >  10718143
limit 200000;

-- 4) insert from main data to temp data
insert into contact_for_updating 
select * from contact_numbers_to_lcc cntl 
where contact_no in (select contact_no from temp_update_customer_data2);

-- 5) insert data to update -- Query OK, 341786 rows affected (2 min 11.37 sec) Records: 170893  Duplicates: 170893  Warnings: 0
replace into contact_for_updating
select 
	cfu.`id`,
	cfu.`file_id`,
	cfu.`contact_no` ,
	case when tucd.name = '' or tucd.name is null then cfu.name else tucd.name end `name` ,
	case when tucd.province_eng = '' or tucd.province_eng is null then cfu.province_eng else tucd.province_eng end `province_eng` ,
	case when tucd.province_laos = '' or tucd.province_laos is null then cfu.province_laos else tucd.province_laos end `province_laos` ,
	case when tucd.district_eng = '' or tucd.district_eng is null then cfu.district_eng else tucd.district_eng end `district_eng` ,
	case when tucd.district_laos = '' or tucd.district_laos is null then cfu.district_laos else tucd.district_laos end `district_laos` ,
	case when tucd.village = '' or tucd.village is null then cfu.village else tucd.village end `village` ,
	cfu.`type` ,
	case when tucd.maker = '' or tucd.maker is null then cfu.maker else tucd.maker end `maker` ,
	case when tucd.model = '' or tucd.model is null then cfu.model else tucd.model end `model` ,
	case when tucd.`year` = '' or tucd.`year` is null then cfu.`year` else tucd.`year` end `year` ,
 	cfu.`remark_1` ,
	cfu.`remark_2` ,
	cfu.`remark_3` ,
	cfu.`branch_name` ,
	cfu.`status` ,
	cfu.`file_no` ,
	cfu.`date_received` ,
	date(now()) `datee_updated` ,
	cfu.`pbxcdr_time`
from contact_for_updating cfu left join temp_update_customer_data2 tucd on (cfu.contact_no = tucd.contact_no);

-- 6) replace to main data again 
replace into contact_numbers_to_lcc select * from contact_for_updating; -- Query OK, 341786 rows affected (2 hours 44 min 52.19 sec)

/* -- this take long time 
select id from contact_numbers_to_lcc cntl where id in (select id from contact_for_updating cfu);
delete from contact_numbers_to_lcc cntl where id in (select id from contact_for_updating cfu); -- Query OK, 169111 rows affected (2 hours 55 min 2.96 sec)
insert into contact_numbers_to_lcc select * from contact_for_updating; -- Query OK, 169111 rows affected (2 hours 45 min 49.68 sec)
*/




