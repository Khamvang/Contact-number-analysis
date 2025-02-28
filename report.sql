

-- Update province name
update contact_numbers_to_lcc cntl
set cntl.province_eng = 
	case	when cntl.province_eng = 'ATTAPUE' then 'Attapeu'
		when cntl.province_eng = 'BOKEO' then 'Bokeo'
		when cntl.province_eng = 'BORLIKHAMXAY' then 'Borikhamxay'
		when cntl.province_eng = 'CHAMPASACK' then 'Champasack'
		when cntl.province_eng = 'HUAPHAN' then 'Huaphanh'
		when cntl.province_eng = 'KHAMMOUAN' then 'Khammuane'
		when cntl.province_eng = 'LUANGNAMTHA' then 'Luangnamtha'
		when cntl.province_eng = 'LUANG PRABANG' then 'Luangprabang'
		when cntl.province_eng = 'OUDOMXAY' then 'Oudomxay'
		when cntl.province_eng = 'PHONGSALY' then 'Phongsaly'
		when cntl.province_eng = 'SALAVANH' then 'Saravane'
		when cntl.province_eng = 'SAVANNAKHET' then 'Savanakhet'
		when cntl.province_eng = 'VIENTIANE CAPITAL' then 'Vientiane Capital'
		when cntl.province_eng = 'VIENTIANE PROVINCE' then 'Vientiane Province'
		when cntl.province_eng = 'XAYABOULY' then 'Xayaboury'
		when cntl.province_eng = 'XAYSOMBOUN' then 'Xaysomboune'
		when cntl.province_eng = 'XEKONG' then 'Sekong'
		when cntl.province_eng = 'XIENGKHUANG' then 'Xiengkhuang'
	end
where cntl.province_eng != '';


-- Update branch before export 
update contact_numbers_to_lcc cntl inner join file_details fd on (fd.id = cntl.file_id)
set cntl.branch_name = 
	case 	when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Attapeu - Saysetha' then 'Attapue'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Attapeu - Samakkhixay' then 'Attapue'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Attapeu - Sanamxay' then 'Attapue'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Attapeu - Sanxay' then 'Attapue'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Attapeu - Phouvong' then 'Attapue'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Bokeo - Houay Xay' then 'Bokeo'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Bokeo - Ton Pheung' then 'Tonpherng'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Bokeo - Meung' then 'Tonpherng'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Bokeo - Pha Oudom' then 'Bokeo'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Bokeo - Pak Tha' then 'Bokeo'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Borikhamxay - Paksane' then 'Paksan'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Borikhamxay - Thaphabat' then 'Paksan'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Borikhamxay - Pakkading' then 'Pakkading'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Borikhamxay - Borikhane' then 'Paksan'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Borikhamxay - Khamkeut' then 'Khamkeuth'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Borikhamxay - Viengthong' then 'Khamkeuth'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Borikhamxay - Xaychamphone' then 'Khamkeuth'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Champasack - Pak Se' then 'Pakse'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Champasack - Sanasomboun' then 'Pakse'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Champasack - Batiengchaleunsouk' then 'Pakse'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Champasack - Paksong' then 'Paksxong'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Champasack - Pathouphone' then 'Pakse'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Champasack - Phonthong' then 'Chongmeg'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Champasack - Champassack' then 'Sukhuma'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Champasack - Soukhoumma' then 'Sukhuma'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Champasack - Mounlapamok' then 'Khong'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Champasack - Khong' then 'Khong'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Huaphanh - Xam Neua' then 'Houaphan'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Huaphanh - Xiengkho' then 'Houaphan'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Huaphanh - Muang Hiam' then 'Houaphan'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Huaphanh - Viengxay' then 'Houaphan'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Huaphanh - Houameuang' then 'Houaphan'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Huaphanh - Samtay' then 'Houaphan'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Huaphanh - Sop Bao' then 'Houaphan'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Huaphanh - Muang Et' then 'Houaphan'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Huaphanh - Kuane' then 'Houaphan'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Huaphanh - Xone' then 'Houaphan'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Khammuane - Thakhek' then 'Thakek'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Khammuane - Mahaxay' then 'Thakek'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Khammuane - Nong Bok' then 'Thakek'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Khammuane - Hineboune' then 'Thakek'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Khammuane - Yommalath' then 'Nhommalth'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Khammuane - Boualapha' then 'Thakek'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Khammuane - Nakai' then 'Nhommalth'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Khammuane - Sebangphay' then 'Thakek'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Khammuane - Saybouathong' then 'Thakek'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Khammuane - Kounkham' then 'Khamkeuth'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Luangnamtha - Namtha' then 'Luangnamtha'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Luangnamtha - Sing' then 'Luangnamtha'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Luangnamtha - Long' then 'Luangnamtha'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Luangnamtha - Viengphoukha' then 'Luangnamtha'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Luangnamtha - Na Le' then 'Luangnamtha'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Luangprabang - Luang Prabang' then 'Luangprabang'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Luangprabang - Xiengngeun' then 'Luangprabang'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Luangprabang - Nane' then 'Nane'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Luangprabang - Pak Ou' then 'Luangprabang'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Luangprabang - Nam Bak' then 'Nambak'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Luangprabang - Ngoy' then 'Nambak'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Luangprabang - Pak Seng' then 'Luangprabang'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Luangprabang - Phonxay' then 'Luangprabang'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Luangprabang - Chomphet' then 'Nane'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Luangprabang - Viengkham' then 'Nambak'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Luangprabang - Phoukhoune' then 'Luangprabang'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Luangprabang - Phonthong' then 'Nambak'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Oudomxay - Xay' then 'Oudomxay'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Oudomxay - La' then 'Oudomxay'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Oudomxay - Na Mo' then 'Oudomxay'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Oudomxay - Nga' then 'Oudomxay'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Oudomxay - Beng' then 'Hoon'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Oudomxay - Houne' then 'Hoon'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Oudomxay - Pak Beng' then 'Hoon'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Phongsaly - May' then 'Phongsary'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Phongsaly - Khoua' then 'Phongsary'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Phongsaly - Samphanh' then 'Phongsary'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Phongsaly - Boun Neua' then 'Phongsary'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Phongsaly - Yot Ou' then 'Phongsary'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Phongsaly - Boun Tay' then 'Phongsary'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Phongsaly - Phongsaly' then 'Phongsary'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Saravane - Saravanh' then 'Salavan'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Saravane - Ta Oy' then 'Salavan'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Saravane - Toumlane' then 'Salavan'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Saravane - Lakhonepheng' then 'Khongxedone'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Saravane - Vapy' then 'Khongxedone'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Saravane - Khongsedone' then 'Khongxedone'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Saravane - Lao Ngam' then 'Salavan'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Saravane - Sa Mouay' then 'Salavan'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Savanakhet - Kaysone Phomvihane' then 'Savannakhet'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Savanakhet - Outhoumphone' then 'Savannakhet'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Savanakhet - Atsaphangthong' then 'Atsaphangthong'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Savanakhet - Phine' then 'Phine'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Savanakhet - Seponh' then 'Phine'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Savanakhet - Nong' then 'Phine'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Savanakhet - Thapangthong' then 'Songkhone'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Savanakhet - Songkhone' then 'Songkhone'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Savanakhet - Champhone' then 'Savannakhet'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Savanakhet - Xayboury' then 'Savannakhet'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Savanakhet - Viraboury' then 'Phine'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Savanakhet - Assaphone' then 'Atsaphangthong'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Savanakhet - Xonnabouly' then 'Savannakhet'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Savanakhet - Phalanxay' then 'Atsaphangthong'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Savanakhet - Xayphouthong' then 'Songkhone'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Vientiane Capital - Chanthabuly' then 'Head office'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Vientiane Capital - Sikhottabong' then 'Sikhottabong'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Vientiane Capital - Xaysetha' then 'Head office'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Vientiane Capital - Sisattanak' then 'Head office'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Vientiane Capital - Naxaythong' then 'Naxaiythong'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Vientiane Capital - Xaythany' then 'Xaythany'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Vientiane Capital - Hadxayfong' then 'Hadxaifong'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Vientiane Capital - Sangthong' then 'Naxaiythong'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Vientiane Capital - Parkngum' then 'Mayparkngum'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Vientiane Province - Phonhong' then 'Vientiane province'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Vientiane Province - Thoulakhom' then 'Thoulakhom'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Vientiane Province - Keo Oudom' then 'Thoulakhom'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Vientiane Province - Kasy' then 'Vangvieng'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Vientiane Province - Vangvieng' then 'Vangvieng'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Vientiane Province - Feuang' then 'Feuang'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Vientiane Province - Xanakharm' then 'Xanakharm'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Vientiane Province - Mad' then 'Xanakharm'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Vientiane Province - Hinhurp' then 'Vientiane province'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Vientiane Province - Viengkham' then 'Vientiane province'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Vientiane Province - Mune' then 'Feuang'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Xayaboury - Xaiyabuly' then 'Xainyabuli'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Xayaboury - Khop' then 'Hongsa'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Xayaboury - Hongsa' then 'Hongsa'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Xayaboury - Ngeun' then 'Hongsa'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Xayaboury - Xienghone' then 'Hongsa'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Xayaboury - Phiang' then 'Xainyabuli'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Xayaboury - Parklai' then 'Parklai'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Xayaboury - Kenethao' then 'Parklai'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Xayaboury - Botene' then 'Parklai'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Xayaboury - Thongmyxay' then 'Parklai'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Xayaboury - Xaysathan' then 'Xainyabuli'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Xaysomboune - Anouvong' then 'Xaisomboun'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Xaysomboune - Longchaeng' then 'Xaisomboun'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Xaysomboune - Longxan' then 'Xaisomboun'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Xaysomboune - Hom' then 'Xaisomboun'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Xaysomboune - Thathom' then 'Xaisomboun'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Sekong - La Mam' then 'Sekong'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Sekong - Kaleum' then 'Sekong'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Sekong - Dak Cheung' then 'Sekong'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Sekong - Tha Teng' then 'Sekong'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Xiengkhuang - Paek' then 'Xiengkhouang'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Xiengkhuang - Kham' then 'Kham'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Xiengkhuang - Nong Het' then 'Kham'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Xiengkhuang - Khoune' then 'Khoune'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Xiengkhuang - Mok' then 'Khoune'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Xiengkhuang - Phou Kout' then 'Xiengkhouang'
		when concat(cntl.province_eng , ' - ', cntl.district_eng) = 'Xiengkhuang - Phaxay' then 'Xiengkhouang'
		else fd.branch_name
	end
where cntl.province_eng != '' or cntl.branch_name is null;



-- Update branch before export, if the query before now is not working
update contact_numbers_to_lcc cntl inner join file_details fd on (fd.id = cntl.file_id)
set cntl.branch_name = 
	case 	WHEN cntl.province_eng = 'Attapeu' AND cntl.district_eng = 'Saysetha' THEN 'Attapue'
		WHEN cntl.province_eng = 'Attapeu' AND cntl.district_eng = 'Samakkhixay' THEN 'Attapue'
		WHEN cntl.province_eng = 'Attapeu' AND cntl.district_eng = 'Sanamxay' THEN 'Attapue'
		WHEN cntl.province_eng = 'Attapeu' AND cntl.district_eng = 'Sanxay' THEN 'Attapue'
		WHEN cntl.province_eng = 'Attapeu' AND cntl.district_eng = 'Phouvong' THEN 'Attapue'
		WHEN cntl.province_eng = 'Bokeo' AND cntl.district_eng = 'Houay Xay' THEN 'Bokeo'
		WHEN cntl.province_eng = 'Bokeo' AND cntl.district_eng = 'Ton Pheung' THEN 'Tonpherng'
		WHEN cntl.province_eng = 'Bokeo' AND cntl.district_eng = 'Meung' THEN 'Tonpherng'
		WHEN cntl.province_eng = 'Bokeo' AND cntl.district_eng = 'Pha Oudom' THEN 'Bokeo'
		WHEN cntl.province_eng = 'Bokeo' AND cntl.district_eng = 'Pak Tha' THEN 'Bokeo'
		WHEN cntl.province_eng = 'Borikhamxay' AND cntl.district_eng = 'Paksane' THEN 'Paksan'
		WHEN cntl.province_eng = 'Borikhamxay' AND cntl.district_eng = 'Thaphabat' THEN 'Paksan'
		WHEN cntl.province_eng = 'Borikhamxay' AND cntl.district_eng = 'Pakkading' THEN 'Pakkading'
		WHEN cntl.province_eng = 'Borikhamxay' AND cntl.district_eng = 'Borikhane' THEN 'Paksan'
		WHEN cntl.province_eng = 'Borikhamxay' AND cntl.district_eng = 'Khamkeut' THEN 'Khamkeuth'
		WHEN cntl.province_eng = 'Borikhamxay' AND cntl.district_eng = 'Viengthong' THEN 'Khamkeuth'
		WHEN cntl.province_eng = 'Borikhamxay' AND cntl.district_eng = 'Xaychamphone' THEN 'Khamkeuth'
		WHEN cntl.province_eng = 'Champasack' AND cntl.district_eng = 'Pak Se' THEN 'Pakse'
		WHEN cntl.province_eng = 'Champasack' AND cntl.district_eng = 'Sanasomboun' THEN 'Pakse'
		WHEN cntl.province_eng = 'Champasack' AND cntl.district_eng = 'Batiengchaleunsouk' THEN 'Pakse'
		WHEN cntl.province_eng = 'Champasack' AND cntl.district_eng = 'Paksong' THEN 'Paksxong'
		WHEN cntl.province_eng = 'Champasack' AND cntl.district_eng = 'Pathouphone' THEN 'Pakse'
		WHEN cntl.province_eng = 'Champasack' AND cntl.district_eng = 'Phonthong' THEN 'Chongmeg'
		WHEN cntl.province_eng = 'Champasack' AND cntl.district_eng = 'Champassack' THEN 'Sukhuma'
		WHEN cntl.province_eng = 'Champasack' AND cntl.district_eng = 'Soukhoumma' THEN 'Sukhuma'
		WHEN cntl.province_eng = 'Champasack' AND cntl.district_eng = 'Mounlapamok' THEN 'Khong'
		WHEN cntl.province_eng = 'Champasack' AND cntl.district_eng = 'Khong' THEN 'Khong'
		WHEN cntl.province_eng = 'Huaphanh' AND cntl.district_eng = 'Xam Neua' THEN 'Houaphan'
		WHEN cntl.province_eng = 'Huaphanh' AND cntl.district_eng = 'Xiengkho' THEN 'Houaphan'
		WHEN cntl.province_eng = 'Huaphanh' AND cntl.district_eng = 'Muang Hiam' THEN 'Houaphan'
		WHEN cntl.province_eng = 'Huaphanh' AND cntl.district_eng = 'Viengxay' THEN 'Houaphan'
		WHEN cntl.province_eng = 'Huaphanh' AND cntl.district_eng = 'Houameuang' THEN 'Houaphan'
		WHEN cntl.province_eng = 'Huaphanh' AND cntl.district_eng = 'Samtay' THEN 'Houaphan'
		WHEN cntl.province_eng = 'Huaphanh' AND cntl.district_eng = 'Sop Bao' THEN 'Houaphan'
		WHEN cntl.province_eng = 'Huaphanh' AND cntl.district_eng = 'Muang Et' THEN 'Houaphan'
		WHEN cntl.province_eng = 'Huaphanh' AND cntl.district_eng = 'Kuane' THEN 'Houaphan'
		WHEN cntl.province_eng = 'Huaphanh' AND cntl.district_eng = 'Xone' THEN 'Houaphan'
		WHEN cntl.province_eng = 'Khammuane' AND cntl.district_eng = 'Thakhek' THEN 'Thakek'
		WHEN cntl.province_eng = 'Khammuane' AND cntl.district_eng = 'Mahaxay' THEN 'Thakek'
		WHEN cntl.province_eng = 'Khammuane' AND cntl.district_eng = 'Nong Bok' THEN 'Thakek'
		WHEN cntl.province_eng = 'Khammuane' AND cntl.district_eng = 'Hineboune' THEN 'Thakek'
		WHEN cntl.province_eng = 'Khammuane' AND cntl.district_eng = 'Yommalath' THEN 'Nhommalth'
		WHEN cntl.province_eng = 'Khammuane' AND cntl.district_eng = 'Boualapha' THEN 'Thakek'
		WHEN cntl.province_eng = 'Khammuane' AND cntl.district_eng = 'Nakai' THEN 'Nhommalth'
		WHEN cntl.province_eng = 'Khammuane' AND cntl.district_eng = 'Sebangphay' THEN 'Thakek'
		WHEN cntl.province_eng = 'Khammuane' AND cntl.district_eng = 'Saybouathong' THEN 'Thakek'
		WHEN cntl.province_eng = 'Khammuane' AND cntl.district_eng = 'Kounkham' THEN 'Khamkeuth'
		WHEN cntl.province_eng = 'Luangnamtha' AND cntl.district_eng = 'Namtha' THEN 'Luangnamtha'
		WHEN cntl.province_eng = 'Luangnamtha' AND cntl.district_eng = 'Sing' THEN 'Luangnamtha'
		WHEN cntl.province_eng = 'Luangnamtha' AND cntl.district_eng = 'Long' THEN 'Luangnamtha'
		WHEN cntl.province_eng = 'Luangnamtha' AND cntl.district_eng = 'Viengphoukha' THEN 'Luangnamtha'
		WHEN cntl.province_eng = 'Luangnamtha' AND cntl.district_eng = 'Na Le' THEN 'Luangnamtha'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Luang Prabang' THEN 'Luangprabang'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Xiengngeun' THEN 'Luangprabang'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Nane' THEN 'Nane'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Pak Ou' THEN 'Luangprabang'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Nam Bak' THEN 'Nambak'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Ngoy' THEN 'Nambak'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Pak Seng' THEN 'Luangprabang'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Phonxay' THEN 'Luangprabang'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Chomphet' THEN 'Nane'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Viengkham' THEN 'Nambak'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Phoukhoune' THEN 'Luangprabang'
		WHEN cntl.province_eng = 'Luangprabang' AND cntl.district_eng = 'Phonthong' THEN 'Nambak'
		WHEN cntl.province_eng = 'Oudomxay' AND cntl.district_eng = 'Xay' THEN 'Oudomxay'
		WHEN cntl.province_eng = 'Oudomxay' AND cntl.district_eng = 'La' THEN 'Oudomxay'
		WHEN cntl.province_eng = 'Oudomxay' AND cntl.district_eng = 'Na Mo' THEN 'Oudomxay'
		WHEN cntl.province_eng = 'Oudomxay' AND cntl.district_eng = 'Nga' THEN 'Oudomxay'
		WHEN cntl.province_eng = 'Oudomxay' AND cntl.district_eng = 'Beng' THEN 'Hoon'
		WHEN cntl.province_eng = 'Oudomxay' AND cntl.district_eng = 'Houne' THEN 'Hoon'
		WHEN cntl.province_eng = 'Oudomxay' AND cntl.district_eng = 'Pak Beng' THEN 'Hoon'
		WHEN cntl.province_eng = 'Phongsaly' AND cntl.district_eng = 'May' THEN 'Phongsary'
		WHEN cntl.province_eng = 'Phongsaly' AND cntl.district_eng = 'Khoua' THEN 'Phongsary'
		WHEN cntl.province_eng = 'Phongsaly' AND cntl.district_eng = 'Samphanh' THEN 'Phongsary'
		WHEN cntl.province_eng = 'Phongsaly' AND cntl.district_eng = 'Boun Neua' THEN 'Phongsary'
		WHEN cntl.province_eng = 'Phongsaly' AND cntl.district_eng = 'Yot Ou' THEN 'Phongsary'
		WHEN cntl.province_eng = 'Phongsaly' AND cntl.district_eng = 'Boun Tay' THEN 'Phongsary'
		WHEN cntl.province_eng = 'Phongsaly' AND cntl.district_eng = 'Phongsaly' THEN 'Phongsary'
		WHEN cntl.province_eng = 'Saravane' AND cntl.district_eng = 'Saravanh' THEN 'Salavan'
		WHEN cntl.province_eng = 'Saravane' AND cntl.district_eng = 'Ta Oy' THEN 'Salavan'
		WHEN cntl.province_eng = 'Saravane' AND cntl.district_eng = 'Toumlane' THEN 'Salavan'
		WHEN cntl.province_eng = 'Saravane' AND cntl.district_eng = 'Lakhonepheng' THEN 'Khongxedone'
		WHEN cntl.province_eng = 'Saravane' AND cntl.district_eng = 'Vapy' THEN 'Khongxedone'
		WHEN cntl.province_eng = 'Saravane' AND cntl.district_eng = 'Khongsedone' THEN 'Khongxedone'
		WHEN cntl.province_eng = 'Saravane' AND cntl.district_eng = 'Lao Ngam' THEN 'Salavan'
		WHEN cntl.province_eng = 'Saravane' AND cntl.district_eng = 'Sa Mouay' THEN 'Salavan'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Kaysone Phomvihane' THEN 'Savannakhet'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Outhoumphone' THEN 'Savannakhet'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Atsaphangthong' THEN 'Atsaphangthong'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Phine' THEN 'Phine'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Seponh' THEN 'Phine'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Nong' THEN 'Phine'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Thapangthong' THEN 'Songkhone'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Songkhone' THEN 'Songkhone'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Champhone' THEN 'Savannakhet'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Xayboury' THEN 'Savannakhet'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Viraboury' THEN 'Phine'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Assaphone' THEN 'Atsaphangthong'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Xonnabouly' THEN 'Savannakhet'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Phalanxay' THEN 'Atsaphangthong'
		WHEN cntl.province_eng = 'Savanakhet' AND cntl.district_eng = 'Xayphouthong' THEN 'Songkhone'
		WHEN cntl.province_eng = 'Vientiane Capital' AND cntl.district_eng = 'Chanthabuly' THEN 'Head office'
		WHEN cntl.province_eng = 'Vientiane Capital' AND cntl.district_eng = 'Sikhottabong' THEN 'Sikhottabong'
		WHEN cntl.province_eng = 'Vientiane Capital' AND cntl.district_eng = 'Xaysetha' THEN 'Head office'
		WHEN cntl.province_eng = 'Vientiane Capital' AND cntl.district_eng = 'Sisattanak' THEN 'Head office'
		WHEN cntl.province_eng = 'Vientiane Capital' AND cntl.district_eng = 'Naxaythong' THEN 'Naxaiythong'
		WHEN cntl.province_eng = 'Vientiane Capital' AND cntl.district_eng = 'Xaythany' THEN 'Xaythany'
		WHEN cntl.province_eng = 'Vientiane Capital' AND cntl.district_eng = 'Hadxayfong' THEN 'Hadxaifong'
		WHEN cntl.province_eng = 'Vientiane Capital' AND cntl.district_eng = 'Sangthong' THEN 'Naxaiythong'
		WHEN cntl.province_eng = 'Vientiane Capital' AND cntl.district_eng = 'Parkngum' THEN 'Mayparkngum'
		WHEN cntl.province_eng = 'Vientiane Province' AND cntl.district_eng = 'Phonhong' THEN 'Vientiane province'
		WHEN cntl.province_eng = 'Vientiane Province' AND cntl.district_eng = 'Thoulakhom' THEN 'Thoulakhom'
		WHEN cntl.province_eng = 'Vientiane Province' AND cntl.district_eng = 'Keo Oudom' THEN 'Thoulakhom'
		WHEN cntl.province_eng = 'Vientiane Province' AND cntl.district_eng = 'Kasy' THEN 'Vangvieng'
		WHEN cntl.province_eng = 'Vientiane Province' AND cntl.district_eng = 'Vangvieng' THEN 'Vangvieng'
		WHEN cntl.province_eng = 'Vientiane Province' AND cntl.district_eng = 'Feuang' THEN 'Feuang'
		WHEN cntl.province_eng = 'Vientiane Province' AND cntl.district_eng = 'Xanakharm' THEN 'Xanakharm'
		WHEN cntl.province_eng = 'Vientiane Province' AND cntl.district_eng = 'Mad' THEN 'Xanakharm'
		WHEN cntl.province_eng = 'Vientiane Province' AND cntl.district_eng = 'Hinhurp' THEN 'Vientiane province'
		WHEN cntl.province_eng = 'Vientiane Province' AND cntl.district_eng = 'Viengkham' THEN 'Vientiane province'
		WHEN cntl.province_eng = 'Vientiane Province' AND cntl.district_eng = 'Mune' THEN 'Feuang'
		WHEN cntl.province_eng = 'Xayaboury' AND cntl.district_eng = 'Xaiyabuly' THEN 'Xainyabuli'
		WHEN cntl.province_eng = 'Xayaboury' AND cntl.district_eng = 'Khop' THEN 'Hongsa'
		WHEN cntl.province_eng = 'Xayaboury' AND cntl.district_eng = 'Hongsa' THEN 'Hongsa'
		WHEN cntl.province_eng = 'Xayaboury' AND cntl.district_eng = 'Ngeun' THEN 'Hongsa'
		WHEN cntl.province_eng = 'Xayaboury' AND cntl.district_eng = 'Xienghone' THEN 'Hongsa'
		WHEN cntl.province_eng = 'Xayaboury' AND cntl.district_eng = 'Phiang' THEN 'Xainyabuli'
		WHEN cntl.province_eng = 'Xayaboury' AND cntl.district_eng = 'Parklai' THEN 'Parklai'
		WHEN cntl.province_eng = 'Xayaboury' AND cntl.district_eng = 'Kenethao' THEN 'Parklai'
		WHEN cntl.province_eng = 'Xayaboury' AND cntl.district_eng = 'Botene' THEN 'Parklai'
		WHEN cntl.province_eng = 'Xayaboury' AND cntl.district_eng = 'Thongmyxay' THEN 'Parklai'
		WHEN cntl.province_eng = 'Xayaboury' AND cntl.district_eng = 'Xaysathan' THEN 'Xainyabuli'
		WHEN cntl.province_eng = 'Xaysomboune' AND cntl.district_eng = 'Anouvong' THEN 'Xaisomboun'
		WHEN cntl.province_eng = 'Xaysomboune' AND cntl.district_eng = 'Longchaeng' THEN 'Xaisomboun'
		WHEN cntl.province_eng = 'Xaysomboune' AND cntl.district_eng = 'Longxan' THEN 'Xaisomboun'
		WHEN cntl.province_eng = 'Xaysomboune' AND cntl.district_eng = 'Hom' THEN 'Xaisomboun'
		WHEN cntl.province_eng = 'Xaysomboune' AND cntl.district_eng = 'Thathom' THEN 'Xaisomboun'
		WHEN cntl.province_eng = 'Sekong' AND cntl.district_eng = 'La Mam' THEN 'Sekong'
		WHEN cntl.province_eng = 'Sekong' AND cntl.district_eng = 'Kaleum' THEN 'Sekong'
		WHEN cntl.province_eng = 'Sekong' AND cntl.district_eng = 'Dak Cheung' THEN 'Sekong'
		WHEN cntl.province_eng = 'Sekong' AND cntl.district_eng = 'Tha Teng' THEN 'Sekong'
		WHEN cntl.province_eng = 'Xiengkhuang' AND cntl.district_eng = 'Paek' THEN 'Xiengkhouang'
		WHEN cntl.province_eng = 'Xiengkhuang' AND cntl.district_eng = 'Kham' THEN 'Kham'
		WHEN cntl.province_eng = 'Xiengkhuang' AND cntl.district_eng = 'Nong Het' THEN 'Kham'
		WHEN cntl.province_eng = 'Xiengkhuang' AND cntl.district_eng = 'Khoune' THEN 'Khoune'
		WHEN cntl.province_eng = 'Xiengkhuang' AND cntl.district_eng = 'Mok' THEN 'Khoune'
		WHEN cntl.province_eng = 'Xiengkhuang' AND cntl.district_eng = 'Phou Kout' THEN 'Xiengkhouang'
		WHEN cntl.province_eng = 'Xiengkhuang' AND cntl.district_eng = 'Phaxay' THEN 'Xiengkhouang'
		else fd.branch_name
	end
where cntl.province_eng != '' or cntl.branch_name is null;



-- ____________________________________ Export to report source all that not yet call last month ____________________________________ --
select * , count(*) from
	(
	select  cntl.branch_name , cntl.province_eng , cntl.`type` , fd.category , fd.category2 ,
		case when cntl.province_eng is not null and cntl.district_eng is not null and cntl.village is not null then 'have_address' else 'no_address' end `address`,
		case when fd.category = '①GOVERNMENT' then 'business_owner' else 'no' end `business_owner`,
		case when cntl.maker is not null or cntl.model is not null then 'have_car' else 'no_car' end `car_info`,
		case when cntl.remark_3 = 'contracted' then 'contracted'
			when cntl.remark_3 = 'ringi_not_contract' then 'ringi_not_contract'
			when cntl.remark_3 = 'aseet_not_contract' then 'aseet_not_contract'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C') then 'prospect_sabc'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('F') then 'prospect_f'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('G','G1','G2') then 'prospect_g'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('X') then 'contracted'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED' then 'ANSWERED'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'NO ANSWER' then 'NO ANSWER'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_active' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_inactive' then 'Telecom_inactive'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_success' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_Failed' then 'Telecom_inactive'
			else cntl.remark_3 
		end `result` 
	from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
	where cntl.id in (select id from contact_for_202301_lcc where status_updated is not null) -- to export the rank F & G the SMS success
	) t
group by branch_name , province_eng , `type` , category , category2 , `address`, `car_info`, `result` ;


-- ____________________________________ Export to report each telecom ____________________________________ --
select * , count(*) from
	(
	select case when CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190302', '1290202') then 'ETL'
			when CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190305', '1290205') then 'LTC'
			when CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190307', '1290207') then 'Beeline'
			when CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1290202','1290208') then 'Besttelecom'
			when CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190304', '1190309', '1290209') then 'Unitel'
		end `telecom`,
		left( contact_no, 4) `numbers`,
	case when cntl.remark_3 = 'contracted' then 'contracted'
			when cntl.remark_3 = 'ringi_not_contract' then 'ringi_not_contract'
			when cntl.remark_3 = 'aseet_not_contract' then 'aseet_not_contract'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C') then 'prospect_sabc'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('F') then 'prospect_f'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('G','G1','G2') then 'prospect_g'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('X') then 'contracted'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED' then 'ANSWERED'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'NO ANSWER' then 'NO ANSWER'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_active' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_inactive' then 'Telecom_inactive'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_success' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_Failed' then 'Telecom_inactive'
			else cntl.remark_3 
		end `result` 
	from contact_numbers_to_lcc cntl 
		) t
group by `telecom`, `numbers`, `result` ;


-- ____________________________________ Export to report source all telecom check ____________________________________ --
select * , count(*) from
	(
	select  cntl.branch_name , cntl.province_eng , cntl.`type` , fd.category , fd.category2 ,
		case when cntl.province_eng is not null and cntl.district_eng is not null and cntl.village is not null then 'have_address' else 'no_address' end `address`,
		case when fd.category = '①GOVERNMENT' then 'business_owner' else 'no' end `business_owner`,
		case when cntl.maker is not null or cntl.model is not null then 'have_car' else 'no_car' end `car_info`,
		case when cntl.remark_3 = 'contracted' then 'contracted'
			when cntl.remark_3 = 'ringi_not_contract' then 'ringi_not_contract'
			when cntl.remark_3 = 'aseet_not_contract' then 'aseet_not_contract'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C') then 'prospect_sabc'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('F') then 'prospect_f'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('G','G1','G2') then 'prospect_g'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('X') then 'contracted'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED' then 'ANSWERED'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'NO ANSWER' then 'NO ANSWER'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_active' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_inactive' then 'Telecom_inactive'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_success' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_Failed' then 'Telecom_inactive'
			else cntl.remark_3 
		end `result` 
	from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
	where cntl.id in (select id from temp_sms_chairman tean where status = 1 ) -- SMS check
		or cntl.id in (select id from temp_etl_active_numbers tean2 ) -- ETL active
	) t
group by branch_name , province_eng , `type` , category , category2 , `address`, `car_info`, `result` ;


-- ____________________________________ Export to report source all SMS success and ETL active ____________________________________ --
select * , count(*) from
	(
	select  cntl.branch_name , cntl.province_eng , cntl.`type` , fd.category , fd.category2 ,
		case when cntl.province_eng is not null and cntl.district_eng is not null and cntl.village is not null then 'have_address' else 'no_address' end `address`,
		case when fd.category = '①GOVERNMENT' then 'business_owner' else 'no' end `business_owner`,
		case when cntl.maker is not null or cntl.model is not null then 'have_car' else 'no_car' end `car_info`,
		case when cntl.remark_3 = 'contracted' then 'contracted'
			when cntl.remark_3 = 'ringi_not_contract' then 'ringi_not_contract'
			when cntl.remark_3 = 'aseet_not_contract' then 'aseet_not_contract'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C') then 'prospect_sabc'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('F') then 'prospect_f'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('G','G1','G2') then 'prospect_g'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('X') then 'contracted'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED' then 'ANSWERED'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'NO ANSWER' then 'NO ANSWER'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_active' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_inactive' then 'Telecom_inactive'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_success' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_Failed' then 'Telecom_inactive'
			else cntl.remark_3 
		end `result` 
	from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
	 where cntl.id in (select id from temp_sms_chairman tean where status = 1) -- to export the rank F & G the SMS success
	 	or cntl.id in (select id from temp_etl_active_numbers tean2 ) -- ETL active
	) t
group by branch_name , province_eng , `type` , category , category2 , `address`, `car_info`, `result` ;



-- ____________________________________ Export to report SMS status ____________________________________ --
select date_created, telecom, old_status , status , count(*) 
from temp_sms_chairman -- where date_updated >= '2022-09-01' 
group by date_created, telecom, old_status, status ;

-- ____________________________________ Export to report Pending for SMS checking ____________________________________ --
select case when CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190302', '1290202') then 'ETL'
		when CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190305', '1290205') then 'LTC'
		when CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190307', '1290207') then 'Beeline'
		when CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1290208') then 'Besttelecom'
		when CONCAT(LENGTH(contact_no), left( contact_no, 5)) in ('1190304', '1190309', '1290209') then 'Unitel'
	end `telecom`,
	count(case when status in ('F') then 1 end) 'F',
	count(case when status in ('G','G1','G2') then 1 end) 'G',
	count(case when status is null then 1 end) 'null'
from contact_numbers_to_lcc 
where (status is null or status in ('F','G','G1','G2')) and id not in (select id from temp_sms_chairman) --  where status in (1,2)
	and CONCAT(LENGTH(contact_no), left( contact_no, 5)) not in ('1190302', '1290202') 
group by telecom;



/* ___________________________ Order 2023-01-13 update 2024-05-04 ___________________________ */
-- 1_) Sales partner list
select fd.id, null 'G-Dept', null 'Branch', null 'Department', null 'Unit', null 'Staff Status', fd.staff_no , fd.staff_name, fd.staff_tel , 
	concat(fd.broker_name, ' ',fd.broker_tel) 'broker_key', fd.broker_name, fd.broker_tel, fd.company_name , fd.category2, fd.category, fd.`type`, fd.date_received,
	cn.`numbers_of_original`, icn.`numbers_of_invalid`, aucn.`numbers_of_unique`, p.`numbers_of_payment`, cntl.`numbers_of_contracted`
from file_details fd 
left join (select file_id, count(*) `numbers_of_original` from contact_numbers group by file_id ) cn on (fd.id = cn.file_id)
left join (select file_id, count(*) `numbers_of_invalid` from invalid_contact_numbers icn group by file_id ) icn on (fd.id = icn.file_id)
left join (select file_id, count(*) `numbers_of_unique` from all_unique_contact_numbers aucn group by file_id ) aucn on (fd.id = aucn.file_id)
left join (select file_id, count(*) `numbers_of_payment` from payment p group by file_id ) p on (fd.id = p.file_id)
left join (select file_id, count(*) `numbers_of_contracted` from contact_numbers_to_lcc where remark_3 = 'contracted' or (remark_3 in ('prospect_sabc') and status in ('X')) group by file_id ) cntl on (fd.id = cntl.file_id)
order by id desc;



-- 5 Draft: Add the numbers for table file_details 
select fd.id, cn.`numbers`, icn.`numbers`, aucn.`numbers`, p.`numbers`
from file_details fd 
left join (select file_id, count(*) `numbers` from contact_numbers group by file_id ) cn on (fd.id = cn.file_id)
left join (select file_id, count(*) `numbers` from invalid_contact_numbers icn group by file_id ) icn on (fd.id = icn.file_id)
left join (select file_id, count(*) `numbers` from all_unique_contact_numbers aucn group by file_id ) aucn on (fd.id = aucn.file_id)
left join (select file_id, count(*) `numbers` from payment p group by file_id ) p on (fd.id = p.file_id)


-- 6) Count number with name, address and car info
select *, count(*)  from (
select 
	fd.id `file_id`, concat(fd.broker_name, ' ', fd.broker_tel) `broker_key`, fd.branch_name, fd.`type` , fd.category , fd.date_received, fd.company_name ,
	concat( 
	case when cntl.name != '' then 1 else 0 end , -- customer name
	case when ((cntl.province_eng != '' or cntl.province_laos != '') and (cntl.district_eng != '' or cntl.district_laos != '') and cntl.village != '') != '' then 1 else 0 end , -- address
	case when (cntl.maker != '' or cntl.model != '' or cntl.`year` != '') != '' then 1 else 0 end -- car
		) `code`
from file_details fd left join contact_numbers cntl on (fd.id = cntl.file_id)
) t
group by file_id, code;


-- Hattori request for Yoshi -- ative
select *, count(*) from 
	(
select 
	case when cntl.maker != '' or cntl.model != '' then 'have_car' end `have_car`,
	case when fd.category = '①GOVERNMENT' then 'business_owner' end `business_owner`,
	case when cntl.province_eng != '' and cntl.district_eng != '' and cntl.village != '' then 'have_address' end `have_address`,
	case when cntl.remark_3 = 'contracted' then 'contracted'
			when cntl.remark_3 = 'ringi_not_contract' then 'ringi_not_contract'
			when cntl.remark_3 = 'aseet_not_contract' then 'aseet_not_contract'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C') then 'prospect_sabc'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('F') then 'prospect_f'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('G','G1','G2') then 'prospect_g'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('X') then 'contracted'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED' then 'ANSWERED'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'NO ANSWER' then 'NO ANSWER'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_active' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_inactive' then 'Telecom_inactive'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_success' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_Failed' then 'Telecom_inactive'
			else cntl.remark_3 
		end `result` 
from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
where cntl.id in (select id from temp_sms_chairman tean where status = 1) -- to export the rank F & G the SMS success
	 	or cntl.id in (select id from temp_etl_active_numbers tean2 ) -- ETL active
) t
group by `have_car`, `business_owner`, `have_address`, `result`;


-- Hattori request for Yoshi -- all source
select *, count(*) from 
	(
select 
	case when cntl.maker != '' or cntl.model != '' then 'have_car' end `have_car`,
	case when fd.category = '①GOVERNMENT' then 'business_owner' end `business_owner`,
	case when cntl.province_eng != '' and cntl.district_eng != '' and cntl.village != '' then 'have_address' end `have_address`,
	case when cntl.remark_3 = 'contracted' then 'contracted'
			when cntl.remark_3 = 'ringi_not_contract' then 'ringi_not_contract'
			when cntl.remark_3 = 'aseet_not_contract' then 'aseet_not_contract'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('S','A','B','C') then 'prospect_sabc'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('F') then 'prospect_f'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('G','G1','G2') then 'prospect_g'
			when cntl.remark_3 = 'prospect_sabc' and cntl.status in ('X') then 'contracted'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED' then 'ANSWERED'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'NO ANSWER' then 'NO ANSWER'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_active' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_inactive' then 'Telecom_inactive'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_success' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_Failed' then 'Telecom_inactive'
			else cntl.remark_3 
		end `result` 
from contact_numbers_to_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
) t
group by `have_car`, `business_owner`, `have_address`, `result`;



-- ____________________________________ Export to report original soure update 2023-04-05 ____________________________________ -- 
select * , count(*) from 
	(
	select  cntl.province_eng , cntl.`type` , fd.category , fd.category2, fd.date_received, cntl.remark_1 `priority`, null `condition`,
		case when cntl.province_eng is not null and cntl.district_eng is not null and cntl.village is not null then 'have_address' else 'no_address' end `address`,
		case when fd.category = '①GOVERNMENT' then 'business_owner' else 'no' end `business_owner`,
		case when cntl.maker is not null or cntl.model is not null then 'have_car' else 'no_car' end `car_info`,
		case when cntl.name is not null or cntl.name != '' then 'have_name' else 'no_name' end `name_info`
	from contact_numbers cntl left join file_details fd on (fd.id = cntl.file_id)
	) t
group by  province_eng , `type` , category , category2, date_received, `priority`, `condition`, `address`, `business_owner`, `car_info`, `name_info` ;





-- ____________________________________ Export to report source monthly update 2025-02-12 ____________________________________ -- 
select * , count(*) from 
	(
	select  cntl.branch_name , cntl.province_eng , cntl.`type` , fd.category , 
		case when cntl.`type` = 'prospect' then cntl.status else fd.category2 end `category2`, 
		case when cntl.`type` = 'prospect' then '2023-08-01' else fd.date_received end `date_received`, 
		cntl.remark_1 `priority`, cntl.`condition`,
		case when cntl.province_eng is not null and cntl.district_eng is not null and cntl.village is not null then 'have_address' else 'no_address' end `address`,
		case when fd.category = '①GOVERNMENT' then 'business_owner' else 'no' end `business_owner`,
		case when cntl.maker is not null or cntl.model is not null then 'have_car' else 'no_car' end `car_info`,
		case when cntl.name is not null or cntl.name != '' then 'have_car' else 'no_car' end `name_info`,
		case when cntl.remark_3 = 'contracted' then 'contracted'
			when cntl.remark_3 = 'ringi_not_contract' then 'ringi_not_contract'
			when cntl.remark_3 = 'aseet_not_contract' then 'aseet_not_contract'
			when cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('S','A','B','C') then 'prospect_sabc'
			when cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('F') then 'prospect_f'
			when cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('G','G1','G2') then 'prospect_g'
			when cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('X') then 'contracted'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED' then 'ANSWERED'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'NO ANSWER' then 'NO ANSWER'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_active' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_inactive' then 'Telecom_inactive'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_success' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_Failed' then 'Telecom_inactive'
			when cntl.remark_3 = 'lcc' and cntl.status = 'Block need_to_block' then 'Block need_to_block'
			when cntl.remark_3 = 'lcc' and cntl.status = 'FF1 not_answer' then 'FF1 not_answer'
			when cntl.remark_3 = 'lcc' and cntl.status = 'FF2 power_off' then 'FF2 power_off'
			when cntl.remark_3 = 'lcc' and cntl.status in ('FFF can_not_contact', 'No have in telecom') then 'FFF can_not_contact'
			else cntl.remark_3 
		end `result`,
		case when cntl.remark_2 = 'contracted' and cntl.status_updated in ('Active', 'Refinance') then 'contracted'
			when cntl.remark_2 = 'contracted' and cntl.status_updated in ('Closed') then 'prospect_f'
			when cntl.remark_2 = 'ringi_not_contract' then 'ringi_not_contract'
			when cntl.remark_2 = 'aseet_not_contract' then 'aseet_not_contract'
			when cntl.remark_2 in ('prospect_sabc', 'lcc') and cntl.status_updated in ('S') then 'prospect_s'
			when cntl.remark_2 in ('prospect_sabc', 'lcc') and cntl.status_updated in ('A') then 'prospect_a'
			when cntl.remark_2 in ('prospect_sabc', 'lcc') and cntl.status_updated in ('B') then 'prospect_b'
			when cntl.remark_2 in ('prospect_sabc', 'lcc') and cntl.status_updated in ('C') then 'prospect_c'
			when cntl.remark_2 in ('prospect_sabc', 'lcc') and cntl.status_updated in ('F') then 'prospect_f'
			when cntl.remark_2 in ('prospect_sabc', 'lcc') and cntl.status_updated in ('G','G1','G2') then 'prospect_g'
			when cntl.remark_2 in ('prospect_sabc') and cntl.status_updated in ('X') then 'contracted'
			when cntl.remark_2 in ('lcc') and cntl.status_updated in ('X') then 'prospect_f' -- because there're wrong
			when cntl.remark_2 = 'pbx_cdr' and cntl.status_updated = 'ANSWERED' then 'ANSWERED'
			when cntl.remark_2 = 'pbx_cdr' and cntl.status_updated = 'NO ANSWER' then 'NO ANSWER'
			when cntl.remark_2 = 'Telecom' and cntl.status_updated = 'ETL_active' then 'Telecom_active'
			when cntl.remark_2 = 'Telecom' and cntl.status_updated = 'ETL_inactive' then 'Telecom_inactive'
			when cntl.remark_2 = 'Telecom' and cntl.status_updated = 'SMS_success' then 'Telecom_active'
			when cntl.remark_2 = 'Telecom' and cntl.status_updated = 'SMS_Failed' then 'Telecom_inactive'
			when cntl.remark_2 = 'lcc' and cntl.status_updated = 'Block need_to_block' then 'Block need_to_block'
			when cntl.remark_2 = 'lcc' and cntl.status_updated = 'FF1 not_answer' then 'FF1 not_answer'
			when cntl.remark_2 = 'lcc' and cntl.status_updated = 'FF2 power_off' then 'FF2 power_off'
			when cntl.remark_2 = 'lcc' and cntl.status_updated in ('FFF can_not_contact', 'No have in telecom') then 'FFF can_not_contact'
			else cntl.remark_2 
		end `new_result`,
		case when cntl2.date_updated >= '2024-11-01' then '3 months less'
			else 'over 3 months'
		end `called_in`
	from contact_for_202502_lcc cntl left join file_details fd on (fd.id = cntl.file_id)
	left join contact_numbers_to_lcc cntl2 on (cntl2.id = cntl.id)
	) t
group by branch_name ,  province_eng , `type` , category , category2 , date_received, `priority`, `condition`, `address`, `business_owner`, `car_info`,`name_info` , `result`, `new_result`, `called_in` ;



-- ____________________________________ Export to report all valid source update 2024-02-20 ____________________________________ -- 
select * , count(*) from 
	(
	select  cntl.branch_name , cntl.province_eng , cntl.`type` , fd.category , fd.category2, fd.date_received, cntl.remark_1 `priority`, null `condition`,
		case when cntl.province_eng is not null and cntl.district_eng is not null and cntl.village is not null then 'have_address' 
			when cntl.province_eng is not null and cntl.district_eng is not null then 'only province & district' 
			when cntl.province_eng is not null then 'only province' 
			else 'no_address' 
		end `address`,
		case when fd.category = '①GOVERNMENT' then 'business_owner' else 'no' end `business_owner`,
		case when cntl.maker is not null or cntl.model is not null then 'have_car' else 'no_car' end `car_info`,
		case when cntl.name is not null or cntl.name != '' then 'have_name' else 'no_name' end `name_info`,
		case when cntl.remark_3 = 'contracted' then 'contracted'
			when cntl.remark_3 = 'ringi_not_contract' then 'ringi_not_contract'
			when cntl.remark_3 = 'aseet_not_contract' then 'aseet_not_contract'
			when cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('S','A','B','C') then 'prospect_sabc'
			when cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('F','SP will be salespartner') then 'prospect_f'
			when cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('G','G1','G2') then 'prospect_g'
			when cntl.remark_3 in ('prospect_sabc') and cntl.status in ('X') then 'contracted'
			when cntl.remark_3 in ('lcc') and cntl.status in ('X') then 'prospect_f' -- because there're wrong
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED' then 'ANSWERED'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'NO ANSWER' then 'NO ANSWER'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_active' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_inactive' then 'Telecom_inactive'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_success' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_Failed' then 'Telecom_inactive'
			when cntl.remark_3 = 'lcc' and cntl.status = 'Block need_to_block' then 'Block need_to_block'
			when cntl.remark_3 = 'lcc' and cntl.status = 'FF1 not_answer' then 'FF1 not_answer'
			when cntl.remark_3 = 'lcc' and cntl.status = 'FF2 power_off' then 'FF2 power_off'
			when cntl.remark_3 = 'lcc' and cntl.status in ('FFF can_not_contact', 'No have in telecom') then 'FFF can_not_contact'
			else cntl.remark_3 
		end `result`
	from contact_numbers_to_lcc cntl inner join file_details fd on (fd.id = cntl.file_id)
	where (cntl.remark_3 in ('contracted', 'ringi_not_contract', 'aseet_not_contract') ) -- already register on LMS
		or (cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('X','S','A','B','C', 'FF1 not_answer', 'FF2 power_off') ) -- already register on CRM and LCC
		or (cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED') -- Ever Answered in the past
		or (cntl.remark_3 = 'Telecom' and cntl.status in ('ETL_active', 'SMS_success') ) -- Ever sent SMS and success
		or cntl.status is null -- new number
		or cntl.contact_id in (select contact_id from temp_sms_chairman tean where status = 1 ) -- SMS check
		or cntl.contact_id in (select contact_id from temp_etl_active_numbers tean2 ) -- ETL active 
	) t
group by branch_name , province_eng , `type` , category , category2 , date_received, `priority`, `condition`, `address`, `business_owner`, `car_info`, `name_info`, `result` ;



-- ____________________________________ Export to report all source update 2023-11-02 ____________________________________ -- 
select * , count(*) from 
	(
	select  cntl.branch_name , cntl.province_eng , cntl.`type` , fd.category , fd.category2, fd.date_received, cntl.remark_1 `priority`, null `condition`,
		case when cntl.province_eng is not null and cntl.district_eng is not null and cntl.village is not null then 'have_address' else 'no_address' end `address`,
		case when fd.category = '①GOVERNMENT' then 'business_owner' else 'no' end `business_owner`,
		case when cntl.maker is not null or cntl.model is not null then 'have_car' else 'no_car' end `car_info`,
		case when cntl.name is not null or cntl.name != '' then 'have_name' else 'no_name' end `name_info`,
		case when cntl.remark_3 = 'contracted' then 'contracted'
			when cntl.remark_3 = 'ringi_not_contract' then 'ringi_not_contract'
			when cntl.remark_3 = 'aseet_not_contract' then 'aseet_not_contract'
			when cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('S','A','B','C') then 'prospect_sabc'
			when cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('F','SP will be salespartner') then 'prospect_f'
			when cntl.remark_3 in ('prospect_sabc', 'lcc') and cntl.status in ('G','G1','G2') then 'prospect_g'
			when cntl.remark_3 in ('prospect_sabc') and cntl.status in ('X') then 'contracted'
			when cntl.remark_3 in ('lcc') and cntl.status in ('X') then 'prospect_f' -- because there're wrong
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'ANSWERED' then 'ANSWERED'
			when cntl.remark_3 = 'pbx_cdr' and cntl.status = 'NO ANSWER' then 'NO ANSWER'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_active' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'ETL_inactive' then 'Telecom_inactive'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_success' then 'Telecom_active'
			when cntl.remark_3 = 'Telecom' and cntl.status = 'SMS_Failed' then 'Telecom_inactive'
			when cntl.remark_3 = 'lcc' and cntl.status = 'Block need_to_block' then 'Block need_to_block'
			when cntl.remark_3 = 'lcc' and cntl.status = 'FF1 not_answer' then 'FF1 not_answer'
			when cntl.remark_3 = 'lcc' and cntl.status = 'FF2 power_off' then 'FF2 power_off'
			when cntl.remark_3 = 'lcc' and cntl.status in ('FFF can_not_contact', 'No have in telecom') then 'FFF can_not_contact'
			else cntl.remark_3 
		end `result`
	from contact_numbers_to_lcc cntl inner join file_details fd on (fd.id = cntl.file_id)
	) t
group by branch_name , province_eng , `type` , category , category2 , date_received, `priority`, `condition`, `address`, `business_owner`, `car_info`, `name_info`, `result` ;




--  and check data
select remark_2, status_updated, count(*) from contact_for_202305_lcc cntl  group by remark_2, status_updated 
order by field(remark_2, "contracted", "ringi_not_contract", "aseet_not_contract",
			"prospect_sabc", "pbx_cdr", "lcc") ,
		FIELD(`status_updated` , "Active", "Closed", "Refinance", "Disbursement Approval", "Pending Disbursement", "Pending Approval", "Pending",
		"Approved", "Pending Approval from Credit", "Asset Assessed", "Pending Assessment", "Draft", "Cancelled", "Deleted",
		"X", "S", "A", "B", "C", "F", "G", "G1", "G2", "SP will be salespartner", "ANSWERED", 
		"NO ANSWER", "Block need_to_block", "FF1 not_answer", "FF2 power_off", "FFF can_not_contact", "No have in telecom") ;



-- COO Yoshi requests How many call time from each number separate by category (0 time, less 5 times, less 10 times, over 10 times)
select *, count(*) from 
(
select fd.`type`, fd.category, fd.category2, 
	case when cntl.`condition` = 0 then '①0 time'
		when cntl.`condition` <= 5 then '②less 5 times'
		when cntl.`condition` <= 10 then '③less 10 times'
		when cntl.`condition` > 10 then '④over 10 times'
	end `call_time_type`
from file_details fd inner join contact_for_202403_lcc cntl on (fd.id = cntl.file_id)
) t
group by `type`, category, category2, `call_time_type`;


select fd.`type`, fd.category, fd.category2, cntl.condition `call_time_type`, count(*) 
from file_details fd inner join contact_for_202403_lcc cntl on (fd.id = cntl.file_id)
group by `type`, category, category2, cntl.condition;














