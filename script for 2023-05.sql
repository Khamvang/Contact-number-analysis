
update contact_numbers_to_lcc cntl set branch_name = 'Bokeo'
where (cntl.contact_id in (select contact_id from contact_for_202303_lcc ) -- valid numbers
		or cntl.status in ('ringi_not_contract', 'aseet_not_contract','X','S','A','B','C','ANSWERED')
		or cntl.status is null -- new number
	)
	and cntl.branch_name is null;
  
  
  -- 1) table contact_for  
create table `contact_for_202305_lcc` (
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
	  `remark_1` varchar(255) DEFAULT null COMMENT 'priority 1=New call list acquire in Apr 2023, 2=all ①Have Car, 3=②Need loan, 4=③Have address, 5=prospect, 6=telecom',
	  `remark_2` varchar(255) DEFAULT NULL,
	  `remark_3` varchar(255) DEFAULT NULL,
	  `branch_name` varchar(255) DEFAULT NULL,
	  `status` varchar(255) DEFAULT NULL,
	  `status_updated` varchar(255) DEFAULT NULL,
	  `staff_id` varchar(255) DEFAULT NULL,
	  `pvd_id` varchar(255) DEFAULT NULL,
	  `contact_id` int(11) not null comment 'the phone number without 9020 and 9030',
	  `condition` int(11) not null comment '①「Need Loan」, ②「Have Car」, ③「Have Address」　＆　『GOVERNMENT』　OR  『Yellow Page』, ④「Have Address」　＆　others, ⑤『EXPECT』(SAB)  ＆ 　≠『EXITING』『 DORMACCY』, ⑥『EXPECT』(C)  ＆ 　≠『EXITING』『 DORMACCY』 ＆　『CAR INFORMATOIN』, ⑦『TELECOM』have address, ⑧『TELECOM』no address',
	  `group` int(11) not null comment '1=condition 1,2,3,5,6, 2=condition 4,7, 3=condition 8',
	  PRIMARY KEY (`id`),
	  key `contact_no` (`contact_no`),
	  key `fk_file_id` (`file_id`),
	  key `contact_id` (`contact_id`),
	  CONSTRAINT `contact_for_202305_lcc_ibfk_1` FOREIGN KEY (`file_id`) REFERENCES `file_details` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 collate utf8mb4_general_ci ;



-- _____________________________________________________________ 00 _____________________________________________________________
select count(*)
from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
where (cntl.contact_id in (select contact_id from contact_for_202303_lcc ) -- valid numbers
		or cntl.status in ('X','S','A','B','C','ANSWERED')
		or cntl.status is null -- new number
	)
	and (cntl.remark_3 in ('ringi_not_contract', 'aseet_not_contract')
		or (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C','F','G','G1','G2' ))
		or cntl.remark_3 = 'pbx_cdr'
		or (cntl.remark_3 = 'Telecom' and cntl.status in ('ETL_active', 'SMS_success'))
		or (cntl.remark_3 = 'lcc' and cntl.status in ('FF1 not_answer', 'FF2 power_off'))
		or cntl.status is null or cntl.status = ''
		)



-- 1) Priority1: New Call list received in 2023-04
insert into contact_for_202305_lcc
 select cntl.id, cntl.`file_id`,`contact_no`,`name`,cntl.province_eng,`province_laos`,cntl.district_eng,`district_laos`,cntl.`village`,cntl.`type`,`maker`,`model`,`year`, 
	'1' `remark_1`,
	null `remark_2`,`remark_3`,cntl.`branch_name`,cntl.`status`, null `status_updated`, null `staff_id`,null `pvd_id`, 
	case when left(cntl.contact_no,4) = '9020' then right(cntl.contact_no,8) when left(cntl.contact_no,4) = '9030' then right(cntl.contact_no,7) end `contact_id`, 
	case when cntl.`type` = '①Have Car' then 2
		when cntl.`type` = '②Need loan' then 1
		when cntl.`type` = '③Have address' and fd.category = '①GOVERNMENT' then 3
		when cntl.`type` = '③Have address' and fd.category != '①GOVERNMENT' then 4
		when cntl.`type` = '④Telecom' and (cntl.province_eng is not null and cntl.district_eng is not null and cntl.village is not null ) then 7
		when cntl.`type` = '④Telecom' then 8
	end `condition`, 
	case when cntl.`type` in ('①Have Car', '②Need loan') then 1
		when cntl.`type` = '③Have address' and fd.category = '①GOVERNMENT' then 1
		when cntl.`type` = '③Have address' and fd.category != '①GOVERNMENT' then 2
		when cntl.`type` = '④Telecom' and (cntl.province_eng is not null and cntl.district_eng is not null and cntl.village is not null ) then 2
		when cntl.`type` = '④Telecom' then 3
	end `group`
-- select count(*) -- 21428
from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
where (cntl.contact_id in (select contact_id from contact_for_202303_lcc ) -- valid numbers
		or cntl.status in ('X','S','A','B','C','ANSWERED')
		or cntl.status is null -- new number
	)
	and (cntl.remark_3 in ('ringi_not_contract', 'aseet_not_contract')
		or (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C','F','G','G1','G2' ))
		or cntl.remark_3 = 'pbx_cdr'
		or (cntl.remark_3 = 'Telecom' and cntl.status in ('ETL_active', 'SMS_success'))
		or (cntl.remark_3 = 'lcc' and cntl.status in ('FF1 not_answer', 'FF2 power_off'))
		or cntl.status is null or cntl.status = ''
		)
	and fd.date_received >= '2023-04-01';






-- 2) Priority2: Old Call list received before 2023-04
insert into contact_for_202305_lcc
 select cntl.id, cntl.`file_id`,`contact_no`,`name`,cntl.province_eng,`province_laos`,cntl.district_eng,`district_laos`,cntl.`village`,cntl.`type`,`maker`,`model`,`year`, 
	case when cntl.`type` = '①Have Car' then '2'
		when cntl.`type` = '②Need loan' then '3'
		when cntl.`type` = '③Have address' then '4'
		when cntl.`type` = 'prospect' then '5'
		when cntl.`type` = '④Telecom' then '6'
	end `remark_1`,
	null `remark_2`,`remark_3`,cntl.`branch_name`,cntl.`status`, null `status_updated`, null `staff_id`,null `pvd_id`, 
	case when left(cntl.contact_no,4) = '9020' then right(cntl.contact_no,8) when left(cntl.contact_no,4) = '9030' then right(cntl.contact_no,7) end `contact_id`, 
	case when cntl.`type` = '①Have Car' then 2
		when cntl.`type` = '②Need loan' then 1
		when cntl.`type` = '③Have address' and fd.category = '①GOVERNMENT' then 3
		when cntl.`type` = '③Have address' and fd.category != '①GOVERNMENT' then 4
		when cntl.`type` = '④Telecom' and (cntl.province_eng is not null and cntl.district_eng is not null and cntl.village is not null ) then 7
		when cntl.`type` = '④Telecom' then 8
	end `condition`, 
	case when cntl.`type` in ('①Have Car', '②Need loan') then 1
		when cntl.`type` = '③Have address' and fd.category = '①GOVERNMENT' then 1
		when cntl.`type` = '③Have address' and fd.category != '①GOVERNMENT' then 2
		when cntl.`type` = '④Telecom' and (cntl.province_eng is not null and cntl.district_eng is not null and cntl.village is not null ) then 2
		when cntl.`type` = '④Telecom' then 3
	end `group`
-- select count(*) -- 4160014
from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
where (cntl.contact_id in (select contact_id from contact_for_202303_lcc ) -- valid numbers
		or cntl.status in ('X','S','A','B','C','ANSWERED')
		or cntl.status is null -- new number
	)
	and (cntl.remark_3 in ('ringi_not_contract', 'aseet_not_contract')
		or (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C','F','G','G1','G2' ))
		or cntl.remark_3 = 'pbx_cdr'
		or (cntl.remark_3 = 'Telecom' and cntl.status in ('ETL_active', 'SMS_success'))
		or (cntl.remark_3 = 'lcc' and cntl.status in ('FF1 not_answer', 'FF2 power_off'))
		or cntl.status is null or cntl.status = ''
		)
	and fd.date_received < '2023-04-01';



-- Export from lalcodb to contact_for_202304_lcc for condition 5&6
select * , case when left(contact_no, 4) = '9020' then right(contact_no, 8) when left(contact_no, 4) = '9030' then right(contact_no, 7) end "contact_id",
	case when status in ('S','A','B') then '5' when status = 'C' and (maker !='' or model != '') then 6 else 6 end "condition",
	'1' "group"
from (
	select
		null "id",
		case
			when left(right (translate (tel, translate(tel, '0123456789', ''), ''), 8), 1)= '0' then CONCAT('903', right (translate (tel, translate(tel, '0123456789', ''), ''), 8))
			when LENGTH( translate (tel, translate(tel, '0123456789', ''), '')) = 7 then CONCAT('9030', right (translate (tel, translate(tel, '0123456789', ''), ''), 8))
			else CONCAT('9020', right (translate (tel, translate(tel, '0123456789', ''), ''), 8))
		end "contact_no",
		translate (concat(firstname, ' ', lastname), '.,:,', '') "name",
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
		end "province_eng",
		null "province_laos",
		translate (district, '.,:,', '') "district_eng",
		null "district_laos",
		translate (c.addr , '.,:,`', '') "village",
		'prospect' "type",
		translate (maker, '.,:,`', '') "maker",
		translate (model, '.,:,`', '') "model",
		"year",
		null "remark_1",
		null "remark_2",
		'prospect_sabc' "remark_3",
		null "branch_name",
		rank1 "status",
		null "staff_id",
		tua.new_village_id "pvd_id"
	from custtbl c left join temp_update_address tua on (c.id = tua.id)
	where c.rank1 in ('S','A','B') or (c.rank1 = 'C' and (c.maker !='' or c.model != '') )
	order by inputdate desc ) t
where CONCAT(LENGTH("contact_no"), left( "contact_no", 5)) in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290209');



-- check and delete douplicate number 

-- 6)delete duplicate and check data
delete from removed_duplicate_2;
select count(*) from contact_for_202305_lcc_copy; -- 38584 >> 
insert into removed_duplicate_2 
select id, row_numbers, now() `time` from ( 
		select id , row_number() over (partition by contact_no order by field(`type`, "contracted", "ringi_not_contract", "aseet_not_contract",
			"prospect_sabc", "pbx_cdr", "lcc") ,
		FIELD(`status` , "Active", "Closed", "Refinance", "Disbursement Approval", "Pending Disbursement", "Pending Approval", "Pending",
		"Approved", "Pending Approval from Credit", "Asset Assessed", "Pending Assessment", "Draft", "Cancelled", "Deleted",
		"X", "S", "A", "B", "C", "F", "G", "G1", "G2", "ANSWERED", "NO ANSWER", "Block need_to_block", "FF1 not_answer", "FF2 power_off", "FFF can_not_contact")) as row_numbers  
		from contact_for_202305_lcc_copy  
		) as t1
	where row_numbers > 1;

delete from contact_for_202305_lcc_copy where id in (select id from removed_duplicate_2 );


select * from contact_for_202305_lcc_copy where contact_id in (select contact_id from contact_for_202305_lcc);

delete from contact_for_202305_lcc_copy where contact_id in (select contact_id from contact_for_202305_lcc);

update contact_for_202305_lcc_copy set remark_1 = 5;

-- ________________________________________________ update branch name ________________________________________________
-- update contact_numbers_to_lcc aucn
update contact_for_202305_lcc_copy aucn
set branch_name = 
	case when aucn.province_eng = 'ATTAPUE' then 'Attapue'
		when aucn.province_eng = 'BORKEO' then 'Bokeo'
		when aucn.province_eng = 'BORLIKHAMXAY' then 'Paksan'
		when aucn.province_eng = 'CHAMPASACK' then 'Pakse'
		when aucn.province_eng = 'HUAPHAN' then 'Houaphan'
		when aucn.province_eng = 'KHAMMOUAN' then 'Thakek'
		when aucn.province_eng = 'LUANG PRABANG' then 'Luangprabang'
		when aucn.province_eng = 'LUANGNAMTHA' then 'Luangnamtha'
		when aucn.province_eng = 'OUDOMXAY' then 'Oudomxay'
		when aucn.province_eng = 'PHONGSALY' then 'Oudomxay'
		when aucn.province_eng = 'SALAVANH' then 'Salavan'
		when aucn.province_eng = 'SAVANNAKHET' then 'Savannakhet'
		when aucn.province_eng = 'VIENTIANE CAPITAL' then 'Head office'
		when aucn.province_eng = 'VIENTIANE PROVINCE' then 'Vientiane province'
		when aucn.province_eng = 'XAYABOULY' then 'Xainyabuli'
		when aucn.province_eng = 'XAYSOMBOUN' then 'Xiengkhouang'
		when aucn.province_eng = 'XEKONG' then 'Attapue'
		when aucn.province_eng = 'XIENGKHUANG' then 'Xiengkhouang'
		else null 
	end
where aucn.province_eng is not null;

select branch_name , count(*)  from contact_for_202305_lcc_copy group by branch_name 

update contact_for_202305_lcc_copy set branch_name = 'Bokeo' where branch_name is null;

insert into contact_for_202305_lcc select * from contact_for_202305_lcc_copy ;

