
-- fix branch
select branch_name, province_eng, district_eng, count(*) 
from contact_for_202406_lcc cfl 
where branch_name = 'Head Office' 
group by branch_name, province_eng, district_eng 
order by branch_name, province_eng, district_eng


select distinct branch_name, province_eng, district_eng
from contact_for_202406_lcc cfl 
where branch_name = 'Head Office' 
order by branch_name, province_eng, district_eng


-- 'Attapeu - Saysetha','Borikhamxay - Khamkeut','Champasack - Paksong','Champasack - Phonthong','Luangprabang - Nam Bak','Savanakhet - Songkhone','Vientiane Capital - Naxaythong','Vientiane Capital - Xaythany','Vientiane Capital - Hadxayfong','Vientiane Capital - Parkngum','Vientiane Province - Vangvieng','Xayaboury - Parklai','Xiengkhuang - Kham'

select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`condition` `remark_2`,`remark_3`
from contact_for_202408_lcc cntl 
where concat(province_eng, ' - ', district_eng) in ('Attapeu - Saysetha');




-- get report from lcc server 
SELECT customers.phone, customers.name, dtmf_campaign_calls.* FROM 
dtmf_campaign_calls  
join campaign_calls on campaign_calls.id=dtmf_campaign_calls.campaigncall_id
join customers on campaign_calls.customer_id=customers.id
where campaign_calls.campaign_id=4189
order by campaigncall_id, flag, info;

======================================================================================================================================================

 -- prepare list for new 13 branches
select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`condition` `remark_2`,`remark_3`
from contact_for_202408_lcc cntl 
where concat(province_eng, ' - ', district_eng) in ('Attapeu - Saysetha','Borikhamxay - Khamkeut','Champasack - Paksong','Champasack - Phonthong','Luangprabang - Nam Bak','Savanakhet - Songkhone','Vientiane Capital - Naxaythong','Vientiane Capital - Xaythany','Vientiane Capital - Hadxayfong','Vientiane Capital - Parkngum','Vientiane Province - Vangvieng','Xayaboury - Parklai','Xiengkhuang - Kham'
)
order by branch_name, province_eng, district_eng;
















