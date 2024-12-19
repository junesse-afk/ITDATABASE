-- [SQL문법] 9. 데이터정의어(DDL) - Table
use hr;

-- 데이터정의어(DDL)란?
-- 객체(object - table, view, index 등)를 생성/수정/삭제하는 명령어
-- Table 관련 DDL : create table, alter table,
--                 drop table, truncate table

-- 9-1. 테이블 생성(create table)
-- [문법] create table 테이블명
--      (컬럼명1 데이터타입(컬럼사이즈),
--       컬럼명2 데이터타입(컬럼사이즈) [제약조건],
--       컬럼명3 데이터타입(컬럼사이즈) [default 기본값],
--       컬럼명n 데이터타입(컬럼사이즈));

-- (1) 데이터타입
-- 문자 - 고정형 : char
--     - 가변형 : varchar
-- 숫자 - 정수형 : int, bigint
--     - 실수형 : float, double
-- 날짜 - 년/월/일 : date
--     - 년/월/일/시/분/초 : datetime

-- dept 테이블 생성 예제
create table dept
(deptno int,
 dname varchar(14),
 loc varchar(13),
 create_date datetime default now());

desc dept;

insert into dept
values (10, 'AAA', 'A100', '2024-10-15 14:30:15');

-- 자동으로 default값 삽입하는 방법
insert into dept(deptno, dname)
values (20, 'BBB');

-- 수동으로 default값 삽입하는 방법
insert into dept
values (30, 'CCC', 'C100', default);

insert into dept
values (40, 'DDD', default, default);

select *
from dept;

-- (2) 제약조건
-- 테이블의 특정 컬럼에 부적합한 데이터가 삽입/수정/삭제되는 것을 막아주는 역할
-- 제약조건 종류 : not null, unique, primary key, foreign key, check

-- [not null] 제약조건
-- 컬럼에 null값이 삽입/수정되는 것을 막아주는 제약조건
-- 필수 컬럼에 선언함.
-- test1 테이블 생성하기
create table test1
(id int not null,
 name varchar(30) not null,
 jumin varchar(13) not null,
 job varchar(20),
 email varchar(20),
 phone varchar(20) not null,
 start_date date);

desc test1;

-- [unique] 제약조건
-- 컬럼에 중복된 데이터가 삽입/수정되는 것을 막아주는 제약조건
-- 고유값(주민번호, 전화번호, 이메일 등)이 들어와야 하는 컬럼에 선언함.
-- test2 테이블 생성하기
create table test2
(id int not null unique,
 name varchar(30) not null,
 jumin varchar(13) not null unique,
 job varchar(20),
 email varchar(20) unique,
 phone varchar(20) not null unique,
 start_date date);

desc test2;

-- [primary key] 제약조건
-- 기본키 제약조건으로 not null과 unique의 성격을 모두 가지는 제약조건
-- pk 제약조건이 선언된 컬럼에는 null값도 안되고, 중복값도 안됨.
-- 단, 테이블당 한번만 선언 가능함!
-- <stu> 테이블 
-- stu_no | stu_name | jumin | level | phone | email| ...
-- ------------------------------------------------------
--   pk		  nn		nn		nn		nn		uk
--   					uk				uk
-- test3 테이블 생성하기
create table test3
(id int primary key,
 name varchar(30) not null,
 jumin varchar(13) not null unique,
 job varchar(20),
 email varchar(20) unique,
 phone varchar(20) not null unique,
 start_date date);
 
desc test3;

-- [foreign key] 제약조건
-- 외래키 제약조건으로 자기 자신 테이블이나 다른 테이블의 특정 컬럼(pk, uk)을 
-- 참조하는 제약조건
-- fk 제약조건이 선언된 컬럼 : 자식 컬럼
-- fk 제약조건이 참조하는 컬럼 : 부모 컬럼
-- 자식 컬럼에는 부모 컬럼의 값 중 하나만 삽입/수정될 수 있는 제약조건
-- test4 테이블 생성하기
create table test4
(t_num int primary key,
 t_id int,
 title varchar(20) not null,
 story varchar(100) not null,
 foreign key(t_id) references test3(id));
 
desc test4;
 
-- [check] 제약조건
-- 해당 컬럼이 만족해야하는 조건문을 자유롭게 지정할 수 있는 제약조건
-- (예1) salary int check(salary > 0)
-- (예2) jumin char(13) check(length(jumin) = 13)
-- (예3) grade int check(grade between 1 and 4)
-- (예4) 성별 varchar(10) check(성별 in ('남', '여'))
-- test5 테이블 생성하기
create table test5
(id int(10) primary key,
 name varchar(30) not null,
 jumin varchar(13) not null unique check(length(jumin)=13),
 job varchar(20),
 email varchar(20) unique,
 phone varchar(20) not null unique,
 start_date date check(start_date >= '2005-01-01'));
 
desc test5;

-- (3) DB 사전을 사용해서 Table의 제약조건 정보 조회하기
-- DB 사전으로 전환하기
show databases;
use information_schema;

-- DB 사전 목록 확인하기
show tables;

-- table_constraints 조회하기
select *
from table_constraints
where table_name = 'test5';

select *
from table_constraints
where table_name = 'employees';

-- check_constraints 조회하기
select *
from check_constraints;

-- key_column_usage 조회하기
select *
from key_column_usage
where table_name = 'employees';

select *
from key_column_usage
where table_name = 'test4';

-- create table + 서브쿼리 활용 예제
-- 기존 테이블을 기반으로 복사본의 테이블이 생성됨.(단, 제약조건은 not null만 복사됨)
-- 테이블 백업 또는 테스트용 테이블 생성 시 활용됨.
create table dept80
as select employee_id, last_name, salary*12 as annsal, hire_date
   from employees
   where department_id = 80;
   
desc dept80;
select *
from dept80;

-- 9-2. 테이블 수정(alter table)
-- alter table 테이블명 add ------; : 컬럼 추가, 제약조건 추가(pk, fk, uk, ck)
-- alter table 테이블명 modify ---; : 컬럼 수정, 제약조건 추가/삭제(not null)
-- alter table 테이블명 drop -----; : 컬럼 삭제, 제약조건 삭제(pk, fk, uk, ck)
-- alter table 테이블명 rename ---; : 컬럼명 수정

-- 1) 컬럼 추가
-- 새롭게 추가된 컬럼은 기본적으로 마지막 컬럼으로 추가됨.
-- 데이터는 자동으로 null값 저장됨.
alter table dept80
add job_id varchar(30);

-- default값이 있는 컬럼은 자동으로 default값 저장됨.
alter table dept80
add email varchar(25) default '미입력';

-- 테이블 가장 앞에 컬럼 추가하는 방법
alter table dept80
add emp_no int first;

-- 특정 컬럼 뒤에 컬럼 추가하는 방법
alter table dept80
add salary int after last_name;

-- 컬럼 추가 시 not null 제약조건이 선언된 경우 데이터타입별 저장되는 데이터 확인
alter table dept80
add phone_number varchar(30) not null;	-- 자동으로 null값 대신 공백 삽입

alter table dept80
add age int not null;					-- 자동으로 null값 대신 0 삽입

SHOW VARIABLES LIKE 'sql_mode';
SET sql_mode = 'no_zero_date';

alter table dept80
add join_date date not null; 	-- 자동으로 null값 대신 0000-00-00 삽입

select *
from dept80;

-- 2) 컬럼 수정(데이터타입, 컬럼사이즈, default값, not null 제약조건)
desc dept80;

-- last_name(varchar(25), not null) -> (varchar(15))
alter table dept80
modify last_name varchar(15);

-- phone_number(varchar(30), not null) -> (char(13), not null)
alter table dept80
modify phone_number char(13) not null;

-- email(varchar(25), default : '미입력') -> (varchar(25), default : '미정')
alter table dept80
modify email varchar(25) default '미정';

insert into dept80
values (null, 180, 'Hong', 3000, 80000, '2024-12-10', null, 
        default, '010-1111-1111', 25);

select *
from dept80;

-- 3) 컬럼 삭제
alter table dept80
drop column annsal;

select *
from dept80;

-- 4) 제약조건 추가
-- [문법1] alter table 테이블명 add --; : pk, uk, ck, fk
alter table dept80
add primary key(employee_id);

alter table dept80
add unique(emp_no);

alter table dept80
add check(salary > 0);

alter table dept80
add foreign key(employee_id) references employees(employee_id);

-- [문법2] alter table 테이블명 modify --; : not null
alter table dept80
modify last_name varchar(15) not null;

desc dept80;

-- 5) 제약조건 삭제
-- [문법1] alter table 테이블명 drop primary key; : pk
alter table dept80
drop primary key;

-- [문법2] alter table 테이블명 drop 제약조건유형 제약조건명; : fk, ck, uk
use information_schema;
select *
from table_constraints
where table_name = 'dept80';    -- fk제약조건명 : dept80_ibfk_1

use hr;
alter table dept80
drop foreign key dept80_ibfk_1;

-- [문법3] alter table 테이블명 modify --; : not null
alter table dept80
modify hire_date date null;

desc dept80;

-- 6) 컬럼명 수정
alter table dept80
rename column last_name to lname;

desc dept80;

-- [참고] 테이블명 수정
rename table dept80 to dept90;
desc dept90;

-- 9-3. 테이블 삭제(drop table)
-- [문법] drop table 테이블명;
-- 테이블의 구조와 데이터가 삭제되는 작업
-- DB로부터 테이블의 존재가 없어짐.
drop table dept90; 
select *
from dept90;		-- 존재하지 않음.

-- 9-4. 테이블 절단(truncate table)
-- [문법] truncate table 테이블명; (==) delete from 테이블명;
-- 테이블의 구조는 남고, 테이블의 모든 행이 삭제되는 작업
truncate table copy_emp;

desc copy_emp;
select *
from copy_emp;