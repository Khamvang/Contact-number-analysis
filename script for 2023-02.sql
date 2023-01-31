#=========== Prepare contact for LCC, for Area marketing ===============
-- 1) table contact_for  
create table `contact_for_202302_lcc` (
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
  `remark_1` varchar(255) DEFAULT null COMMENT '1=Have car info, 2=Business owner, 3=Have address',
  `remark_2` varchar(255) DEFAULT NULL,
  `remark_3` varchar(255) DEFAULT NULL,
  `branch_name` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `status_updated` varchar(255) DEFAULT NULL,
  `staff_id` varchar(255) DEFAULT NULL,
  `pvd_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  key `contact_no` (`contact_no`),
  key `fk_file_id` (`file_id`),
  CONSTRAINT `contact_for_202302_lcc_ibfk_1` FOREIGN KEY (`file_id`) REFERENCES `file_details` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 collate utf8mb4_general_ci ;



-- --------------------------------Check and update ------------------------------------
-- 1) 
select cntl.id, cntl.branch_name 
from contact_numbers_to_lcc cntl
where cntl.branch_name is null
and ( cntl.remark_3 = 'ringi_not_contract' or cntl.remark_3 = 'aseet_not_contract' 
or (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C'))
or (cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED')
or (cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_active')
or (cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_success') ); -- 1639

update contact_numbers_to_lcc cntl set cntl.branch_name = 'Bokeo'
where cntl.branch_name is null
and ( cntl.remark_3 = 'ringi_not_contract' or cntl.remark_3 = 'aseet_not_contract' 
or (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C'))
or (cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED')
or (cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_active')
or (cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_success') ); -- 1639


-- 2) 
select cntl.id, cntl.branch_name 
from contact_numbers_to_lcc cntl
where cntl.branch_name is null and cntl.remark_3 != 'contracted'
and (cntl.id in (select id from temp_sms_chairman tean where status = 1 ) -- SMS check
or cntl.id in (select id from temp_etl_active_numbers tean2 ) ) -- ETL active

update contact_numbers_to_lcc cntl set cntl.branch_name = 'Bokeo'
where cntl.branch_name is null and cntl.remark_3 != 'contracted'
and (cntl.id in (select id from temp_sms_chairman tean where status = 1 ) -- SMS check
or cntl.id in (select id from temp_etl_active_numbers tean2 ) ) -- ETL active



# ______________________________________________________ Check ______________________________________________________________ #
-- 1)
select count(*) 
from contact_numbers_to_lcc cntl
where cntl.branch_name in ('Attapue','Bokeo','Head Office','Houaphan','LuangNamtha','Luangprabang','Oudomxay','Paksan','Pakse','Salavan','Savannakhet','Thakek','Vientiane province','Xainyabuli','Xiengkhouang'
)
and ( cntl.remark_3 = 'ringi_not_contract' or cntl.remark_3 = 'aseet_not_contract' 
or (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C'))
or (cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED')
or (cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_active')
or (cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_success') ); -- 3021720

-- 2)
select count(*) 
from contact_numbers_to_lcc cntl
where cntl.branch_name in ('Attapue','Bokeo','Head Office','Houaphan','LuangNamtha','Luangprabang','Oudomxay','Paksan','Pakse','Salavan','Savannakhet','Thakek','Vientiane province','Xainyabuli','Xiengkhouang'
)
and ( (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('F')) 
	or (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('G','G1','G2') )
	or (cntl.remark_3 = 'pbx_cdr' and cntl.status = 'NO ANSWER') )
and (cntl.id in (select id from temp_sms_chairman tean where status = 1 ) -- SMS check
or cntl.id in (select id from temp_etl_active_numbers tean2 ) ) -- ETL active




# ______________________________________________________ insert into contact_for_202302_lcc ______________________________________________________________ #
-- 1)
insert into contact_for_202302_lcc
select cntl.id, cntl.`file_id`,`contact_no`,`name`,cntl.province_eng,`province_laos`,cntl.district_eng,`district_laos`,cntl.`village`,cntl.`type`,`maker`,`model`,`year`, 
	'1' `remark_1`,null `remark_2`,`remark_3`,cntl.`branch_name`,cntl.`status`, null `status_updated`, null `staff_id`,null `pvd_id`
-- select count(*) -- 23571
from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
where cntl.branch_name in ('Attapue','Bokeo','Head Office','Houaphan','LuangNamtha','Luangprabang','Oudomxay','Paksan','Pakse','Salavan','Savannakhet','Thakek','Vientiane province','Xainyabuli','Xiengkhouang'
)
and ( cntl.remark_3 = 'ringi_not_contract' or cntl.remark_3 = 'aseet_not_contract' 
or (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C'))
or (cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED')
or (cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_active')
or (cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_success') )
and cntl.id not in (select id from contact_for_202302_lcc);


-- 2)
insert into contact_for_202302_lcc
select cntl.id, cntl.`file_id`,`contact_no`,`name`,cntl.province_eng,`province_laos`,cntl.district_eng,`district_laos`,cntl.`village`,cntl.`type`,`maker`,`model`,`year`, 
	'1' `remark_1`,null `remark_2`,`remark_3`,cntl.`branch_name`,cntl.`status`, null `status_updated`, null `staff_id`,null `pvd_id`
-- select count(*) -- 1199586
from contact_numbers_to_lcc cntl
where cntl.branch_name in ('Attapue','Bokeo','Head Office','Houaphan','LuangNamtha','Luangprabang','Oudomxay','Paksan','Pakse','Salavan','Savannakhet','Thakek','Vientiane province','Xainyabuli','Xiengkhouang'
)
and ( (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('F')) 
	or (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('G','G1','G2') )
	or (cntl.remark_3 = 'pbx_cdr' and cntl.status = 'NO ANSWER') )
and (cntl.id in (select id from temp_sms_chairman tean where status = 1 ) -- SMS check
or cntl.id in (select id from temp_etl_active_numbers tean2 ) ) -- ETL active
 and cntl.id not in (select id from contact_for_202302_lcc);


