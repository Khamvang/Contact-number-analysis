#================ How to update contact data as address, car info by sync data from LALCO portal, LALCO moneymax, LALCO CRM, LALCO LCC =============
-- I. Create tabel for inporting data from LMS LALCO, Moneymax, CRM, LCC
create table `temp_imort_data_from_lms_crm` (
	`id` int(11) not null auto_increment,
	`contact_id` int(11) not null COMMENT 'use phone number int=7 for 030 and int=8 for 020',
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
	primary key (`id`),
	key `contact_id` (`contact_id`)
) engine=InnoDB auto_increment=1 default CHARSET=utf8mb4;


-- create contact_id
alter table temp_imort_data_from_lms_crm add `contact_id` int(11) not null;

alter table temp_imort_data_from_lms_crm add key `contact_id` (`contact_id`);

update temp_imort_data_from_lms_crm set contact_id = case when left(contact_no,4) = '9020' then right(contact_no,8) when left(contact_no,4) = '9030' then right(contact_no,7) end ;



CREATE TABLE `contact_for_updating` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`file_id` int(11) DEFAULT NULL,
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
	`date_updated` date DEFAULT '0000-00-00',
	`pbxcdr_time` int(11) NOT NULL DEFAULT 0,
	`contact_id` int(11) NOT NULL,
	PRIMARY KEY (`id`),
	KEY `fk_file_id` (`file_id`),
	KEY `contact_id` (`contact_id`),
	CONSTRAINT `contact_for_updating_ibfk_1` FOREIGN KEY (`file_id`) REFERENCES `file_details` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;





-- 1) export customer info form LMS to contact_data_db
select 
	case when left (right (REPLACE ( cu.main_contact_no, ' ', '') ,8),1) = '0' then right (REPLACE ( cu.main_contact_no, ' ', '') ,8)
    	when length (REPLACE ( cu.main_contact_no, ' ', '')) = 7 then REPLACE( cu.main_contact_no, ' ', '')
   		else right(REPLACE ( cu.main_contact_no, ' ', '') , 8)
	end `contact_id`,
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
	v.pvd_id `village_id`,
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
	case when left (right (REPLACE ( cu.main_contact_no, ' ', '') ,8),1) = '0' then right (REPLACE ( cu.main_contact_no, ' ', '') ,8)
    	when length (REPLACE ( cu.main_contact_no, ' ', '')) = 7 then REPLACE( cu.main_contact_no, ' ', '')
   		else right(REPLACE ( cu.main_contact_no, ' ', '') , 8)
	end `contact_id`,
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
	v.pvd_id `village_id`,
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
	case
		when left(right (translate (c.tel, translate(c.tel, '0123456789', ''), ''), 8), 1)= '0' then right (translate (c.tel, translate(c.tel, '0123456789', ''), ''), 8)
		when LENGTH( translate (c.tel, translate(c.tel, '0123456789', ''), '')) = 7 then right (translate (c.tel, translate(c.tel, '0123456789', ''), ''), 8)
		else right (translate (c.tel, translate(c.tel, '0123456789', ''), ''), 8)
	end "contact_id",
	case
		when left(right (translate (c.tel, translate(c.tel, '0123456789', ''), ''), 8), 1)= '0' then CONCAT('903', right (translate (c.tel, translate(c.tel, '0123456789', ''), ''), 8))
		when LENGTH( translate (c.tel, translate(c.tel, '0123456789', ''), '')) = 7 then CONCAT('9030', right (translate (c.tel, translate(c.tel, '0123456789', ''), ''), 8))
		else CONCAT('9020', right (translate (c.tel, translate(c.tel, '0123456789', ''), ''), 8))
	end "contact_no",
	concat (firstname, ' ' ,lastname) "name",
	case when province ='Attapeu' then 'ATTAPUE'
		when province ='Bokeo' then 'BORKEO'
		when province ='Bolikhamxai' then 'BORLIKHAMXAY '
		when province ='Champasak' then 'CHAMPASACK'
		when province ='Houaphan' then 'HUAPHAN'
		when province ='Khammouan' then 'KHAMMOUAN'
		when province ='Louang Namtha' then 'LUANGNAMTHA '
		when province ='Louangphrabang' then 'LUANG PRABANG'
		when province ='Oudomxai' then 'OUDOMXAY'
		when province ='Phongsali' then 'PHONGSALY'
		when province ='Saravan' then 'SALAVANH '
		when province ='Savannakhet' then 'SAVANNAKHET'
		when province ='Vientiane Cap' then 'VIENTIANE CAPITAL'
		when province ='Vientiane province' then 'VIENTIANE PROVINCE'
		when province ='Xaignabouri' then 'XAYABOULY '
		when province ='Xaisomboun' then 'XAYSOMBOUN'
		when province ='Xekong' then 'XEKONG'
		when province ='Xiangkhoang' then 'XIENGKHUANG  '
		else null 
	end "province_eng",
	null "province_laos", null "district_eng", district "district_laos", addr "village", village_id ,
	maker  "maker", model  "model", "year",
	3 "priority"
from custtbl c;


-- 4) export customers info form lcc to contact_data_db


-- 5) clear table removed_duplicate_2
delete from removed_duplicate_2;

-- 6) Query date to expot into table removed duplicate_2 
-- partition by contact_no === check duplicate by contact_no
-- order by FIELD(`priority` , 1=lalco, 2=moneymax, 3=crm), id === order priorities by type and id
insert into removed_duplicate_2
select id, row_numbers, now() `time` from ( 
		select id, row_number() over (partition by id order by FIELD(`priority` , 1,2,3), id) as row_numbers  
		from temp_imort_data_from_lms_crm 
		) as t1
	where row_numbers > 1;

-- 7) check and remove duplicate Delete from all unique where id = id in table removed duplicate 
select * from removed_duplicate_2 where `time` >= '2023-02-22';

delete from temp_imort_data_from_lms_crm 
where id in (select id from removed_duplicate_2 where `time` >= '2023-02-22'); 



-- 8) clear table contact_for_updating
delete from contact_for_updating;

-- 9) insert data from contact_numbers_to_lcc to contact_for_updating 
insert into contact_for_updating 
select * from contact_numbers_to_lcc cntl where contact_id in (select contact_id from temp_imort_data_from_lms_crm );

 -- _______________________________________ do temp update _______________________________________
select priority, count(*)  from temp_imort_data_from_lms_crm  group by priority;

select * from temp_imort_data_from_lms_crm limit 10,2 -- 2 rows after row number = 10

insert into temp_imort_data_from_lms_crm_v2
select null 'id', id 'contact_id',contact_no,name,province_eng,province_laos,district_eng,district_laos,village,village_id,maker,model,year,priority
from temp_imort_data_from_lms_crm tidflc 
-- _______________________________________ 00 _______________________________________


-- 10) insert into contact_for_updating from contact_numbers_to_lcc
-- 1st method --
insert into contact_for_updating 
select * from contact_numbers_to_lcc cntl where contact_id in (select id from temp_imort_data_from_lms_crm );

-- 2nd method
insert into contact_for_updating select * from contact_numbers_to_lcc cntl where contact_id in (select contact_id from temp_imort_data_from_lms_crm where id between 1 and 10000 );
insert into contact_for_updating select * from contact_numbers_to_lcc cntl where contact_id in (select contact_id from temp_imort_data_from_lms_crm where id between 10001 and 20000 );


-- 11) replace data to update 
replace into contact_for_updating
select cfu.`id`,cfu.`file_id`,cfu.`contact_no`,
	case when td.name = '' or td.name is null then cfu.name else td.name end `name` ,
	case when td.province_eng = '' or td.province_eng is null then cfu.province_eng else td.province_eng end `province_eng` ,
	case when td.province_laos = '' or td.province_laos is null then cfu.province_laos else td.province_laos end `province_laos` ,
	case when td.district_eng = '' or td.district_eng is null then cfu.district_eng else td.district_eng end `district_eng` ,
	case when td.district_laos = '' or td.district_laos is null then cfu.district_laos else td.district_laos end `district_laos` ,
	case when td.village = '' or td.village is null then cfu.village else td.village end `village` ,
	cfu.`type`,
	case when td.maker = '' or td.maker is null then cfu.maker else td.maker end `maker` ,
	case when td.model = '' or td.model is null then cfu.model else td.model end `model` ,
	case when td.`year` = '' or td.`year` is null then cfu.`year` else td.`year` end `year`, 
	cfu.`remark_1`, cfu.`remark_2`, cfu.`remark_3`, cfu.`branch_name`, cfu.`status`, cfu.`file_no`, cfu.`date_received`, 
	cfu.`date_updated`, cfu.`pbxcdr_time`,cfu.`contact_id`
from contact_for_updating cfu left join temp_imort_data_from_lms_crm td on (td.contact_id = cfu.contact_id) ;

-- 12) open the table contact_for_updating then export as replace to contact_numbers_to_lcc



-- 13) replace data to update from old data to new data
replace into contact_numbers_to_sp
select td.`id`,td.`file_id`,td.`contact_no`,
	case when td.name = '' or td.name is null then cfu.name else td.name end `name` ,
	case when td.province_eng = '' or td.province_eng is null then cfu.province_eng else td.province_eng end `province_eng` ,
	case when td.province_laos = '' or td.province_laos is null then cfu.province_laos else td.province_laos end `province_laos` ,
	case when td.district_eng = '' or td.district_eng is null then cfu.district_eng else td.district_eng end `district_eng` ,
	case when td.district_laos = '' or td.district_laos is null then cfu.district_laos else td.district_laos end `district_laos` ,
	case when td.village = '' or td.village is null then cfu.village else td.village end `village` ,
	td.`type`,
	case when td.maker = '' or td.maker is null then cfu.maker else td.maker end `maker` ,
	case when td.model = '' or td.model is null then cfu.model else td.model end `model` ,
	case when td.`year` = '' or td.`year` is null then cfu.`year` else td.`year` end `year`, 
	null `remark_1`, null `remark_2`, cfu.`remark_3`, 
	case when td.`branch_name` = '' or td.branch_name is null then cfu.branch_name else td.branch_name end `branch_name` , 
	cfu.`status`, td.`file_no`, td.`date_received`, 
	cfu.`date_updated`, cfu.`pbxcdr_time`,cfu.`contact_id`
from contact_numbers_to_copy cfu left join contact_numbers_to_sp td on (td.contact_id = cfu.contact_id) ;




