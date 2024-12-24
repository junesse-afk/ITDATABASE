-- [SQL 문법] 6. 그룹함수와 그룹화
use hr;

-- 6-1. 그룹함수란?
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

-- 6-2. group by절
-- 테이블 안에서 또 다시 작은 그룹화를 나눠주는 구문
-- [문법] select 컬럼1, 컬럼2, 컬럼3
--       from 테이블명
--      [where 조건문]
--      [group by 컬럼명]
--      [order by 컬럼명 [asc | desc]];
-- (★) 그룹함수와 group by절이 사용되는 구문 작성 시 규칙!
-- select절의 컬럼리스트 중 그룹함수에 포함된 컬럼과
-- 그룹함수에 포함되지 않은 컬럼이 같이 출력되려면
-- 그룹함수에 포함되지 않은 컬럼은 빠짐없이 group by절에 
-- 포함되어야 문법 오류가 발생되지 않음!

-- employees 테이블에서 부서별 급여의 평균을 출력하시오.
select department_id, avg(salary)
from employees
group by department_id;

-- employees 테이블에서 부서 내 업무별 평균 급여를 출력하시오.
select department_id, job_id, avg(salary)
from employees
group by department_id, job_id
order by department_id;

select department_id, job_id, sum(salary)
from employees
where department_id > 40
group by department_id, job_id
order by department_id;

-- 부서별 사원의 수를 출력하시오.
select department_id, count(last_name)
from employees
group by department_id;

-- 부서 내 업무별 사원의 수를 출력하시오.
select department_id, job_id, count(last_name)
from employees
group by department_id, job_id;

-- 6-3. having절
-- [문법] select 컬럼1, 컬럼2, 컬럼3
--       from 테이블명
--      [where 조건문]		--> 행 제한 조건문
--      [group by 컬럼명]
--      [having 조건문]		--> 행그룹 제한 조건문(그룹함수 포함 조건문)
--      [order by 컬럼명 [asc | desc]];

select job_id, sum(salary) payroll
from employees
where job_id not like '%REP%'
group by job_id
having sum(salary) > 13000
order by payroll;

-- <연습문제>
-- 1.
select round(avg(ifnull(commission_pct, 0)),2) as avg_comm
from employees;

-- 2.
SELECT job_id, ROUND(MAX(salary),0) "Maximum",
			   ROUND(MIN(salary),0) "Minimum",
			   ROUND(SUM(salary),0) "Sum",
			   ROUND(AVG(salary),0) "Average"
FROM employees
GROUP BY job_id;

-- 3.
SELECT job_id, COUNT(last_name)
FROM employees
GROUP BY job_id;

-- 4.
SELECT manager_id, MIN(salary)
FROM employees
WHERE manager_id IS NOT NULL
GROUP BY manager_id
HAVING MIN(salary) > 6000
ORDER BY MIN(salary) DESC;

-- 5.
SELECT MAX(salary) - MIN(salary) DIFFERENCE
FROM employees;

-- 6.
SELECT COUNT(employee_id) total, 
       count(if(year(hire_date)=1995, 1, null)) "1995", 
	   count(if(year(hire_date)=1996, 1, null)) "1996",
       count(if(year(hire_date)=1997, 1, null)) "1997",
       count(if(year(hire_date)=1998, 1, null)) "1998"
FROM employees;
-- (==)
SELECT COUNT(*) total, 
       SUM(if(year(hire_date)=1995, 1, 0)) "1995", 
	   SUM(if(year(hire_date)=1996, 1, 0)) "1996",
       SUM(if(year(hire_date)=1997, 1, 0)) "1997",
       SUM(if(year(hire_date)=1998, 1, 0)) "1998"
FROM employees;
-- (==)
SELECT COUNT(*) total, 
       SUM(if(year(hire_date)=1995, 1, null)) "1995", 
	   SUM(if(year(hire_date)=1996, 1, null)) "1996",
       SUM(if(year(hire_date)=1997, 1, null)) "1997",
       SUM(if(year(hire_date)=1998, 1, null)) "1998"
FROM employees;					