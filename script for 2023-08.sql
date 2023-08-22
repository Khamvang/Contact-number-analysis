

-- 1) table contact_for  
create table `contact_for_202308_lcc` (
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
	  `remark_1` varchar(255) default null COMMENT 'priority 1=P1: New number file_id>=1207, 2=P2: ③Have address, 3=P3: ②Need loan, 4=P4: ①Have Car, 5=P5: ④Telecom',
	  `remark_2` varchar(255) default null,
	  `remark_3` varchar(255) default null,
	  `branch_name` varchar(255) default null,
	  `status` varchar(255) default null,
	  `status_updated` varchar(255) default null,
	  `staff_id` varchar(255) default null,
	  `pvd_id` varchar(255) default null,
	  `contact_id` int(11) not null comment 'the phone number without 9020 and 9030',
	  `condition` int(11) not null comment '①「Need Loan」, ②「Have Car」, ③「Have Address」　＆　『GOVERNMENT』　OR  『Yellow Page』, ④「Have Address」　＆　others, ⑤『EXPECT』(SAB)  ＆ 　≠『EXITING』『 DORMACCY』, ⑥『EXPECT』(C)  ＆ 　≠『EXITING』『 DORMACCY』 ＆　『CAR INFORMATOIN』, ⑦『TELECOM』have address, ⑧『TELECOM』no address',
	  `group` int(11) not null comment '1=condition 1,2,3,5,6, 2=condition 4,7, 3=condition 8',
	  primary key (`id`),
	  key `contact_no` (`contact_no`),
	  key `fk_file_id` (`file_id`),
	  key `contact_id` (`contact_id`),
	  constraint `contact_for_202308_lcc_ibfk_1` foreign key (`file_id`) references `file_details` (`id`)
) engine=InnoDB auto_increment=1 default CHARSET=utf8mb4 collate utf8mb4_general_ci ;



-- 2) intert data from contact_numbers_to_lcc to table monthly
insert into contact_for_202308_lcc
select cntl.id, cntl.`file_id`,`contact_no`,`name`,cntl.province_eng,`province_laos`,cntl.district_eng,`district_laos`,cntl.`village`,cntl.`type`,`maker`,`model`,`year`, 
	case when cntl.file_id >= 1207 then '1'
		when cntl.status = '' or cntl.status is null then '1'
		when cntl.`type` = '①Have Car' then '4'
		when cntl.`type` = '②Need loan' then '3'
		when cntl.`type` = '③Have address' then '2'
		when cntl.`type` = 'prospect' then '5'
		when cntl.`type` = '④Telecom' then '6'
	end `remark_1`,
	null `remark_2`,`remark_3`,cntl.`branch_name`,cntl.`status`, null `status_updated`, null `staff_id`,null `pvd_id`, 
	case when left(cntl.contact_no,4) = '9020' then right(cntl.contact_no,8) when left(cntl.contact_no,4) = '9030' then right(cntl.contact_no,7) end `contact_id`, 
	case when cntl.`type` = '①Have Car' then 2
		when cntl.`type` = '②Need loan' then 1
		when cntl.`type` = '③Have address' and fd.category = '①GOVERNMENT' then 3
		when cntl.`type` = '③Have address' and fd.category != '①GOVERNMENT' then 4
		when cntl.`type` = '④Telecom' and (cntl.province_eng is not null and cntl.district_eng is not null and cntl.village is not null ) then 7
		when cntl.`type` = '④Telecom' then 8
	end `condition`, 
	case when cntl.`type` in ('①Have Car', '②Need loan') then 1
		when cntl.`type` = '③Have address' and fd.category = '①GOVERNMENT' then 1
		when cntl.`type` = '③Have address' and fd.category != '①GOVERNMENT' then 2
		when cntl.`type` = '④Telecom' and (cntl.province_eng is not null and cntl.district_eng is not null and cntl.village is not null ) then 2
		when cntl.`type` = '④Telecom' then 3
	end `group`
-- select count(*) -- 4622987
from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
where (cntl.remark_3 in ('contracted', 'ringi_not_contract', 'aseet_not_contract') ) -- already register on LMS
	or (cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('X','S','A','B','C', 'FF1 not_answer', 'FF2 power_off') ) -- already register on CRM and LCC
	or (cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED') -- Ever Answered in the past
	or (cntl.remark_3 = 'Telecom' and cntl.status in ('ETL_active', 'SMS_success') ) -- Ever sent SMS and success
	or cntl.status is null -- new number
	or cntl.contact_id in (select contact_id from temp_sms_chairman tean where status = 1 ) -- SMS check
	or cntl.contact_id in (select contact_id from temp_etl_active_numbers tean2 ) -- ETL active 


-- 3) delete the status contracted, inactive number from table monthly
select count(*)  from contact_for_202308_lcc -- 4490751 number need to delete becaues contracted or invalid number
; delete from contact_for_202308_lcc
where remark_3 = 'contracted' -- contracted
	or (remark_3 in ('prospect_sabc', 'lcc') and status in ('X') ) -- contracted
	or (remark_3 = 'lcc' and status = 'Block need_to_block') -- Block need_to_block
	or (remark_3 = 'lcc' and status in ('FFF can_not_contact', 'No have in telecom')) -- FFF can_not_contact
	or (remark_3 = 'Telecom' and status in ('ETL_inactive','SMS_Failed')) -- Telecom_inactive
	or remark_3 = 'blacklist' -- blacklist


-- Export from lalcodb to contact_for_lcc_prospectsabc for priority 5
delete from contact_for_lcc_prospectsabc;

select * , case when left(contact_no, 4) = '9020' then right(contact_no, 8) when left(contact_no, 4) = '9030' then right(contact_no, 7) end "contact_id",
	case when status in ('S','A','B') then '5' when status = 'C' and (maker !='' or model != '') then 6 else 6 end "condition",
	'1' "group"
from (
	select null "id",
		case when left(right (translate (tel, translate(tel, '0123456789', ''), ''), 8), 1)= '0' then concat('903', right (translate (tel, translate(tel, '0123456789', ''), ''), 8))
			when length( translate (tel, translate(tel, '0123456789', ''), '')) = 7 then concat('9030', right (translate (tel, translate(tel, '0123456789', ''), ''), 8))
			else concat('9020', right (translate (tel, translate(tel, '0123456789', ''), ''), 8))
		end "contact_no",
		translate (concat(firstname, ' ', lastname), '.,:,', '') "name",
		case when province = 'Attapeu' then 'ATTAPUE'
			when province = 'Bokeo' then 'BORKEO'
			when province = 'Bolikhamxai' then 'BORLIKHAMXAY'
			when province = 'Champasak' then 'CHAMPASACK'
			when province = 'Houaphan' then 'HUAPHAN'
			when province = 'Khammouan' then 'KHAMMOUAN'
			when province = 'Louangphrabang' then 'LUANG PRABANG'
			when province = 'Louang Namtha' then 'LUANGNAMTHA'
			when province = 'Oudomxai' then 'OUDOMXAY'
			when province = 'Phongsali' then 'PHONGSALY'
			when province = 'Saravan' then 'SALAVANH'
			when province = 'Savannakhet' then 'SAVANNAKHET'
			when province = 'Vientiane Cap' then 'VIENTIANE CAPITAL'
			when province = 'Vientiane province' then 'VIENTIANE PROVINCE'
			when province = 'Xaignabouri' then 'XAYABOULY'
			when province = 'Xaisomboun' then 'XAYSOMBOUN'
			when province = 'Xekong' then 'XEKONG'
			when province = 'Xiangkhoang' then 'XIENGKHUANG'
			else null
		end "province_eng",
		null "province_laos",
		translate (district, '.,:,', '') "district_eng",
		null "district_laos",
		translate (c.addr , '.,:,`', '') "village",
		'prospect' "type",
		translate (maker, '.,:,`', '') "maker",
		translate (model, '.,:,`', '') "model",
		"year",
		5 "remark_1",
		null "remark_2",
		'prospect_sabc' "remark_3",
		null "branch_name",
		rank1 "status",
		null "staff_id",
		tua.new_village_id "pvd_id"
	from custtbl c left join temp_update_address tua on (c.id = tua.id)
	where c.rank1 in ('S','A','B') or (c.rank1 = 'C' and (c.maker !='' or c.model != '') )
	order by inputdate desc ) t
where concat(length("contact_no"), left( "contact_no", 5)) in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290209');


-- check and delete douplicate number 

-- 6)delete duplicate and check data
delete from removed_duplicate_2;
select count(*) from contact_for_lcc_prospectsabc; -- 39509 >> 
insert into removed_duplicate_2 
select id, row_numbers, now() `time` from ( 
		select id , row_number() over (partition by contact_no order by field(`type`, "contracted", "ringi_not_contract", "aseet_not_contract",
			"prospect_sabc", "pbx_cdr", "lcc") ,
		FIELD(`status` , "Active", "Closed", "Refinance", "Disbursement Approval", "Pending Disbursement", "Pending Approval", "Pending",
		"Approved", "Pending Approval from Credit", "Asset Assessed", "Pending Assessment", "Draft", "Cancelled", "Deleted",
		"X", "S", "A", "B", "C", "F", "G", "G1", "G2", "ANSWERED", "NO ANSWER", "Block need_to_block", "FF1 not_answer", "FF2 power_off", "FFF can_not_contact")) as row_numbers  
		from contact_for_lcc_prospectsabc  
		) as t1
	where row_numbers > 1;

-- delete number duplicate in file contact_for_lcc_prospectsabc
delete from contact_for_lcc_prospectsabc where id in (select id from removed_duplicate_2 );
delete from removed_duplicate_2;

-- delete number duplicate contact_for_202308_lcc
select * from contact_for_lcc_prospectsabc where contact_id in (select contact_id from contact_for_202308_lcc);
delete from contact_for_lcc_prospectsabc where contact_id in (select contact_id from contact_for_202308_lcc);


-- ________________________________________________ update branch name ________________________________________________
-- update contact_numbers_to_lcc aucn
update contact_for_lcc_prospectsabc aucn
set branch_name = 
	case when aucn.province_eng = 'ATTAPUE' then 'Attapue'
		when aucn.province_eng = 'BORKEO' then 'Bokeo'
		when aucn.province_eng = 'BORLIKHAMXAY' then 'Paksan'
		when aucn.province_eng = 'CHAMPASACK' then 'Pakse'
		when aucn.province_eng = 'HUAPHAN' then 'Houaphan'
		when aucn.province_eng = 'KHAMMOUAN' then 'Thakek'
		when aucn.province_eng = 'LUANG PRABANG' then 'Luangprabang'
		when aucn.province_eng = 'LUANGNAMTHA' then 'Luangnamtha'
		when aucn.province_eng = 'OUDOMXAY' then 'Oudomxay'
		when aucn.province_eng = 'PHONGSALY' then 'Oudomxay'
		when aucn.province_eng = 'SALAVANH' then 'Salavan'
		when aucn.province_eng = 'SAVANNAKHET' then 'Savannakhet'
		when aucn.province_eng = 'VIENTIANE CAPITAL' then 'Head office'
		when aucn.province_eng = 'VIENTIANE PROVINCE' then 'Vientiane province'
		when aucn.province_eng = 'XAYABOULY' then 'Xainyabuli'
		when aucn.province_eng = 'XAYSOMBOUN' then 'Xiengkhouang'
		when aucn.province_eng = 'XEKONG' then 'Attapue'
		when aucn.province_eng = 'XIENGKHUANG' then 'Xiengkhouang'
		else null 
	end
where aucn.province_eng is not null;

select branch_name , count(*)  from contact_for_lcc_prospectsabc group by branch_name 

update contact_for_lcc_prospectsabc set branch_name = 'Luangnamtha' where branch_name is null ;


-- insert to contact_for_202308_lcc
insert into contact_for_202308_lcc select * from contact_for_lcc_prospectsabc ;



-- set branch_name before export
select branch_name , count(*)  from contact_for_202308_lcc group by branch_name ;

update contact_for_202308_lcc set branch_name = 'Bokeo' where branch_name is null;


select count(*) from contact_for_202308_lcc cfl -- 4498655




# ______________________________________________________ export to create campaign on LCC for contact_for_202308_lcc ______________________________________________________________ #

Branch: 'Attapue','Bokeo','Head Office','Houaphan','LuangNamtha','Luangprabang','Oudomxay','Paksan','Pakse','Salavan','Savannakhet','Thakek','Vientiane province','Xainyabuli','Xiengkhouang'
Team: 'ATP Team', 'Bokeo', 'Team2', 'Team3', 'Team4', 'Houaphan Team', 'Luangnamtha', 'LPB Team', 'OUX Team', 'Paksan Team', 'Pakse Team', 'Salavan', 'SVK Team', 'Thakket Team', 'VTP Team', 'XYB Team', 'XKH Team'

-- ____________________________________________________ Priority1 ____________________________________________________
-- Campaign name: all_new_ATTAPUE_ATP Team_20230801_p1
-- select count(*) -- 59113
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202308_lcc cntl 
where cntl.remark_1 in ('1') 
	and branch_name = 'Attapue' ;


-- ____________________________________________________ Priority2 ____________________________________________________
-- Campaign name: 3_Old_ATTAPUE_ATP Team_20230801_p2
-- select count(*) -- 869506
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202308_lcc cntl 
where cntl.remark_1 in ('2')
	and branch_name = 'Attapue' ;


-- ____________________________________________________ Priority3 ____________________________________________________
-- Campaign name: 2_Old_ATTAPUE_ATP Team_20230801_p3
-- select count(*) -- 961537
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202308_lcc cntl 
where cntl.remark_1 in ('3')
	and branch_name = 'Attapue';


-- ____________________________________________________ Priority4 ____________________________________________________
-- Campaign name: 1_Old_ATTAPUE_ATP Team_20230801_p4
-- select count(*) -- 765053
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202308_lcc cntl 
where cntl.remark_1 in ('4')
	and branch_name = 'Attapue' ;


-- ____________________________________________________ Priority5 ____________________________________________________
-- Campaign name: p_Old_ATTAPUE_ATP Team_20230801_p5
-- select count(*) -- 
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202308_lcc cntl 
where cntl.remark_1 in ('5')
	and branch_name = 'Attapue' ;


-- ____________________________________________________ Priority6 ____________________________________________________
-- Campaign name: 4_Old_ATTAPUE_ATP Team_20230801_p6
-- select count(*) -- 
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202308_lcc cntl 
where cntl.remark_1 in ('6')
	and branch_name = 'Attapue' ;


-- ____________________________________________________ Priority6 ____________________________________________________
-- Campaign name: 4_Old_Head Office_Team2_20230801_p6
-- select count(*) -- 1125547
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`remark_2`,`remark_3`
from contact_for_202308_lcc cntl 
where cntl.remark_1 in ('6')
	 and branch_name = 'Head Office' -- limit 0, 3 -- mean start from row 0+1 and of row 0+3
	-- limit 0*75100 , 75100 -- result will be start from 0*75100+1, end 0*75100+75100, limit n+1, n (start from n+1, end of n)
	-- limit 1*75100, 75100 -- result will be start from 1*75100+1, end at 1*75100+75100
	 -- limit 2*75100, 75100 -- result will be start from 2*75100+1, end at 2*75100+75100



-- ___________________________________________________________________________________________________________________________________________
-- ____________________________________________________ Report to the Chairman 2023-08-22 ____________________________________________________
-- create table contact_for  
create table `contact_for_202308_to_chairman` (
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
	  `remark_1` varchar(255) default null COMMENT 'priority 1=P1: CIB 300,000, 2=P2: Yoshi list, 3=P3: Signboard, 4=P4: Village master, 5=P5: G rank, 6=P6: Yellow page',
	  `remark_2` varchar(255) default null,
	  `remark_3` varchar(255) default null,
	  `branch_name` varchar(255) default null,
	  `status` varchar(255) default null,
	  `status_updated` varchar(255) default null,
	  `staff_id` varchar(255) default null,
	  `pvd_id` varchar(255) default null,
	  `contact_id` int(11) not null comment 'the phone number without 9020 and 9030',
	  `reference_id` int(11) not null comment '1=condition 1,2,3,5,6, 2=condition 4,7, 3=condition 8',
	  `duplicate` int(11) default null,
	  primary key (`id`),
	  key `contact_no` (`contact_no`),
	  key `fk_file_id` (`file_id`),
	  key `contact_id` (`contact_id`),
	  key `reference_id` (`reference_id`),
	  constraint `contact_for_202308_to_chairman_ibfk_1` foreign key (`file_id`) references `file_details` (`id`)
) engine=InnoDB auto_increment=1 default CHARSET=utf8mb4 collate utf8mb4_general_ci ;


-- 1) CIB 300,000 data (ho have)

-- 2) Yotha
select cntl.*, fd.category , fd.category2  from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
where fd.category2 = 'MPWT'

insert into contact_for_202308_to_chairman
select null `id`, cntl.`file_id`,`contact_no`,`name`,cntl.province_eng,`province_laos`,cntl.district_eng,`district_laos`,cntl.`village`,cntl.`type`,`maker`,`model`,`year`, 
	case when fd.category2 = 'MPWT' then '2' when fd.category2 = 'Signboard' then '3' when fd.category2 = 'Village_master' then '4' end  `remark_1`, 
	null `remark_2`,`remark_3`,cntl.`branch_name`,cntl.`status`, null `status_updated`, null `staff_id`,null `pvd_id`, 
	case when left(cntl.contact_no,4) = '9020' then right(cntl.contact_no,8) when left(cntl.contact_no,4) = '9030' then right(cntl.contact_no,7) end `contact_id`, 
	cntl.id `reference_id`
-- select count(*) -- 62595
from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
where fd.category2 in ('MPWT', 'Signboard', 'Village_master');

-- 3) Signboard project
select * from signboard_project sp where contact_id not in (select contact_id from contact_numbers_to_lcc cntl where `type` != '④Telecom')
	and CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290208','1290209');

insert into contact_for_202308_to_chairman
select null `id`, null `file_id`,`contact_no`,`name`, `province_eng`, null `province_laos`, `district_eng`,null `district_laos`, `village`, '③Have address' `type`, null `maker`, null `model`, null `year`, 
	'3' `remark_1`, null `remark_2`,null `remark_3`, null `branch_name`, null `status`, null `status_updated`, null `staff_id`,null `pvd_id`, 
	case when left(sp.contact_no,4) = '9020' then right(sp.contact_no,8) when left(sp.contact_no,4) = '9030' then right(sp.contact_no,7) end `contact_id`, 
	sp.id `reference_id`
-- select count(*) -- 62595
from signboard_project sp 
where contact_id not in (select contact_id from contact_numbers_to_lcc cntl where `type` != '④Telecom')
	and CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290208','1290209');

-- 4) Village master 
select * from village_master_project vmp; where contact_id not in (select contact_id from contact_numbers_to_lcc cntl where `type` != '④Telecom')
	and CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290208','1290209');

insert into contact_for_202308_to_chairman
select null `id`, null `file_id`,`contact_no`,`name`, `province_eng`, null `province_laos`, `district_eng`,null `district_laos`, `village`, '③Have address' `type`, null `maker`, null `model`, null `year`, 
	'4' `remark_1`, null `remark_2`,null `remark_3`, null `branch_name`, null `status`, null `status_updated`, null `staff_id`,null `pvd_id`, 
	case when left(vmp.contact_no,4) = '9020' then right(vmp.contact_no,8) when left(vmp.contact_no,4) = '9030' then right(vmp.contact_no,7) end `contact_id`, 
	vmp.id `reference_id`
-- select count(*) -- 62595
from village_master_project vmp
where contact_id not in (select contact_id from contact_numbers_to_lcc cntl where `type` != '④Telecom')
	and CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290208','1290209');

-- 5) G rank
select * , case when left(contact_no, 4) = '9020' then right(contact_no, 8) when left(contact_no, 4) = '9030' then right(contact_no, 7) end "contact_id"
from (
	select null "id",
		case when left(right (translate (tel, translate(tel, '0123456789', ''), ''), 8), 1)= '0' then concat('903', right (translate (tel, translate(tel, '0123456789', ''), ''), 8))
			when length( translate (tel, translate(tel, '0123456789', ''), '')) = 7 then concat('9030', right (translate (tel, translate(tel, '0123456789', ''), ''), 8))
			else concat('9020', right (translate (tel, translate(tel, '0123456789', ''), ''), 8))
		end "contact_no",
		translate (concat(firstname, ' ', lastname), '.,:,', '') "name",
		case when province = 'Attapeu' then 'ATTAPUE'
			when province = 'Bokeo' then 'BORKEO'
			when province = 'Bolikhamxai' then 'BORLIKHAMXAY'
			when province = 'Champasak' then 'CHAMPASACK'
			when province = 'Houaphan' then 'HUAPHAN'
			when province = 'Khammouan' then 'KHAMMOUAN'
			when province = 'Louangphrabang' then 'LUANG PRABANG'
			when province = 'Louang Namtha' then 'LUANGNAMTHA'
			when province = 'Oudomxai' then 'OUDOMXAY'
			when province = 'Phongsali' then 'PHONGSALY'
			when province = 'Saravan' then 'SALAVANH'
			when province = 'Savannakhet' then 'SAVANNAKHET'
			when province = 'Vientiane Cap' then 'VIENTIANE CAPITAL'
			when province = 'Vientiane province' then 'VIENTIANE PROVINCE'
			when province = 'Xaignabouri' then 'XAYABOULY'
			when province = 'Xaisomboun' then 'XAYSOMBOUN'
			when province = 'Xekong' then 'XEKONG'
			when province = 'Xiangkhoang' then 'XIENGKHUANG'
			else null
		end "province_eng",
		null "province_laos",
		translate (district, '.,:,', '') "district_eng",
		null "district_laos",
		translate (c.addr , '.,:,`', '') "village",
		'prospect' "type",
		translate (maker, '.,:,`', '') "maker",
		translate (model, '.,:,`', '') "model",
		"year",
		5 "remark_1",
		null "remark_2",
		'prospect_sabc' "remark_3",
		null "branch_name",
		rank1 "status",
		null "staff_id",
		tua.new_village_id "pvd_id",
		c.id "reference_id"
	from custtbl c left join temp_update_address tua on (c.id = tua.id)
	where c.rank1 in ('G','G1','G2') 
	order by inputdate desc ) t
where concat(length("contact_no"), left( "contact_no", 5)) in ('1190302','1190304','1190305','1190307','1190309','1290202','1290205','1290207','1290209');

-- 6) Yellow page


-- update branch name
update contact_for_202308_to_chairman aucn
set branch_name = 
	case when aucn.province_eng = 'ATTAPUE' then 'Attapue'
		when aucn.province_eng = 'BORKEO' then 'Bokeo'
		when aucn.province_eng = 'BORLIKHAMXAY' then 'Paksan'
		when aucn.province_eng = 'CHAMPASACK' then 'Pakse'
		when aucn.province_eng = 'HUAPHAN' then 'Houaphan'
		when aucn.province_eng = 'KHAMMOUAN' then 'Thakek'
		when aucn.province_eng = 'LUANG PRABANG' then 'Luangprabang'
		when aucn.province_eng = 'LUANGNAMTHA' then 'Luangnamtha'
		when aucn.province_eng = 'OUDOMXAY' then 'Oudomxay'
		when aucn.province_eng = 'PHONGSALY' then 'Oudomxay'
		when aucn.province_eng = 'SALAVANH' then 'Salavan'
		when aucn.province_eng = 'SAVANNAKHET' then 'Savannakhet'
		when aucn.province_eng = 'VIENTIANE CAPITAL' then 'Head office'
		when aucn.province_eng = 'VIENTIANE PROVINCE' then 'Vientiane province'
		when aucn.province_eng = 'XAYABOULY' then 'Xainyabuli'
		when aucn.province_eng = 'XAYSOMBOUN' then 'Xiengkhouang'
		when aucn.province_eng = 'XEKONG' then 'Attapue'
		when aucn.province_eng = 'XIENGKHUANG' then 'Xiengkhouang'
		else null 
	end
where aucn.province_eng is not null;


-- 7) Broker 
select fd.id `file_id`, fd.branch_name 'Branch', case when sme.staff_no is not null then 'Sales' else 'Non_Sales' end 'Department', sme.unit 'Unit', fd.staff_no , fd.staff_name, fd.staff_tel, null 'Staff Status',
	concat(fd.broker_name, ' ',fd.broker_tel) 'broker_key', fd.broker_name, fd.broker_tel , 
	row_number() over (partition by fd.broker_tel order by fd.broker_tel, fd.broker_name) as 'duplicate broker_tel',
	row_number() over (partition by concat(fd.broker_name, ' ',fd.broker_tel) order by fd.broker_tel, fd.broker_name) as 'duplicate broker name & tel',
	row_number() over (partition by fd.broker_tel order by fd.broker_tel, fd.broker_name) = row_number() over (partition by concat(fd.broker_name, ' ',fd.broker_tel) order by fd.broker_tel, fd.broker_name) 'duplicate check',
	fd.`type` , fd.category , fd.date_received, fd.company_name , fd.number_of_original_file,
	null 'unique_numbers', null 'can_contact_numbers', null ' staff status', null 'current_staff_no', null 'current_staff_name'
from file_details fd left join sme_org sme on (fd.staff_no = sme.staff_no)
where fd.category in ('①GOVERNMENT','②INSURANCE','③CAR SHOP','④FINANCE∙LEASE') -- not need telecom and other 
	and fd.broker_tel != '0'
order by fd.broker_tel, fd.broker_name ;









