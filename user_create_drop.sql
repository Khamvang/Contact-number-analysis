
SELECT CURRENT_USER(), SCHEMA();

#=========== check and fix Reason: SQL Error [1292] [22001]: Data truncation: Incorrect date value: '0000-00-00' for column `test`.`tbl collection`.`transfer date` at row 1 ======
select @@global.sql_mode global, @@session.sql_mode session;
set sql_mode = '', global sql_mode = '';

#============ Fix reference key ============
SET FOREIGN_KEY_CHECKS=OFF;
SET FOREIGN_KEY_CHECKS=ON;

#convert varcher to int 
select cast('2.5' as unsigned); -- mysql server
select cast('2.5' as int); -- xampp server

#============ REGEXP_REPLACE to get number from string =============
SELECT REGEXP_REPLACE('deddf2484521584sda,.;eds2', '[^[:digit:]]', '') "REGEXP_REPLACE";



#================ END Create database for lalco pbx ===================

#============ Calculate days months years from two date ===========
SELECT DATEDIFF('2036-03-01', '2036-01-28');
SELECT TIMESTAMPDIFF(DAY,'2009-06-18','2009-07-29'); 
SELECT TIMESTAMPDIFF(MONTH,'2009-06-18','2009-07-29'); 
SELECT TIMESTAMPDIFF(YEAR,'2008-06-18','2009-07-29'); 

#============== Create user to access the mysql database PC 3floor ===============
create user 'admin'@'172.16.40.190' IDENTIFIED by 'LalcoAdmin';
create user 'admin'@'%' IDENTIFIED by 'LalcoAdmin';
grant all privileges on *.* to 'admin'@'172.16.10.190' with grant option;
grant all privileges on *.* to 'admin'@'%' with grant option;
flush privileges;

#================= Create user to access the mysql database PC server ip:192.168.1.123 and PC i7 IP:  192.168.1.67 =======================
create user 'admin'@'192.168.1.67' identified by 'LalcoAdmin@2021';
create user 'admin'@'%' identified by 'LalcoAdmin@2021';
grant all privileges on *.* to 'admin'@' 192.168.1.67' with grant option; -- when you use with grant option, this user can add grant to all user 
grant all privileges on *.* to 'admin'@'%' with grant option;
flush privileges;

create user 'tou'@'192.168.1.123' identified by 'TouAdmin@2021';
create user 'tou'@'%' identified by 'TouAdmin@2021';
grant all privileges on *.* to 'tou'@' 192.168.1.123';
grant all privileges on *.* to 'tou'@'%';
flush privileges;

create user 'ta'@'192.168.1.67' identified by 'Ta2186@2022';
create user 'ta'@'%' identified by 'Ta2186@2022';
grant create, insert, select,update, delete on *.* to 'ta'@' 192.168.1.67';
grant create, insert, select,update, delete on *.* to 'ta'@'%';
flush privileges;

create user 'thad3457'@'192.168.1.67' identified by 'thad3457@2022';
create user 'thad3457'@'%' identified by 'thad3457@2022';
grant create, insert, select, update, delete on *.* to 'thad3457'@' 192.168.1.67';
grant create, insert, select,update, delete on *.* to 'thad3457'@'%';
flush privileges;


drop user 'keo3228'@'192.168.1.216';
drop user 'keo3228'@'%';

drop user 'ta'@'192.168.1.216';
drop user 'ta'@'%';

drop user 'tou'@'192.168.1.216';
drop user 'tou'@'%';

drop user 'thad3457'@'192.168.1.216';
drop user 'thad3457'@'%';

drop user 'admin'@'192.168.1.216';
drop user 'admin'@'%';

repair table `user`;

select user, host from mysql.user;
SELECT USER(), CURRENT_USER();
SHOW VARIABLES LIKE 'skip_networking';
#=============== End create users ================







