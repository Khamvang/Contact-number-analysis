
CREATE TABLE `contact_for_acc` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_id` int(11) DEFAULT NULL,
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
  `remark_1` varchar(255) DEFAULT NULL COMMENT 'priority 1=New call list from Village survey team, 2=Call list received after 2019 and without ①contracted, ②FFF can_not_contact & ③Block need_to_block and ④No Answer 3 months , 3=①「Need Loan」, ②「Have Car」 before 2019',
  `remark_2` varchar(255) DEFAULT NULL,
  `remark_3` varchar(255) DEFAULT NULL,
  `branch_name` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `status_updated` varchar(255) DEFAULT NULL,
  `staff_id` varchar(255) DEFAULT NULL,
  `pvd_id` varchar(255) DEFAULT NULL,
  `contact_id` int(11) NOT NULL COMMENT 'the phone number without 9020 and 9030',
  `condition` int(11) NOT NULL COMMENT '①「Need Loan」, ②「Have Car」, ③「Have Address」　＆　『GOVERNMENT』　OR  『Yellow Page』, ④「Have Address」　＆　others, ⑤『EXPECT』(SAB)  ＆ 　≠『EXITING』『 DORMACCY』, ⑥『EXPECT』(C)  ＆ 　≠『EXITING』『 DORMACCY』 ＆　『CAR INFORMATOIN』, ⑦『TELECOM』have address, ⑧『TELECOM』no address',
  `group` int(11) NOT NULL COMMENT '1=condition 1,2,3,5,6, 2=condition 4,7, 3=condition 8',
  PRIMARY KEY (`id`),
  KEY `contact_no` (`contact_no`),
  KEY `fk_file_id` (`file_id`),
  KEY `contact_id` (`contact_id`),
  CONSTRAINT `contact_for_acc_ibfk_1` FOREIGN KEY (`file_id`) REFERENCES `file_details` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19416132 DEFAULT CHARSET=utf8mb4;


-- 4) Priority3: 3=③「Have address」 before 2019
insert into contact_for_acc 
select cntl.id, cntl.`file_id`,`contact_no`,`name`,cntl.province_eng,`province_laos`,cntl.district_eng,`district_laos`,cntl.`village`,cntl.`type`,`maker`,`model`,`year`, 
	'3' `remark_1`,
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
-- select count(*) -- 111598
from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
-- where cntl.id in (select id from contact_for_acc_jan2023_acc)
where fd.date_received < '2019-01-01' and cntl.`type` in  ('③Have address') and cntl.province_eng is null and (cntl.branch_name is null or cntl.branch_name = 'Head office')
	and cntl.status != 'Block need_to_block' and cntl.status != 'FFF can_not_contact'
	and cntl.id not in (select id from contact_for_202304_lcc)
	and cntl.contact_id not in (select contact_id from contact_for_acc_jan2023_acc )
	and (
		(cntl.remark_3 = 'ringi_not_contract' or cntl.remark_3 = 'aseet_not_contract' 
	or (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C'))
	or (cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED')
	or (cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_active')
	or (cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_success') ) -- 1
	or (
		( ( cntl.remark_3 = 'prospect_sabc' and cntl.status in ('F')) 
		or (cntl.remark_3 = 'prospect_sabc' and cntl.status in ('G','G1','G2') )
		or (cntl.remark_3 = 'pbx_cdr' and cntl.status = 'NO ANSWER') )
		and (cntl.id in (select id from temp_sms_chairman tean where status = 1 ) -- SMS check
		or cntl.id in (select id from temp_etl_active_numbers tean2 ) ) 
		) -- 2
	or cntl.status is null -- new number
	)
;




update contact_for_acc set date_provided = '2023-03-02'
where id in (select id from contact_for_acc_jan2023_acc where date_provided = '2023-03-02' );


select date_provided, count(*)  from contact_for_acc group by date_provided;

update contact_for_acc set date_provided = date(now()) where date_provided = '0000-00-00' limit 18000;

-- Call list for ACC
select * from contact_for_acc cfa where date_provided = date(now());


