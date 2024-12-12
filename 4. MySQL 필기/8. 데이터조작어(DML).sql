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

-- 8-2. 데이터 수정(update)
-- [문법] update 테이블명
--       set 컬럼명1 = 값1, 컬럼명2 = 값2, ...
--      [where 조건문];

-- 특정 행 수정하기
update employees
set department_id = 50
where employee_id = 113;

select employee_id, last_name, department_id
from employees
where employee_id = 113;

-- 모든 행 수정하기(where절 생략)
-- 전 직원의 급여를 10% 인상하시오.
update copy_emp
set salary = salary * 1.1;

select employee_id, last_name, salary, department_id
from copy_emp;

-- update + 서브쿼리 예제1
select employee_id, last_name, job_id, salary
from copy_emp
where employee_id = 113;

select employee_id, last_name, job_id, salary
from employees
where employee_id = 205;

update copy_emp
set job_id = (select job_id
			  from employees
			  where employee_id = 205),
    salary = (select salary
			  from employees
			  where employee_id = 205)
where employee_id = 113;

select employee_id, last_name, job_id, salary
from copy_emp
where employee_id = 113;

-- update + 서브쿼리 예제2
update copy_emp
set salary = salary * 1.1
where department_id = (select department_id
					   from departments
					   where location_id = 1800);

select employee_id, last_name, salary, department_id
from copy_emp
where department_id = (select department_id
                       from departments
                       where location_id = 1800);

-- null값으로 수정하기
update copy_emp
set department_id = null
where employee_id = 109;

select employee_id, last_name, job_id, department_id
from copy_emp;

-- 다중 컬럼 수정하기
update copy_emp
set department_id = 60, job_id = 'AC_ACCOUNT'
where employee_id = 140;

select employee_id, last_name, job_id, department_id
from copy_emp
where employee_id = 140;

-- 8-3. 데이터 삭제(delete)
-- [문법] delete from 테이블명
--      [where 조건문];

-- 특정 행 삭제하기
delete from departments
where department_id = 320;

select *
from departments;

-- 모든 행 삭제하기
delete from copy_emp;

select *
from copy_emp;

-- employees 테이블의 데이터를 copy_emp 테이블로 복사하기
insert into copy_emp
	select *
    from employees;

select *
from copy_emp;

-- delete + 서브쿼리 예제
delete from copy_emp
where department_id = (select department_id
					   from departments
                       where location_id = 1800);
                       
select *
from copy_emp;

-- 8-4. 트랜잭션과 트랜잭션 명령어(TCL)
-- 트랜잭션이란?
-- 하나의 논리적인 작업 단위
-- 하나이상의 DML(insert, update, delete)이 모여서 하나의 트랜잭션을 구성함.
-- 하나의 DDL(create, alter, drop, truncate)이 하나의 트랜잭션을 구성함.

-- 트랜잭션 제어 명령어(TCL)
-- commit : 변경 작업을 저장하는 명령어
-- rollback : 변경 작업을 취소하는 명령어
-- savepoint : 트랜잭션 진행 중 되돌아갈 지점을 생성하는 명령어

-- 트랜잭션 운영 방법
-- 1. auto-commit 기능 활성화
-- 메뉴 : [Query] - [Auto-Commit Transactions] 체크
-- 단일 DML 발생 시 자동 저장됨. 
-- 장점 : 단일 DML 발생 시 자동 저장되므로 편함.
-- 단점 : 작업 실수 시 되돌릴 수 없음.

-- 2. auto-commit 기능 비활성화
-- 메뉴 : [Query] - [Auto-Commit Transactions] 체크 해제
-- DML 작업 후 commit, rollback으로 트랜잭션을 마무리해야함.
-- 장점 : 작업 실수 시 commit 전이면 rollback 가능함.
-- 단점 : 변경 작업 후 commit, rollback으로 트랜잭션을 마무리해야함.

-- [Query] - [Auto-Commit Transactions] 체크 해제 후 작업하기
-- [commit] 사용하기
-- 트랜잭션 시작
update copy_emp
set salary = salary * 1.2
where department_id = 30;    	-- 임시 data 상태

select employee_id, last_name, salary, department_id
from copy_emp
where department_id = 30;		-- 미리보기

delete from departments
where department_id = 300;		-- 임시 data 상태

select *
from departments
order by department_id desc;	-- 미리보기

commit;							-- 영구히 저장됨.
-- 트랜잭션 종료

-- [rollback] 사용하기
-- 트랜잭션 시작
delete from copy_emp;			-- 임시 data 상태

select *
from copy_emp;					-- 미리보기

rollback;						-- 작업 취소됨.
-- 트랜잭션 종료
-- 작업 취소 확인
select *
from copy_emp;

-- savepoint 사용하기
-- 트랜잭션 시작
update copy_emp
set salary = salary * 1.5
where department_id = 90;			-- 임시 data 상태

select employee_id, last_name, salary, department_id
from copy_emp
where department_id = 90;			-- 미리보기

savepoint test1;					-- savepoint 생성

update copy_emp
set email = 'abc@naver.com'
where employee_id = 101;			-- 임시 data 상태

select employee_id, last_name, email
from copy_emp
where employee_id = 101;			-- 미리보기

delete from copy_emp
where job_id = 'IT_PROG';			-- 임시 data 상태

select employee_id, last_name, job_id
from copy_emp
where job_id = 'IT_PROG';			-- 미리보기

rollback to test1;					-- savepoint 지점으로 롤백

select employee_id, last_name, job_id
from copy_emp
where job_id = 'IT_PROG';			-- delete 취소 확인

select employee_id, last_name, email
from copy_emp
where employee_id = 101;			-- 메일 update 취소 확인

select employee_id, last_name, salary, department_id
from copy_emp
where department_id = 90;			-- 급여 update 유지 확인, 임시 data 상태

commit;
-- 트랜잭션 종료

-- <연습문제>
-- [Query] - [Auto-Commit Transactions] 체크 해제 후 작업하기
-- 1. my_employee 테이블 생성하기
CREATE TABLE my_employee
(id int PRIMARY Key,
 last_name VARCHAR(25),
 first_name VARCHAR(25),
 userid VARCHAR(8),
 salary int);
 
-- 2. my_employee 테이블 구조 조회
desc my_employee;

-- 트랜잭션 시작
-- 3.
INSERT INTO my_employee
VALUES (1, 'Patel', 'Ralph', 'rpatel', 895);

INSERT INTO my_employee (id, last_name, first_name, userid, salary)
VALUES (2, 'Dancs', 'Betty', 'bdancs', 860);

INSERT INTO my_employee
VALUES (3, 'Biri', 'Ben', 'bbiri', 1100),
       (4, 'Newman', 'Chad', 'cnewman', 750);
-- 4.
SELECT *
FROM my_employee;
-- 5.
commit; 
-- 트랜잭션 종료

-- 트랜잭션 시작
-- 6.
UPDATE my_employee
SET last_name = 'Drexler'
WHERE id = 3;
-- 7.
UPDATE my_employee
SET salary = 1000 
WHERE salary < 900;
-- 8.
SELECT *
FROM my_employee;
-- 9.
DELETE FROM my_employee 
WHERE last_name = 'Dancs';
-- 10.
SELECT *
FROM my_employee;
-- 11.
commit;
-- 트랜잭션 종료

-- 트랜잭션 시작
-- 12.
INSERT INTO my_employee
VALUES (5, 'Ropeburn', 'Audrey', 'aropebur', 1550);
-- 13.
SELECT *
FROM my_employee;
-- 14.
SAVEPOINT step14;
-- 15. 
DELETE FROM my_employee;
-- 16.
SELECT *
FROM my_employee;
-- 17.
ROLLBACK TO step14;
-- 18.
SELECT *
FROM my_employee;
-- 19.
commit;
-- 트랜잭션 종료