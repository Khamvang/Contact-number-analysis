SELECT CURRENT_USER(), SCHEMA();

#============ Incorrect date value '0000-00-00' for DATE or DATETIME ==============
SELECT @@GLOBAL.sql_mode global, @@SESSION.sql_mode session;
SET sql_mode = '';
SET GLOBAL sql_mode = '';

#============ REGEXP_REPLACE to get number from string =============
SELECT REGEXP_REPLACE('deddf2484521584sda,.;eds2', '[^[:digit:]]', '') "REGEXP_REPLACE";

select 
	id, contact_no ,
	replace(name , ',', '') `name`,
	replace (province_eng , ',', '') `province_eng`,
	replace (province_laos , ',', '') `province_laos`,
	replace (district_eng , ',', '') `district_eng`,
	replace (district_laos , ',', '') `district_laos`,
	replace (village , ',', '') `village`,
	`type` ,
	replace (maker , ',', '') `maker`,
	replace (model , ',', '') `model`,
	`year` ,
	remark_1 ,
	remark_2 ,
	remark_3 ,
	branch_name ,
	status 
from contact_data_db.contact_numbers_to_lcc 
where branch_name = 'Head office' and (status = 'ANSWERED' or status is null) and `type` = ''
limit 10;


select count(*) from contact_data_db.contact_numbers_to_lcc  
where `type` = ''

select * from contact_data_db.contact_numbers_to_lcc cntl 
where contact_no like '%.%' limit 100;

select *,concat('9030',right (replace (contact_no, ';',''),7))  from contact_data_db.contact_numbers_to_lcc cntl where id = 17842170;

update contact_data_db.contact_numbers 
set contact_no = concat('9030',right (replace (contact_no, ';',''),7))
where id in (17842170,17842219,17842239,17948829,17948992,19280482,19280538,19280597,19280776,19281039,19281096,19281403,19281676,19281721,19281776,19281801,19281858,19281905,19281955,19282030,19282039,19282089,19282106,19282202,19282268,19282269,19282555,19282649,19282785,19283438,19283629,19283980,19284015,19284038,19284090,19284132,19284354,19284470,19427581,19427583,19427587,19427588,19427589,19427594,19427599,19427600,19427603,19427605,19427616,19427617,19427619,19427627,19427631,19427637,19427645,19427649,19427657,19427661,19427667,19427668,19427669,19427674,19427679,19427684,19427686,19427714,19427748,19427780,19427789,19427790,19427795,19427802,19427803,19427804,19427805,19427809,19427810,19427812,19427815,19427820,20700377,20714487
)

select date_received, file_id, branch_name, `type`, count(*) 
from contact_data_db.contact_numbers_to_lcc cntl 
group by date_received, file_id, branch_name, `type`;

select count(*) from contact_data_db.contact_numbers_to_lcc cntl ;

#======================= Start alter table add primary key and auto_increment key ====================
alter table contact_analysis.analysis_result add primary key (`id`);
ALTER TABLE contact_analysis.analysis_result MODIFY COLUMN id int auto_increment NOT NULL;
#======================= END alter table add primary key and auto_increment key ====================

select remark_1, `type`, count(*) from contact_numbers cn group by remark_1, `type`;


select count(id) from contact_data_db.valid_contact_numbers vcn ;

select count(*) from contact_analysis.analysis_result ar ; -- 13739796
select count(*) from contact_data_db.all_unique_contact_numbers aucn ; -- 12855086 13739796
select 13739796 - 12855086; -- need to select 884710 from valid contact number to all unique by id 

select * from contact_data_db.all_unique_contact_numbers aucn order by id desc; -- 37000000

select * from contact_data_db.valid_contact_numbers vcn where id in (
select id from contact_analysis.analysis_result ar where id > 37000000);


select count(*) from valid_contact_numbers vcn ;

#============ The step to insert new contact numbers to my database ================
#============ update date_created to new data of table file_details =============
select *, unix_timestamp(now()), from_unixtime(unix_timestamp(now())) from file_details fd where id > 993;
update file_details set date_created = unix_timestamp(now()) where id > 993;

#=========== insert date from data test and table file_details to contact_data_db and table file_details 
select * from test.file_details fd where id > 993;
insert into contact_data_db.file_details select * from test.file_details fd where id > 993;

#============ update or add file_id to new contact number ============
select *, cast(remark_1 as unsigned) - 191, date(now()) from contact_numbers cn where cast(remark_1 as unsigned) >= 1188;
update contact_numbers set file_id = cast(remark_1 as unsigned) - 191, created_date = date(now()) where cast(remark_1 as unsigned) >= 1188;
select file_id, remark_1, created_date, count(*) from contact_numbers group by file_id, remark_1, created_date order by file_id ;

#=========== insert new data from test.contact_numbers to contact_data_db.contact_numbers ============
insert into contact_data_db.contact_numbers 
(`file_id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`,`created_date`)
select `file_id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`,`created_date`
from test.contact_numbers where `file_id` > 994 order by file_id ;

#=========== Check how many number of new contact numbers ==========
select count(*) from contact_data_db.contact_numbers cn where file_id >= 1036; -- 203642

#============== Update the number format ==============
	-- check 
select id, file_id , case when left (right (REPLACE ( contact_no , ' ', '') ,8),1) = '0' then CONCAT('903',right (REPLACE ( contact_no, ' ', '') ,8))
    when length (REPLACE ( contact_no, ' ', '')) = 7 then CONCAT('9030',REPLACE ( contact_no, ' ', ''))
    else CONCAT('9020', right(REPLACE ( contact_no, ' ', '') , 8))
end `contact_no`
from contact_numbers cn 
where file_id >= 1036;

	-- update
update contact_numbers set contact_no = (case when left (right (REPLACE ( contact_no , ' ', '') ,8),1) = '0' then CONCAT('903',right (REPLACE ( contact_no, ' ', '') ,8))
    when length (REPLACE ( contact_no, ' ', '')) = 7 then CONCAT('9030',REPLACE ( contact_no, ' ', ''))
    else CONCAT('9020', right(REPLACE ( contact_no, ' ', '') , 8))
end)
where file_id >= 1036;

#============= Check how many valid number before import to valid table ===========
select * from contact_data_db.contact_numbers 
where CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290209')
	and file_id >= 1036 ; -- 202979

#============== Import valid contact number data to valid table ===========
insert into contact_data_db.valid_contact_numbers 
(`id`,`file_id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`)
select `id`,`file_id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_data_db.contact_numbers 
where CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290209')
	and file_id >= 1036  ;

#============== Import valid contact number data to all_unique_contact_numbers table ===========
insert into contact_data_db.all_unique_contact_numbers 
(`id`,`file_id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`)
select `id`,`file_id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_data_db.contact_numbers 
where CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290209')
	and file_id >= 1036 ;

#============= Check how many invalid number before import to invalid table ===========
select count(id) from contact_data_db.contact_numbers 
where CONCAT(LENGTH(contact_no), left( contact_no, 5)) not in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290209')
	and file_id >= 1036 ; -- 663

#============= Import invalid contact number data to invalid table ==========
insert into contact_data_db.invalid_contact_numbers 
(`id`,`file_id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`)
select `id`,`file_id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_data_db.contact_numbers 
where CONCAT(LENGTH(contact_no), left( contact_no, 5)) not in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290209')
	and file_id >= 1036 ;

select count(*) from all_unique_contact_numbers aucn where file_id > 1036;


#===================== Step3 Start check and remove duplicate =======================#
#Select duplicate rows from table all_unique_contact_numbers by checking priorities type and id === This working fine and correct in DBeaver program===
-- partition by contact_no === check duplicate by contact_no
-- order by FIELD(`type` , "Have Car","Need loan","Have address","Telecom"), id === order priorities by type and id
#================ Count to check show many numbers are duplicate ==============
select count(*) from (
		select id, row_number() over (partition by contact_no order by FIELD(`type` , "Have Car","Need loan","Have address","Telecom"), id) as row_numbers  
		from contact_data_db.all_unique_contact_numbers 
		where file_id <= 1036
		) as t1
	where row_numbers > 1; -- 36146

#================ Query date to expot into table removed duplicate ================
select id, row_numbers, now() `time` from ( 
		select id, row_number() over (partition by contact_no order by FIELD(`type` , "Have Car","Need loan","Have address","Telecom"), id) as row_numbers  
		from contact_data_db.all_unique_contact_numbers 
		where file_id <= 993
		) as t1
	where row_numbers > 1;

#=============== Delete from all unique where id = id in table removed duplicate =============
delete from contact_data_db.all_unique_contact_numbers 
where id in (select id from contact_data_db.removed_duplicate where `time` >= '2021-11-01');

select * from removed_duplicate rd where `time` >= '2021-11-01' order by `time` ; -- 68388
select count(*) from all_unique_contact_numbers aucn ;
#===================== Step3 END check and remove duplicate =======================#

#================= Start Calculate payment amount ================= 
SELECT ROUND(22.22289 + 0.00005, 4) 'roundup', ROUND(22.22289 - 0.00005, 4) 'rounddown';

select file_id, count(*) from all_unique_contact_numbers aucn where file_id >= 994 group by file_id 

#Import data to payment table
insert into contact_data_db.payment 
(`id`,`file_id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`,`code`,`payment_amount`)
;select `id`,`file_id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`,`code`,`payment_amount`
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
			aucn .* ,
			concat( 
			case when aucn.file_id = 1039 then 3 when c.type_id = 1 then 1 when c.type_id = 2 then 2 when c.type_id = 3 then 2 when c.type_id = 4 then 3 end , "-" ,
			case when aucn.contact_no != '' then 1 else 0 end ,
			case when aucn.name != '' then 1 else 0 end ,
			case when ((aucn.province_eng != '' or aucn.province_laos != '') and (aucn.district_eng != '' or aucn.district_laos != '') and aucn.village != '') != '' then 1 else 0 end ,
			case when (aucn.maker != '' or aucn.model != '') != '' then 1 else 0 end
				) `code`
		from contact_data_db.all_unique_contact_numbers aucn 
		left join contact_data_db.category c on (c.`type` = aucn.`type`)
		where aucn.file_id >= 1036 -- (948,951,959,960,963,973,975,976,978,980,982,987,991) 
		group by aucn.contact_no
	) `tblpayment`
) `data_import`;

#=========== Calculate to pay ============
select '' `No.`, fd.date_received, fd.staff_no, fd.staff_name, 
	fd.broker_name, fd.broker_tel , fd.broker_work_place ,
	fd.file_no , t.`type` , fd.number_of_original_file , 
	fd.number_of_original_file -
	case when p.file_id = 983 then ROUND(count(p.contact_no)/10,0)
		when p.file_id = 984 then ROUND(count(p.contact_no)/10,0)
		when p.file_id = 985 then ROUND(count(p.contact_no)/10,0)
		when p.file_id = 986 then ROUND(count(p.contact_no)/10,0)
		when p.file_id = 987 then ROUND(count(p.contact_no)*8/100,0)
		when p.file_id = 988 then ROUND(count(p.contact_no)/10,0)
		when p.file_id = 1039 then ROUND(count(p.contact_no)/2,0) -- from 1504	Joy it's randowm numbers
		else count(p.contact_no)
	end 'count(not_pay)',
	case when p.file_id = 983 then ROUND(count(p.contact_no)/10,0)
		when p.file_id = 984 then ROUND(count(p.contact_no)/10,0)
		when p.file_id = 985 then ROUND(count(p.contact_no)/10,0)
		when p.file_id = 986 then ROUND(count(p.contact_no)/10,0)
		when p.file_id = 987 then ROUND(count(p.contact_no)*8/100,0)
		when p.file_id = 988 then ROUND(count(p.contact_no)/10,0)
		when p.file_id = 1039 then ROUND(count(p.contact_no)/2,0) -- from 1504	Joy it's randowm numbers
		else count(p.contact_no)
	end 'count(to_pay)',
	case when p.file_id = 983 then sum(p.payment_amount)/10
		when p.file_id = 984 then sum(p.payment_amount)/10
		when p.file_id = 985 then sum(p.payment_amount)/10
		when p.file_id = 986 then sum(p.payment_amount)/10
		when p.file_id = 987 then sum(p.payment_amount)*8/100
		when p.file_id = 988 then sum(p.payment_amount)/10
		when p.file_id = 1039 then sum(p.payment_amount)/2 -- from 1504	Joy it's randowm numbers
		else sum(p.payment_amount)
	end 'calculate_amount',
	case when p.file_id = 983 then ROUND(sum(p.payment_amount)/10 ,0)
		when p.file_id = 984 then ROUND(sum(p.payment_amount)/10 ,0)
		when p.file_id = 985 then ROUND(sum(p.payment_amount)/10 ,0)
		when p.file_id = 986 then ROUND(sum(p.payment_amount)/10 ,0)
		when p.file_id = 987 then ROUND(sum(p.payment_amount)*8/100 ,0)
		when p.file_id = 988 then ROUND(sum(p.payment_amount)/10 ,0)
		when p.file_id = 1039 then ROUND(sum(p.payment_amount)/2 ,0) -- from 1504	Joy it's randowm numbers
		else ROUND(sum(p.payment_amount),0)
	end 'payment_amount',
	'' `remark`
from contact_data_db.payment p 
RIGHT join contact_data_db.file_details fd on (p.file_id = fd.id)
left join contact_data_db.`type` t on (t.id = fd.`type`)
where fd.id >= 1036 group by fd.id ;

select round('6.26350', 0) 
#=========== END Calculate to pay ============

create table contact_data_db.`type` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`type` varchar(255) NOT NULL,
	`date_created` int(11) NOT NULL,
	primary key (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;

#=============== START Check and insert data into table like_valid_contact_number ===============
create table `like_valid_contact_numbers` (
	`id` int(11) not null auto_increment,
	`like_contact_number` varchar(255) not null,
	`status` varchar(255) default null,
	`priority_type` varchar(255) default null,
	`date_created` date default null,
	`date_updated` date default null,
	primary key (`id`)
) ENGINE = InnoDB auto_increment = 1 default CHARSET = utf8;

-- insert 
insert into like_valid_contact_numbers 
(`like_contact_number`, `status`, `priority_type`, `date_created`, `date_updated`)
select * from (
select 
	case when length(pa.contact_no) = 11 then left(pa.contact_no, 8)
	when length(pa.contact_no) = 12 then left(pa.contact_no, 9)
	else null
	end `like_contact_number`,
	pa.status ,
	pa.priority_type ,
	date(now()) `date_created` ,
	date(now()) `date_updated`
from contact_data_db.all_unique_analysis pa ) t1
where like_contact_number is not null and status = 'F' -- in ('ANSWERED', 'Active', 'Closed', 'Refinance', 'S', 'A', 'B', 'C', 'F')
group by like_contact_number;

-- select to check
select id, row_numbers, now() `time` from ( 
		select id, row_number() over (partition by like_contact_number order by FIELD(`status` , "ANSWERED", "Active", "Closed", "Refinance", "S", "A", "B", "C","F"), id) as row_numbers  
		from like_valid_contact_numbers  
		) as t1
	where row_numbers > 1;

-- delete 
delete from like_valid_contact_numbers where id in (
select id from ( 
		select id, row_number() over (partition by like_contact_number order by FIELD(`status` , "ANSWERED", "Active", "Closed", "Refinance", "S", "A", "B", "C","F"), id) as row_numbers  
		from like_valid_contact_numbers  
		) as t1
	where row_numbers > 1);

select count(*) from like_valid_contact_numbers lvcn ;
#=============== END Check and insert data into table like_valid_contact_number ===============

#============== START Check and delete the contact numbers that not like valid num ==============
-- select to check
select count(*) from payment p 
where file_id = 1012 and 
	case when length(p.contact_no) = 11 then left(p.contact_no, 8)
		when length(p.contact_no) = 12 then left(p.contact_no, 9)
		else null
	end not in (select like_contact_number from like_valid_contact_numbers ); 

-- delete from table payment
delete from payment p 
where file_id = 1012 and 
	case when length(p.contact_no) = 11 then left(p.contact_no, 8)
		when length(p.contact_no) = 12 then left(p.contact_no, 9)
		else null
	end not in (select like_contact_number from like_valid_contact_numbers ); 
#============== END Check and delete the contact numbers that not like valid num ==============
#================= END Calculate payment amount ================= 

#================= START Check data in 2021-09-18 =====================
select count(*) from contact_data_db.all_unique_analysis aua ; -- 4399655
select count(*) from contact_data_db.all_unique_contact_numbers aucn ; -- 16770607
select count(*) from contact_data_db.analysis_result ar ; -- 13739796
select count(*) from contact_data_db.category c ; -- 6
select count(*) from contact_data_db.contact_numbers cn ; -- 34263444
select count(*) from contact_data_db.contact_numbers_to_lcc cntl ; -- 16770607
select count(*) from contact_data_db.file_details fd ; -- 991
select count(*) from contact_data_db.invalid_contact_numbers icn ; -- 254248
select count(*) from contact_data_db.not_need_contact_numbers nncn ; -- 801899
select count(*) from contact_data_db.payment p ; -- 2355217
select count(*) from contact_data_db.prepare_analysis pa ; -- 17975537
select count(*) from contact_data_db.removed_duplicate rd ; -- 2294788
select count(*) from contact_data_db.`type` ; -- 4
select count(*) from contact_data_db.valid_contact_numbers vcn ; -- 34009196


#================= END Check data in 2021-09-08 =====================


#================= START Yoshi request to export to him ==================
select aucn.file_id , fd.date_received , aucn.`type` , fd.`type`, fd.number_of_original_file , count(aucn.id) 
from contact_data_db.all_unique_contact_numbers aucn 
left join contact_data_db.file_details fd on (fd.id = aucn.file_id)
group by aucn.file_id ;

select * from contact_data_db.all_unique_contact_numbers aucn where file_id = 948


select aucn.*, fd.date_received ,
	case when aucn.province_eng = 'ATTAPUE' then 'Attapue'
		when aucn.province_eng = 'BORKEO' then 'Luangprabang'
		when aucn.province_eng = 'BORLIKHAMXAY' then 'Paksan'
		when aucn.province_eng = 'CHAMPASACK' then 'Pakse'
		when aucn.province_eng = 'HUAPHAN' then 'Houaphan'
		when aucn.province_eng = 'KHAMMOUAN' then 'Thakek'
		when aucn.province_eng = 'LUANG PRABANG' then 'Luangprabang'
		when aucn.province_eng = 'LUANGNAMTHA' then 'Luangprabang'
		when aucn.province_eng = 'OUDOMXAY' then 'Oudomxay'
		when aucn.province_eng = 'PHONGSALY' then 'Oudomxay'
		when aucn.province_eng = 'SALAVANH' then 'Salavan'
		when aucn.province_eng = 'SAVANNAKHET' then 'Savannakhet'
		when aucn.province_eng = 'VIENTIANE CAPITAL' then 'Head office'
		when aucn.province_eng = 'VIENTIANE PROVINCE' then 'Head office'
		when aucn.province_eng = 'XAYABOULY' then 'Sainyabuli'
		when aucn.province_eng = 'XAYSOMBOUN' then 'Xiengkhouang'
		when aucn.province_eng = 'XEKONG' then 'Attapue'
		when aucn.province_eng = 'XIENGKHUANG' then 'Xiengkhouang'
		when aucn.province_eng = '' then fd.branch_name 
		when aucn.province_eng is null then fd.branch_name 
		else null 
	end `branch_name`
from contact_data_db.all_unique_contact_numbers aucn 
left join contact_data_db.file_details fd on (aucn.file_id = fd.id)
where fd.id in (807,806,805,804,803,802,801,800,799,798,797,796,795,794,793,792,791,790,789,636,635,634,633,632,631,630,629,613,611,610,786,785,784,783,782,781,780,779,778,777,776,775,774,773,647,657,656,655,654,772,771,770,769,768,767,766,765,764,763,762,761,760,759,758,757,756,684,682,712,708,707,706,705,704,703,702,701,700,699,698,697,696,695,694,693,692,691,690,689,688,687,686,685,683,864,848,844,840,946,945,943,942,941,940,939,938,905,809,993,968,967,966,965,964,961,958,954
) ;

select district_eng, `type` , count(*) from contact_data_db.all_unique_contact_numbers aucn 
where province_eng = 'VIENTIANE CAPITAL' 
group by district_eng , `type` ;

select * from contact_data_db.all_unique_contact_numbers aucn 
where province_eng = 'VIENTIANE CAPITAL' and district_eng is not null;

#================= END Yoshi request to export to him ==================

select * from contact_data_db.payment p 
-- update contact_data_db.valid_contact_numbers set `type` = ''
-- delete from contact_data_db.payment 
where file_id in (948,951,959,960,963,973,975,976,978,980,982,987,991
) 

select * from contact_data_db.payment p 
-- update contact_data_db.valid_contact_numbers set `type` = ''
-- delete from contact_data_db.payment 
where file_id in (971)


#=============== START Select and insert data and export to contact numbers to lcc ==============
insert into contact_data_db.contact_numbers_to_lcc 
select  aucn.*,
	case when aucn.province_eng = 'ATTAPUE' then 'Attapue'
		when aucn.province_eng = 'BORKEO' then 'LuangNamtha'
		when aucn.province_eng = 'BORLIKHAMXAY' then 'Paksan'
		when aucn.province_eng = 'CHAMPASACK' then 'Pakse'
		when aucn.province_eng = 'HUAPHAN' then 'Houaphan'
		when aucn.province_eng = 'KHAMMOUAN' then 'Thakek'
		when aucn.province_eng = 'LUANG PRABANG' then 'Luangprabang'
		when aucn.province_eng = 'LUANGNAMTHA' then 'LuangNamtha'
		when aucn.province_eng = 'OUDOMXAY' then 'Oudomxay'
		when aucn.province_eng = 'PHONGSALY' then 'Oudomxay'
		when aucn.province_eng = 'SALAVANH' then 'Salavan'
		when aucn.province_eng = 'SAVANNAKHET' then 'Savannakhet'
		when aucn.province_eng = 'VIENTIANE CAPITAL' then 'Head office'
		when aucn.province_eng = 'VIENTIANE PROVINCE' then 'VTP-Vangvieng'
		when aucn.province_eng = 'XAYABOULY' then 'Sainyabuli'
		when aucn.province_eng = 'XAYSOMBOUN' then 'Xiengkhouang'
		when aucn.province_eng = 'XEKONG' then 'Attapue'
		when aucn.province_eng = 'XIENGKHUANG' then 'Xiengkhouang'
		when aucn.province_eng = '' then fd.branch_name 
		when aucn.province_eng is null then fd.branch_name 
		else null 
	end `branch_name`,
	ar.status ,
	fd.file_no ,
	fd.date_received 
from contact_data_db.all_unique_contact_numbers aucn 
left join contact_data_db.file_details fd on (fd.id = aucn.file_id)
left join contact_data_db.analysis_result ar on (ar.id = aucn.id)
where aucn.id > 44243337 
limit 500000;

-- update branch name
update contact_numbers_to_lcc set branch_name = 'Attapue'
where branch_name != 'Attapue' and  province_eng = 'XEKONG'


#=============== END Select and insert data and export to contact numbers to lcc ==============

select count(*) from contact_data_db.contact_numbers_to_lcc cntl where file_id >= 947;


select date_format('2021-09-09 22:02:54', '%Y-%m-%d')

select * from test.pbx_cdr pc where date_format(`time`, '%Y-%m') = '2021-08'; order by id desc limit 100;

#================ START Create database for lalco pbx ===================
select * from pbx_cdr where date_format(`time`, '%Y-%m-%d') between '2021-10-09' and '2021-10-09' limit 100;

select * from pbx_cdr order by id desc limit 1000 ;

select count(*) from pbx_cdr pc where date_format(`time`, '%Y-%m-%d') between '2021-10-09' and '2021-10-09'; -- 95105
select * from pbx_cdr pc where date_format(`time`, '%Y-%m-%d') = '2021-10-22' order by id desc limit 100 ;

-- delete from pbx_cdr where id >= 17747798;
-- alter table pbx_cdr auto_increment = 17747798;

SELECT CAST('25.65' AS UNSIGNED);

#================ END Create database for lalco pbx ===================

#============= START create database for lalco backup ==============
SELECT COUNT(*) from lalco_portal.tblpaymentschedule t ; -- 1424814
SELECT COUNT(*) FROM lalco_portal.tblcontract t ; -- 71428
SELECT COUNT(*) FROM lalco_portal.tblcollection t ; -- 955563
SELECT COUNT(*) FROM lalco_portal.tblcustomer t ; -- 52385
SELECT COUNT(*) FROM lalco_portal.tblpayment t ; -- 2627626
SELECT COUNT(*) FROM lalco_portal.tblprospect t ; -- 80288
#============= END create database for lalco backup ==============


select file_id, `type`, count(*) from contact_data_db.all_unique_contact_numbers aucn  group by file_id , `type` ;

select * from contact_data_db.payment p where file_id = 987 and contact_no in (
select contact_no from contact_data_db.all_unique_contact_numbers aucn where `type` = ''

select date_format(date_received, '%Y-%m'), branch_name, `type`, count(*) from contact_data_db.contact_numbers_to_lcc cntl 
where branch_name = 'Head office' and `type` = ''
group by date_format(date_received, '%Y-%m'), branch_name , `type` ;


select *, date_format(date_received, '%Y-%m') from contact_data_db.contact_numbers_to_lcc cntl where branch_name = 'Head office' and `type` = ''
select * from contact_data_db.all_unique_contact_numbers aucn where file_id = 987;


select * from lalco_portal.tblpaymentschedule t where prospect_id = 2074634;

select * from test.tblpaymentschedule t where prospect_id = 2073510;
select * from test.tblpayment t where contract_id = 79239;

#1
update test.tblpaymentschedule set payment_amount = 4500 , principal_amount = 0 
where contract_id = 79239 and payment_date in ('2021-05-05', '2021-06-05', '2021-07-05', '2021-08-05');
#2
update test.tblpaymentschedule set payment_amount = 29500 , principal_amount = 25000 
where contract_id = 79239 and payment_date in ('2021-09-05', '2021-10-05', '2021-11-05', '2021-12-05');
#3
update test.tblpayment set amount = 0 where contract_id = 79239 and `type` = 'principal' and due_date in ('2021-05-05', '2021-06-05', '2021-07-05', '2021-08-05');
#4
update test.tblpayment set amount = 25000 where contract_id = 79239 and `type` = 'principal' and due_date in ('2021-09-05', '2021-10-05', '2021-11-05', '2021-12-05');

update tblpayment set amount = 0 where type = 'principal' and due_date in ('2021-05-05', '2021-06-05', '2021-07-05', '2021-08-05');

#=========== Start Reupdate the last payment_amount and last_principal of contract no 2074754,2072327 Tciket #928 ==========
SELECT t.*, p.loan_amount, p.loan_amount + t.interest_amount 'new_payment_amount' FROM tblpaymentschedule t left join tblprospect p on (p.id = t.prospect_id) 
where t.prospect_id in (2074754,2072327) and t.payment_date = '2021-09-05';

UPDATE tblpaymentschedule t left join tblprospect p on (p.id = t.prospect_id) 
set t.payment_amount = p.loan_amount + t.interest_amount, t.principal_amount = p.loan_amount 
where t.prospect_id in (2074754,2072327) and t.payment_date = '2021-09-05';

SELECT * FROM tblpayment t2 where contract_id in (78429,80771);
SELECT *, 6000 'new amount' FROM tblpayment where id = 3043161 and contract_id = 78429;
SELECT *, 21000 'new amount' FROM tblpayment where id = 3043211 and contract_id = 80771;

UPDATE tblpayment set amount = 6000 where id = 3043161 and contract_id = 78429;
UPDATE tblpayment set amount = 21000 where id = 3043211 and contract_id = 80771;
#=========== END Reupdate the last payment_amount and last_principal of contract no 2074754,2072327 ==========

select priority_type, status, count(*) from all_unique_analysis aua group by priority_type, status;

#============ Calculate days months years from two date ===========
SELECT DATEDIFF('2036-03-01', '2036-01-28');
SELECT TIMESTAMPDIFF(DAY,'2009-06-18','2009-07-29'); 
SELECT TIMESTAMPDIFF(MONTH,'2009-06-18','2009-07-29'); 
SELECT TIMESTAMPDIFF(YEAR,'2008-06-18','2009-07-29'); 

#============= Start Update branch_name of table contact_numbers_to_lcc ==============
select count(*) from contact_numbers_to_lcc 
where `type` = ''

select * from contact_numbers_to_lcc 
where `type` = ''

update contact_numbers_to_lcc set branch_name = 'Sainyabuli' 
where `type` = ''
limit 9000;
#============= END Update branch_name of table contact_numbers_to_lcc ==============

#============= insert data from contact_numbers_to_lcc to contact_for_202110 =============
select count(*) 
from contact_for_202110 cf where `type` = ''

insert into contact_for_202110 
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`,`branch_name`,`status`
from contact_numbers_to_lcc cntl where `type` = ''

select branch_name, `type`, status , count(*) from contact_for_202110 cf group by branch_name, `type`, status ;

#Update contract type same contract type WHEN 1 THEN 'SME Car' WHEN 2 THEN 'SME Bike' WHEN 3 THEN 'Car Leasing' WHEN 4 THEN 'Bike Leasing'
SELECT id , contract_type , trading_currency, loan_amount, status from tblprospect where id in (2082074,2082062,2080596);
update tblprospect set contract_type = 2 where id in (2082074,2082062,2080596) and contract_type = 1;

#============= Leemee request to update collection data on AAA system Ticket #1344 ===========
-- 1) Created table and Excel template for them to input the collection data that need to update on LMS
CREATE TABLE `update_tblcollection` (
	`contract_no` int NOT NULL,
	`ncn` varchar(100) DEFAULT NULL,
	`contract_id` int NOT NULL,
	`collection_id` int NOT NULL AUTO_INCREMENT,
	`date_collected` date NOT NULL,
	`payment_amount` decimal(20,2) NOT NULL,
	`usd_amount` decimal(20,2) NOT NULL,
	`thb_amount` decimal(20,2) NOT NULL,
	`lak_amount` decimal(20,2) NOT NULL,
	`collection_method` tinyint NOT NULL,
	PRIMARY KEY (`collection_id`),
	KEY `contract_id` (`contract_id`)
) ENGINE=InnoDB AUTO_INCREMENT=103660 DEFAULT CHARSET=utf8mb3;

-- 2) Select and export 10 data for make example to them
-- insert into update_tblcollection 
select 
	c.contract_no ,
	c.ncn ,
	c.id contract_id ,
	co.id `collection_id`,
	co.date_collected ,
	co.payment_amount ,
	co.usd_amount ,
	co.thb_amount ,
	co.lak_amount ,
	co.collection_method ,
	co.bank_usd_amount ,
	co.bank_thb_amount ,
	co.bank_lak_amount 
from tblcollection co 
left join tblcontract c on (c.id = co.contract_id)
left join tblprospect p on (p.id = c.prospect_id)
where co.id in (select collection_id from update_tblcollection)

where p.contract_type = 5
limit 20;

-- 3) The query to update collection data
select * from update_tblcollection ut ;
update tblcollection co left join update_tblcollection ut on (ut.collection_id = co.id)
set co.date_collected = ut.date_collected , co.payment_amount = ut.payment_amount , 
	co.usd_amount = case when ut.collection_method = 1 then ut.usd_amount else 0 end,
	co.bank_usd_amount = case when ut.collection_method = 2 then ut.usd_amount else 0 end,
	co.thb_amount = case when ut.collection_method = 1 then ut.thb_amount else 0 end,
	co.bank_thb_amount = case when ut.collection_method = 2 then ut.thb_amount else 0 end,
	co.lak_amount = case when ut.collection_method = 1 then ut.lak_amount else 0 end,
	co.bank_lak_amount = case when ut.collection_method = 2 then ut.lak_amount else 0 end,
	co.collection_method = ut.collection_method 
where co.id in (select collection_id from update_tblcollection) and ut.collection_method in (1,2);


select 
	province_eng ,
	district_eng ,
	village ,
	count(*) 
from contact_numbers_to_lcc 
where province_eng = 'VIENTIANE CAPITAL' and district_eng = 'Xaythany'
group by province_eng , district_eng , village 

select distinct province_eng from contact_numbers_to_lcc

update contact_numbers_to_lcc set village = 'B. Phaun hi kham' 
where province_eng = 'VIENTIANE CAPITAL' and district_eng = 'Xaythany' and village != 'B. Phaun hi kham'
	and village in ()

select * from contact_numbers_to_lcc 
where province_eng = 'VIENTIANE CAPITAL' and district_eng in ('Chanthabuly','Sikhottabong','Xaysetha','Sisattanak','Naxaythong','Xaythany','Hadxayfong','Sangthong','Parkngum'
)


update contact_data_db.contact_numbers_to_lcc cl left join test.update_new_village u on (cl.id = u.id)
set cl.village = u.new_village 
where cl.id in (select id from test.update_new_village)

select cl.id, cl.district_eng, cl.village , u.new_village 
from contact_data_db.contact_numbers_to_lcc cl left join test.update_new_village u on (cl.id = u.id)
where cl.id in (select id from test.update_new_village)


#=========== check and fix Reason: SQL Error [1292] [22001]: Data truncation: Incorrect date value: '0000-00-00' for column `test`.`tbl collection`.`transfer date` at row 1 ======
SELECT @@GLOBAL.sql_mode global, @@SESSION.sql_mode session;
SET sql_mode = '';
SET GLOBAL sql_mode = '';

select * from contact_numbers_to_lcc cntl where province_eng = 'VIENTIANE PROVINCE';



update contact_numbers_to_lcc set district_eng = 'Mune'
where branch_name = 'VTE Province' and district_eng != 'Mune' and district_laos = 'Mune'


SELECT * from tblprospect t where id = 2771;

SELECT * FROM tblpaymentschedule t where prospect_id = 2070529;

create user 'admin'@'172.16.40.190' IDENTIFIED by 'LalcoAdmin';
create user 'admin'@'%' IDENTIFIED by 'LalcoAdmin';
grant all privileges on *.* to 'admin'@'172.16.10.190';
grant all privileges on *.* to 'admin'@'%';
flush privileges;

create user 'tou'@'172.16.10.121' IDENTIFIED by 'Tou623test';
create user 'tou'@'%' IDENTIFIED by 'Tou623test';
GRANT ALL PRIVILEGES ON *.* TO 'tou'@'172.16.10.121';
GRANT ALL PRIVILEGES ON *.* TO 'tou'@'%';
FLUSH PRIVILEGES;

insert into lalco.tblprospect 
SELECT * from lalco_moneymax.tblprospect t where id = 2771;

delete from tblprospect ;

create database lalco_data;
create table `mpwt_yothalist` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`number_plate` varchar(255) DEFAULT NULL,
	`type_of_number_plate` varchar(255) DEFAULT NULL,
	`owner_name` varchar(255) DEFAULT NULL,
	`province_eng` varchar(255) DEFAULT NULL,
	`province_laos` varchar(255) DEFAULT NULL,
	`district_eng` varchar(255) DEFAULT NULL,
	`district_laos` varchar(255) DEFAULT NULL,
	`pvd_id` int(11) DEFAULT NULL,
	`village` varchar(255) DEFAULT NULL,
	`type_of_automobile` varchar(255) DEFAULT NULL,
	`maker` varchar(255) DEFAULT NULL,
	`model` varchar(255) DEFAULT NULL,
	`color` varchar(255) DEFAULT NULL,
	`year` varchar(255) DEFAULT NULL,
	`car_steering_wheel` varchar(255) DEFAULT NULL,
	`fuel` varchar(255) DEFAULT NULL,
	`drive` varchar(255) DEFAULT NULL,
	`displacement` varchar(255) DEFAULT NULL,
	`collateral_engine_no` varchar(255) DEFAULT NULL,
	`collateral_vin_code` varchar(255) DEFAULT NULL,
	`date_created` date NOT  NULL,
	`date_updated` date NOT  NULL,
	PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3;
ALTER TABLE lalco_data.mpwt_yothalist ADD register_date DATE NULL;
ALTER TABLE lalco_data.mpwt_yothalist ADD expired_date DATE NULL;

select province_eng, district_laos , count(*) from mpwt_yothalist my -- where date_created = '2019-09-01' 
group by province_eng , district_laos 

select distinct province_eng, district_eng , district_laos from mpwt_yothalist where province_eng = 'VIENTIANE CAPITAL'



select * from mpwt_yothalist my where province_eng = 'VIENTIANE CAPITAL'

select * from tblpaymentschedule t where prospect_id = 2074526;

select * from tblpayment t where contract_id = 80563 order by due_date ;

update tblpaymentschedule set payment_amount = 78, principal_amount = 0, interest_amount = 78, covid_interest = 0, covid_interest_amount = 0
where contract_id = 80563 and payment_date in ('2021-05-05');

update tblpaymentschedule set payment_amount = 75, principal_amount = 0, interest_amount = 75, covid_interest = 0, covid_interest_amount = 0
where contract_id = 80563 and payment_date in ('2021-06-05','2021-07-05','2021-08-05');

update tblpaymentschedule set payment_amount = 2575, principal_amount = 2500, interest_amount = 75, covid_interest = 0, covid_interest_amount = 0
where contract_id = 80563 and payment_date in ('2021-09-05');

delete from tblpaymentschedule where contract_id = 80563 and payment_date = '2021-10-05';

update tblpayment set amount = 0, paid_amount = 0, covid_interest = 0, covid_interest_amount = 0
where contract_id = 80563 and due_date in ('2021-05-05','2021-06-05','2021-07-05','2021-08-05') and `type` = 'principal';

update tblpayment set amount = 2500, covid_interest = 0, covid_interest_amount = 0
where contract_id = 80563 and due_date in ('2021-09-05') and `type` = 'principal';

delete from tblpayment where contract_id = 80563 and due_date = '2021-10-05';



select * from tblpaymentschedule ps left join tblpayment pt on (ps.id = pt.schedule_id)
where ps.prospect_id = 2070529 and pt.`type` = 'interest'



CREATE TABLE `contact_for_202111` (
  `id` int DEFAULT NULL,
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
  `remark_1` varchar(255) DEFAULT NULL,
  `remark_2` varchar(255) DEFAULT NULL,
  `remark_3` varchar(255) DEFAULT NULL,
  `branch_name` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3;
ALTER TABLE contact_for_202111 CONVERT TO CHARACTER SET utf8mb4;
alter table contact_for_202111 add `staff_id` varchar(255) DEFAULT null;
RENAME TABLE ringi_asset_prospect_for_202111 TO contact_for_202111_ringi_asset_prospect;


delete from contact_for_202111 where `type` = 'prospect'

select count(*) from  contact_for_202111 where `type` = 'prospect'

select * from contact_for_202111 cf 
where CONCAT(LENGTH(contact_no), left(contact_no, 5)) not in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290209');

delete from contact_for_202111
where CONCAT(LENGTH(contact_no), left(contact_no, 5)) not in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290209');

select * from contact_for_202111 where `type` in ('11Ringi_not_contract','12Asset_not_contract') -- remark_3 in ('S','A','B','C')

delete from contact_for_202111 where id in (
select id from ( 
		select id, `type`, `remark_1`, row_number() over (partition by contact_no order by FIELD(`type` , "11Ringi_not_contract", "12Asset_not_contract", "prospect"), id) as row_numbers  
		from contact_for_202111
		) as t1
	where row_numbers > 1 )

#========== Check and update branch_name ========
select * , case when province_eng = 'ATTAPUE' then 'Attapue'
		when province_eng = 'BORKEO' then 'Luangprabang'
		when province_eng = 'BORLIKHAMXAY' then 'Paksan'
		when province_eng = 'CHAMPASACK' then 'Pakse'
		when province_eng = 'HUAPHAN' then 'Houaphan'
		when province_eng = 'KHAMMOUAN' then 'Thakek'
		when province_eng = 'LUANG PRABANG' then 'Luangprabang'
		when province_eng = 'LUANGNAMTHA' then 'LuangNamtha'
		when province_eng = 'OUDOMXAY' then 'Oudomxay'
		when province_eng = 'PHONGSALY' then 'Oudomxay'
		when province_eng = 'SALAVANH' then 'Salavan'
		when province_eng = 'SAVANNAKHET' then 'Savannakhet'
		when province_eng = 'VIENTIANE CAPITAL' then 'Head office'
		when province_eng = 'VIENTIANE PROVINCE' then 'VTP-Vangvieng'
		when province_eng = 'XAYABOULY' then 'Sainyabuli'
		when province_eng = 'XAYSOMBOUN' then 'Xiengkhouang'
		when province_eng = 'XEKONG' then 'Attapue'
		when province_eng = 'XIENGKHUANG' then 'Xiengkhouang'
		else null 
	end `branch_name`
from contact_for_202111 cf 
where `type` = 'prospect' and remark_3 not in ('S','A','B','C')

-- update branch_name 
update contact_for_202111 
set branch_name = 
	case when province_eng = 'ATTAPUE' then 'Attapue'
		when province_eng = 'BORKEO' then 'Luangprabang'
		when province_eng = 'BORLIKHAMXAY' then 'Paksan'
		when province_eng = 'CHAMPASACK' then 'Pakse'
		when province_eng = 'HUAPHAN' then 'Houaphan'
		when province_eng = 'KHAMMOUAN' then 'Thakek'
		when province_eng = 'LUANG PRABANG' then 'Luangprabang'
		when province_eng = 'LUANGNAMTHA' then 'LuangNamtha'
		when province_eng = 'OUDOMXAY' then 'Oudomxay'
		when province_eng = 'PHONGSALY' then 'Oudomxay'
		when province_eng = 'SALAVANH' then 'Salavan'
		when province_eng = 'SAVANNAKHET' then 'Savannakhet'
		when province_eng = 'VIENTIANE CAPITAL' then 'Head office'
		when province_eng = 'VIENTIANE PROVINCE' then 'VTP-Vangvieng'
		when province_eng = 'XAYABOULY' then 'Sainyabuli'
		when province_eng = 'XAYSOMBOUN' then 'Xiengkhouang'
		when province_eng = 'XEKONG' then 'Attapue'
		when province_eng = 'XIENGKHUANG' then 'Xiengkhouang'
		else null 
	end
where `type` = 'prospect' and remark_3 not in ('S','A','B','C');

insert into test.contact_for_202111
select * from contact_data_db.contact_for_202111_2 ;

CREATE TABLE `add_staff_id` (
  `id` int DEFAULT NULL,
  `contact_no` varchar(255) NOT NULL,
  `staff_id` varchar(255) DEFAULT null
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3;

select id, contact_no, staff_id from contact_for_202111_ringi_asset_prospect where contact_no in (select contact_no from add_staff_id);

#=========== Check and export data from contact_numbers_to_lcc to contact_for_202111 =========
-- 1
create table temp_area_marketing (
	`id` int NOT NULL AUTO_INCREMENT,
	`file_id` int DEFAULT null,
   PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb3;

#==============  insert data from contact_numbers_to_lcc to contact_for_202111 =================
insert into contact_for_202111_report (`id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`,`branch_name`,`status`)
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`,`branch_name`,`status`
from contact_data_db.contact_numbers_to_lcc cntl 
where branch_name = 'VTP-Vangvieng' and `type` in ()

select count(*) from contact_for_202111_report cfr where branch_name = 'Head office' and id not in (select id from contact_for_202111 cf)

update contact_for_202111 set village = null where village = '';


insert into temp_area_marketing (`id`)
select id from contact_for_202111 where branch_name = 'Head office';

delete from temp_area_marketing 

select * from contact_for_202111 cf where branch_name = 'Head office' and id not in (select id from temp_area_marketing );

select * from contact_numbers_to_lcc cntl where branch_name = 'Head office' and id not in (select id from contact_for_202111 cf) limit 100000;

-- create table lalco_customer
create table lalco_customer (
	`id` int NOT NULL AUTO_INCREMENT,
	`contact_no` varchar(255) NOT NULL,
	`status` varchar(255) DEFAULT NULL,
   PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=0 DEFAULT CHARSET=utf8mb3;

-- check 
select branch_name , `type` , count(*) from contact_for_202111_ringi_asset_prospect cfrap group by branch_name , `type` 

select id, contact_no, branch_name, staff_id from contact_for_202111_ringi_asset_prospect
where contact_no in (select contact_no from test.add_staff_id asi )


#=============== Learning my first CRUD Operations in PHP MySQL with Bootstrap =============
-- create database 
CREATE DATABASE my_db;

-- create table
CREATE TABLE `customers` (
`custId` INT(11) NOT NULL AUTO_INCREMENT,
`fname` VARCHAR(255) NULL DEFAULT NULL,
`lname` VARCHAR(255) NULL DEFAULT NULL,
`email` VARCHAR(255) NULL DEFAULT NULL,
`created` DATETIME NULL DEFAULT NULL,
PRIMARY KEY (`custId`)
) COLLATE='latin1_swedish_ci' ENGINE=InnoDB AUTO_INCREMENT=1;

-- insert data into my table
INSERT INTO `customers` (`custId`, `fname`, `lname`, `email`, `created`) 
VALUES (NULL, 'Tiago', 'Sam', 'dornelas@studio8k.com', NULL), 
	(NULL, 'Anil', 'Kumar', 'ca.anil.kumar@gmail.com', NULL);
# ============ End =============

select province_eng, count(*) from contact_numbers_to_lcc cntl group by province_eng order by province_eng ;
select distinct province_eng  from contact_numbers_to_lcc ;

select province_laos, count(*) from contact_numbers_to_lcc cntl where province_eng is null and province_laos != '' group by province_laos ;

select count(*) from contact_numbers_to_lcc cntl where province_eng is null and province_laos != '';

select province_eng, count(*) from contact_numbers_to_lcc cntl group by province_eng;

-- check data by temp_update_address
select count(*) from contact_numbers_to_lcc cntl where id in (select id from temp_update_address ); -- 13562

-- update data by temp_update_address 
update contact_numbers_to_lcc cl inner join temp_update_address ta on (cl.id = ta.id)
set cl.province_eng = ta.province_eng , cl.district_eng = ta.district_eng , cl.village = ta.village 
where cl.id = ta.id;

select count(*), 15758317 + 254 from contact_numbers_to_lcc where village != ''; -- empty = 15758317 -- have village = 1012036, is null = 254
update contact_numbers_to_lcc set village = null where village = '' limit 2000000;

update tblcontract c left join tblprospect p on (p.id = c.prospect_id)
set p.first_payment_date = DATE_ADD(p.initial_date , INTERVAL 1 DAY)
WHERE c.status in (4,6,7) and p.contract_type = 5  and p.first_payment_date != DATE_ADD(p.initial_date , INTERVAL 1 DAY);

#============= Yoshi request to check the data have address and car for area marketing ============ 
select province_eng , `type` , count(*),
	count( case when province_eng != '' and district_eng != '' and village != '' then 1 end ) 'have_address(pdv)',
	count( case when maker != '' or model != '' then 1 end ) 'have_automobile',
	count( case when province_eng != '' and district_eng != '' and village != '' 
		and (maker != '' or model != '')
	then 1 end ) 'have_address_&_automobile'
from contact_for_202112_contact cfc 
-- where province_eng = 'VIENTIANE CAPITAL' and id in (select id from temp_update_address ) -- for HQ and match real village
-- where province_eng = 'VIENTIANE CAPITAL' and id not in (select id from temp_update_address ) -- for HQ not match real village
-- where province_eng is not null and province_eng != 'VIENTIANE CAPITAL' -- for branch
group by province_eng , `type` 

select count(*) from contact_for_202112_prospect cfp 
where province_eng != '' and district_eng != '' and village != ''; -- contact = 41250, prospect = 442148

select distinct province_eng from contact_numbers_to_lcc where province_eng is not null and province_eng != 'VIENTIANE CAPITAL';

select count(*) from contact_numbers_to_lcc where province_eng is null ; -- 9894528
select count(*) from contact_numbers_to_lcc cntl ; -- 16770607
select count(*) from contact_numbers_to_lcc cntl where maker = ''; -- 15859809
select count(*) from contact_numbers_to_lcc cntl where maker is null; -- 276
select count(*) from contact_numbers_to_lcc cntl where maker != ''; -- 910522

select 15758317 + 1012036 + 254, 15758317 + 254 , 16770607;

#=========== Prepare contact for Dec 2021 ===============
-- 1) table prospect 
CREATE TABLE `contact_for_202112_lcc` (
  `id` int NOT NULL AUTO_INCREMENT,
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
  `remark_1` varchar(255) DEFAULT NULL,
  `remark_2` varchar(255) DEFAULT NULL,
  `remark_3` varchar(255) DEFAULT NULL,
  `branch_name` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `staff_id` varchar(255) DEFAULT NULL,
  `pvd_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3;
ALTER TABLE contact_for_202112_prospect CONVERT TO CHARACTER SET utf8mb4;

-- 2) contact numbers
select count(*) 
from contact_numbers_to_lcc cntl left join temp_update_address tua on (cntl.id = tua.id)
where cntl.province_eng != 'VIENTIANE CAPITAL' and cntl.province_eng != '' and cntl.district_eng != '' and cntl.village != '' -- BR = 836239 , HQ = 22482
	and contact_no not in (select contact_no from contact_for_202112_prospect cfp); -- contact not in prospect HO = 828811, -- HQ = 18144

-- insert from contact_numbers_to_lcc to contact_for_202112_contact
insert into contact_for_202112_contact 
select cntl.id,`contact_no`,`name`,cntl.province_eng,`province_laos`,cntl.district_eng,`district_laos`,cntl.`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`,`branch_name`,`status`, null `staff_id`,tua.village_id `pvd_id`
from contact_numbers_to_lcc cntl left join temp_update_address tua on (cntl.id = tua.id)
-- where cntl.province_eng = 'VIENTIANE CAPITAL' and cntl.province_eng != '' and cntl.district_eng != '' and cntl.village != '' -- BR = 836239 , HQ = 22482
-- 	and contact_no not in (select contact_no from contact_for_202112_prospect cfp); -- contact not in prospect BR = 828811, -- HQ = 18144
where cntl.id in (select id from temp_update_any tua); -- new data from signboard_project sp 

select count(*) from contact_for_202112_contact cfc ; -- 846955
select 18144 + 397792 'HO', 828811 + 83737 'BR';

-- 3) Export data 
select distinct district_eng from contact_for_202112_contact cfc where province_eng = 'VIENTIANE CAPITAL'

#========== create table for signboard_project and village_master_project ============
CREATE TABLE `village_master_project` (
  `id` int NOT NULL AUTO_INCREMENT,
  `timestamp` datetime DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL, 
  `tel1` varchar(255) DEFAULT NULL,
  `tel2` varchar(255) DEFAULT NULL,
  `province` varchar(255) DEFAULT NULL,
  `district` varchar(255) DEFAULT NULL,
  `village` varchar(255) DEFAULT NULL,
  `contact_no` varchar(255) DEFAULT NULL,
  `province_eng` varchar(255) DEFAULT NULL,
  `district_eng` varchar(50) DEFAULT NULL,
  `village_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb3;

-- delete charer from contact_no 
SELECT REGEXP_REPLACE('deddf2484521584sda,.;eds2', '[^[:digit:]]', '') "REGEXP_REPLACE";
select * , regexp_replace(tel1 , '[^[:digit:]]', '') ,	length (regexp_replace(tel1 , '[^[:digit:]]', '')),
	case when (length (regexp_replace(tel1 , '[^[:digit:]]', '')) = 9 and left (regexp_replace(tel1 , '[^[:digit:]]', ''),3) = '021')
			or (length (regexp_replace(tel1 , '[^[:digit:]]', '')) = 8 and left (regexp_replace(tel1 , '[^[:digit:]]', ''),2) = '21' )
			or (length (regexp_replace(tel1 , '[^[:digit:]]', '')) = 6)
		then concat('9021',right(regexp_replace(tel1 , '[^[:digit:]]', ''),6)) -- for 021
		when (length (regexp_replace(tel1 , '[^[:digit:]]', '')) = 11 and left (regexp_replace(tel1 , '[^[:digit:]]', ''),3) = '020')
			or (length (regexp_replace(tel1 , '[^[:digit:]]', '')) = 10 and left (regexp_replace(tel1 , '[^[:digit:]]', ''),2) = '20')
			or (length (regexp_replace(tel1 , '[^[:digit:]]', '')) = 8 and left (regexp_replace(tel1 , '[^[:digit:]]', ''),1) in ('2','5','7','8','9'))
		then concat('9020',right(regexp_replace(tel1 , '[^[:digit:]]', ''),8)) -- for 020
		when (length (regexp_replace(tel1 , '[^[:digit:]]', '')) = 10 and left (regexp_replace(tel1 , '[^[:digit:]]', ''),3) = '030')
			or (length (regexp_replace(tel1 , '[^[:digit:]]', '')) = 9 and left (regexp_replace(tel1 , '[^[:digit:]]', ''),2) = '30')
			or (length (regexp_replace(tel1 , '[^[:digit:]]', '')) = 7 and left (regexp_replace(tel1 , '[^[:digit:]]', ''),1) in ('2','4','5','7','9'))
		then concat('9030',right(regexp_replace(tel1 , '[^[:digit:]]', ''),7)) -- for 090
		when left (right (regexp_replace(tel1 , '[^[:digit:]]', ''),8),1) in ('0','1','') then concat('9030',right(regexp_replace(tel1 , '[^[:digit:]]', ''),7))
		when left (right (regexp_replace(tel1 , '[^[:digit:]]', ''),8),1) in ('2','5','7','8','9')
		then concat('9020',right(regexp_replace(tel1 , '[^[:digit:]]', ''),8))
		else concat('9020',right(regexp_replace(tel1 , '[^[:digit:]]', ''),8))
	end 'new_contact_no'
from village_master_project vmp 

update signboard_project set contact_no = 
	case when (length (regexp_replace(tel1 , '[^[:digit:]]', '')) = 9 and left (regexp_replace(tel1 , '[^[:digit:]]', ''),3) = '021')
			or (length (regexp_replace(tel1 , '[^[:digit:]]', '')) = 8 and left (regexp_replace(tel1 , '[^[:digit:]]', ''),2) = '21' )
			or (length (regexp_replace(tel1 , '[^[:digit:]]', '')) = 6)
		then concat('9021',right(regexp_replace(tel1 , '[^[:digit:]]', ''),6)) -- for 021
		when (length (regexp_replace(tel1 , '[^[:digit:]]', '')) = 11 and left (regexp_replace(tel1 , '[^[:digit:]]', ''),3) = '020')
			or (length (regexp_replace(tel1 , '[^[:digit:]]', '')) = 10 and left (regexp_replace(tel1 , '[^[:digit:]]', ''),2) = '20')
			or (length (regexp_replace(tel1 , '[^[:digit:]]', '')) = 8 and left (regexp_replace(tel1 , '[^[:digit:]]', ''),1) in ('2','5','7','8','9'))
		then concat('9020',right(regexp_replace(tel1 , '[^[:digit:]]', ''),8)) -- for 020
		when (length (regexp_replace(tel1 , '[^[:digit:]]', '')) = 10 and left (regexp_replace(tel1 , '[^[:digit:]]', ''),3) = '030')
			or (length (regexp_replace(tel1 , '[^[:digit:]]', '')) = 9 and left (regexp_replace(tel1 , '[^[:digit:]]', ''),2) = '30')
			or (length (regexp_replace(tel1 , '[^[:digit:]]', '')) = 7 and left (regexp_replace(tel1 , '[^[:digit:]]', ''),1) in ('2','4','5','7','9'))
		then concat('9030',right(regexp_replace(tel1 , '[^[:digit:]]', ''),7)) -- for 090
		when left (right (regexp_replace(tel1 , '[^[:digit:]]', ''),8),1) in ('0','1','') then concat('9030',right(regexp_replace(tel1 , '[^[:digit:]]', ''),7))
		when left (right (regexp_replace(tel1 , '[^[:digit:]]', ''),8),1) in ('2','5','7','8','9')
		then concat('9020',right(regexp_replace(tel1 , '[^[:digit:]]', ''),8))
		else concat('9020',right(regexp_replace(tel1 , '[^[:digit:]]', ''),8))
	end;


-- 4) insert from signboard_project into contact_for_202112_signboard 
insert into contact_for_202112_village_master 
select `id`,`contact_no`,`name`,`province_eng`,null `province_laos`,`district_eng`,null `district_laos`,`village`,'signboard' `type`,null `maker`,null `model`,null `year`,null `remark_1`,null `remark_2`,null `remark_3`, 'Head office' `branch_name`, null `status`, null `staff_id`,village_id `pvd_id`
from village_master_project 
where contact_no not in (select contact_no from contact_for_202112_contact cfc) and id not in (select id from contact_for_202112_village_master)

select * from temp_update_any ;

-- 5) delete where contact numbers in contact_for_202112_signboard duplicate with contact_for_202112_prospect
select id, contact_no from contact_for_202112_village_master  where contact_no in (select contact_no from contact_for_202112_signboard cfs); -- 11288
delete from contact_for_202112_village_master  where id in (select id from temp_update_any );

-- 6) delete duplicate numbers in contact_for_202112_signboard
delete from contact_for_202112_village_master where id in (
select id from ( 
		select id, row_number() over (partition by contact_no order by  id) as row_numbers  
		from contact_for_202112_signboard  
		) as t1
	where row_numbers > 1);

-- 7) check invalid number 
select * from contact_for_202112_village_master 
where CONCAT(LENGTH(contact_no), left( contact_no, 5)) not in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290209')
	and CONCAT(LENGTH(contact_no), left( contact_no, 4)) not in ('109021')

-- 8) delete invalid numbers
delete from contact_for_202112_village_master
where CONCAT(LENGTH(contact_no), left( contact_no, 5)) not in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290209')
	and CONCAT(LENGTH(contact_no), left( contact_no, 4)) not in ('109021')

-- 9) check 
select count(*) from contact_for_202112_contact cfc ; -- 66,271
select count(*) from contact_for_202112_prospect cfp ; -- 481,529
select count(*) from contact_for_202112_signboard cfs ; -- 27,632
select count(*) from contact_for_202112_village_master cfvm ; -- 14,651

-- 10) contact_for_202112_lcc
select province_eng, `type`, count(*) from contact_for_202112_lcc cfl group by province_eng , `type` ;

insert into contact_for_202112_lcc (`id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`,`branch_name`,`status`)
;select count(*) 
-- `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`,`branch_name`,`status`
from contact_numbers_to_lcc cntl 
where `type` = '②Need loan' and id not in (select id from contact_for_202112_contact ) and province_eng != ''

insert into temp_update_any 
select id, contact_no from contact_for_202112_lcc cfl where contact_no in (select contact_no from contact_for_202112_village_master);

delete from contact_for_202112_lcc where id in (select id from temp_update_any);

delete from temp_update_any ;

-- 11) export to create campaign on LCC
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202112_lcc
where `type` = '②Need loan' and province_eng = 'PHONGSALY' ;

#======== check and udate first payment date in tblpaymentschedule and tblpayment
SELECT c.contract_no , c.id,
	/*p.initial_date , c.contract_date , p.initial_date = c.contract_date 'check_contract_date',*/
	p.first_payment_date ,  DATE_ADD(p.initial_date , INTERVAL 1 DAY) 'real_1ns_payment_date', A.payment_date, pm.due_date ,
	p.first_payment_date = A.payment_date 'check_1st_payent_date',
	p.first_payment_date - A.payment_date 'update_key'
FROM tblcontract c
LEFT JOIN tblprospect p ON (p.id = c.prospect_id)
LEFT JOIN tblpaymentschedule A ON A.id = (select id from tblpaymentschedule where contract_id=c.id order by payment_date limit 1)
LEFT JOIN tblpayment pm ON pm.id = (select id from tblpayment where contract_id=c.id order by due_date limit 1)
WHERE c.status in (4,6,7) and p.contract_type = 5 
	and p.first_payment_date != pm.due_date

select ps.prospect_id , ps.contract_id, ps.payment_date , pm.due_date , 
DATE_ADD(ps.payment_date , INTERVAL - 1 DAY) 'new_payment_date', DATE_ADD(pm.due_date , INTERVAL - 1 DAY) 'new_due_date'
from tblpaymentschedule ps left join tblpayment pm on (ps.id = pm.schedule_id)
where ps.prospect_id in (1117,1052,1199,1300,1203,1271) --  ps.payment_date =  ps.payment_date - 1, pm.due_date = pm.due_date - 1

select ps.prospect_id , ps.contract_id, ps.payment_date , pm.due_date, 
DATE_ADD(ps.payment_date , INTERVAL - 2 DAY) 'new_payment_date', DATE_ADD(pm.due_date , INTERVAL - 2 DAY) 'new_due_date'
from tblpaymentschedule ps left join tblpayment pm on (ps.id = pm.schedule_id)
where ps.prospect_id in (1296) --  ps.payment_date =  ps.payment_date - 2, pm.due_date = pm.due_date - 2

select ps.prospect_id , ps.contract_id, ps.payment_date , pm.due_date , 
DATE_ADD(ps.payment_date , INTERVAL + 1 DAY) 'new_payment_date', DATE_ADD(pm.due_date , INTERVAL + 1 DAY) 'new_due_date'
from tblpaymentschedule ps left join tblpayment pm on (ps.id = pm.schedule_id)
where ps.prospect_id in (1792) --  ps.payment_date =  ps.payment_date + 1, pm.due_date = pm.due_date + 1

update tblpaymentschedule ps left join tblpayment pm on (ps.id = pm.schedule_id)
set ps.payment_date = DATE_ADD(ps.payment_date , INTERVAL - 1 DAY) , pm.due_date = DATE_ADD(pm.due_date , INTERVAL - 1 DAY)
where ps.prospect_id in (1117,1052,1199,1300,1203,1271)

update tblpaymentschedule ps left join tblpayment pm on (ps.id = pm.schedule_id)
set ps.payment_date = DATE_ADD(ps.payment_date , INTERVAL - 2 DAY) , pm.due_date = DATE_ADD(pm.due_date , INTERVAL - 2 DAY)
where ps.prospect_id in (1296)

update tblpaymentschedule ps left join tblpayment pm on (ps.id = pm.schedule_id)
set ps.payment_date = DATE_ADD(ps.payment_date , INTERVAL + 1 DAY) , pm.due_date = DATE_ADD(pm.due_date , INTERVAL + 1 DAY)
where ps.prospect_id in (1792)



-- check before and after update data
SELECT p.id, p.contract_type , p.loan_amount, SUM(ps.principal_amount),p.loan_amount = SUM(ps.principal_amount) ,
	p.no_of_payment , count(*) , p.no_of_payment = count(*)
from tblprospect p left join tblpaymentschedule ps on (p.id = ps.prospect_id)
where p.id in (2007013,2044246,2049515,2049540,2051492,2052176,2053045,2054382,2055661,2056629,2057388,2058960,2060971,2061461,2062244,2062141,2062578,2052926,2062349,2063292,2064193,2064327,2064964,2065307,2065316,2065785,2061717,2066141,2066150,2066102,2066306,2066555,2066728,2065882,2067420,2067448,2067496,2067538,2067537,2067819,2067873,2068001,2068486,2068568,2068654,2068808,2068874,2068880,2068965,2069072,2068920,2069339,2069711,2069854,2069735,2070152,2070056,2070154,2070295,2070290,2070434,2070192,2070602,2070926,2070920,2070780,2070714,2071127,2071181,2071128,2071166,2071139,2071268,2071271,2071194,2066619,2071343,2071561,2071936,2071956,2072143,2072248,2072200,2072217,2072336,2072383,2072346,2072457,2072552,2072609,2072660,2072878,2072902,2072991,2072819,2073041,2073038,2073276,2069450,2073535,2073643,2073564,2073665,2073474,2073713,2073722,2073691,2073687,2073637,2072521,2073800,2073955,2074163,2074249,2074323,2074367,2074438,2074589,2074760,2074754,2074872,2075024,2075359,2075461,2075344,2075581,2075644,2075778,2075782,2075845,2075772,2075689,2071294,2075900,2075916,2075945,2075677,2075906,2075982,2076003,2076128,2072117,2076145,2075166,2076449,2076427,2076416,2076484,2076510,2076580,2076606,2076598,2076591,2076560,2076745,2076358,2071390,2076962,2076981,2077011,2077099,2077102,2077048,2077131,2077146,2077236,2077107,2077243,2077344,2077391,2077061,2077342,2077333,2077426,2077514,2077557,2077594,2077708,2077736,2077892,2078076,2078091,2078133,2078177,2078287
) 
group by p.id;

select * 
from tblpaymentschedule ps right join tblpayment pm on (ps.id = pm.schedule_id)
where ps.prospect_id = 2007013 -- and pm.`type` != 'penalty';

select * from tblpaymentschedule t where contract_id = 7014;
select * from tblpayment t where contract_id = 7014 order by due_date ;

-- match_contract_id
select prospect_id, id, contract_no from tblcontract where prospect_id in (2007013,2044246,2049515,2049540,2051492,2052176,2052926,2053045,2054382,2055661,2056629,2057388,2058960,2060971,2061461,2061717,2062141,2062244,2062349,2062578,2063292,2064193,2064327,2064964,2065307,2065316,2065785,2065882,2066102,2066141,2066150,2066306,2066555,2066619,2066728,2067420,2067448,2067496,2067537,2067538,2067819,2067873,2068001,2068486,2068568,2068654,2068808,2068874,2068880,2068920,2068965,2069072,2069339,2069450,2069711,2069735,2069854,2070056,2070152,2070154,2070192,2070290,2070295,2070434,2070602,2070714,2070780,2070920,2070926,2071127,2071128,2071139,2071166,2071181,2071194,2071268,2071271,2071294,2071343,2071390,2071561,2071936,2071956,2072117,2072143,2072200,2072217,2072248,2072336,2072346,2072383,2072457,2072521,2072552,2072609,2072660,2072819,2072878,2072902,2072991,2073038,2073041,2073276,2073474,2073535,2073564,2073637,2073643,2073665,2073687,2073691,2073713,2073722,2073800,2073955,2074163,2074249,2074323,2074367,2074438,2074589,2074754,2074760,2074872,2075024,2075166,2075344,2075359,2075461,2075581,2075644,2075677,2075689,2075772,2075778,2075782,2075845,2075900,2075906,2075916,2075945,2075982,2076003,2076128,2076145,2076358,2076416,2076427,2076449,2076484,2076510,2076560,2076580,2076591,2076598,2076606,2076745,2076962,2076981,2077011,2077048,2077061,2077099,2077102,2077107,2077131,2077146,2077236,2077243,2077333,2077342,2077344,2077391,2077426,2077514,2077557,2077594,2077708,2077736,2077892,2078076,2078091,2078133,2078177,2078287
)

-- 1) delete the data in tblpaymentschedule
delete from tblpaymentschedule where contract_id in (7014,44817,51166,51220,53533,54584,67519,55581,58116,58822,60214,60838,62740,65132,65914,70643,66746,66671,67600,67214,67803,68844,69017,69617,69986,70117,70593,71822,70971,70925,70946,71258,71497,77035,71660,72523,72533,72560,72697,72608,72929,72958,73271,73696,73868,73937,74100,74195,74221,74438,74323,74405,75147,78994,75155,75299,75228,75670,75654,75768,75984,75853,75811,75967,76171,76510,76501,76494,76439,76705,76829,76864,76835,76790,77019,76974,76978,81987,77123,83094,77221,77600,77632,82266,77773,77881,77944,77826,78005,78158,78054,78185,79718,78267,78331,78371,78783,78602,78675,78686,78879,78790,78986,79478,79280,79399,79688,79349,79423,79560,79536,79511,79527,79880,79973,80001,80147,80198,80264,80325,80398,80771,80690,80810,81029,82435,81587,81338,81436,81616,81666,82047,81962,81900,81795,81864,81889,82024,82051,82027,82038,82126,82154,82245,82330,82997,82605,82546,82536,82612,82682,82885,82714,82866,82833,82811,82941,83218,83260,83262,83374,83651,83353,83365,83517,83392,83398,83459,83547,83680,83658,83609,83642,83788,83817,83819,83831,83946,83980,84113,84314,84345,84346,84444,84541
)

-- 2) delete the data in tblpayment
delete from tblpayment where contract_id in (7014,44817,51166,51220,53533,54584,67519,55581,58116,58822,60214,60838,62740,65132,65914,70643,66746,66671,67600,67214,67803,68844,69017,69617,69986,70117,70593,71822,70971,70925,70946,71258,71497,77035,71660,72523,72533,72560,72697,72608,72929,72958,73271,73696,73868,73937,74100,74195,74221,74438,74323,74405,75147,78994,75155,75299,75228,75670,75654,75768,75984,75853,75811,75967,76171,76510,76501,76494,76439,76705,76829,76864,76835,76790,77019,76974,76978,81987,77123,83094,77221,77600,77632,82266,77773,77881,77944,77826,78005,78158,78054,78185,79718,78267,78331,78371,78783,78602,78675,78686,78879,78790,78986,79478,79280,79399,79688,79349,79423,79560,79536,79511,79527,79880,79973,80001,80147,80198,80264,80325,80398,80771,80690,80810,81029,82435,81587,81338,81436,81616,81666,82047,81962,81900,81795,81864,81889,82024,82051,82027,82038,82126,82154,82245,82330,82997,82605,82546,82536,82612,82682,82885,82714,82866,82833,82811,82941,83218,83260,83262,83374,83651,83353,83365,83517,83392,83398,83459,83547,83680,83658,83609,83642,83788,83817,83819,83831,83946,83980,84113,84314,84345,84346,84444,84541
)

-- 3 insert new data of 185 contracts to tblpaymentschedule
insert into tblpaymentschedule (id,prospect_id,contract_id,payment_date,payment_amount,principal_amount,interest_amount,status,penalty_status,covid_interest)
select id,prospect_id,contract_id,payment_date,payment_amount,principal_amount,interest_amount,status,penalty_status,0
from tblpaymentschedule_20210917 
where contract_id in (7014,44817,51166,51220,53533,54584,67519,55581,58116,58822,60214,60838,62740,65132,65914,70643,66746,66671,67600,67214,67803,68844,69017,69617,69986,70117,70593,71822,70971,70925,70946,71258,71497,77035,71660,72523,72533,72560,72697,72608,72929,72958,73271,73696,73868,73937,74100,74195,74221,74438,74323,74405,75147,78994,75155,75299,75228,75670,75654,75768,75984,75853,75811,75967,76171,76510,76501,76494,76439,76705,76829,76864,76835,76790,77019,76974,76978,81987,77123,83094,77221,77600,77632,82266,77773,77881,77944,77826,78005,78158,78054,78185,79718,78267,78331,78371,78783,78602,78675,78686,78879,78790,78986,79478,79280,79399,79688,79349,79423,79560,79536,79511,79527,79880,79973,80001,80147,80198,80264,80325,80398,80771,80690,80810,81029,82435,81587,81338,81436,81616,81666,82047,81962,81900,81795,81864,81889,82024,82051,82027,82038,82126,82154,82245,82330,82997,82605,82546,82536,82612,82682,82885,82714,82866,82833,82811,82941,83218,83260,83262,83374,83651,83353,83365,83517,83392,83398,83459,83547,83680,83658,83609,83642,83788,83817,83819,83831,83946,83980,84113,84314,84345,84346,84444,84541
)

-- 4 insert new data of 185 contracts to tblpayment 
insert into tblpayment (id,schedule_id,contract_id,due_date,amount,`type`,paid_amount,void_amount,refinance_amount,void_reason,status,collection_id,void_id,automated,covid_interest)
select id,schedule_id,contract_id,due_date,amount,`type`,paid_amount,void_amount,refinance_amount,void_reason,status,collection_id,void_id,automated,0
from tblpayment_20210917 
where contract_id in (7014,44817,51166,51220,53533,54584,67519,55581,58116,58822,60214,60838,62740,65132,65914,70643,66746,66671,67600,67214,67803,68844,69017,69617,69986,70117,70593,71822,70971,70925,70946,71258,71497,77035,71660,72523,72533,72560,72697,72608,72929,72958,73271,73696,73868,73937,74100,74195,74221,74438,74323,74405,75147,78994,75155,75299,75228,75670,75654,75768,75984,75853,75811,75967,76171,76510,76501,76494,76439,76705,76829,76864,76835,76790,77019,76974,76978,81987,77123,83094,77221,77600,77632,82266,77773,77881,77944,77826,78005,78158,78054,78185,79718,78267,78331,78371,78783,78602,78675,78686,78879,78790,78986,79478,79280,79399,79688,79349,79423,79560,79536,79511,79527,79880,79973,80001,80147,80198,80264,80325,80398,80771,80690,80810,81029,82435,81587,81338,81436,81616,81666,82047,81962,81900,81795,81864,81889,82024,82051,82027,82038,82126,82154,82245,82330,82997,82605,82546,82536,82612,82682,82885,82714,82866,82833,82811,82941,83218,83260,83262,83374,83651,83353,83365,83517,83392,83398,83459,83547,83680,83658,83609,83642,83788,83817,83819,83831,83946,83980,84113,84314,84345,84346,84444,84541
)

-- 5) update no_of_payment in tblprospect
update tblprospect p left join 
(select prospect_id, count(*) `time` from tblpaymentschedule_20210917 t group by prospect_id) t
on (p.id = t.prospect_id)
set p.no_of_payment = t.`time` 
where p.id in (2007013,2044246,2049515,2049540,2051492,2052176,2053045,2054382,2055661,2056629,2057388,2058960,2060971,2061461,2062244,2062141,2062578,2052926,2062349,2063292,2064193,2064327,2064964,2065307,2065316,2065785,2061717,2066141,2066150,2066102,2066306,2066555,2066728,2065882,2067420,2067448,2067496,2067538,2067537,2067819,2067873,2068001,2068486,2068568,2068654,2068808,2068874,2068880,2068965,2069072,2068920,2069339,2069711,2069854,2069735,2070152,2070056,2070154,2070295,2070290,2070434,2070192,2070602,2070926,2070920,2070780,2070714,2071127,2071181,2071128,2071166,2071139,2071268,2071271,2071194,2066619,2071343,2071561,2071936,2071956,2072143,2072248,2072200,2072217,2072336,2072383,2072346,2072457,2072552,2072609,2072660,2072878,2072902,2072991,2072819,2073041,2073038,2073276,2069450,2073535,2073643,2073564,2073665,2073474,2073713,2073722,2073691,2073687,2073637,2072521,2073800,2073955,2074163,2074249,2074323,2074367,2074438,2074589,2074760,2074754,2074872,2075024,2075359,2075461,2075344,2075581,2075644,2075778,2075782,2075845,2075772,2075689,2071294,2075900,2075916,2075945,2075677,2075906,2075982,2076003,2076128,2072117,2076145,2075166,2076449,2076427,2076416,2076484,2076510,2076580,2076606,2076598,2076591,2076560,2076745,2076358,2071390,2076962,2076981,2077011,2077099,2077102,2077048,2077131,2077146,2077236,2077107,2077243,2077344,2077391,2077061,2077342,2077333,2077426,2077514,2077557,2077594,2077708,2077736,2077892,2078076,2078091,2078133,2078177,2078287
) 

-- 6) check last payment_date in tblprospect
select p.id, p.last_payment_date , ps.payment_date, DATE_ADD(p.first_payment_date , INTERVAL p.no_of_payment - 1 MONTH) 'new_1st+no_of_payment-1', 
	p.last_payment_date = DATE_ADD(p.first_payment_date , INTERVAL p.no_of_payment - 1 MONTH) 'check_new_with_p', 
	ps.payment_date = DATE_ADD(p.first_payment_date , INTERVAL p.no_of_payment - 1 MONTH) 'check_new_with_ps', 
	TIMESTAMPDIFF(MONTH, p.last_payment_date , ps.payment_date) 'different'
from tblcontract c
left join tblprospect p on (p.id = c.prospect_id)
left join tblpaymentschedule ps on ps.id = (select id from tblpaymentschedule where contract_id = c.id order by payment_date desc limit 1)
where p.id in (2007013,2044246,2049515,2049540,2051492,2052176,2053045,2054382,2055661,2056629,2057388,2058960,2060971,2061461,2062244,2062141,2062578,2052926,2062349,2063292,2064193,2064327,2064964,2065307,2065316,2065785,2061717,2066141,2066150,2066102,2066306,2066555,2066728,2065882,2067420,2067448,2067496,2067538,2067537,2067819,2067873,2068001,2068486,2068568,2068654,2068808,2068874,2068880,2068965,2069072,2068920,2069339,2069711,2069854,2069735,2070152,2070056,2070154,2070295,2070290,2070434,2070192,2070602,2070926,2070920,2070780,2070714,2071127,2071181,2071128,2071166,2071139,2071268,2071271,2071194,2066619,2071343,2071561,2071936,2071956,2072143,2072248,2072200,2072217,2072336,2072383,2072346,2072457,2072552,2072609,2072660,2072878,2072902,2072991,2072819,2073041,2073038,2073276,2069450,2073535,2073643,2073564,2073665,2073474,2073713,2073722,2073691,2073687,2073637,2072521,2073800,2073955,2074163,2074249,2074323,2074367,2074438,2074589,2074760,2074754,2074872,2075024,2075359,2075461,2075344,2075581,2075644,2075778,2075782,2075845,2075772,2075689,2071294,2075900,2075916,2075945,2075677,2075906,2075982,2076003,2076128,2072117,2076145,2075166,2076449,2076427,2076416,2076484,2076510,2076580,2076606,2076598,2076591,2076560,2076745,2076358,2071390,2076962,2076981,2077011,2077099,2077102,2077048,2077131,2077146,2077236,2077107,2077243,2077344,2077391,2077061,2077342,2077333,2077426,2077514,2077557,2077594,2077708,2077736,2077892,2078076,2078091,2078133,2078177,2078287
) 

-- 7) update last payment_date in tblprospect
update tblprospect set last_payment_date = DATE_ADD(first_payment_date , INTERVAL no_of_payment - 1 MONTH)
where id in (2007013,2044246,2049515,2049540,2051492,2052176,2053045,2054382,2055661,2056629,2057388,2058960,2060971,2061461,2062244,2062141,2062578,2052926,2062349,2063292,2064193,2064327,2064964,2065307,2065316,2065785,2061717,2066141,2066150,2066102,2066306,2066555,2066728,2065882,2067420,2067448,2067496,2067538,2067537,2067819,2067873,2068001,2068486,2068568,2068654,2068808,2068874,2068880,2068965,2069072,2068920,2069339,2069711,2069854,2069735,2070152,2070056,2070154,2070295,2070290,2070434,2070192,2070602,2070926,2070920,2070780,2070714,2071127,2071181,2071128,2071166,2071139,2071268,2071271,2071194,2066619,2071343,2071561,2071936,2071956,2072143,2072248,2072200,2072217,2072336,2072383,2072346,2072457,2072552,2072609,2072660,2072878,2072902,2072991,2072819,2073041,2073038,2073276,2069450,2073535,2073643,2073564,2073665,2073474,2073713,2073722,2073691,2073687,2073637,2072521,2073800,2073955,2074163,2074249,2074323,2074367,2074438,2074589,2074760,2074754,2074872,2075024,2075359,2075461,2075344,2075581,2075644,2075778,2075782,2075845,2075772,2075689,2071294,2075900,2075916,2075945,2075677,2075906,2075982,2076003,2076128,2072117,2076145,2075166,2076449,2076427,2076416,2076484,2076510,2076580,2076606,2076598,2076591,2076560,2076745,2076358,2071390,2076962,2076981,2077011,2077099,2077102,2077048,2077131,2077146,2077236,2077107,2077243,2077344,2077391,2077061,2077342,2077333,2077426,2077514,2077557,2077594,2077708,2077736,2077892,2078076,2078091,2078133,2078177,2078287
) 

select * from tblpaymentschedule_20210917 t where prospect_id in (2063894, 2070926, 2074526, 2074754)

#======= test datatable ===========
create database demos;

CREATE TABLE `users` (
 `id` int(11) NOT NULL AUTO_INCREMENT,
 `name` varchar(25) COLLATE utf8_unicode_ci NOT NULL,
 `email` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
 `created_at` datetime NOT NULL,
 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


create database datatable_example;

#=========== database and table for datatables-add-edit-delete-ajax-php-mysql-demo ===============
create database webdamn_demo;

CREATE TABLE `employee` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `skills` varchar(255) NOT NULL,
  `address` varchar(255) NOT NULL,
  `designation` varchar(255) NOT NULL,
  `age` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


#============= Lockdown policy check loan and principal amount =================
SELECT * FROM (
	SELECT t.prospect_id , t.contract_id , SUM(t.principal_amount ) `total_principal`, p.loan_amount ,
		CASE
		contract_type WHEN 1 THEN 'SME Car'
		WHEN 2 THEN 'SME Bike'
		WHEN 3 THEN 'Car Leasing'
		WHEN 4 THEN 'Bike Leasing'
		WHEN 5 THEN 'Micro Leasing'
		ELSE NULL
	END `contract_type`,
	CASE
		c.status WHEN 0 THEN 'Pending'
		WHEN 1 THEN 'Pending Approval'
		WHEN 2 THEN 'Pending Disbursement'
		WHEN 3 THEN 'Disbursement Approval'
		WHEN 4 THEN 'Active'
		WHEN 5 THEN 'Cancelled'
		WHEN 6 THEN 'Refinance'
		WHEN 7 THEN 'Closed'
		ELSE NULL
	END `contract_status`,
	c.date_closed 
	FROM tblpaymentschedule t
	LEFT JOIN tblprospect p ON (p.id = t.prospect_id)
	LEFT JOIN tblcontract c ON (c.prospect_id = p.id)
	GROUP BY t.prospect_id ) tbl
WHERE prospect_id in (2046934,2014350,2017917);
-- WHERE loan_amount <> `total_principal` and date_closed >= '2021-01-01';

#============ how to fix ===============
SELECT * FROM tblpayment where contract_id = 47968 and `type` != 'penalty' order by due_date, field(`type`, 'interest','principal') ;
select * from tblpaymentschedule t where contract_id = 47968 order by payment_date ;

select * from tblpaymentschedule_2046934 



select * from tblcontract t where prospect_id = 2081946 

insert into tblcontract 
select * from tblcontract_2081946 ;





