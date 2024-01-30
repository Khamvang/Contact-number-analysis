

-- 1) table contact_for  
create table `contact_for_logcall` (
	  `date` date not null ,
	  `contact_no` varchar(255) not null,
	  `contact_id` int(11) not null comment 'the phone number without 9020 and 9030',
	  `remark_2` varchar(255) default null,
	  `status_updated` varchar(255) default null,
	  key `contact_id` (`contact_id`)
) engine=InnoDB auto_increment=1 default CHARSET=utf8mb4 collate utf8mb4_general_ci ;

-- insert data from each month into table contact_for_logcall
-- Jan 2023
insert into contact_for_logcall
select '2023-01-31' `date`, `contact_no`, `contact_id`, `remark_2`, `status_updated`
from contact_for_202301_lcc cfl where status_updated is not null;

-- Feb 2023
insert into contact_for_logcall
select '2023-02-28' `date`, `contact_no`, `contact_id`, `remark_2`, `status_updated`
from contact_for_202302_lcc cfl where status_updated is not null;

-- Mar 2023
insert into contact_for_logcall
select '2023-03-31' `date`, `contact_no`, `contact_id`, `remark_2`, `status_updated`
from contact_for_202303_lcc cfl where status_updated is not null;

-- Apr 2023
insert into contact_for_logcall
select '2023-04-30' `date`, `contact_no`, `contact_id`, `remark_2`, `status_updated`
from contact_for_202304_lcc cfl where status_updated is not null;

-- May 2023
insert into contact_for_logcall
select '2023-05-31' `date`, `contact_no`, `contact_id`, `remark_2`, `status_updated`
from contact_for_202305_lcc cfl where status_updated is not null;

-- Jun 2023
insert into contact_for_logcall
select '2023-06-30' `date`, `contact_no`, `contact_id`, `remark_2`, `status_updated`
from contact_for_202306_lcc cfl where status_updated is not null;

-- Jul 2023
insert into contact_for_logcall
select '2023-07-31' `date`, `contact_no`, `contact_id`, `remark_2`, `status_updated`
from contact_for_202307_lcc cfl where status_updated is not null;

-- Aug 2023
insert into contact_for_logcall
select '2023-08-31' `date`, `contact_no`, `contact_id`, `remark_2`, `status_updated`
from contact_for_202308_lcc cfl where status_updated is not null;

-- Sep 2023
insert into contact_for_logcall
select '2023-09-30' `date`, `contact_no`, `contact_id`, `remark_2`, `status_updated`
from contact_for_202309_lcc cfl where status_updated is not null;

-- Oct 2023
insert into contact_for_logcall
select '2023-10-31' `date`, `contact_no`, `contact_id`, `remark_2`, `status_updated`
from contact_for_202310_lcc cfl where status_updated is not null;

-- Nov 2023
insert into contact_for_logcall
select '2023-11-30' `date`, `contact_no`, `contact_id`, `remark_2`, `status_updated`
from contact_for_202311_lcc cfl where status_updated is not null;

-- Dec 2023
insert into contact_for_logcall
select '2023-12-31' `date`, `contact_no`, `contact_id`, `remark_2`, `status_updated`
from contact_for_202312_lcc cfl where status_updated is not null;

-- Jan 2024
insert into contact_for_logcall
select '2024-01-31' `date`, `contact_no`, `contact_id`, `remark_2`, `status_updated`
from contact_for_202401_lcc cfl where status_updated is not null;

-- ______________________________________________________________ check and update set the condition = call time ______________________________________________________________
select cfl.contact_id, t.`count_time` from contact_for_202310_lcc cfl
left join (select contact_id, count(*) `count_time` from contact_for_logcall group by contact_id) t on (cfl.contact_id = t.contact_id)

update contact_for_202310_lcc cfl
left join (select contact_id, count(*) `count_time` from contact_for_logcall group by contact_id) t on (cfl.contact_id = t.contact_id)
set cfl.`condition` = t.`count_time`




