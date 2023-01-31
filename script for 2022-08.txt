#=========== Prepare contact for LCC, for Area marketing ===============
-- 1) table contact_for  
create table `contact_for_202208_lcc` (
  `id` int NOT NULL AUTO_INCREMENT,
  `file_id` int DEFAULT NULL,
  `contact_no` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `province_eng` varchar(255) DEFAULT NULL,
  `province_laos` varchar(255) DEFAULT NULL,
  `district_eng` varchar(50) DEFAULT NULL,
  `district_laos` varchar(255) DEFAULT NULL,
  `village` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `maker` varchar(255) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `year` varchar(255) DEFAULT NULL,
  `remark_1` varchar(255) DEFAULT null COMMENT '1=1 Car Shop+2 Insurance+3 Finance, 2= 4 Others (not Telecom), 3=5 Others (Telecom)',
  `remark_2` varchar(255) DEFAULT NULL,
  `remark_3` varchar(255) DEFAULT NULL,
  `branch_name` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `status_updated` varchar(255) DEFAULT NULL,
  `staff_id` varchar(255) DEFAULT NULL,
  `pvd_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  key `contact_no` (`contact_no`),
  KEY `fk_file_id` (`file_id`),
  CONSTRAINT `contact_for_202208_lcc_ibfk_1` FOREIGN KEY (`file_id`) REFERENCES `file_details` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 collate utf8mb4_general_ci ;


-- --------------------------------------------------------------------
select distinct branch_name from contact_numbers_to_lcc;

update contact_numbers_to_lcc set branch_name = 'Xainyabuli' where branch_name = 'Sainyabuli';

update contact_numbers_to_lcc set branch_name = 'Xainyabuli' where branch_name = 'VTP-Vangvieng';


#____________________________________________________________________________________________________________________#
#__________________________________________00 Import priority1 to LCC 00_____________________________________________#
-- ---------------------------------------------------------------------
#Priority1: 1) Telcom active -- insert into contact_for_202208_lcc 
insert into contact_for_202208_lcc
select cntl.id, cntl.`file_id`,`contact_no`,`name`,cntl.province_eng,`province_laos`,cntl.district_eng,`district_laos`,cntl.`village`,cntl.`type`,`maker`,`model`,`year`, 
	'1' `remark_1`,`remark_2`,`remark_3`,cntl.`branch_name`,cntl.`status`, null `status_updated`, null `staff_id`,null `pvd_id`
-- select count(*) -- 1147583
from contact_numbers_to_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
where cntl.branch_name in ('Attapue','Bokeo','Head Office','Houaphan','LuangNamtha','Luangprabang','Oudomxay','Paksan','Pakse','Salavan','Savannakhet','Thakek','Vientiane province','Xainyabuli','Xiengkhouang')
	and (cntl.remark_3 = 'Telecom' and cntl.status in ('ETL_active', 'SMS_success'));

-- ---------------------------------------------------------------------
#Priority1: 2) ringi_not_contract, aseet_not_contract and prospect_sabc -- insert into contact_for_202208_lcc 
insert into contact_for_202208_lcc
select cntl.id, cntl.`file_id`,`contact_no`,`name`,cntl.province_eng,`province_laos`,cntl.district_eng,`district_laos`,cntl.`village`,cntl.`type`,`maker`,`model`,`year`, 
	'1' `remark_1`,`remark_2`,`remark_3`,cntl.`branch_name`,cntl.`status`, null `status_updated`, null `staff_id`,null `pvd_id`
-- select count(*) -- 26287
from contact_numbers_to_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
where cntl.branch_name in ('Attapue','Bokeo','Head Office','Houaphan','LuangNamtha','Luangprabang','Oudomxay','Paksan','Pakse','Salavan','Savannakhet','Thakek','Vientiane province','Xainyabuli','Xiengkhouang')
	and (cntl.remark_3 = 'ringi_not_contract' or cntl.remark_3 = 'aseet_not_contract' or (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C')));


#____________________________________________________________________________________________________________________#
#__________________________________________00 Import priority2 to LCC 00_____________________________________________#
-- ---------------------------------------------------------------------
#Priority2: 1) Answered -- insert into contact_for_202208_lcc 
insert into contact_for_202208_lcc
select cntl.id, cntl.`file_id`,`contact_no`,`name`,cntl.province_eng,`province_laos`,cntl.district_eng,`district_laos`,cntl.`village`,cntl.`type`,`maker`,`model`,`year`, 
	'2' `remark_1`,`remark_2`,`remark_3`,cntl.`branch_name`,cntl.`status`, null `status_updated`, null `staff_id`,null `pvd_id`
-- select count(*) -- 1761534
from contact_numbers_to_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
where cntl.branch_name in ('Attapue','Bokeo','Head Office','Houaphan','LuangNamtha','Luangprabang','Oudomxay','Paksan','Pakse','Salavan','Savannakhet','Thakek','Vientiane province','Xainyabuli','Xiengkhouang')
	and (cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED');


#____________________________________________________________________________________________________________________#
#__________________________________________00 Import priority3 to LCC 00_____________________________________________#
-- ---------------------------------------------------------------------
#Priority3: prospect_sabc F -- insert into contact_for_202208_lcc 
insert into contact_for_202208_lcc
select cntl.id, cntl.`file_id`,`contact_no`,`name`,cntl.province_eng,`province_laos`,cntl.district_eng,`district_laos`,cntl.`village`,cntl.`type`,`maker`,`model`,`year`, 
	'3' `remark_1`,`remark_2`,`remark_3`,cntl.`branch_name`,cntl.`status`, null `status_updated`, null `staff_id`,null `pvd_id`
-- select count(*) -- 147493
from contact_numbers_to_lcc cntl 
left join file_details fd on (fd.id = cntl.file_id)
where cntl.branch_name in ('Head Office','Luangprabang','Paksan','Pakse','Savannakhet','Xiengkhouang')
	and (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('F'));


#____________________________________________________________________________________________________________________#
#__________________________________________00 Export priority1 to LCC 00_____________________________________________#
-- --------------------------------Type ①Have Car-------------------------------------
#Export Priority1
-- 4) export to create campaign on LCC
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202208_lcc cntl 
where branch_name = 'Attapue' and `type` in( '①Have Car' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 = '1'
	and ( (cntl.remark_3 = 'Telecom' and cntl.status in ('ETL_active', 'SMS_success'))
		or (cntl.remark_3 = 'ringi_not_contract' or cntl.remark_3 = 'aseet_not_contract' or (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C'))) )
	
-- --------------------------- Type ②Need loan ---------------------------
#Export Priority1
-- 4) export to create campaign on LCC
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202208_lcc cntl 
where branch_name = 'Attapue' and `type` in( '②Need loan' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 = '1'
	and ( (cntl.remark_3 = 'Telecom' and cntl.status in ('ETL_active', 'SMS_success'))
		or (cntl.remark_3 = 'ringi_not_contract' or cntl.remark_3 = 'aseet_not_contract' or (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C'))) )

-- --------------------------- Type ③Have address ---------------------------
#Export Priority1
-- 4) export to create campaign on LCC
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202208_lcc cntl 
where branch_name = 'Attapue' and `type` in( '③Have address' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 = '1'
	and ( (cntl.remark_3 = 'Telecom' and cntl.status in ('ETL_active', 'SMS_success'))
		or (cntl.remark_3 = 'ringi_not_contract' or cntl.remark_3 = 'aseet_not_contract' or (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C'))) )

-- --------------------------- Type ④Telecom ---------------------------
#Export Priority1
-- 4) export to create campaign on LCC
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202208_lcc cntl 
where branch_name = 'Attapue' and `type` in( '④Telecom' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 = '1'
	and ( (cntl.remark_3 = 'Telecom' and cntl.status in ('ETL_active', 'SMS_success'))
		or (cntl.remark_3 = 'ringi_not_contract' or cntl.remark_3 = 'aseet_not_contract' or (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C'))) )

#____________________________________________________________________________________________________________________#
#__________________________________________00 Export priority2 to LCC 00_____________________________________________#
-- --------------------------- Type ①Have Car ---------------------------
#Priority2: 1) Answered -- insert into contact_for_202208_lcc 
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202208_lcc cntl 
	where cntl.branch_name in ('Savannakhet') and cntl.type = '①Have Car'
	and cntl.remark_1 = '2'
	and (cntl.remark_3 = 'pbx_cdr'  and cntl.status = 'ANSWERED');

-- --------------------------- Type ②Need loan ---------------------------
#Priority2: 1) Answered -- insert into contact_for_202208_lcc 
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202208_lcc cntl 
	where cntl.branch_name in ('Savannakhet') and cntl.type = '②Need loan'
	and cntl.remark_1 = '2'
	and (cntl.remark_3 = 'pbx_cdr'  and cntl.status = 'ANSWERED');

-- --------------------------- Type ③Have address ---------------------------
#Priority2: 1) Answered -- insert into contact_for_202208_lcc 
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202208_lcc cntl 
	where cntl.branch_name in ('Savannakhet') and cntl.type = '③Have address'
	and cntl.remark_1 = '2'
	and (cntl.remark_3 = 'pbx_cdr'  and cntl.status = 'ANSWERED');
		

-- --------------------------- Type ④Telecom ---------------------------
#Priority2: 1) Answered -- insert into contact_for_202208_lcc 
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202208_lcc cntl 
	where cntl.branch_name in ('Savannakhet') and cntl.type = '④Telecom'
	and cntl.remark_1 = '2'
	and (cntl.remark_3 = 'pbx_cdr'  and cntl.status = 'ANSWERED');


#____________________________________________________________________________________________________________________#
#__________________________________________00 Export priority3 to LCC 00_____________________________________________#
-- --------------------------- Type ①Have Car ---------------------------
#Priority3: prospect_sabc F
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202208_lcc cntl 
	where cntl.branch_name in ('Paksan') and cntl.type = '①Have Car'
	and cntl.remark_1 = '3'
	and (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('F'));

-- --------------------------- Type ②Need loan ---------------------------
#Priority3: prospect_sabc F
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202208_lcc cntl 
	where cntl.branch_name in ('Paksan') and cntl.type = '②Need loan'
	and cntl.remark_1 = '3'
	and (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('F'));

-- --------------------------- Type ③Have address ---------------------------
#Priority3: prospect_sabc F
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202208_lcc cntl 
	where cntl.branch_name in ('Paksan') and cntl.type = '③Have address'
	and cntl.remark_1 = '3'
	and (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('F'));
		

-- --------------------------- Type ④Telecom ---------------------------
#Priority3: prospect_sabc F
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202208_lcc cntl 
	where cntl.branch_name in ('Paksan') and cntl.type = '④Telecom'
	and cntl.remark_1 = '3'
	and (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('F'));




