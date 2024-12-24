-- [SQL문법] 10. 데이터정의어(DDL) - View
use hr;

-- Table(테이블) : DB 내 Data를 물리적으로 저장하기 위한 객체
-- 사용방법 : select, insert, update, delete
-- 정의방법 : create table, alter table, 
--          drop table, truncate table

-- View(뷰) : DB 내 Data를 논리적으로 저장하기 위한 객체
-- 사용방법 : select, insert, update, delete
-- 정의방법 : create view, alter view, drop view

-- View(뷰)란?
-- 하나이상의 테이블을 기반으로 생성은 되었으나 물리적으로 존재하지 않고
-- DB 사전에 select 구문 형태로 정의만 되어 있는 가상의 논리적인 테이블
-- 뷰 사용 목적 : 보안성, 공간효율성, 편의성

-- 10-1. 뷰 생성(create view)
-- [문법] create view 뷰명
--       as select 컬럼1, 컬럼2, 컬럼3, ...
--          from 테이블명
--         [where 조건문];

-- empvu80 뷰 생성하기
create view empvu80
as select employee_id, last_name, salary, department_id
   from employees
   where department_id = 80;

desc empvu80;

select *
from empvu80;

-- deptvu 뷰 생성하기
create view deptvu
as select *
   from departments
   where department_id > 200;

desc deptvu;
select *
from deptvu;

-- 뷰를 사용한 DML 작업
insert into deptvu
values (340, 'Test1', 124, 1700);

update deptvu
set location_id = 1700
where department_id = 310;

delete from deptvu
where department_id = 280;

update departments
set manager_id = 125
where department_id = 310;

select *
from deptvu;

select *
from departments;

-- 보안성 예제
use shopdb;
create view member_vu
as select member_id, member_name, birth, job
   from members;
   
select *
from member_vu;

-- 편의성 예제
use hr;
create view dept_sal_vu
as select d.department_name, sum(e.salary) as "급여 합계",
          avg(e.salary) as "급여 평균", min(e.salary) as "최소 급여",
          max(e.salary) as "최대 급여"
   from employees e join departments d
   on e.department_id = d.department_id
   group by d.department_name
   order by d.department_name;
   
select *
from dept_sal_vu;

-- 10-2. 뷰 수정(alter view)
-- [문법] alter view 뷰명
--       as select 컬럼1, 컬럼2, 컬럼3, ...
--          from 테이블명
--         [where 조건문];

alter view empvu80
as select employee_id, last_name, salary, email, department_id
   from employees
   where department_id = 80;
   
select *
from empvu80;

-- 10-3. 뷰 삭제(drop view)
-- [문법] drop view 뷰명;
drop view empvu80;

select *
from empvu80;

select *
from employees
where department_id = 80;

-- 10-4. DB 사전으로부터 View 정보 조회하기
use information_schema;
show tables;
select *
from views
where table_schema = 'hr';