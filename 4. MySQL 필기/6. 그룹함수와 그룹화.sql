-- [SQL 문법] 6. 그룹함수와 그룹화
use hr;
1
-- 그룹함수란?
-- 행그룹을 조작해서 하나의 결과값을 반환함.
-- 그룹함수 종류 : sum, avg, min, max, count
-- 그룹함수 특징 : null값은 제외하고 작업함!

-- min(행그룹) : 행그룹에서 최소값을 반환함. 모든 데이터타입에 사용 가능함.
-- max(행그룹) : 행그룹에서 최대값을 반환함. 모든 데이터타입에 사용 가능함.
select min(salary), max(salary)
from employees;

select min(hire_date), max(hire_date)
from employees;

select min(last_name), max(last_name)
from employees;

-- sum(행그룹) : 행그룹의 합계를 반환함.
-- avg(행그룹) : 행그룹의 평균을 반환함.
select sum(salary) as "급여 합계", avg(salary) as "급여 평균"
from employees;

select sum(salary) as "급여 합계", avg(salary) as "평균 급여"
from employees
where job_id like '%REP%';

-- (예제) employees 테이블에서 전체 직원의 커미션 평균을 출력하시오.
-- [오답] 커미션을 받는 사원들의 커미션 평균
select avg(commission_pct) as avg_comm
from employees;

-- [정답] 
select avg(ifnull(commission_pct, 0)) as avg_comm
from employees;

-- count(행그룹) : 행그룹에서 행의 개수를 반환함.
select count(*)
from employees;				-- 전 직원 수를 출력하시오.

select count(employee_id)
from employees;				-- 전 직원 수를 출력하시오.

select count(last_name)
from employees;				-- 전 직원 수를 출력하시오.

select count(commission_pct)
from employees;				-- 커미션을 받는 직원 수를 출력하시오.

select count(department_id)
from employees;				-- 부서가 있는 직원 수를 출력하시오.

select count(distinct department_id)	
from employees;				-- 직원들이 소속된 부서의 수를 출력하시오.
                            
select count(department_id)
from departments;			-- 우리 회사에 존재하는 부서의 수를 출력하시오.						