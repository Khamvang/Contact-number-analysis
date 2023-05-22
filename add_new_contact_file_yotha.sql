


create table `yotha_mpwt_original` (
	`id` int(11) not null auto_increment,
	`no_in_month` varchar(255) default null,
	`number_plate` varchar(255) default null,
	`type_of_number_plate` varchar(255) default null,
	`owner_name` varchar(255) default null,
	`village` varchar(255) default null,
	`district` varchar(255) default null,
	`province` varchar(255) default null,
	`body_type` varchar(255) default null,
	`maker` varchar(255) default null,
	`model` varchar(255) default null,
	`color` varchar(255) default null,
	`contact_no` varchar(255) default null,
	`period` varchar(255) default null,
	`contact_id` int(11) default null,
	primary key (`id`),
	key `contact_id` (`contact_id`)
) engine=InnoDB auto_increment=1 default charset=utf8;

alter table yotha_mpwt_original add date_created timestamp null default current_timestamp;
update yotha_mpwt_original set date_created = '2023-04-03 15:45:54'


-- insert data from original file final file
insert into yotha_mpwt select * from yotha_mpwt_original 

-- update the contact number to correct format
update yotha_mpwt set contact_no = 
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
;

-- set contact_id
update yotha_mpwt 
set contact_id = case when left(contact_no,4) = '9020' then right(contact_no,8) when left(contact_no,4) = '9030' then right(contact_no,7) end ;

-- check and delete invalid number 
select * from yotha_mpwt 
where CONCAT(LENGTH(contact_no), left( contact_no, 5)) not in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290208','1290209');

-- delete invalid number
delete from yotha_mpwt 
where CONCAT(LENGTH(contact_no), left( contact_no, 5)) not in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290208','1290209');  -- 193


-- 4) clear 
delete from removed_duplicate_2;

-- insert duplicate 
insert into removed_duplicate_2
select id, row_numbers, now() `time` from ( 
		select id, row_number() over (partition by contact_no order by id asc ) as row_numbers  -- order by id desc Because the new data is close the correct data more then old data
		from yotha_mpwt 
		) as t1
	where row_numbers > 1; -- 4107

-- ) check and remove duplicate Delete from all unique where id = id in table removed duplicate 
select * from removed_duplicate_2 where `time` >= '2023-04-03';

delete from yotha_mpwt 
where id in (select id from removed_duplicate_2 where `time` >= '2023-03-27'); -- 4107













