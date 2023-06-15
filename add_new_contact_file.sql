-- _____________________________________________________________________________________________________________________________ --
#============ The step to insert new contact numbers to my database ================
-- 1) check the current data in contact_numbers before import new 
select * from contact_numbers where remark_1 in ('1233','1234','1235','1236','1237','1238','1239','1240','1241','1242') ;
-- result: 0 row
select * from contact_numbers order by id desc limit 10;
-- result: last id 47610791 and last file_id 1068
select * from file_details order by id desc;
id  |file_no|file_name                    
----+-------+-----------------------------
1067|1258   |1258_Sai_3463_20230126_CSV   
1068|1257   |1257_Sai_3463_20230126_CSV    

-- 2) open the googlessheets link: [https://docs.google.com/spreadsheets/d/1e6i-Xhnb7VhSkgSuSlzOhLs53gasV-DiwbOcSftcVdQ/edit#gid=115262897]

-- 3) convert file .xlsx to file .csv download files from sheetname [Upload_Excel_file] 

-- 4) upload file .csv to sheetname [Upload_CSV_file]

-- 5) add new record and update table file_details from sheetname [file_details_database] at google sheet
select * from file_details fd ;

update file_details set date_created = unix_timestamp(now()) 
where id >= 1068 ; -- need to change the new file_no here when add new data
-- update staff_tel and broker_tel
update file_details set broker_tel = 
	case when broker_tel = '0' then '0'
	when (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 9 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),3) = '021')
			or (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 8 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),2) = '21' )
			or (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 6)
		then concat('9021',right(regexp_replace(broker_tel , '[^[:digit:]]', ''),6)) -- for 021
		when (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 11 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),3) = '020')
			or (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 10 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),2) = '20')
			or (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 8 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),1) in ('2','5','7','8','9'))
		then concat('9020',right(regexp_replace(broker_tel , '[^[:digit:]]', ''),8)) -- for 020
		when (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 10 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),3) = '030')
			or (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 9 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),2) = '30')
			or (length (regexp_replace(broker_tel , '[^[:digit:]]', '')) = 7 and left (regexp_replace(broker_tel , '[^[:digit:]]', ''),1) in ('2','4','5','7','9'))
		then concat('9030',right(regexp_replace(broker_tel , '[^[:digit:]]', ''),7)) -- for 030
		when left (right (regexp_replace(broker_tel , '[^[:digit:]]', ''),8),1) in ('0','1','') then concat('9030',right(regexp_replace(broker_tel , '[^[:digit:]]', ''),7))
		when left (right (regexp_replace(broker_tel , '[^[:digit:]]', ''),8),1) in ('2','5','7','8','9')
		then concat('9020',right(regexp_replace(broker_tel , '[^[:digit:]]', ''),8))
		else concat('9020',right(regexp_replace(broker_tel , '[^[:digit:]]', ''),8))
	end,
	staff_tel = 
	case when staff_tel = '0' then '0'
	when (length (regexp_replace(staff_tel , '[^[:digit:]]', '')) = 9 and left (regexp_replace(staff_tel , '[^[:digit:]]', ''),3) = '021')
			or (length (regexp_replace(staff_tel , '[^[:digit:]]', '')) = 8 and left (regexp_replace(staff_tel , '[^[:digit:]]', ''),2) = '21' )
			or (length (regexp_replace(staff_tel , '[^[:digit:]]', '')) = 6)
		then concat('9021',right(regexp_replace(staff_tel , '[^[:digit:]]', ''),6)) -- for 021
		when (length (regexp_replace(staff_tel , '[^[:digit:]]', '')) = 11 and left (regexp_replace(staff_tel , '[^[:digit:]]', ''),3) = '020')
			or (length (regexp_replace(staff_tel , '[^[:digit:]]', '')) = 10 and left (regexp_replace(staff_tel , '[^[:digit:]]', ''),2) = '20')
			or (length (regexp_replace(staff_tel , '[^[:digit:]]', '')) = 8 and left (regexp_replace(staff_tel , '[^[:digit:]]', ''),1) in ('2','5','7','8','9'))
		then concat('9020',right(regexp_replace(staff_tel , '[^[:digit:]]', ''),8)) -- for 020
		when (length (regexp_replace(staff_tel , '[^[:digit:]]', '')) = 10 and left (regexp_replace(staff_tel , '[^[:digit:]]', ''),3) = '030')
			or (length (regexp_replace(staff_tel , '[^[:digit:]]', '')) = 9 and left (regexp_replace(staff_tel , '[^[:digit:]]', ''),2) = '30')
			or (length (regexp_replace(staff_tel , '[^[:digit:]]', '')) = 7 and left (regexp_replace(staff_tel , '[^[:digit:]]', ''),1) in ('2','4','5','7','9'))
		then concat('9030',right(regexp_replace(staff_tel , '[^[:digit:]]', ''),7)) -- for 030
		when left (right (regexp_replace(staff_tel , '[^[:digit:]]', ''),8),1) in ('0','1','') then concat('9030',right(regexp_replace(staff_tel , '[^[:digit:]]', ''),7))
		when left (right (regexp_replace(staff_tel , '[^[:digit:]]', ''),8),1) in ('2','5','7','8','9')
		then concat('9020',right(regexp_replace(staff_tel , '[^[:digit:]]', ''),8))
		else concat('9020',right(regexp_replace(staff_tel , '[^[:digit:]]', ''),8))
	end
;


-- 6) import csv file from to table name [contact_numbers] 
select * from contact_numbers where file_id is null order by id desc;

select file_id, `type`, remark_1, count(*) from contact_numbers cn
where file_id >= 1068
group by file_id, `type`, remark_1 ;

alter table valid_contact_numbers convert to character set utf8mb4 collate utf8mb4_general_ci;

-- 7) update file_id in table [contact_numbers] 
update contact_numbers cn right join file_details fd on (cn.remark_1 = fd.file_no)
set cn.file_id = fd.id , cn.created_date = date(now())
where fd.id >= 1068; -- done <= 1068

select cn.* , fd.id, fd.file_no from contact_numbers cn left join file_details fd on (cn.remark_1 = fd.file_no)
where fd.id >= 1068; -- done <= 1068

-- manual
-- update contact_numbers set file_id = 1065 where file_id is null ;

select cn.* , fd.id, fd.file_no from contact_numbers cn left join file_details fd on (cn.remark_1 = fd.file_no)
where fd.id >= 1068; -- done <= 1068

-- 8) update contact number format sql: SELECT REGEXP_REPLACE('deddf2484521584sda,.;eds2', '[^[:digit:]]', '') "REGEXP_REPLACE";
select * , regexp_replace(contact_no , '[^[:digit:]]', '') ,	length (regexp_replace(contact_no , '[^[:digit:]]', '')),
	case when (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 9 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),3) = '021')
			or (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 8 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),2) = '21' )
			or (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 6)
		then concat('9021',right(regexp_replace(contact_no , '[^[:digit:]]', ''),6)) -- for 021
		when (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 11 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),3) = '020')
			or (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 10 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),2) = '20')
			or (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 8 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),1) in ('2','5','7','8','9'))
		then concat('9020',right(regexp_replace(contact_no , '[^[:digit:]]', ''),8)) -- for 020
		when (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 10 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),3) = '030')
			or (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 9 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),2) = '30')
			or (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 7 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),1) in ('2','4','5','7','9'))
		then concat('9030',right(regexp_replace(contact_no , '[^[:digit:]]', ''),7)) -- for 030
		when left (right (regexp_replace(contact_no , '[^[:digit:]]', ''),8),1) in ('0','1','') then concat('9030',right(regexp_replace(contact_no , '[^[:digit:]]', ''),7))
		when left (right (regexp_replace(contact_no , '[^[:digit:]]', ''),8),1) in ('2','5','7','8','9')
		then concat('9020',right(regexp_replace(contact_no , '[^[:digit:]]', ''),8))
		else concat('9020',right(regexp_replace(contact_no , '[^[:digit:]]', ''),8))
	end 'new_contact_no'
from contact_numbers cn 
where file_id >= 1068; -- done <= 1068

update contact_numbers set contact_no = 
	case when (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 9 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),3) = '021')
			or (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 8 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),2) = '21' )
			or (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 6)
		then concat('9021',right(regexp_replace(contact_no , '[^[:digit:]]', ''),6)) -- for 021
		when (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 11 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),3) = '020')
			or (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 10 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),2) = '20')
			or (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 8 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),1) in ('2','5','7','8','9'))
		then concat('9020',right(regexp_replace(contact_no , '[^[:digit:]]', ''),8)) -- for 020
		when (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 10 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),3) = '030')
			or (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 9 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),2) = '30')
			or (length (regexp_replace(contact_no , '[^[:digit:]]', '')) = 7 and left (regexp_replace(contact_no , '[^[:digit:]]', ''),1) in ('2','4','5','7','9'))
		then concat('9030',right(regexp_replace(contact_no , '[^[:digit:]]', ''),7)) -- for 030
		when left (right (regexp_replace(contact_no , '[^[:digit:]]', ''),8),1) in ('0','1','') then concat('9030',right(regexp_replace(contact_no , '[^[:digit:]]', ''),7))
		when left (right (regexp_replace(contact_no , '[^[:digit:]]', ''),8),1) in ('2','5','7','8','9')
		then concat('9020',right(regexp_replace(contact_no , '[^[:digit:]]', ''),8))
		else concat('9020',right(regexp_replace(contact_no , '[^[:digit:]]', ''),8))
	end
where file_id >= 1068; -- done <= 1068

-- 9) check and import valid number to table valid_contact_numbers
select *, CONCAT(LENGTH(contact_no), left( contact_no, 5)) from contact_numbers 
where CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290208','1290209')
	and file_id >= 1068 ; -- done <= 1068

select * from valid_contact_numbers where file_id >= 1068;
insert into valid_contact_numbers 
(`id`,`file_id`,`contact_no`)
select `id`,`file_id`,`contact_no`
from contact_numbers 
where CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290208','1290209')
	and file_id >= 1068; -- done <= 1068

-- 10) check and import invalid number to table valid_contact_numbers
select *, CONCAT(LENGTH(contact_no), left( contact_no, 5)) from contact_numbers 
where CONCAT(LENGTH(contact_no), left( contact_no, 5)) not in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290208','1290209')
	and file_id >= 1068; -- done <= 1068

select * from invalid_contact_numbers where file_id >= 1068;
insert into invalid_contact_numbers 
(`id`,`file_id`,`contact_no`)
select `id`,`file_id`,`contact_no`
from contact_data_db.contact_numbers 
where CONCAT(LENGTH(contact_no), left( contact_no, 5)) not in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290208','1290209')
	and file_id >= 1068; -- done <= 1068

-- 11) import data to all_unique_contact_numbers
insert into all_unique_contact_numbers 
(`id`,`file_id`,`contact_id`,`type`)
select `id`,`file_id`,case when left(contact_no,4) = '9020' then right(contact_no,8) when left(contact_no,4) = '9030' then right(contact_no,7) end `contact_id`, `type`
from contact_numbers 
where CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290208','1290209')
	and file_id >= 1068; -- done <= 1068

-- please go to run the query for Sales promotion first then will go to next step
https://github.com/Khamvang/Contact-number-analysis/edit/main/add_new_contact_file_sp.sql


select file_id , `type`, count(*)  from all_unique_contact_numbers aucn where file_id >= 1068 group by file_id , `type`

-- 12) Query date to expot into table removed duplicate 
-- partition by contact_no === check duplicate by contact_no
-- order by FIELD(`type` , "Have Car","Need loan","Have address","Telecom"), id === order priorities by type and id
insert into removed_duplicate
select id, row_numbers, now() `time` from ( 
		select id, row_number() over (partition by contact_id order by FIELD(`type` , "①Have Car","②Need loan","③Have address","④Telecom"), id) as row_numbers  
		from all_unique_contact_numbers 
		-- where file_id <= 1068
		) as t1
	where row_numbers > 1; -- done <= 1068

-- 13) check and remove duplicate Delete from all unique where id = id in table removed duplicate 
select * from removed_duplicate where `time` >= '2023-02-18';

delete from all_unique_contact_numbers 
where id in (select id from removed_duplicate where `time` >= '2023-02-18'); -- done <= 1068

-- 14) check and import date from contact_numbers to contact_numbers_to_lcc 
-- Do this on 2023-05-13 because need to decrease space for this table: alter table contact_numbers_to_lcc drop `file_no`, drop `date_received`;

select distinct province_eng from contact_numbers where file_id >= 1068;

insert into contact_numbers_to_lcc (`id`,`file_id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`,`branch_name`,`status`,`date_updated`,`pbxcdr_time`, `contact_id`)
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
	null `status`,date(now()) `date_updated`, 0 `pbxcdr_time`,
	case when left(contact_no,4) = '9020' then right(contact_no,8) when left(contact_no,4) = '9030' then right(contact_no,7) end `contact_id`
from contact_numbers cn left join file_details fd on (fd.id = cn.file_id)
where CONCAT(LENGTH(cn.contact_no), left( cn.contact_no, 5)) in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290208','1290209')
	and file_id >= 1068; -- done <= 1068

select `type` , count(*) from contact_numbers_to_lcc cntl where file_id >= 1068 group by `type` ;

-- 15) check and remove duplicate Delete from all unique where id = id in table removed duplicate 
-- 15.1 **** insert the old data to keep in table temp_merge_data for doing merge after 
delete from temp_merge_data ;

insert into temp_merge_data 
select * from contact_numbers_to_lcc where id in (select id from removed_duplicate where `time` >= '2023-01-26');

-- 15.2 **** delete duplicate data from contact_numbers_to_lcc 
delete from contact_numbers_to_lcc where id in (select id from removed_duplicate where `time` >= '2023-01-26');

-- 15.3 **** insert data to temp_update_any to do update status
insert into temp_update_any 
select cntl.id, cntl.contact_no, tmd.`remark_3`, tmd.status, 0 `pbxcdr_time`, cntl.`contact_id`
from contact_numbers_to_lcc cntl inner join temp_merge_data tmd on (cntl.contact_id = tmd.contact_id)
where cntl.contact_id in (select contact_id  from temp_merge_data ) and tmd.status is not null ;

-- 15.4 **** update status in table contact_numbers_to_lcc 
update contact_numbers_to_lcc cntl left join temp_update_any tua on (cntl.contact_id = tua.contact_id) 
set cntl.remark_3 = tua.remark_3, cntl.status = tua.status , cntl.date_updated = date(now())
where cntl.id in (select id from temp_update_any );


-- 15.5 **** insert into contact_for_updating from contact_numbers_to_lcc to do merge data
delete from contact_for_updating;

insert into contact_for_updating 
select * from contact_numbers_to_lcc cntl where cntl.contact_id in (select contact_id from temp_merge_data where 1=1) ;

-- 15.6 **** replace data to update, this will take around 10 minutes for 476,077 rows
replace into contact_for_updating
select cfu.`id`,cfu.`file_id`,cfu.`contact_no`,
	case when tmd.name = '' or tmd.name is null then cfu.name else tmd.name end `name` ,
	case when tmd.province_eng = '' or tmd.province_eng is null then cfu.province_eng else tmd.province_eng end `province_eng` ,
	case when tmd.province_laos = '' or tmd.province_laos is null then cfu.province_laos else tmd.province_laos end `province_laos` ,
	case when tmd.district_eng = '' or tmd.district_eng is null then cfu.district_eng else tmd.district_eng end `district_eng` ,
	case when tmd.district_laos = '' or tmd.district_laos is null then cfu.district_laos else tmd.district_laos end `district_laos` ,
	case when tmd.village = '' or tmd.village is null then cfu.village else tmd.village end `village` ,
	cfu.`type`,
	case when tmd.maker = '' or tmd.maker is null then cfu.maker else tmd.maker end `maker` ,
	case when tmd.model = '' or tmd.model is null then cfu.model else tmd.model end `model` ,
	case when tmd.`year` = '' or tmd.`year` is null then cfu.`year` else tmd.`year` end `year`, 
	cfu.`remark_1`, cfu.`remark_2`, cfu.`remark_3`, cfu.`branch_name`, cfu.`status`,
	cfu.`date_updated`, cfu.`pbxcdr_time`,cfu.`contact_id`
from contact_for_updating cfu left join temp_merge_data tmd on (tmd.contact_id = cfu.contact_id); 



-- 16) count to check 
select cntl.file_no , cntl.`type`, count(*) from file_details fd left join contact_numbers_to_lcc cntl on (fd.id = cntl.file_id)
where fd.id >= 1068
group by cntl.file_no, cntl.`type` ;

-- 17) import data to payment table
insert into payment 
(`id`,`file_id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`,`code`,`payment_amount`)
select `id`,`file_id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`,`code`,`payment_amount`
from ( 
	select *, 
	ROUND( case when `code` = '1-1000' then 1/150
		when `code` = '1-1100' then 1/50
		when `code` = '1-1010' then 1/40
		when `code` = '1-1110' then 1/30
		when `code` = '1-1001' then 1/30
		when `code` = '1-1011' then 1/20
		when `code` = '1-1101' then 1/20
		when `code` = '1-1111' then 1/10
		when `code` = '2-1000' then 1/300
		when `code` = '2-1100' then 1/100
		when `code` = '2-1010' then 1/100
		when `code` = '2-1110' then 1/80
		when `code` = '2-1001' then 1/80
		when `code` = '2-1011' then 1/70
		when `code` = '2-1101' then 1/70
		when `code` = '2-1111' then 1/50
		when `code` = '3-1000' then 1/600
		when `code` = '3-1100' then 1/300
		when `code` = '3-1010' then 1/250
		when `code` = '3-1110' then 1/200
		when `code` = '3-1001' then 1/150
		when `code` = '3-1011' then 1/100
		when `code` = '3-1101' then 1/100
		when `code` = '3-1111' then 1/80
		else ''
	end - 0.00005, 4) `payment_amount` 
from (
		select 
			cntl .* ,
			concat( 
			case when t.id = 1 then 1 when t.id = 2 then 2 when t.id = 3 then 2 when t.id = 4 then 3 end , "-" , -- type
			case when cntl.contact_no != '' then 1 else 0 end , -- contact_no
			case when cntl.name != '' then 1 else 0 end , -- customer name
			case when ((cntl.province_eng != '' or cntl.province_laos != '') and (cntl.district_eng != '' or cntl.district_laos != '') and cntl.village != '') != '' then 1 else 0 end , -- address
			case when (cntl.maker != '' or cntl.model != '') != '' then 1 else 0 end -- car
				) `code`
		from contact_numbers_to_lcc cntl 
		left join tbltype t on (t.`type` = cntl.`type`)
		where cntl.file_id >= 1068 
		group by cntl.contact_no
	) `tblpayment`
) `data_import`;


-- 18) Check and delete the invalid numbers that SMS check
delete from temp_update_any ;

insert into temp_update_any 
select id, contact_no, remark_3 , status, pbxcdr_time  from contact_numbers_to_lcc cntl where file_id in (1058,1059) and status = 'SMS_Failed';

delete from payment where id in (select id from temp_update_any);

-- 19) Calculate to pay for Tou 623
select round(60000.26350 , 0) ;
select round(22.22289 + 0.00005, 4) 'roundup', round(22.22289 - 0.00005, 4) 'rounddown';
select round(848000.0 + 500.000, -3) 'roundup for LAK', round(100 + 4.9, -1) 'rounddown';

select '' `No.`, fd.date_received, fd.staff_no, fd.staff_name, 
	fd.broker_name, fd.broker_tel , fd.broker_work_place ,
	fd.file_no , fd.`type` , fd.number_of_original_file , 
	fd.number_of_original_file -
	case when p.file_id = 983 then ROUND(count(p.contact_no)/10,0)
		when p.file_id = 984 then ROUND(count(p.contact_no)/10,0)
		when p.file_id = 985 then ROUND(count(p.contact_no)/10,0)
		when p.file_id = 986 then ROUND(count(p.contact_no)/10,0)
		when p.file_id = 987 then ROUND(count(p.contact_no)*8/100,0)
		when p.file_id = 988 then ROUND(count(p.contact_no)/10,0)
		when p.file_id = 1039 then ROUND(count(p.contact_no)/2,0) -- from 1504	Joy it's randowm numbers
		when p.file_id = 1049 then ROUND(count(p.contact_no)/2,0) -- from 1504	Joy it's randowm numbers
		when p.file_id = 1055 then 0 -- we are already paid LAK 16.011.700,00 on 25/04/2022
		else count(p.contact_no)
	end 'count(not_pay)',
	case when p.file_id = 983 then ROUND(count(p.contact_no)/10,0)
		when p.file_id = 984 then ROUND(count(p.contact_no)/10,0)
		when p.file_id = 985 then ROUND(count(p.contact_no)/10,0)
		when p.file_id = 986 then ROUND(count(p.contact_no)/10,0)
		when p.file_id = 987 then ROUND(count(p.contact_no)*8/100,0)
		when p.file_id = 988 then ROUND(count(p.contact_no)/10,0)
		when p.file_id = 1039 then ROUND(count(p.contact_no)/2,0) -- from 1504	Joy it's randowm numbers
		when p.file_id = 1049 then ROUND(count(p.contact_no)/2,0) -- from 1504	Joy it's randowm numbers
		else count(p.contact_no)
	end 'count(to_pay)',
	case when p.file_id = 983 then sum(p.payment_amount)/10
		when p.file_id = 984 then sum(p.payment_amount)/10
		when p.file_id = 985 then sum(p.payment_amount)/10
		when p.file_id = 986 then sum(p.payment_amount)/10
		when p.file_id = 987 then sum(p.payment_amount)*8/100
		when p.file_id = 988 then sum(p.payment_amount)/10
		when p.file_id = 1039 then sum(p.payment_amount)/2 -- from 1504	Joy it's randowm numbers
		when p.file_id = 1049 then sum(p.payment_amount)/2 -- from 1504	Joy it's randowm numbers
		else sum(p.payment_amount)
	end 'calculate_amount',
	case when p.file_id = 983 then ROUND(sum(p.payment_amount)/10 ,0)
		when p.file_id = 984 then ROUND(sum(p.payment_amount)/10 ,0)
		when p.file_id = 985 then ROUND(sum(p.payment_amount)/10 ,0)
		when p.file_id = 986 then ROUND(sum(p.payment_amount)/10 ,0)
		when p.file_id = 987 then ROUND(sum(p.payment_amount)*8/100 ,0)
		when p.file_id = 988 then ROUND(sum(p.payment_amount)/10 ,0)
		when p.file_id = 1039 then ROUND(sum(p.payment_amount)/2 ,0) -- from 1504	Joy it's randowm numbers
		when p.file_id = 1049 then ROUND(sum(p.payment_amount)/2 ,0) -- from 1504	Joy it's randowm numbers
		when p.file_id = 1055 then 0 -- we already paid LAK 16.011.700,00 on 25/04/2022
		else ROUND(sum(p.payment_amount),0)
	end 'payment_amount',
	concat('file_id = ', fd.id) `remark`
from payment p 
right join file_details fd on (p.file_id = fd.id)
where fd.id >= 1058 
group by fd.id ;


select * from contact_numbers_to_lcc cntl where status is null and file_id in (1058,1059)

-- temp update status and remove inactive contact_no 
delete from temp_update_any ;
insert into temp_update_any select id, contact_no , remark_3, status, pbxcdr_time from contact_numbers_to_lcc cntl 
where file_id >= 1068 and left(contact_no, 5) in ('90302', '90202'); 

-- update 
select * from temp_update_any tua where contact_no not in (select contact_no from temp_etl_active_numbers tean);
update temp_update_any set remark_3 = 'Telecom', status = 'ETL_inactive' where contact_no not in (select contact_no from temp_etl_active_numbers tean);

update contact_numbers_to_lcc cntl left join temp_update_any tua on (cntl.id = tua.id) 
set cntl.remark_3 = tua.remark_3, cntl.status = tua.status, cntl.date_updated = date(now())
where cntl.id in (select id from temp_update_any );

delete from payment where id in (select id from temp_update_any where status = 'ETL_inactive');



-- 20 Add the numbers for table file_details 
select fd.id, cn.`numbers`, icn.`numbers`, aucn.`numbers`, p.`numbers`
from file_details fd 
left join (select file_id, count(*) `numbers` from contact_numbers group by file_id ) cn on (fd.id = cn.file_id)
left join (select file_id, count(*) `numbers` from invalid_contact_numbers icn group by file_id ) icn on (fd.id = icn.file_id)
left join (select file_id, count(*) `numbers` from all_unique_contact_numbers aucn group by file_id ) aucn on (fd.id = aucn.file_id)
left join (select file_id, count(*) `numbers` from payment p group by file_id ) p on (fd.id = p.file_id)
where fd.id >= 1068;


update file_details fd 
left join (select file_id, count(*) `numbers` from contact_numbers group by file_id ) cn on (fd.id = cn.file_id)
left join (select file_id, count(*) `numbers` from invalid_contact_numbers icn group by file_id ) icn on (fd.id = icn.file_id)
left join (select file_id, count(*) `numbers` from all_unique_contact_numbers aucn group by file_id ) aucn on (fd.id = aucn.file_id)
left join (select file_id, count(*) `numbers` from payment p group by file_id ) p on (fd.id = p.file_id)
set fd.number_of_original_file = case when cn.`numbers` is not null then cn.`numbers` else 0 end, 
	fd.number_of_invalid_contact = case when icn.`numbers` is not null then icn.`numbers` else 0 end, 
	fd.number_of_unique_contact = case when aucn.`numbers` is not null then aucn.`numbers` else 0 end, 
	fd.number_for_payment = case when p.`numbers` is not null then p.`numbers` else 0 end
where fd.id >= 1185


-- 21 Update or merge customer data from old to new 
select * from contact_numbers_to_lcc where contact_no in (select contact_no from temp_merge_data)

select * from contact_numbers_to_lcc where file_id >= 1068;
select * from temp_merge_data;

select * from temp_sms_chairman where id in (select id from temp_update_any tua);
delete from temp_sms_chairman where id in (select id from temp_update_any tua);


-- 22 export into other server
select * from contact_numbers cn where file_id >= 1068;
select * from all_unique_contact_numbers where file_id >= 1068;
select * from valid_contact_numbers vcn where file_id >= 1068;
select * from invalid_contact_numbers icn where file_id >= 1068;
select * from contact_numbers_to_lcc cntl where file_id >= 1068;
select * from temp_merge_data file_id >= 1068;
select * from removed_duplicate where `time` >= '2023-01-26';
select * from file_details fd ;


-- 23 delete data from new database as delete from old
delete from all_unique_contact_numbers 
where id in (select id from removed_duplicate where `time` >= '2023-01-26'); -- done <= 1068

delete from all_unique_contact_numbers 
where id in (select id from removed_duplicate where `time` >= '2023-01-26'); -- done <= 1068



-- 24 Insert or Export from one server to one server
-- 01)____First method_______
select * from file_details fd where id >= 1068;

select * from contact_numbers cn where file_id >= 1068;

select * from all_unique_contact_numbers aucn where file_id >= 1068;

select * from contact_numbers_to_lcc cntl where file_id >= 1068;

select * from removed_duplicate rd where `time` >= '2023-01-26';

select * from temp_merge_data tmd where file_id >= 1068;

select * from valid_contact_numbers vcn where file_id >= 1068;

select * from invalid_contact_numbers icn where file_id >= 1068;

select * from payment p where file_id >= 1068;

-- _________________________ Delete duplicate record from new database _________________________
delete from all_unique_contact_numbers 
where id in (select id from removed_duplicate where `time` >= '2023-01-26'); -- done <= 1068

delete from contact_numbers_to_lcc where id in (select id from removed_duplicate where `time` >= '2023-01-26');



-- 02) _______Second method ________
-- _________________________ Export table  _________________________
C:\Users\Advice>mysqldump -u root -p -h localhost --port 3306 contact_data_db file_details contact_numbers all_unique_contact_numbers contact_numbers_to_lcc removed_duplicate temp_merge_data valid_contact_numbers invalid_contact_numbers payment > D:\"OneDrive - LALCO lalcodb1"\"OneDrive - Lao Asean Leasing Co. Ltd"\contact_data_db\new_contact_number_20230127.sql
Enter password:

-- _________________________ Import table  _________________________ 
C:\Users\Advice>mysql -u root -p -h localhost --port 3306 contact_data_db < D:\"OneDrive - LALCO lalcodb1"\"OneDrive - Lao Asean Leasing Co. Ltd"\contact_data_db\new_contact_number_20230127.sql
Enter password:



-- __________________________________________________________________ Yotha list __________________________________________________________________
-- Yotha list, Yoshi-san request to calculate second method
-- D:\OneDrive - Lao Asean Leasing Co. Ltd\Yothalist\ລິສໂຍທາ ປີ2021+2022+2023 ຈາກອ້າຍຈັນ\Yotha list calculate to pay.xlsx

select * from valid_contact_numbers vcn where file_id between 1185 and 1206 -- 106,908

select * from valid_contact_numbers vcn where file_id in (1171, 1184) -- 40,363

select id, file_id, contact_no, remark_3 , status from contact_numbers_to_lcc cntl where cntl.remark_3 = 'contracted' or (cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('X')); -- 51,436



-- __________________________________________________________________ MOIC list __________________________________________________________________
-- Location D:\OneDrive - Lao Asean Leasing Co. Ltd\Yothalist\MOIC ລີສການຄ້າ
-- 1) create table
CREATE TABLE `business_register` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_no` varchar(255) DEFAULT NULL,
  `vat_no` varchar(255) DEFAULT NULL,
  `register_type` varchar(255) DEFAULT NULL,
  `fee_amount_LAK` varchar(255) DEFAULT NULL,
  `fee_amount_USD` varchar(255) DEFAULT NULL,
  `register_no` varchar(255) DEFAULT NULL,
  `date_issue` varchar(255) DEFAULT NULL,
  `company_name` varchar(255) DEFAULT NULL,
  `owner_name` varchar(1000) DEFAULT NULL,
  `contact_no` varchar(255) DEFAULT NULL,
  `provice_id` varchar(255) DEFAULT NULL,
  `province` varchar(255) DEFAULT NULL,
  `district` varchar(255) DEFAULT NULL,
  `village` varchar(255) DEFAULT NULL,
  `tel_original` varchar(255) DEFAULT NULL,
  `ISIC_1` varchar(255) DEFAULT NULL,
  `activities_in_progress` varchar(1000) DEFAULT NULL,
  `activitives_no` varchar(255) DEFAULT NULL,
  `rank` varchar(255) DEFAULT NULL,
  `business_type_lao` varchar(255) DEFAULT NULL,
  `business_type_en` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb4;

alter table business_register add date_created timestamp not null default current_timestamp;
alter table business_register add file_id int(11) default null;

-- 2) insert data from csv to database

-- 3) check and update 
select id,company_no , vat_no  ,replace(company_no, '/', ''), replace(vat_no, '/', '') from business_register br where id >= 145535

update business_register set company_no = replace(company_no, '/', ''), vat_no = replace(vat_no, '/', '');

update business_register set vat_no = case when vat_no = company_no or vat_no = '' then null else vat_no end;

update business_register set company_no = replace(company_no, ' ', ''), vat_no = replace(vat_no, ' ', '') ;


CREATE TABLE `business_register_update` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `company_no` varchar(255) DEFAULT NULL,
  `vat_no` varchar(255) DEFAULT NULL,
  `provice_id` varchar(255) DEFAULT NULL,
  `province` varchar(255) DEFAULT NULL,
  `district` varchar(255) DEFAULT NULL,
  `village` varchar(255) DEFAULT NULL,
  `tel_original` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=310821 DEFAULT CHARSET=utf8mb4;

-- update
update business_register t inner join business_register_update tu on (t.id = tu.id)
set t.vat_no = tu.vat_no , t.province = tu.province , t.district = tu.district, t.village = tu.village , t.tel_original = tu.tel_original 
where t.id in (select id from business_register_update);

-- update contact_no
update business_register set contact_no = 
	case when tel_original = '' then ''
		when (length (regexp_replace(tel_original , '[^[:digit:]]', '')) = 9 and left (regexp_replace(tel_original , '[^[:digit:]]', ''),3) = '021')
			or (length (regexp_replace(tel_original , '[^[:digit:]]', '')) = 8 and left (regexp_replace(tel_original , '[^[:digit:]]', ''),2) = '21' )
			or (length (regexp_replace(tel_original , '[^[:digit:]]', '')) = 6)
		then concat('9021',right(regexp_replace(tel_original , '[^[:digit:]]', ''),6)) -- for 021
		when (length (regexp_replace(tel_original , '[^[:digit:]]', '')) = 11 and left (regexp_replace(tel_original , '[^[:digit:]]', ''),3) = '020')
			or (length (regexp_replace(tel_original , '[^[:digit:]]', '')) = 10 and left (regexp_replace(tel_original , '[^[:digit:]]', ''),2) = '20')
			or (length (regexp_replace(tel_original , '[^[:digit:]]', '')) = 8 and left (regexp_replace(tel_original , '[^[:digit:]]', ''),1) in ('2','5','7','8','9'))
		then concat('9020',right(regexp_replace(tel_original , '[^[:digit:]]', ''),8)) -- for 020
		when (length (regexp_replace(tel_original , '[^[:digit:]]', '')) = 10 and left (regexp_replace(tel_original , '[^[:digit:]]', ''),3) = '030')
			or (length (regexp_replace(tel_original , '[^[:digit:]]', '')) = 9 and left (regexp_replace(tel_original , '[^[:digit:]]', ''),2) = '30')
			or (length (regexp_replace(tel_original , '[^[:digit:]]', '')) = 7 and left (regexp_replace(tel_original , '[^[:digit:]]', ''),1) in ('2','4','5','7','9'))
		then concat('9030',right(regexp_replace(tel_original , '[^[:digit:]]', ''),7)) -- for 030
		when left (right (regexp_replace(tel_original , '[^[:digit:]]', ''),8),1) in ('0','1','') then concat('9030',right(regexp_replace(tel_original , '[^[:digit:]]', ''),7))
		when left (right (regexp_replace(tel_original , '[^[:digit:]]', ''),8),1) in ('2','5','7','8','9')
		then concat('9020',right(regexp_replace(tel_original , '[^[:digit:]]', ''),8))
		else concat('9020',right(regexp_replace(tel_original , '[^[:digit:]]', ''),8))
	end
where id >= 145541


-- add and set col for valid number
alter table business_register add valid_number int(11) null comment '1=valid, 0=invalid';

update business_register set valid_number = 
case when CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290208','1290209') then 1 else 0 end

-- select and insert to database contact_data_db
alter table business_register add file_id int(11) default null;

update business_register set file_id = 
	case when id <= 155939 then '1212'
		when id <= 158392 then '1213'
		when id <= 162143 then '1214' 
		when id <= 164460 then '1220'
		when id <= 169021 then '1221'
		when id <= 172803 then '1222'
		when id <= 186389 then '1223'
		when id <= 217667 then '1224'
		when id <= 229305 then '1226'
		when id <= 230383 then '1227'
		when id <= 235254 then '1228'
		when id <= 244153 then '1229'
		when id <= 251711 then '1230'
		when id <= 255351 then '1231'
		when id <= 264558 then '1232'
		when id <= 269935 then '1236'
		when id <= 279727 then '1237'
		when id <= 284026 then '1238'
		when id <= 285810 then '1234'
		when id <= 291638 then '1239'
		when id <= 303453 then '1240'
		when id <= 308563 then '1241'
		when id <= 310820 then '1242'
	end
where id >= 145541;

select file_id , count(*)  from business_register br group by file_id ;


select file_id, contact_no ,
left(owner_name, locate(',', owner_name, 1)-1) 'name',
case when province  = 'ບໍ່ແກ້ວ' then 'BORKEO'
		when province  = 'ບໍລິຄຳໄຊ' then 'BORLIKHAMXAY'
		when province  = 'ຈຳປາສັກ' then 'CHAMPASACK'
		when province  = 'ຫົວພັນ' then 'HUAPHAN'
		when province  = 'ຄຳມ່ວນ' then 'KHAMMOUAN'
		when province  = 'ຜົ້ງສາລີ' then 'PHONGSALY'
		when province  = 'ສາລະວັນ' then 'SALAVANH'
		when province  = 'ສະຫວັນນະເຂດ' then 'SAVANNAKHET'
		when province  = 'ນະຄອນຫຼວງວຽງຈັນ' then 'VIENTIANE CAPITAL'
		when province  = 'ວຽງຈັນ' then 'VIENTIANE PROVINCE'
		when province  = 'ຊຽງຂວາງ' then 'XIENGKHUANG'
		when province  = 'ໄຊສົມບູນ' then 'XAYSOMBOUN'
		when province  = 'ຫຼວງນ້ຳທາ' then 'LUANGNAMTHA'
		when province  = 'ຫຼວງພະບາງ' then 'LUANG PRABANG'
		when province  = 'ອັດຕະປື' then 'ATTAPUE'
		when province  = 'ອຸດົມໄຊ' then 'OUDOMXAY'
		when province  = 'ເຊກອງ' then 'XEKONG'
		when province  = 'ໄຊຍະບູລີ' then 'XAYABOULY'
		when province  is null then null 
		else null 
	end `province_eng` ,
province 'province_laos',
null 'district_eng',
district 'district_laos',
village 'village',
"③Have address" 'type',
null 'maker',
null 'model',
null 'year',
case when id <= 155939 then '1403'
		when id <= 158392 then '1404'
		when id <= 162143 then '1405' 
		when id <= 164460 then '1411'
		when id <= 169021 then '1412'
		when id <= 172803 then '1413'
		when id <= 186389 then '1414'
		when id <= 217667 then '1415'
		when id <= 229305 then '1417'
		when id <= 230383 then '1418'
		when id <= 235254 then '1419'
		when id <= 244153 then '1420'
		when id <= 251711 then '1421'
		when id <= 255351 then '1422'
		when id <= 264558 then '1423'
		when id <= 269935 then '1427'
		when id <= 279727 then '1428'
		when id <= 284026 then '1429'
		when id <= 285810 then '1425'
		when id <= 291638 then '1430'
		when id <= 303453 then '1431'
		when id <= 308563 then '1432'
		when id <= 310820 then '1433'
	end 'remark_1',
null 'remark_2',
null 'remark_3'
from business_register where file_id = 1403;











