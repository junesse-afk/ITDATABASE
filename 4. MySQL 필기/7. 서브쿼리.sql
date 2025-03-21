-- [SQL문법] 7. 서브쿼리(subquery)
use hr;

-- 서브쿼리란?
-- 쿼리구문 안에 또 다시 쿼리구문이 들어가 있는 형태
-- 실행순서 : 서브쿼리(inner query)를 먼저 실행하고 
--          메인쿼리(outer query)를 실행함.
-- 서브쿼리 작성될 수 있는 곳 : group by절을 제외한 select구문에 작성 가능함.
--                        DML(insert, update, delete) 작성 가능함.
--                        DDL(create, alter 등) 작성 가능함.
-- [문법] where절에 서브쿼리가 사용된 경우
--       select 컬럼1, 컬럼2, 컬럼3
--       from 테이블명
--       where 컬럼명 = (select 컬럼명
--                     from 테이블명
--                     where 조건문);
-- 서브쿼리 유형 : 단일행 서브쿼리, 다중행 서브쿼리

-- 7-1. 단일행 서브쿼리
-- 서브쿼리로부터 메인쿼리로 단일행(단일값)이 반환되는 유형
-- 메인쿼리에 우변에 단일 값이 올 수 있는 단일행 비교연산자 사용하면 됨.
-- 단일행 비교연산자 : =, >, >=, <, <=, <>, !=

-- employees 테이블에서 last_name이 'abel'인 사원보다 급여를 더 많이
-- 받는 사원을 출력하시오.
select employee_id, last_name, salary
from employees
where salary > (select salary
                from employees
                where last_name = 'abel');

-- 141번 사원과 동일 업무 담당자를 출력하시오.
SELECT last_name, job_id
FROM employees
WHERE job_id = (SELECT job_id
                FROM employees
                WHERE employee_id = 141);
                
-- 우리 회사에서 최소 급여를 받는 사원의 정보를 출력하시오.
SELECT last_name, job_id, salary
FROM employees
WHERE salary = (SELECT MIN(salary)
                FROM employees);

-- Lee와 동일업무를 담당하되 급여는 더 많이 받는 사원을 출력하시오.
SELECT last_name, job_id, salary
FROM employees
WHERE job_id = (SELECT job_id
                FROM employees
                WHERE last_name = 'Lee')
AND salary > (SELECT salary
              FROM employees
              WHERE last_name = 'Lee');

-- having절에 서브쿼리가 사용된 예제
SELECT department_id, MIN(salary)
FROM employees
WHERE department_id is not null
GROUP BY department_id
HAVING MIN(salary) > (SELECT MIN(salary)
                      FROM employees
                      WHERE department_id = 30);

-- 서브쿼리로부터 여러 행이 반환되는 예제
-- 오류 수정 : = -> in (다중행 비교연산자 사용해야함)                     
SELECT employee_id, last_name
FROM employees
WHERE salary in (SELECT MIN(salary)
                 FROM employees
                 GROUP BY department_id);

-- 결과가 나오지 않는 이유? haas 직원이 존재하지 않음.
-- 단일행 서브쿼리로부터 null값이 반환된 경우 메인쿼리 결과도 null이다!
SELECT last_name, job_id
FROM employees
WHERE job_id = (SELECT job_id
                FROM employees
                WHERE last_name = 'Haas');

-- 7-2. 다중행 서브쿼리
-- 서브쿼리로부터 메인쿼리로 여러행(다중값)이 반환되는 유형
-- 메인쿼리에는 우변에 값리스트가 올 수 있는 다중행 비교연산자 사용해야함.
-- 다중행 비교연산자 : in(=,or), not in(<>,and), any(or), all(and)
-- =any		: (=, or)		(==) in	: (=, or)
-- >any		: (>, or)	-> 최소값보다 크면 된다.
-- >=any	: (>=, or)	-> 최소값보다 크거나 같으면 된다.
-- <any		: (<, or)   -> 최대값보다 작으면 된다.
-- <=any	: (<=, or)	-> 최대값보다 작거나 같으면 된다.
-- <>any	: (<>, or)	-> 단일값인 경우 의미가 있고, 다중값인 경우에는 의미가 없음.
-- =all		: (=, and)	-> 단일값인 경우 의미가 있고, 다중값인 경우에는 의미가 없음.
-- >all		: (>, and)	-> 최대값보다 크면 된다.
-- >=all	: (>=, and)	-> 최대값보다 크거나 같으면 된다.
-- <all		: (<, and)	-> 최소값보다 작으면 된다.
-- <=all	: (<=, and)	-> 최소값보다 작거나 같으면 된다.
-- <>all	: (<>, and)		(==) not in : (<>, and)

-- 다중행 비교연산자 in이 사용된 다중행 서브쿼리 예제1
SELECT employee_id, last_name, manager_id, department_id 
FROM employees 
WHERE manager_id IN (SELECT manager_id 
					 FROM employees 
					 WHERE employee_id IN (174, 141)) 
AND department_id IN (SELECT department_id 
					  FROM employees 
					  WHERE employee_id IN (174, 141)) 
AND employee_id NOT IN(174, 141);

-- 다중행 비교연산자 any가 사용된 다중행 서브쿼리 예제2
SELECT employee_id, last_name, job_id, salary
FROM employees
WHERE salary <ANY (SELECT salary
                   FROM employees
                   WHERE job_id = 'IT_PROG')
AND job_id <> 'IT_PROG';

-- 다중행 비교연산자 all이 사용된 다중행 서브쿼리 예제3
SELECT employee_id, last_name, job_id, salary
FROM employees
WHERE salary <ALL (SELECT salary 
                   FROM employees
                   WHERE job_id = 'IT_PROG')
AND job_id <> 'IT_PROG';

-- 다중행 서브쿼리 + 다중컬럼 서브쿼리 예제
SELECT employee_id, first_name, department_id, salary
FROM employees
WHERE (department_id, salary) IN (SELECT department_id, min(salary) 
                                  FROM employees
                                  GROUP BY department_id)
ORDER BY department_id;

-- employees 테이블에서 자기 자신이 매니저가 아닌 최하위 직원을 출력하시오.
-- 결과가 나오지 않는 원인은?
-- 다중행 서브쿼리로부터 반환되는 값리스트에 null값이 포함된 경우
-- (1) or의 성격을 가지는 다중행 비교연산자 사용 -> 메인 쿼리 결과 정상 출력됨.
-- (2) and의 성격을 가지는 다중행 비교연산자 사용 -> 메인 쿼리 결과도 null이다!
SELECT last_name
FROM employees
WHERE employee_id NOT IN (SELECT manager_id
                          FROM employees
                          WHERE manager_id is not null);
                          
-- <연습문제>
-- 1. 
SELECT last_name, hire_date
FROM employees
WHERE department_id = (SELECT department_id
					   FROM employees
					   WHERE last_name = 'Abel')
AND last_name <> 'Abel';

-- 2.
SELECT employee_id, last_name, salary
FROM employees
WHERE salary >= (SELECT AVG(salary)
 	             FROM employees)
ORDER BY salary;

-- 3.
SELECT employee_id, last_name
FROM employees
WHERE department_id IN (SELECT department_id
						FROM employees
						WHERE last_name like '%u%');

-- 4. 
SELECT employee_id, last_name, department_id, job_id
FROM employees
WHERE department_id IN (SELECT department_id
                        FROM departments
                        WHERE location_id = 1700);

-- 5. 
SELECT employee_id, last_name, salary
FROM employees
WHERE department_id IN (SELECT department_id
                        FROM employees
                        WHERE last_name like '%u%')
AND salary >= (SELECT AVG(salary)
               FROM employees);

-- 6. 
SELECT employee_id, last_name
FROM employees
WHERE employee_id IN (select manager_id
					  from employees);

-- 7. 
SELECT department_id, department_name
FROM departments
WHERE department_id NOT IN (select department_id
                            from employees
                            where department_id is not null);