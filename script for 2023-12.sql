/*

@Kham Questions and instructions from the Chairman regarding your report "Call list: remove bad data from call list as Chairman introduced 2023-10-30".
1) What does "No have in telecom" mean? -> when call to that number, there's a respone sound, this number is not in telecom service
2) There is no need to delete FF1 and FF2.
3) "Block need to block" and Z1 are targets for calls made by affiliated companies other than LALCO (Money MAX, etc.).
4) If FFF doesn't connect, delete it once instead of twice (Is it okay if FFF doesn't have a phone contract?)
5) SP has ranks divided into XYZ, so change the display. (e.g. SP-X, SP-Y, SP-Z, etc.)

So, do "FFF can't contact" and "No have in telecom" mean the same thing?
-> Same but different because 
-> No have in telecom service mean it's not register there 100% can't contact before the telecom open that number, No have in telecom mean really sure that number still not register there
-> FFF can't contact means that the number cannot be reached only this time (as we tested sometime power off the service also has a sound like that), or there is no chance to call at all or sometime the telecom server not sure because this number is not working for long time as we asked telecom last time they said this sound mean the system service is not really sure the reason what's happen for that number

*/


-- 1) table contact_for  
create table `contact_for_202312_lcc` (
	  `id` int(11) not null auto_increment,
	  `file_id` int(11) default null,
	  `contact_no` varchar(255) not null,
	  `name` varchar(255) default null,
	  `province_eng` varchar(255) default null,
	  `province_laos` varchar(255) default null,
	  `district_eng` varchar(50) default null,
	  `district_laos` varchar(255) default null,
	  `village` varchar(255) default null,
	  `type` varchar(255) default null,
	  `maker` varchar(255) default null,
	  `model` varchar(255) default null,
	  `year` varchar(255) default null,
	  `remark_1` varchar(255) default null COMMENT 'priority 1=P1: New number or never call before, 2=P2: ③Have address called 1 time, 3=P3: ②Need loan called 1 time, 4=P4: ①Have Car called 1 time, 5=P5: ④Telecom called 0 time',
	  `remark_2` varchar(255) default null,
	  `remark_3` varchar(255) default null,
	  `branch_name` varchar(255) default null,
	  `status` varchar(255) default null,
	  `status_updated` varchar(255) default null,
	  `staff_id` varchar(255) default null,
	  `pvd_id` varchar(255) default null,
	  `contact_id` int(11) not null comment 'the phone number without 9020 and 9030',
	  `condition` int(11) default null comment 'number of call time in the past: 0=called 0 time, 1=called 1 time, 2=called 2 times ...',
	  `group` int(11) not null comment '1=condition 1,2,3,5,6, 2=condition 4,7, 3=condition 8',
	  primary key (`id`),
	  key `contact_no` (`contact_no`),
	  key `fk_file_id` (`file_id`),
	  key `contact_id` (`contact_id`),
	  constraint `contact_for_202312_lcc_ibfk_1` foreign key (`file_id`) references `file_details` (`id`)
) engine=InnoDB auto_increment=1 default CHARSET=utf8mb4 collate utf8mb4_general_ci ;


-- 2) intert data from contact_numbers_to_lcc to table monthly
insert into contact_for_202312_lcc
select cntl.id, cntl.`file_id`,`contact_no`,`name`,cntl.province_eng,`province_laos`,cntl.district_eng,`district_laos`,cntl.`village`,cntl.`type`,`maker`,`model`,`year`, 
	case -- when cntl.file_id >= 1207 then '1' -- because there's not new list
		when cntl.status = '' or cntl.status is null then '1'
		when cntl.`type` = '①Have Car' then '4'
		when cntl.`type` = '②Need loan' then '3'
		when cntl.`type` = '③Have address' then '2'
		when cntl.`type` = 'prospect' then '5'
		when cntl.`type` = '④Telecom' then '6'
	end `remark_1`,
	null `remark_2`,`remark_3`,cntl.`branch_name`,cntl.`status`, null `status_updated`, null `staff_id`,null `pvd_id`, 
	case when left(cntl.contact_no,4) = '9020' then right(cntl.contact_no,8) when left(cntl.contact_no,4) = '9030' then right(cntl.contact_no,7) end `contact_id`, 
	null `condition`, 
	case when cntl.`type` in ('①Have Car', '②Need loan') then 1
		when cntl.`type` = '③Have address' and fd.category = '①GOVERNMENT' then 1
		when cntl.`type` = '③Have address' and fd.category != '①GOVERNMENT' then 2
		when cntl.`type` = '④Telecom' and (cntl.province_eng is not null and cntl.district_eng is not null and cntl.village is not null ) then 2
		when cntl.`type` = '④Telecom' then 3
	end `group`
-- select count(*) -- 
from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
where (cntl.remark_3 in ('contracted', 'ringi_not_contract', 'aseet_not_contract') ) -- already register on LMS
	or (cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('X','S','A','B','C', 'FF1 not_answer', 'FF2 power_off') ) -- already register on CRM and LCC
	or (cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED') -- Ever Answered in the past
	or (cntl.remark_3 = 'Telecom' and cntl.status in ('ETL_active', 'SMS_success') ) -- Ever sent SMS and success
	or cntl.status is null -- new number
	or cntl.contact_id in (select contact_id from temp_sms_chairman tean where status = 1 ) -- SMS check
	or cntl.contact_id in (select contact_id from temp_etl_active_numbers tean2 ) -- ETL active 

	







