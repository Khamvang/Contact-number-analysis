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
create table `contact_for_202504_lcc` (
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
	  `contact_id` int(11) not null default 0 comment 'the phone number without 9020 and 9030',
	  `condition` int(11) default null comment 'number of call time in the past: 0=called 0 time, 1=called 1 time, 2=called 2 times ...',
	  `group` int(11) not null default 0 comment '1=condition 1,2,3,5,6, 2=condition 4,7, 3=condition 8',
	  last_call_date date default null comment 'last call date before add to this table',
	  primary key (`id`),
	  key `contact_no` (`contact_no`),
	  key `fk_file_id` (`file_id`),
	  key `contact_id` (`contact_id`),
	key `type` (`type`),
	  constraint `contact_for_202504_lcc_ibfk_1` foreign key (`file_id`) references `file_details` (`id`)
) engine=InnoDB auto_increment=1 default CHARSET=utf8mb4 collate utf8mb4_general_ci ;




-- 2) intert data from contact_numbers_to_lcc to table monthly
insert into contact_for_202504_lcc
select cntl.id, cntl.`file_id`,`contact_no`,`name`,cntl.province_eng,`province_laos`,cntl.district_eng,`district_laos`,cntl.`village`,cntl.`type`,`maker`,`model`,`year`, 
	case 	
		when cntl.`type` = 'F' then '1'
		when cntl.`type` = 'G' then '2'
		when fd.category = '③CAR SHOP' then '9'
		when fd.category = '④FINANCE∙LEASE' then '5'
		when fd.category = '②INSURANCE' then '3'
		when fd.category = '①GOVERNMENT' then '4'
		when fd.category = '⑦SIGNBOARD' then '8'
		when fd.category = '⑥OTHERS' then '7'
		when fd.category = '⑤TELECOM' then '6'
	end  `remark_1`,
	null `remark_2`,`remark_3`,cntl.`branch_name`,cntl.`status`, null `status_updated`, null `staff_id`,null `pvd_id`, 
	case when left(cntl.contact_no,4) = '9020' then right(cntl.contact_no,8) when left(cntl.contact_no,4) = '9030' then right(cntl.contact_no,7) end `contact_id`, 
	null `condition`, 
	'0' AS `group`,
	cntl.date_updated as `last_call_date`
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
select count(*)  from contact_for_202504_lcc;  --  number need to delete becaues contracted or invalid number

delete from contact_for_202504_lcc
where remark_3 = 'contracted' -- contracted
	or (remark_3 in ('prospect_sabc', 'lcc') and status in ('X') ) -- contracted
	or (remark_3 = 'lcc' and status = 'Block need_to_block') -- Block need_to_block
	or (remark_3 = 'lcc' and status in ('FFF can_not_contact', 'No have in telecom')) -- FFF can_not_contact
	or (remark_3 = 'Telecom' and status in ('ETL_inactive','SMS_Failed')) -- Telecom_inactive
	or remark_3 = 'blacklist' -- blacklist

-- 4) set branch_name before export
select branch_name , count(*)  from contact_for_202504_lcc group by branch_name ;

update contact_for_202504_lcc set branch_name = 'Bokeo' where branch_name is null;

select count(*) from contact_for_202504_lcc cfl -- 

-- 5) prospect customer
 -- > this month not need because we import to frappe table: tabSME_BO_and_Plan  and make them use from there


-- 6) insert data from each month into table contact_for_logcall
select * from contact_for_logcall order by `date` desc limit 10;

insert into contact_for_logcall
select '2025-03-31' `date`, `contact_no`, `contact_id`, `remark_2`, `status_updated`
from contact_for_202503_lcc cfl where status_updated is not null;


-- 7) check and update logcall 
select cfl.contact_id, t.`count_time` from contact_for_202504_lcc cfl
left join (select contact_id, count(*) `count_time` from contact_for_logcall group by contact_id) t on (cfl.contact_id = t.contact_id) ;

-- update
update contact_for_202504_lcc cfl
left join (select contact_id, count(*) `count_time` from contact_for_logcall group by contact_id) t on (cfl.contact_id = t.contact_id)
set cfl.`condition` = t.`count_time` ;

-- update the condition is null
select * from contact_for_202504_lcc where `condition` is null; -- 1,356,166
update contact_for_202504_lcc set `condition` = 1 where `condition` is null and status is not null; -- 1,335,744
update contact_for_202504_lcc set `condition` = 1 where `condition` is null and status is null; -- 422



select * from contact_for_202504_lcc order by id desc 51015810;

ALTER TABLE contact_for_202504_lcc AUTO_INCREMENT = 60000000;


-- run on Frappe server
-- F rank list for all each province and district
select null 'id', customer_tel 'contact_no', customer_name 'name', 
	left(address_province_and_city, locate(' -', address_province_and_city)-1) 'province_eng', null 'province_laos',
	right(address_province_and_city, (length(address_province_and_city) - locate('- ', address_province_and_city) -1 ) ) 'district_eng', null 'district_laos',
	address_village 'village', 
	tb.'type', 
	maker, model, `year`, 2 as 'remark_1', null 'remark_2', null 'remark_3',
	case when left(customer_tel,4) = '9020' then right(customer_tel,8) when left(customer_tel,4) = '9030' then right(customer_tel,7) end `contact_id`
from tabSME_BO_and_Plan  
inner join temp_sme_pbx_BO tb on (tb.id = bp.name and tb.`type` in ('F'));



-- run on Frappe server
-- G rank list for all each province and district
select null 'id', customer_tel 'contact_no', customer_name 'name', 
	left(address_province_and_city, locate(' -', address_province_and_city)-1) 'province_eng', null 'province_laos',
	right(address_province_and_city, (length(address_province_and_city) - locate('- ', address_province_and_city) -1 ) ) 'district_eng', null 'district_laos',
	address_village 'village', 
	case when contract_status = 'Contracted' then 'Contracted'
		when contract_status != 'Contracted' and rank_update in ('S', 'A', 'B', 'C') then 'SABC'
		when contract_status != 'Contracted' and rank_update in ('F', 'FF1', 'FF2', 'FFF') then 'F'
		when contract_status != 'Contracted' and rank_update in ('G') then 'G'
	end 'type', 
	maker, model, `year`, 2 as 'remark_1', null 'remark_2', null 'remark_3',
	case when left(customer_tel,4) = '9020' then right(customer_tel,8) when left(customer_tel,4) = '9030' then right(customer_tel,7) end `contact_id`
from tabSME_BO_and_Plan  
where contract_status != 'Contracted' and address_province_and_city != '' 
	and (contract_status != 'Contracted' and rank_update in ('G') )
order by address_province_and_city asc;




-- Bases on Morikawa suggest in [C:\Users\Lalco_Admin\Downloads\Contact numbers for 2025-02\資料源配布について20250130.docx]
update contact_for_202504_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
set `remark_1` =
	case 	when cntl.`condition` = 0 then '1'
		when cntl.`type` = 'F' then '1'
		when cntl.`type` = 'G' then '2'
		when fd.category = '③CAR SHOP' then '9'
		when fd.category = '④FINANCE∙LEASE' then '5'
		when fd.category = '②INSURANCE' then '3'
		when fd.category = '①GOVERNMENT' then '4'
		when fd.category = '⑦SIGNBOARD' then '8'
		when fd.category = '⑥OTHERS' then '7'
		when fd.category = '⑤TELECOM' then '6'
	end 
;



-- Update branch Name
update contact_for_202504_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
set cntl.branch_name = 
	case 	WHEN cntl.province_eng = 'Attapeu' AND cntl.district_eng = 'Saysetha' THEN 'Attapue'
		WHEN cntl.province_eng = 'Attapeu' AND cntl.district_eng = 'Samakkhixay' THEN 'Attapue'
		WHEN cntl.province_eng = 'Attapeu' AND cntl.district_eng = 'Sanamxay' THEN 'Attapue'
		WHEN cntl.province_eng = 'Attapeu' AND cntl.district_eng = 'Sanxay' THEN 'Attapue'
		WHEN cntl.province_eng = 'Attapeu' AND cntl.district_eng = 'Phouvong' THEN 'Attapue'
		WHEN cntl.province_eng = 'Bokeo' AND cntl.district_eng = 'Houay Xay' THEN 'Bokeo'
		WHEN cntl.province_eng = 'Bokeo' AND cntl.district_eng = 'Ton Pheung' THEN 'Tonpherng'
		WHEN cntl.province_eng = 'Bokeo' AND cntl.district_eng = 'Meung' THEN 'Tonpherng'
		WHEN cntl.province_eng = 'Bokeo' AND cntl.district_eng = 'Pha Oudom' THEN 'Bokeo'
		WHEN cntl.province_eng = 'Bokeo' AND cntl.district_eng = 'Pak Tha' THEN 'Bokeo'
		WHEN cntl.province_eng = 'Borikhamxay' AND cntl.district_eng = 'Paksane' THEN 'Paksan'
		WHEN cntl.province_eng = 'Borikhamxay' AND cntl.district_eng = 'Thaphabat' THEN 'Paksan'
		WHEN cntl.province_eng = 'Borikhamxay' AND cntl.district_eng = 'Pakkading' THEN 'Pakkading'
		WHEN cntl.province_eng = 'Borikhamxay' AND cntl.district_eng = 'Borikhane' THEN 'Paksan'
		WHEN cntl.province_eng = 'Borikhamxay' AND cntl.district_eng = 'Khamkeut' THEN 'Khamkeuth'
		WHEN cntl.province_eng = 'Borikhamxay' AND cntl.district_eng = 'Viengthong' THEN 'Khamkeuth'
		WHEN cntl.province_eng = 'Borikhamxay' AND cntl.district_eng = 'Xaychamphone' THEN 'Khamkeuth'
		WHEN cntl.province_eng = 'Champasack' AND cntl.district_eng = 'Pak Se' THEN 'Pakse'
		WHEN cntl.province_eng = 'Champasack' AND cntl.district_eng = 'Sanasomboun' THEN 'Pakse'
		WHEN cntl.province_eng = 'Champasack' AND cntl.district_eng = 'Batiengchaleunsouk' THEN 'Pakse'
		WHEN cntl.province_eng = 'Champasack' AND cntl.district_eng = 'Paksong' THEN 'Paksxong'
		WHEN cntl.province_eng = 'Champasack' AND cntl.district_eng = 'Pathouphone' THEN 'Pakse'
		WHEN cntl.province_eng = 'Champasack' AND cntl.district_eng = 'Phonthong' THEN 'Chongmeg'
		WHEN cntl.province_eng = 'Champasack' AND cntl.district_eng = 'Champassack' THEN 'Sukhuma'
		WHEN cntl.province_eng = 'Champasack' AND cntl.district_eng = 'Soukhoumma' THEN 'Sukhuma'
		WHEN cntl.province_eng = 'Champasack' AND cntl.district_eng = 'Mounlapamok' THEN 'Khong'
		WHEN cntl.province_eng = 'Champasack' AND cntl.district_eng = 'Khong' THEN 'Khong'
		WHEN cntl.province_eng = 'Huaphanh' AND cntl.district_eng = 'Xam Neua' THEN 'Houaphan'
		WHEN cntl.province_eng = 'Huaphanh' AND cntl.district_eng = 'Xiengkho' THEN 'Houaphan'
		WHEN cntl.province_eng = 'Huaphanh' AND cntl.district_eng = 'Muang Hiam' THEN 'Houaphan'
		WHEN cntl.province_eng = 'Huaphanh' AND cntl.district_eng = 'Viengxay' THEN 'Houaphan'
		WHEN cntl.province_eng = 'Huaphanh' AND cntl.district_eng = 'Houameuang' THEN 'Houaphan'
		WHEN cntl.province_eng = 'Huaphanh' AND cntl.district_eng = 'Samtay' THEN 'Houaphan'
		WHEN cntl.province_eng = 'Huaphanh' AND cntl.district_eng = 'Sop Bao' THEN 'Houaphan'
		WHEN cntl.province_eng = 'Huaphanh' AND cntl.district_eng = 'Muang Et' THEN 'Houaphan'
		WHEN cntl.province_eng = 'Huaphanh' AND cntl.district_eng = 'Kuane' THEN 'Houaphan'
		WHEN cntl.province_eng = 'Huaphanh' AND cntl.district_eng = 'Xone' THEN 'Houaphan'
		WHEN cntl.province_eng = 'Khammuane' AND cntl.district_eng = 'Thakhek' THEN 'Thakek'
		WHEN cntl.province_eng = 'Khammuane' AND cntl.district_eng = 'Mahaxay' THEN 'Thakek'
		WHEN cntl.province_eng = 'Khammuane' AND cntl.district_eng = 'Nong Bok' THEN 'Thakek'
		WHEN cntl.province_eng = 'Khammuane' AND cntl.district_eng = 'Hineboune' THEN 'Thakek'
		WHEN cntl.province_eng = 'Khammuane' AND cntl.district_eng = 'Yommalath' THEN 'Nhommalth'
		WHEN cntl.province_eng = 'Khammuane' AND cntl.district_eng = 'Boualapha' THEN 'Thakek'
		WHEN cntl.province_eng = 'Khammuane' AND cntl.district_eng = 'Nakai' THEN 'Nhommalth'
		WHEN cntl.province_eng = 'Khammuane' AND cntl.district_eng = 'Sebangphay' THEN 'Thakek'
		WHEN cntl.province_eng = 'Khammuane' AND cntl.district_eng = 'Saybouathong' THEN 'Thakek'
		WHEN cntl.province_eng = 'Khammuane' AND cntl.district_eng = 'Kounkham' THEN 'Khamkeuth'
		WHEN cntl.province_eng = 'Luangnamtha' AND cntl.district_eng = 'Namtha' THEN 'Luangnamtha'
		WHEN cntl.province_eng = 'Luangnamtha' AND cntl.district_eng = 'Sing' THEN 'Luangnamtha'
		WHEN cntl.province_eng = 'Luangnamtha' AND cntl.district_eng = 'Long' THEN 'Luangnamtha'
		WHEN cntl.province_eng = 'Luangnamtha' AND cntl.district_eng = 'Viengphoukha' THEN 'Luangnamtha'
		WHEN cntl.province_eng = 'Luangnamtha' AND cntl.district_eng = 'Na Le' THEN 'Luangnamtha'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Luang Prabang' THEN 'Luangprabang'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Xiengngeun' THEN 'Luangprabang'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Nane' THEN 'Nane'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Pak Ou' THEN 'Luangprabang'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Nam Bak' THEN 'Nambak'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Ngoy' THEN 'Nambak'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Pak Seng' THEN 'Luangprabang'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Phonxay' THEN 'Luangprabang'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Chomphet' THEN 'Nane'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Viengkham' THEN 'Nambak'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Phoukhoune' THEN 'Luangprabang'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Phonthong' THEN 'Nambak'
		WHEN cntl.province_eng = 'Oudomxay' AND cntl.district_eng = 'Xay' THEN 'Oudomxay'
		WHEN cntl.province_eng = 'Oudomxay' AND cntl.district_eng = 'La' THEN 'Oudomxay'
		WHEN cntl.province_eng = 'Oudomxay' AND cntl.district_eng = 'Na Mo' THEN 'Oudomxay'
		WHEN cntl.province_eng = 'Oudomxay' AND cntl.district_eng = 'Nga' THEN 'Oudomxay'
		WHEN cntl.province_eng = 'Oudomxay' AND cntl.district_eng = 'Beng' THEN 'Hoon'
		WHEN cntl.province_eng = 'Oudomxay' AND cntl.district_eng = 'Houne' THEN 'Hoon'
		WHEN cntl.province_eng = 'Oudomxay' AND cntl.district_eng = 'Pak Beng' THEN 'Hoon'
		WHEN cntl.province_eng = 'Phongsaly' AND cntl.district_eng = 'May' THEN 'Phongsary'
		WHEN cntl.province_eng = 'Phongsaly' AND cntl.district_eng = 'Khoua' THEN 'Phongsary'
		WHEN cntl.province_eng = 'Phongsaly' AND cntl.district_eng = 'Samphanh' THEN 'Phongsary'
		WHEN cntl.province_eng = 'Phongsaly' AND cntl.district_eng = 'Boun Neua' THEN 'Phongsary'
		WHEN cntl.province_eng = 'Phongsaly' AND cntl.district_eng = 'Yot Ou' THEN 'Phongsary'
		WHEN cntl.province_eng = 'Phongsaly' AND cntl.district_eng = 'Boun Tay' THEN 'Phongsary'
		WHEN cntl.province_eng = 'Phongsaly' AND cntl.district_eng = 'Phongsaly' THEN 'Phongsary'
		WHEN cntl.province_eng = 'Saravane' AND cntl.district_eng = 'Saravanh' THEN 'Salavan'
		WHEN cntl.province_eng = 'Saravane' AND cntl.district_eng = 'Ta Oy' THEN 'Salavan'
		WHEN cntl.province_eng = 'Saravane' AND cntl.district_eng = 'Toumlane' THEN 'Salavan'
		WHEN cntl.province_eng = 'Saravane' AND cntl.district_eng = 'Lakhonepheng' THEN 'Khongxedone'
		WHEN cntl.province_eng = 'Saravane' AND cntl.district_eng = 'Vapy' THEN 'Khongxedone'
		WHEN cntl.province_eng = 'Saravane' AND cntl.district_eng = 'Khongsedone' THEN 'Khongxedone'
		WHEN cntl.province_eng = 'Saravane' AND cntl.district_eng = 'Lao Ngam' THEN 'Salavan'
		WHEN cntl.province_eng = 'Saravane' AND cntl.district_eng = 'Sa Mouay' THEN 'Salavan'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Kaysone Phomvihane' THEN 'Savannakhet'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Outhoumphone' THEN 'Savannakhet'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Atsaphangthong' THEN 'Atsaphangthong'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Phine' THEN 'Phine'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Seponh' THEN 'Phine'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Nong' THEN 'Phine'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Thapangthong' THEN 'Songkhone'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Songkhone' THEN 'Songkhone'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Champhone' THEN 'Savannakhet'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Xayboury' THEN 'Savannakhet'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Viraboury' THEN 'Phine'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Assaphone' THEN 'Atsaphangthong'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Xonnabouly' THEN 'Savannakhet'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Phalanxay' THEN 'Atsaphangthong'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Xayphouthong' THEN 'Songkhone'
		WHEN cntl.province_eng = 'Vientiane Capital' AND cntl.district_eng = 'Chanthabuly' THEN 'Head office'
		WHEN cntl.province_eng = 'Vientiane Capital' AND cntl.district_eng = 'Sikhottabong' THEN 'Sikhottabong'
		WHEN cntl.province_eng = 'Vientiane Capital' AND cntl.district_eng = 'Xaysetha' THEN 'Head office'
		WHEN cntl.province_eng = 'Vientiane Capital' AND cntl.district_eng = 'Sisattanak' THEN 'Head office'
		WHEN cntl.province_eng = 'Vientiane Capital' AND cntl.district_eng = 'Naxaythong' THEN 'Naxaiythong'
		WHEN cntl.province_eng = 'Vientiane Capital' AND cntl.district_eng = 'Xaythany' THEN 'Xaythany'
		WHEN cntl.province_eng = 'Vientiane Capital' AND cntl.district_eng = 'Hadxayfong' THEN 'Hadxaifong'
		WHEN cntl.province_eng = 'Vientiane Capital' AND cntl.district_eng = 'Sangthong' THEN 'Naxaiythong'
		WHEN cntl.province_eng = 'Vientiane Capital' AND cntl.district_eng = 'Parkngum' THEN 'Mayparkngum'
		WHEN cntl.province_eng = 'Vientiane Province' AND cntl.district_eng = 'Phonhong' THEN 'Vientiane province'
		WHEN cntl.province_eng = 'Vientiane Province' AND cntl.district_eng = 'Thoulakhom' THEN 'Thoulakhom'
		WHEN cntl.province_eng = 'Vientiane Province' AND cntl.district_eng = 'Keo Oudom' THEN 'Thoulakhom'
		WHEN cntl.province_eng = 'Vientiane Province' AND cntl.district_eng = 'Kasy' THEN 'Vangvieng'
		WHEN cntl.province_eng = 'Vientiane Province' AND cntl.district_eng = 'Vangvieng' THEN 'Vangvieng'
		WHEN cntl.province_eng = 'Vientiane Province' AND cntl.district_eng = 'Feuang' THEN 'Feuang'
		WHEN cntl.province_eng = 'Vientiane Province' AND cntl.district_eng = 'Xanakharm' THEN 'Xanakharm'
		WHEN cntl.province_eng = 'Vientiane Province' AND cntl.district_eng = 'Mad' THEN 'Xanakharm'
		WHEN cntl.province_eng = 'Vientiane Province' AND cntl.district_eng = 'Hinhurp' THEN 'Vientiane province'
		WHEN cntl.province_eng = 'Vientiane Province' AND cntl.district_eng = 'Viengkham' THEN 'Vientiane province'
		WHEN cntl.province_eng = 'Vientiane Province' AND cntl.district_eng = 'Mune' THEN 'Feuang'
		WHEN cntl.province_eng = 'Xayaboury' AND cntl.district_eng = 'Xaiyabuly' THEN 'Xainyabuli'
		WHEN cntl.province_eng = 'Xayaboury' AND cntl.district_eng = 'Khop' THEN 'Hongsa'
		WHEN cntl.province_eng = 'Xayaboury' AND cntl.district_eng = 'Hongsa' THEN 'Hongsa'
		WHEN cntl.province_eng = 'Xayaboury' AND cntl.district_eng = 'Ngeun' THEN 'Hongsa'
		WHEN cntl.province_eng = 'Xayaboury' AND cntl.district_eng = 'Xienghone' THEN 'Hongsa'
		WHEN cntl.province_eng = 'Xayaboury' AND cntl.district_eng = 'Phiang' THEN 'Xainyabuli'
		WHEN cntl.province_eng = 'Xayaboury' AND cntl.district_eng = 'Parklai' THEN 'Parklai'
		WHEN cntl.province_eng = 'Xayaboury' AND cntl.district_eng = 'Kenethao' THEN 'Parklai'
		WHEN cntl.province_eng = 'Xayaboury' AND cntl.district_eng = 'Botene' THEN 'Parklai'
		WHEN cntl.province_eng = 'Xayaboury' AND cntl.district_eng = 'Thongmyxay' THEN 'Parklai'
		WHEN cntl.province_eng = 'Xayaboury' AND cntl.district_eng = 'Xaysathan' THEN 'Xainyabuli'
		WHEN cntl.province_eng = 'Xaysomboune' AND cntl.district_eng = 'Anouvong' THEN 'Xaisomboun'
		WHEN cntl.province_eng = 'Xaysomboune' AND cntl.district_eng = 'Longchaeng' THEN 'Xaisomboun'
		WHEN cntl.province_eng = 'Xaysomboune' AND cntl.district_eng = 'Longxan' THEN 'Xaisomboun'
		WHEN cntl.province_eng = 'Xaysomboune' AND cntl.district_eng = 'Hom' THEN 'Xaisomboun'
		WHEN cntl.province_eng = 'Xaysomboune' AND cntl.district_eng = 'Thathom' THEN 'Xaisomboun'
		WHEN cntl.province_eng = 'Sekong' AND cntl.district_eng = 'La Mam' THEN 'Sekong'
		WHEN cntl.province_eng = 'Sekong' AND cntl.district_eng = 'Kaleum' THEN 'Sekong'
		WHEN cntl.province_eng = 'Sekong' AND cntl.district_eng = 'Dak Cheung' THEN 'Sekong'
		WHEN cntl.province_eng = 'Sekong' AND cntl.district_eng = 'Tha Teng' THEN 'Sekong'
		WHEN cntl.province_eng = 'Xiengkhuang' AND cntl.district_eng = 'Paek' THEN 'Xiengkhouang'
		WHEN cntl.province_eng = 'Xiengkhuang' AND cntl.district_eng = 'Kham' THEN 'Kham'
		WHEN cntl.province_eng = 'Xiengkhuang' AND cntl.district_eng = 'Nong Het' THEN 'Kham'
		WHEN cntl.province_eng = 'Xiengkhuang' AND cntl.district_eng = 'Khoune' THEN 'Khoune'
		WHEN cntl.province_eng = 'Xiengkhuang' AND cntl.district_eng = 'Mok' THEN 'Khoune'
		WHEN cntl.province_eng = 'Xiengkhuang' AND cntl.district_eng = 'Phou Kout' THEN 'Xiengkhouang'
		WHEN cntl.province_eng = 'Xiengkhuang' AND cntl.district_eng = 'Phaxay' THEN 'Xiengkhouang'
		else fd.branch_name
	end
where cntl.`type` IN ('F', 'G');





# ______________________________________________________ export to create campaign on LCC for contact_for_202504_lcc ______________________________________________________________ #


/*
(1) In Feb-2025, the number created on LCC is 4,027,724 numbers and called 1,017,019 numbers = 25%. Breakdown is as follows: G rank = 100%, ③CAR SHOP = 81%, ④FINANCE∙LEASE = 45%, ⑦SIGNBOARD = 21%, ②INSURANCE = 17%, ①GOVERNMENT = 10%, ⑤TELECOM = 5% and ⑥OTHERS = 5%.
(2) The High contract rate is ②INSURANCE = 0.5%, G rank = 0.1%, ①GOVERNMENT = 0.1%, ④FINANCE∙LEASE and ⑤TELECOM 
(3) Based on the results I think we should create campaigns with prospect F rank and G rank. So, March priority will be F rank, G rank, ②INSURANCE, ①GOVERNMENT, ④FINANCE∙LEASE, ⑤TELECOM, ⑥OTHERS, ⑦SIGNBOARD, ③CAR SHOP

*/

Branch: 'Attapue', 'Bokeo', 'Tonpherng', 'Paksan', 'Pakkading', 'Khamkeuth', 'Pakse', 'Paksxong', 'Chongmeg', 'Sukhuma', 'Khong', 'Houaphan', 'Thakek', 'Nhommalth', 'Luangnamtha', 'Luangprabang', 'Nane', 'Nambak', 'Oudomxay', 'Hoon', 'Phongsary', 'Salavan', 'Khongxedone', 'Savannakhet', 'Atsaphangthong', 'Phine', 'Songkhone', 'Head office', 'Sikhottabong', 'Naxaiythong', 'Xaythany', 'Hadxaifong', 'Mayparkngum', 'Vientiane province', 'Thoulakhom', 'Vangvieng', 'Feuang', 'Xanakharm', 'Xainyabuli', 'Hongsa', 'Parklai', 'Xaisomboun', 'Sekong', 'Xiengkhouang', 'Kham', 'Khoune'


Team: 'ATP Team', 'Bokeo', 'Team2', 'Team3', 'Team4', 'Houaphan Team', 'Luangnamtha', 'LPB Team', 'OUX Team', 'Paksan Team', 'Pakse Team', 'Salavan', 'SVK Team', 'Thakket Team', 'VTP Team', 'XYB Team', 'XKH Team'



-- ____________________________________________________ Priority1: 0 call ____________________________________________________
-- Campaign name: 11_Old_Attapue_ATP Team_20250401 / 11_Old_Attapue_ATP Team_20250401
-- select count(*) -- 
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`condition` `remark_2`,`remark_3`
from contact_for_202504_lcc cntl 
where cntl.remark_1 in ('1')
	and branch_name = 'Attapue' order by `condition` asc;



-- ____________________________________________________ Priority2: G rank ____________________________________________________
-- Campaign name: 12_Old_Attapue_ATP Team_20250401 / 12_Old_Attapue_ATP Team_20250401
-- select count(*) -- 
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`condition` `remark_2`,`remark_3`
from contact_for_202504_lcc cntl 
where cntl.remark_1 in ('2')
	and branch_name = 'Attapue' order by `condition` asc;


-- ____________________________________________________ Priority3: ①GOVERNMENT ____________________________________________________
-- Campaign name: 13_Old_Attapue_ATP Team_20250401 / 13_Old_Attapue_ATP Team_20250401
-- select count(*) -- 
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`condition` `remark_2`,`remark_3`
from contact_for_202504_lcc cntl 
where cntl.remark_1 in ('3') and cntl.last_call_date < '2024-11-01' and cntl.condition <= 3
	and branch_name = 'Attapue' order by `condition` asc;


-- ____________________________________________________ Priority4: ②INSURANCE ____________________________________________________
-- Campaign name: 14_Old_Attapue_ATP Team_20250401 / 14_Old_Attapue_ATP Team_20250401
-- select count(*) -- 
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`condition` `remark_2`,`remark_3`
from contact_for_202504_lcc cntl 
where cntl.remark_1 in ('4') and cntl.last_call_date < '2024-11-01' and cntl.condition <= 3
	and branch_name = 'Attapue' order by `condition` asc;


-- ____________________________________________________ Priority5: ④FINANCE∙LEASE ____________________________________________________
-- Campaign name: 15_Old_Attapue_ATP Team_20250401 / 15_Old_Attapue_ATP Team_20250401
-- select count(*) -- 
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`condition` `remark_2`,`remark_3`
from contact_for_202504_lcc cntl 
where cntl.remark_1 in ('5') and cntl.last_call_date < '2024-11-01' and cntl.condition <= 3
	and branch_name = 'Attapue' order by `condition` asc;


-- ____________________________________________________ Priority6: ⑤TELECOM ____________________________________________________
-- Campaign name: 16_Old_Attapue_ATP Team_20250401 / 16_Old_Attapue_ATP Team_20250401
-- select count(*) -- 
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`condition` `remark_2`,`remark_3`
from contact_for_202504_lcc cntl 
where cntl.remark_1 in ('6') and cntl.last_call_date < '2024-11-01' and cntl.condition <= 3
	and branch_name = 'Attapue' order by `condition` asc;


-- ____________________________________________________ Priority7: ⑥OTHERS ____________________________________________________
-- Campaign name: 17_Old_Attapue_ATP Team_20250401 / 17_Old_Attapue_ATP Team_20250401
-- select count(*) -- 
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`condition` `remark_2`,`remark_3`
from contact_for_202504_lcc cntl 
where cntl.remark_1 in ('7') and cntl.last_call_date < '2024-11-01' and cntl.condition <= 3
	and branch_name = 'Attapue' order by `condition` asc;



-- ____________________________________________________ Priority8: ⑦SIGNBOARD ____________________________________________________
-- Campaign name: 18_Old_Attapue_ATP Team_20250401 / 18_Old_Attapue_ATP Team_20250401
-- select count(*) -- 
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`condition` `remark_2`,`remark_3`
from contact_for_202504_lcc cntl 
where cntl.remark_1 in ('8') and cntl.last_call_date < '2024-11-01' and cntl.condition <= 3
	and branch_name = 'Attapue' order by `condition` asc;



-- ____________________________________________________ Priority9: ③CAR SHOP ____________________________________________________
-- Campaign name: 19_Old_Attapue_ATP Team_20250401 / 1_Old_Attapue_ATP Team_20250401
-- select count(*) -- 
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`condition` `remark_2`,`remark_3`
from contact_for_202504_lcc cntl 
where cntl.remark_1 in ('9') and cntl.last_call_date < '2024-11-01' and cntl.condition <= 3
	and branch_name = 'Attapue' order by `condition` asc;












/* Not use

-- ____________________________________________________ Priority7 HO: Telecom ____________________________________________________
-- Campaign name: 7_Old_Head Office_Team2_20241001_p7 / 7_Old_Head Office_Team2_20241001_p7-1
-- select count(*) -- 
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`condition` `remark_2`,`remark_3`
from contact_for_202504_lcc cntl 
where cntl.remark_1 in ('7')
	 and branch_name = 'Head Office' -- limit 0, 3 -- mean start from row 0+1 and of row 0+3
	-- limit 0*75100 , 75100 -- result will be start from 0*75100+1, end 0*75100+75100, limit n+1, n (start from n+1, end of n)
	-- limit 1*75100, 75100 -- result will be start from 1*75100+1, end at 1*75100+75100
	 -- limit 2*75100, 75100 -- result will be start from 2*75100+1, end at 2*75100+75100


	
-- ____________________________________________________ WA campaign ____________________________________________________
select cntl.id `FIRSTNAME`, null `LASTNAME`, null `EMAIL`, concat('+856', right(contact_no, length(contact_no)-2)) `WHATSAPP`, null `SMS`
from contact_for_202504_lcc cntl 
where cntl.remark_1 in ('4') and cntl.`condition` <= 5
-- where cntl.remark_1 in ('4') and cntl.`condition` > 5
	and CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1290202','1290205','1290207','1290208','1290209')
	and branch_name = 'Head Office' and cntl.id > 4060670
	limit 200;



-- import Approach list from contact_data_db to frappe
select id `name`, now() `creation`, 'Administrator' `owner`, contact_no `customer_tel`, name `customer_name`, concat(province_eng, " - ", district_eng) `address_province_and_city`, village `address_village`,
	`maker`, `model`, `year`, remark_1 `priority`, `branch_name`
from contact_for_202504_lcc
where branch_name in ('Phongsary','Xaisomboun','Sekong','Saysetha - Attapeu','Khamkeut - Borikhamxay','Paksong - Champasack','Phonthong - Champasack','Nam Bak - Luangprabang','Songkhone - Savanakhet','Hadxayfong - Vientiane Capital','Naxaythong - Vientiane Capital','Parkngum - Vientiane Capital','Xaythany - Vientiane Capital','Vangvieng - Vientiane Province','Parklai - Xayaboury','Kham - Xiengkhuang'
) ;
*/

