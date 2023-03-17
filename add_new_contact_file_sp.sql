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


-- 3) insert data into table
insert into contact_numbers_to_sp (`id`,`file_id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`,`branch_name`,`status`,`file_no`,`date_received`,`date_updated`,`pbxcdr_time`, `contact_id`)
select cn.`id`,cn.`file_id`,cn.`contact_no`,
	case when cn.`name` = '' then null else cn.`name` end `name`, 
	case when cn.`province_eng` = '' then null else cn.`province_eng` end `province_eng`,
	case when cn.`province_laos` = '' then null else cn.`province_laos` end `province_laos`,
	case when cn.`district_eng` = '' then null else cn.`district_eng` end `district_eng`,
	case when cn.`district_laos` = '' then null else cn.`district_laos` end `district_laos`,
	case when cn.`village` = '' then null else cn.`village` end `village`,
	cn.`type`, 
	case when cn.`maker` = '' then null else cn.`maker` end `maker`,
	case when cn.`model` = '' then null else cn.`model` end `model`,
	case when cn.`year` = '' then null else cn.`year` end `year`,
	null `remark_1`,null `remark_2`,null `remark_3`,
	case when cn.province_eng = 'ATTAPUE' then 'Attapue'
		when cn.province_eng = 'BORKEO' then 'Bokeo'
		when cn.province_eng = 'BORLIKHAMXAY' then 'Paksan'
		when cn.province_eng = 'CHAMPASACK' then 'Pakse'
		when cn.province_eng = 'HUAPHAN' then 'Houaphan'
		when cn.province_eng = 'KHAMMOUAN' then 'Thakek'
		when cn.province_eng = 'LUANG PRABANG' then 'Luangprabang'
		when cn.province_eng = 'LUANGNAMTHA' then 'Luangnamtha'
		when cn.province_eng = 'OUDOMXAY' then 'Oudomxay'
		when cn.province_eng = 'PHONGSALY' then 'Oudomxay'
		when cn.province_eng = 'SALAVANH' then 'Salavan'
		when cn.province_eng = 'SAVANNAKHET' then 'Savannakhet'
		when cn.province_eng = 'VIENTIANE CAPITAL' then 'Head office'
		when cn.province_eng = 'VIENTIANE PROVINCE' then 'Vientiane province'
		when cn.province_eng = 'XAYABOULY' then 'Xainyabuli'
		when cn.province_eng = 'XAYSOMBOUN' then 'Xiengkhouang'
		when cn.province_eng = 'XEKONG' then 'Attapue'
		when cn.province_eng = 'XIENGKHUANG' then 'Xiengkhouang'
		when cn.province_eng = '' then fd.branch_name 
		when cn.province_eng is null then fd.branch_name 
		else null 
	end `branch_name` ,
	null `status`,fd.`file_no`,fd.`date_received`,date(now()) `date_updated`, 0 `pbxcdr_time`,
	case when left(contact_no,4) = '9020' then right(contact_no,8) when left(contact_no,4) = '9030' then right(contact_no,7) end `contact_id`
from contact_numbers cn left join file_details fd on (fd.id = cn.file_id)
where CONCAT(LENGTH(cn.contact_no), left( cn.contact_no, 5)) in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290208','1290209')
	and file_id >= 1068; -- done <= 1068


-- 4) clear 
delete from removed_duplicate_2;

-- insert duplicate 
insert into removed_duplicate_2
select id, row_numbers, now() `time` from ( 
		select id, row_number() over (partition by contact_no order by id ) as row_numbers  
		from all_unique_contact_numbers 
		-- where file_id <= 1068
		) as t1
	where row_numbers > 1; -- done <= 1068

-- ) check and remove duplicate Delete from all unique where id = id in table removed duplicate 
select * from removed_duplicate_2 where `time` >= '2023-02-18';

delete from all_unique_contact_numbers 
where id in (select id from removed_duplicate_2 where `time` >= '2023-02-18'); -- done <= 1068


