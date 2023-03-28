

-- 1) table contact_for  
create table `contact_for_202304_lcc` (
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
	  `remark_1` varchar(255) DEFAULT null COMMENT 'priority 1=New call list from Village survey team, 2=Call list received after 2019 and without ①contracted, ②FFF can_not_contact & ③Block need_to_block and ④No Answer 3 months , 3=①「Need Loan」, ②「Have Car」 before 2019',
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
	  CONSTRAINT `contact_for_202304_lcc_ibfk_1` FOREIGN KEY (`file_id`) REFERENCES `file_details` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 collate utf8mb4_general_ci ;


