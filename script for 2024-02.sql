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
create table `contact_for_202402_lcc` (
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
	  constraint `contact_for_202402_lcc_ibfk_1` foreign key (`file_id`) references `file_details` (`id`)
) engine=InnoDB auto_increment=1 default CHARSET=utf8mb4 collate utf8mb4_general_ci ;


-- 2) intert data from contact_numbers_to_lcc to table monthly
insert into contact_for_202402_lcc
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


-- 3) delete the status contracted, inactive number from table monthly
select count(*)  from contact_for_202402_lcc;  --  number need to delete becaues contracted or invalid number

delete from contact_for_202402_lcc
where remark_3 = 'contracted' -- contracted
	or (remark_3 in ('prospect_sabc', 'lcc') and status in ('X') ) -- contracted
	or (remark_3 = 'lcc' and status = 'Block need_to_block') -- Block need_to_block
	or (remark_3 = 'lcc' and status in ('FFF can_not_contact', 'No have in telecom')) -- FFF can_not_contact
	or (remark_3 = 'Telecom' and status in ('ETL_inactive','SMS_Failed')) -- Telecom_inactive
	or remark_3 = 'blacklist' -- blacklist

-- 4) set branch_name before export
select branch_name , count(*)  from contact_for_202402_lcc group by branch_name ;

update contact_for_202402_lcc set branch_name = 'Bokeo' where branch_name is null;

select count(*) from contact_for_202402_lcc cfl -- 

-- 5) prospect customer
 -- > this month not need because we import to frappe table: tabSME_BO_and_Plan  and make them use from there


-- 6) insert data from each month into table contact_for_logcall
insert into contact_for_logcall
select '2024-01-31' `date`, `contact_no`, `contact_id`, `remark_2`, `status_updated`
from contact_for_202401_lcc cfl where status_updated is not null;


-- 7) check and update logcall 
select cfl.contact_id, t.`count_time` from contact_for_202402_lcc cfl
left join (select contact_id, count(*) `count_time` from contact_for_logcall group by contact_id) t on (cfl.contact_id = t.contact_id) ;

-- update
update contact_for_202402_lcc cfl
left join (select contact_id, count(*) `count_time` from contact_for_logcall group by contact_id) t on (cfl.contact_id = t.contact_id)
set cfl.`condition` = t.`count_time` ;

-- update the condition is null
select * from contact_for_202402_lcc where `condition` is null; -- 1,356,166
update contact_for_202402_lcc set `condition` = 1 where `condition` is null and status is not null; -- 1,335,744
update contact_for_202402_lcc set `condition` = 1 where `condition` is null and status is null; -- 422




# ______________________________________________________ export to create campaign on LCC for contact_for_202402_lcc ______________________________________________________________ #

Branch: 'Attapue','Bokeo','Head Office','Houaphan','LuangNamtha','Luangprabang','Oudomxay','Paksan','Pakse','Salavan','Savannakhet','Thakek','Vientiane province','Xainyabuli','Xiengkhouang'
Team: 'ATP Team', 'Bokeo', 'Team2', 'Team3', 'Team4', 'Houaphan Team', 'Luangnamtha', 'LPB Team', 'OUX Team', 'Paksan Team', 'Pakse Team', 'Salavan', 'SVK Team', 'Thakket Team', 'VTP Team', 'XYB Team', 'XKH Team'

-- ____________________________________________________ Priority1: new number ____________________________________________________
-- Campaign name: all_new_ATTAPUE_ATP Team_20240201_p1 / all_new_ATTAPUE_ATP Team_20240201_p1-1
-- select count(*) -- 
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202402_lcc cntl 
where cntl.remark_1 in ('1') and cntl.`condition` <= 1
-- where cntl.remark_1 in ('1') and cntl.`condition` > 1
	and branch_name = 'Attapue' ; 


-- ____________________________________________________ Priority2: Have address ____________________________________________________
-- Campaign name: 3_Old_ATTAPUE_ATP Team_20240201_p2 / 3_Old_ATTAPUE_ATP Team_20240201_p2-1
-- select count(*) -- 
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202402_lcc cntl 
where cntl.remark_1 in ('2') and cntl.`condition` <= 1
-- where cntl.remark_1 in ('2') and cntl.`condition` > 1
	and branch_name = 'Attapue' ;


-- ____________________________________________________ Priority3: Need loan ____________________________________________________
-- Campaign name: 2_Old_ATTAPUE_ATP Team_20240201_p3 / 2_Old_ATTAPUE_ATP Team_20240201_p3-1
-- select count(*) -- 
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202402_lcc cntl 
where cntl.remark_1 in ('3') and cntl.`condition` <= 1
-- where cntl.remark_1 in ('3') and cntl.`condition` > 1
	and branch_name = 'Attapue';


-- ____________________________________________________ Priority4: Have Car ____________________________________________________
-- Campaign name: 1_Old_ATTAPUE_ATP Team_20240201_p4  / 1_Old_ATTAPUE_ATP Team_20240201_p4-1
-- select count(*) -- 
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202402_lcc cntl 
where cntl.remark_1 in ('4') and cntl.`condition` <= 1
-- where cntl.remark_1 in ('4') and cntl.`condition` > 1
	and branch_name = 'Attapue' ;


-- ____________________________________________________ Priority5: prospect ____________________________________________________
-- Campaign name: p_Old_ATTAPUE_ATP Team_20240201_p5 / p_Old_ATTAPUE_ATP Team_20240201_p5-1
-- select count(*) -- 
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202402_lcc cntl 
where cntl.remark_1 in ('5') and cntl.`condition` <= 1
-- where cntl.remark_1 in ('5') and cntl.`condition` <= 1
	and branch_name = 'Attapue' ;


-- ____________________________________________________ Priority6 BR: Telecom ____________________________________________________
-- Campaign name: 4_Old_ATTAPUE_ATP Team_20240201_p6  / 4_Old_ATTAPUE_ATP Team_20240201_p6-1
-- select count(*) -- 
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202402_lcc cntl 
where cntl.remark_1 in ('6') and cntl.`condition` <= 1
-- where cntl.remark_1 in ('6') and cntl.`condition` > 1
	and branch_name = 'Attapue' ;


-- ____________________________________________________ Priority6 HO: Telecom ____________________________________________________
-- Campaign name: 4_Old_Head Office_Team2_20240201_p6 / 4_Old_Head Office_Team2_20240201_p6-1
-- select count(*) -- 1125547
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202402_lcc cntl 
where cntl.remark_1 in ('6') and cntl.`condition` <= 1
-- where cntl.remark_1 in ('6') and cntl.`condition` > 1
	 and branch_name = 'Head Office' -- limit 0, 3 -- mean start from row 0+1 and of row 0+3
	-- limit 0*75100 , 75100 -- result will be start from 0*75100+1, end 0*75100+75100, limit n+1, n (start from n+1, end of n)
	-- limit 1*75100, 75100 -- result will be start from 1*75100+1, end at 1*75100+75100
	 -- limit 2*75100, 75100 -- result will be start from 2*75100+1, end at 2*75100+75100
