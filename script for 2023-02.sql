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



# ______________________________________________________ update priority contact_for_202302_lcc ______________________________________________________________ #
update contact_for_202302_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
set remark_1 = 
	case when cntl.maker != '' or cntl.model != '' then 1
		when fd.category = '①GOVERNMENT' then 2
		when cntl.province_eng != '' and cntl.district_eng != '' and cntl.village != '' then 3
		else 4
	end;


# ______________________________________________________ export to create campaign on LCC for contact_for_202302_lcc ______________________________________________________________ #

'Attapue','Bokeo','Head Office','Houaphan','LuangNamtha','Luangprabang','Oudomxay','Paksan','Pakse','Salavan','Savannakhet','Thakek','Vientiane province','Xainyabuli','Xiengkhouang'

-- ____________________________________________________ 1 Have car ____________________________________________________
-- 1) Have car: priority 1&2 -- Campaign name: 1_Old_ATTAPUE_ATP Team_20230201-12
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202302_lcc cntl 
where branch_name = 'Attapue' and `type` in( '①Have Car' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('1', '2') order by cntl.remark_1;

-- 1) Have car: priority 3&4 -- Campaign name: 1_Old_ATTAPUE_ATP Team_20230201-34
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202302_lcc cntl 
where branch_name = 'Attapue' and `type` in( '①Have Car' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('3', '4') order by cntl.remark_1;

-- ____________________________________________________ 2 Need loan ____________________________________________________
-- 2) Need loan: priority 1&2 -- Campaign name: 2_Old_ATTAPUE_ATP Team_20230201-12
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202302_lcc cntl 
where branch_name = 'Attapue' and `type` in( '②Need loan' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('1', '2') order by cntl.remark_1;

-- 2) Need loan: priority 3&4 -- Campaign name: 2_Old_ATTAPUE_ATP Team_20230201-34
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202302_lcc cntl 
where branch_name = 'Attapue' and `type` in( '②Need loan' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('3', '4') order by cntl.remark_1;


-- ____________________________________________________ 3 Have address ____________________________________________________
-- 3) Have address: priority 1&2 -- Campaign name: 3_Old_ATTAPUE_ATP Team_20230201-12
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202302_lcc cntl 
where branch_name = 'Attapue' and `type` in( '③Have address' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('1', '2') order by cntl.remark_1;

-- 3) Have address: priority 3&4 -- Campaign name: 3_Old_ATTAPUE_ATP Team_20230201-34
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202302_lcc cntl 
where branch_name = 'Attapue' and `type` in( '③Have address' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('3', '4') order by cntl.remark_1;


-- ____________________________________________________ 4 Telecom ____________________________________________________
-- 4) Telecom: priority 1&2 -- Campaign name: 4_Old_ATTAPUE_ATP Team_20230201-12
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202302_lcc cntl 
where branch_name = 'Attapue' and `type` in( '④Telecom' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('1', '2') order by cntl.remark_1;

-- 4) Telecom: priority 3&4 -- Campaign name: 4_Old_ATTAPUE_ATP Team_20230201-34
-- select count(*) 
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202302_lcc cntl 
where branch_name = 'Attapue' and `type` in( '④Telecom' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('3', '4') order by cntl.remark_1;




--___________________________________________________________________________________________________________________
-- _______________________________________________________ HO _______________________________________________________

-- ____________________________________________________ 1 Have car ____________________________________________________
-- 1) Have car: priority 1&2 -- Campaign name: 1_Old_HO_Team2_20230201-12, 1_Old_HO_Team3_20230201-12, 1_Old_HO_Team4_20230201-12
 select count(*), count(*)/3
; select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202302_lcc cntl 
where branch_name = 'Head Office' and `type` in( '①Have Car' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('1', '2') -- order by cntl.remark_1;
	-- and cntl.id > 37281111
limit 17520

-- 1) Have car: priority 3&4 -- Campaign name: 1_Old_HO_Team2_20230201-34
 select count(*), count(*)/9
; select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202302_lcc cntl 
where branch_name = 'Head Office' and `type` in( '①Have Car' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('3', '4') -- order by cntl.remark_1;
	 and cntl.id > 36957447
limit 39125



-- ____________________________________________________ 2 Need loan ____________________________________________________
-- 2) Need loan: priority 1&2 -- Campaign name: 2_Old_HO_Team2_20230201-12
 select count(*), count(*)/3
; select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202302_lcc cntl 
where branch_name = 'Head Office' and `type` in( '②Need loan' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('1', '2') -- order by cntl.remark_1;
	 and cntl.id > 33605596
limit 2961

-- 2) Need loan: priority 3&4 -- Campaign name: 2_Old_HO_Team2_20230201-34
 select count(*), count(*)/9
; select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202302_lcc cntl 
where branch_name = 'Head Office' and `type` in( '②Need loan' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('3', '4') -- order by cntl.remark_1;
	 and cntl.id > 21039573
limit 19378


-- ____________________________________________________ 3 Have address ____________________________________________________
-- 3) Have address: priority 1&2 -- Campaign name: 3_Old_HO_Team2_20230201-12
 select count(*), count(*)/9
; select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202302_lcc cntl 
where branch_name = 'Head Office' and `type` in( '③Have address' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('1', '2') -- order by cntl.remark_1;
	 and cntl.id > 7603716
limit 26919

-- 3) Have address: priority 3&4 -- Campaign name: 3_Old_HO_Team2_20230201-34
 select count(*), count(*)/9
 select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202302_lcc cntl 
where branch_name = 'Head Office' and `type` in( '③Have address' ) -- '①Have Car' '②Need loan' '③Have address' '④Telecom'
	and cntl.remark_1 in ('3', '4') -- order by cntl.remark_1;
	-- and cntl.id > 1
limit 1




