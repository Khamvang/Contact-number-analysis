#=========== Prepare contact for LCC, for Area marketing ===============
-- 1) table contact_for  
create table `contact_for_202211_lcc` (
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
  `remark_1` varchar(255) DEFAULT null COMMENT '1=Ringi_Asset_SABC,2=Prospect_F&G that SMS success, 3=Telecom_active or SMS success, 4=ANSWERED and SMS success, 5=SMS success but NO ANSWER',
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
  CONSTRAINT `contact_for_202211_lcc_ibfk_1` FOREIGN KEY (`file_id`) REFERENCES `file_details` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 collate utf8mb4_general_ci ;


-- --------------------------------Check and update ------------------------------------



select remark_1 , count(*) from contact_for_202211_lcc cfl group by remark_1 ;

#____________________________________________________________________________________________________________________#
#__________________________________________00 Import priority1 to LCC 00_____________________________________________#
-- ---------------------------------------------------------------------
#Priority1: 1=Ringi_Asset_SABC  
insert into contact_for_202211_lcc
select cntl.id, cntl.`file_id`,`contact_no`,`name`,cntl.province_eng,`province_laos`,cntl.district_eng,`district_laos`,cntl.`village`,cntl.`type`,`maker`,`model`,`year`, 
	'1' `remark_1`,null `remark_2`,`remark_3`,cntl.`branch_name`,cntl.`status`, null `status_updated`, null `staff_id`,null `pvd_id`
-- select count(*) -- 23571
from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
where cntl.branch_name in ('Attapue','Bokeo','Head Office','Houaphan','LuangNamtha','Luangprabang','Oudomxay','Paksan','Pakse','Salavan','Savannakhet','Thakek','Vientiane province','Xainyabuli','Xiengkhouang')
	and (cntl.remark_3 in ('ringi_not_contract', 'aseet_not_contract' ) or (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C'))) ;

#____________________________________________________________________________________________________________________#
#__________________________________________00 Import priority2 to LCC 00_____________________________________________#
-- ---------------------------------------------------------------------
#Priority2: 2=Prospect_F&G that SMS success 
insert into contact_for_202211_lcc
select cntl.id, cntl.`file_id`,`contact_no`,`name`,cntl.province_eng,`province_laos`,cntl.district_eng,`district_laos`,cntl.`village`,cntl.`type`,`maker`,`model`,`year`, 
	'2' `remark_1`,null `remark_2`,`remark_3`,cntl.`branch_name`,cntl.`status`, null `status_updated`, null `staff_id`,null `pvd_id`
-- select count(*) -- 426712
from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
where cntl.branch_name in ('Attapue','Bokeo','Head Office','Houaphan','LuangNamtha','Luangprabang','Oudomxay','Paksan','Pakse','Salavan','Savannakhet','Thakek','Vientiane province','Xainyabuli','Xiengkhouang')
	and (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('F','G','G1','G2'))
	and cntl.id in (select id from temp_sms_chairman tean where status = 1);

#____________________________________________________________________________________________________________________#
#__________________________________________00 Import priority3 to LCC 00_____________________________________________#
-- ---------------------------------------------------------------------
#Priority3: 3) Telecom_active 
insert into contact_for_202211_lcc
select cntl.id, cntl.`file_id`,`contact_no`,`name`,cntl.province_eng,`province_laos`,cntl.district_eng,`district_laos`,cntl.`village`,cntl.`type`,`maker`,`model`,`year`, 
	'3' `remark_1`,null `remark_2`,`remark_3`,cntl.`branch_name`,cntl.`status`, null `status_updated`, null `staff_id`,null `pvd_id`
-- select count(*) -- 556304
from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
where cntl.branch_name in ('Attapue','Bokeo','Head Office','Houaphan','LuangNamtha','Luangprabang','Oudomxay','Paksan','Pakse','Salavan','Savannakhet','Thakek','Vientiane province','Xainyabuli','Xiengkhouang')
	and (cntl.remark_3 = 'Telecom' and cntl.status in ('ETL_active','SMS_success') ) ;


#Priority3: 3=Null but SMS success 
insert into contact_for_202211_lcc
select cntl.id, cntl.`file_id`,`contact_no`,`name`,cntl.province_eng,`province_laos`,cntl.district_eng,`district_laos`,cntl.`village`,cntl.`type`,`maker`,`model`,`year`, 
	'3' `remark_1`,null `remark_2`,`remark_3`,cntl.`branch_name`,cntl.`status`, null `status_updated`, null `staff_id`,null `pvd_id`
-- select count(*) -- 9906
from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
where cntl.branch_name in ('Attapue','Bokeo','Head Office','Houaphan','LuangNamtha','Luangprabang','Oudomxay','Paksan','Pakse','Salavan','Savannakhet','Thakek','Vientiane province','Xainyabuli','Xiengkhouang')
	and cntl.status is null
	and cntl.id in (select id from temp_sms_chairman tean where status = 1);

#____________________________________________________________________________________________________________________#
#__________________________________________00 Import priority4 to LCC 00_____________________________________________#
-- ---------------------------------------------------------------------
#Priority3: 4=ANSWERED and SMS success
insert into contact_for_202211_lcc
select cntl.id, cntl.`file_id`,`contact_no`,`name`,cntl.province_eng,`province_laos`,cntl.district_eng,`district_laos`,cntl.`village`,cntl.`type`,`maker`,`model`,`year`, 
	'4' `remark_1`,null `remark_2`,`remark_3`,cntl.`branch_name`,cntl.`status`, null `status_updated`, null `staff_id`,null `pvd_id`
-- select count(*) -- 445175
from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
where cntl.branch_name in ('Attapue','Bokeo','Head Office','Houaphan','LuangNamtha','Luangprabang','Oudomxay','Paksan','Pakse','Salavan','Savannakhet','Thakek','Vientiane province','Xainyabuli','Xiengkhouang')
	and (cntl.remark_3 = 'pbx_cdr' and cntl.status in ('ANSWERED') ) 
	and cntl.id in (select id from temp_sms_chairman tean where status = 1);

#____________________________________________________________________________________________________________________#
#__________________________________________00 Import priority5 to LCC 00_____________________________________________#
-- ---------------------------------------------------------------------
#Priority3: 5=SMS success but NO ANSWER
insert into contact_for_202211_lcc
select cntl.id, cntl.`file_id`,`contact_no`,`name`,cntl.province_eng,`province_laos`,cntl.district_eng,`district_laos`,cntl.`village`,cntl.`type`,`maker`,`model`,`year`, 
	'5' `remark_1`,null `remark_2`,`remark_3`,cntl.`branch_name`,cntl.`status`, null `status_updated`, null `staff_id`,null `pvd_id`
-- select count(*) -- 398710
from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
where cntl.branch_name in ('Attapue','Bokeo','Head Office','Houaphan','LuangNamtha','Luangprabang','Oudomxay','Paksan','Pakse','Salavan','Savannakhet','Thakek','Vientiane province','Xainyabuli','Xiengkhouang')
	and (cntl.remark_3 = 'pbx_cdr' and cntl.status in ('NO ANSWER') ) 
	and cntl.id in (select id from temp_sms_chairman tean where status = 1);


#____________________________________________________________________________________________________________________#
#__________________________________________00 Import priority6 to LCC 00_____________________________________________#
-- --------------------------------------------------------------------- 2022-10-17
#Priority3: 6=ANSWERED and SMS not yet check SMS and type = ①Have Car
insert into contact_for_202211_lcc
select cntl.id, cntl.`file_id`,`contact_no`,`name`,cntl.province_eng,`province_laos`,cntl.district_eng,`district_laos`,cntl.`village`,cntl.`type`,`maker`,`model`,`year`, 
	'6' `remark_1`,null `remark_2`,`remark_3`,cntl.`branch_name`,cntl.`status`, null `status_updated`, null `staff_id`,null `pvd_id`
-- select count(*) -- 103039
from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
where cntl.branch_name in ('Attapue','Oudomxay','Thakek')
	and (cntl.remark_3 = 'pbx_cdr' and cntl.status in ('ANSWERED') and cntl.`type` = '①Have Car') 
	and cntl.id not in (select id from contact_for_202211_lcc);



#____________________________________________________________________________________________________________________#
#__________________________________________00 Export priority1 and priority2 to LCC 00_____________________________________________#
-- --------------------------------Type ①Have Car-------------------------------------
#Export Priority1&2: ①Have Car
-- 4) export to create campaign on LCC
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202211_lcc cntl 
where branch_name = 'Attapue' and `type` in( '①Have Car' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('1', '2');

-- --------------------------- Type ②Need loan ---------------------------
#Export Priority1&2: ②Need loan
-- 4) export to create campaign on LCC
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202211_lcc cntl 
where branch_name = 'Attapue' and `type` in( '②Need loan' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('1', '2');

-- --------------------------- Type ③Have address ---------------------------
#Export Priority1&2: ③Have address
-- 4) export to create campaign on LCC
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202211_lcc cntl 
where branch_name = 'Attapue' and `type` in( '③Have address' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('1', '2');

-- --------------------------- Type ④Telecom ---------------------------
#Export Priority1&2: ④Telecom
-- 4) export to create campaign on LCC
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202211_lcc cntl 
where branch_name = 'Attapue' and `type` in( '④Telecom' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('1', '2');


#____________________________________________________________________________________________________________________#
#__________________________________________00 Export priority3 to LCC 00_____________________________________________#
-- --------------------------- Type ①Have Car ---------------------------
#Export Priority3: ①Have Car
-- 4) export to create campaign on LCC
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202211_lcc cntl 
where branch_name = 'Xiengkhouang' and `type` in( '①Have Car' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('3') ;

-- --------------------------- Type ②Need loan ---------------------------
#Export Priority3
-- 4) export to create campaign on LCC
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202211_lcc cntl 
where branch_name = 'Xiengkhouang' and `type` in( '②Need loan' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('3') ;

-- --------------------------- Type ③Have address ---------------------------
#Export Priority3
-- 4) export to create campaign on LCC
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202211_lcc cntl 
where branch_name = 'Xiengkhouang' and `type` in( '③Have address' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('3') ;

-- --------------------------- Type ④Telecom ---------------------------
#Export Priority3
-- 4) export to create campaign on LCC
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202211_lcc cntl 
where branch_name = 'Xiengkhouang' and `type` in( '④Telecom' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('3') ;



#____________________________________________________________________________________________________________________#
#__________________________________________00 Export priority4 to LCC 00_____________________________________________#
-- --------------------------------Type ①Have Car-------------------------------------
#Export Priority4: ①Have Car
-- 4) export to create campaign on LCC
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202211_lcc cntl 
where branch_name = 'Attapue' and `type` in( '①Have Car' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('4');

-- --------------------------- Type ②Need loan ---------------------------
#Export Priority4: ②Need loan
-- 4) export to create campaign on LCC
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202211_lcc cntl 
where branch_name = 'Attapue' and `type` in( '②Need loan' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('4');

-- --------------------------- Type ③Have address ---------------------------
#Export Priority4: ③Have address
-- 4) export to create campaign on LCC
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202211_lcc cntl 
where branch_name = 'Attapue' and `type` in( '③Have address' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('4');

-- --------------------------- Type ④Telecom ---------------------------
#Export Priority4: ④Telecom
-- 4) export to create campaign on LCC
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202211_lcc cntl 
where branch_name = 'Attapue' and `type` in( '④Telecom' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('4');



#____________________________________________________________________________________________________________________#
#__________________________________________00 Export priority5 to LCC 00_____________________________________________#
select branch_name ,
	concat('=HYPERLINK("https://wa.me/+856', right(contact_no, length(contact_no) - 2), '",', id,')' ) `WA_link`,
	concat('=HYPERLINK("https://docs.google.com/forms/d/e/1FAIpQLScoYO-WEEH92X4BCG0d79CuMnfI0Qm9RmwkwK2z7sNxixFBjw/viewform?usp=pp_url&entry.2032788253=', id, '", "update")' ) 'Submit_WA',
	null 'staff_no',
	null 'staff_name'
from contact_for_202211_lcc cfl 
where remark_1 = '5' and left(contact_no, 4) = '9020';




#____________________________________________________________________________________________________________________#
#__________________________________________00 Export priority6 to LCC 00_____________________________________________#
-- --------------------------------Type ①Have Car-------------------------------------
#Export Priority6: ①Have Car
-- 4) export to create campaign on LCC
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202211_lcc cntl 
where branch_name = 'Attapue' and `type` in( '①Have Car' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('6');





