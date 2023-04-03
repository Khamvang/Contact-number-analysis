


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



-- 4) clear 
delete from removed_duplicate_2;

-- insert duplicate 
insert into removed_duplicate_2
select id, row_numbers, now() `time` from ( 
		select id, row_number() over (partition by contact_no order by id ) as row_numbers  
		from contact_numbers_to_sp 
		-- where file_id <= 1091
		) as t1
	where row_numbers > 1; -- done <= 1091

-- ) check and remove duplicate Delete from all unique where id = id in table removed duplicate 
select * from removed_duplicate_2 where `time` >= '2023-03-27';

delete from contact_numbers_to_sp 
where id in (select id from removed_duplicate_2 where `time` >= '2023-03-27'); -- done <= 1068


