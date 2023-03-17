-- This is special script to run for the list from Village survey team and make the call list to Sales promostion team


-- 1) update the global to fix date issue before create table 
select @@global.sql_mode global, @@session.sql_mode session;
set sql_mode = '', global sql_mode = '';


-- 2) create a table
CREATE TABLE `contact_numbers_to_sp` (
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
	CONSTRAINT `contact_numbers_to_sp_ibfk_1` FOREIGN KEY (`file_id`) REFERENCES `file_details` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;



