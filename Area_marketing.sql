


select concat(province_eng , ' - ', district_eng) as province_city,
	province_eng , district_eng, count(*) 
from contact_for_202410_lcc 
where province_eng != '' and district_eng != ''
group by province_eng , district_eng;


