-- [SQL문법] 8. 데이터조작어(DML)
use hr;

-- 데이터조작어(DML)란?
-- 테이블에 데이터를 삽입/수정/삭제하는 명령어
-- DML 종류 : insert, update, delete

-- 8-1. 데이터 삽입(insert)
-- [문법] insert into 테이블명[(컬럼1, 컬럼2, 컬럼3, ...)]
--       values (값1, 값2, 값3, ...);

desc departments;
select *
from departments;

-- 테이블명 뒤에 컬럼리스트 생략 시에는 values절 뒤에 
-- 기본 컬럼 순서대로 모든 값 나열해야함.
insert into departments
values (280, 'Java', 107, 1700);

-- 테이블명 뒤에 컬럼리스트 작성 시에는 values절 뒤의
-- 값리스트와 동일해야함.
insert into departments(department_name, location_id,
                        manager_id, department_id)
values ('Jsp', 1700, 108, 290);

-- null값을 자동으로(암시적) 삽입하는 방법
insert into departments(department_id, department_name)
values (300, 'MySQL');

-- null값을 수동으로(명시적) 삽입하는 방법
insert into departments
values (310, 'Oracle', null, null);

-- 다중행 삽입하기
insert into departments
values (320, 'HTML', null, 1700),
       (330, 'CSS', 200, null);

select *
from departments
order by department_id desc;

-- insert + 서브쿼리 예제
-- 다른 테이블로부터 데이터를 복사해서 삽입하는 작업을 의미함.
-- copy_emp 테이블 생성하기(employees 테이블과 동일 구조를 가져야함.)
create table copy_emp
     select *
     from employees
     where 1=2;

desc copy_emp;
select *
from copy_emp;
     
-- copy_emp 테이블로 employees 테이블의 107명 사원 정보 가져오기
insert into copy_emp
	select *
    from employees;

select *
from copy_emp;