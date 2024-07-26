
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



select `id`,`contact_no`,`name`,`province_eng`,`province_laos`,`district_eng`,`district_laos`,`village`,`type`,`maker`,`model`,`year`,`remark_1`,`condition` `remark_2`,`remark_3`
from contact_for_202406_lcc cntl 
where branch_name = 'Head Office' and province_eng = 'VIENTIANE CAPITAL' 
-- and district_eng = 'Hadxayfong'
-- and district_eng = 'Naxaythong'
-- and district_eng = 'Parkngum'
 and district_eng = 'Xaythany'
order by `condition` asc;




-- get report from lcc server 
SELECT customers.phone, customers.name, dtmf_campaign_calls.* FROM 
dtmf_campaign_calls  
join campaign_calls on campaign_calls.id=dtmf_campaign_calls.campaigncall_id
join customers on campaign_calls.customer_id=customers.id
where campaign_calls.campaign_id=4189
order by campaigncall_id, flag, info;



