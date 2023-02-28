
-- ____________________________________ Export to report source all valid number ____________________________________ --
select * , count(*) from
	(
	select  cntl.branch_name , cntl.province_eng , cntl.`type` , fd.category , fd.category2 ,
		case when cntl.province_eng is not null and cntl.district_eng is not null and cntl.village is not null then 'have_address' else 'no_address' end `address`,
		case when fd.category = '①GOVERNMENT' then 'business_owner' else 'no' end `business_owner`,
		case when cntl.maker is not null or cntl.model is not null then 'have_car' else 'no_car' end `car_info`,
		case when cntl.remark_3 = 'contracted' then 'contracted'
			when cntl.remark_3 = 'ringi_not_contract' then 'ringi_not_contract'
			when cntl.remark_3 = 'aseet_not_contract' then 'aseet_not_contract'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C') then 'prospect_sabc'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('F') then 'prospect_f'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('G','G1','G2') then 'prospect_g'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('X') then 'contracted'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED' then 'ANSWERED'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'NO ANSWER' then 'NO ANSWER'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_active' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_inactive' then 'Telecom_inactive'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_success' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_Failed' then 'Telecom_inactive'
			else cntl.remark_3 
		end `result` , 
		case when TIMESTAMPDIFF(MONTH, cntl.`date_updated`, date(now())) = 0 then 'Feb 2023' -- current month
			 when TIMESTAMPDIFF(MONTH, cntl.`date_updated`, date(now())) = 1 then 'Jan 2023' -- before current month
			 else 'Before Jan 2023'
		end `called_in_month`
	from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
	where (cntl.remark_3 = 'contracted' or cntl.remark_3 = 'ringi_not_contract' or cntl.remark_3 = 'aseet_not_contract' 
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
	) t
group by branch_name , province_eng , `type` , category , category2 , `address`, `car_info`, `result` ;



-- ____________________________________ Check and update the branch_name is null ____________________________________ --
update contact_numbers_to_lcc cntl set branch_name = 'Bokeo'
where branch_name is null
	and ( (cntl.remark_3 = 'contracted' or cntl.remark_3 = 'ringi_not_contract' or cntl.remark_3 = 'aseet_not_contract' 
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



-- 1) table contact_for  
create table `contact_for_202303_lcc` (
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
  `remark_1` varchar(255) DEFAULT null COMMENT 'priority 1=Never make phone call in the past, 2=Have not call in the previous month, 3=Others',
  `remark_2` varchar(255) DEFAULT NULL,
  `remark_3` varchar(255) DEFAULT NULL,
  `branch_name` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `status_updated` varchar(255) DEFAULT NULL,
  `staff_id` varchar(255) DEFAULT NULL,
  `pvd_id` varchar(255) DEFAULT NULL,
  `contact_id` int(11) not null comment 'the phone number without 9020 and 9030',
  `condition` int(11) not null comment '①『TELECOM』, ②「Need Loan」, ③「Have Car」, ④「Have Address」　＆　『GOVERNMENT』　OR  『Yellow Page』, ⑤「Have Address」　＆　others, ⑥『EXPECT』(SAB)  ＆ 　≠『EXITING』『 DORMACCY』, ⑦『EXPECT』(C)  ＆ 　≠『EXITING』『 DORMACCY』 ＆　『CAR INFORMATOIN』, ⑧have address, ⑨no address',
  `group` int(11) not null comment '1=condition 2,3,4,6,7, 2=condition 5,8',
  PRIMARY KEY (`id`),
  key `contact_no` (`contact_no`),
  key `fk_file_id` (`file_id`),
  key `contact_id` (`contact_id`),
  CONSTRAINT `contact_for_202303_lcc_ibfk_1` FOREIGN KEY (`file_id`) REFERENCES `file_details` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 collate utf8mb4_general_ci ;











