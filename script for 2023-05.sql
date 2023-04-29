
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
insert into contact_for_202304_lcc
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
-- select count(*) -- 108249
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




