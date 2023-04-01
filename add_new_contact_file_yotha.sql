


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
