-- [SQL문법] 1. select구문을 사용한 데이터 검색
-- DB 선택
use hr;

-- DB 내 테이블 리스트 조회
show tables;

-- 테이블 구조 조회하기
-- [문법] desc[ribe] 테이블명;
describe employees;
desc departments;
desc locations;

-- 테이블로부터 데이터 조회하는 구문
-- [문법] select * | 컬럼1, 컬럼2, 컬럼3
--       from 테이블명;
-- 모든 컬럼 출력하기
select *
from employees;

select *
from departments;

-- 특정 컬럼 출력하기
select employee_id, last_name, salary, job_id, department_id
from employees;

select department_id, department_name
from departments;

-- select구문에 산술식이 포함된 예제
-- 산술식 : 산술연산자를 사용한 계산식
-- 산술연산자 : *, /, +, -
-- 산술연산자 우선순위 : *, / (높) >> +, - (낮)
select last_name, salary, 12*salary+100
from employees;

select last_name, salary, 12*(salary+100)
from employees;

-- null값이란?
-- 모르는 값, 정의되지 않은 값, 알 수 없는 값, 알려지지 않은 값 등
-- 0(숫자) 또는 공백(문자)과는 다른 특수한 값임.
-- 모든 데이터타입에 사용 가능함.
-- 수당 받지 않는 사원들은 null값 저장되어 있음.
select last_name, job_id, salary, commission_pct
from employees;

-- 부서가 결정되지 않은 신입사원은 null값 저장되어 있음.
select employee_id, last_name, department_id
from employees;

-- 매니저가 없는 직원(사장)은 null값이 저장되어 있음.
select employee_id, last_name, manager_id
from employees;

-- null + 100 = null
-- null - 100 = null 
-- null * 100 = null
-- null / 100 = null
-- 12 * 24000 + null / 7 - 1300 = null
-- 산술식에 null값이 포함되어 있는 경우 결과는 무조건 null이다!
-- 수당 받지 않는 사원들은 연봉 계산이 제대로 되지 않음.
select employee_id, last_name, salary, commission_pct,
       (12*salary)+(12*salary*commission_pct) as "연봉"
from employees;

-- 컬럼 alias
-- [문법1] 컬럼명 as alias
-- [문법2] 컬럼명 alias
-- [문법3] 컬럼명 [as] "별칭" -> 특수문자 포함, 공백 포함
select employee_id as "사번", last_name as "이름",
       salary "급여", email "메일 주소"
from employees;

-- distinct 키워드 : 중복값을 제거하고 출력해주는 키워드 
-- employees 테이블에서 직원들이 소속된 부서종류를 출력하시오.
desc employees;
select distinct department_id
from employees;

select distinct department_id, job_id
from employees
order by department_id;

-- <연습문제>
-- 1.
select employee_id as "Emp #", last_name as "Employee", 
       job_id as "Job", hire_date as "Hire Date"
from employees;

-- 2. 
select distinct job_id
from employees;