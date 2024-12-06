-- [SQL문법] 5-2. 단일행함수 - 숫자함수, 날짜함수
use hr;

-- (1) 숫자함수
-- round(숫자, 반올림할 자리) : 숫자를 반올림할 자리까지 반올림함.
-- truncate(숫자, 버림할 자리) : 숫자를 버림할 자리까지 남기고 버림함.
-- 숫자 :    1   2   3 . 4   5   6
-- 자리 :   -2  -1   0   1   2   3 
select round(45.923, 2), round(45.923, 0), round(45.923, -1);
select truncate(45.923, 2), truncate(45.923, 0), truncate(45.923, -1);

-- ceil(숫자) : 일의 자리까지 올림을 함.
-- floor(숫자) : 일의 자리까지 남기고 버림을 함.
select ceil(45.923), ceil(52.1), ceil(25.0);
select floor(45.923), floor(52.1), floor(25.0);

-- mod(숫자1, 숫자2) : 숫자1을 숫자2로 나눈 나머지를 반환함.
select 157/10, mod(157, 10), 157%10, 157 mod 10;

select last_name, salary, mod(salary, 5000)
from employees
where job_id = 'SA_REP';

-- 값이 짝수인지 홀수인지를 확인하는 용도로도 활용됨.
select employee_id, mod(employee_id, 2)
from employees;

-- abs(숫자) : 절대값을 반환하는 함수
select abs(-5), abs(5), abs(-4.5);

-- power(숫자, 제곱값) : 숫자의 제곱값을 계산해 주는 함수
select power(2, 3), power(8, 2), power(4, 5);

-- sign(숫자) : 숫자가 양수면 1, 음수면 -1, 0이면 0을 반환함.
select sign(3), sign(-3), sign(0), sign(-4.26), sign(4.26);

-- (2) 날짜함수
-- now() = sysdate() = current_timestamp() : 현재 날짜/시간을 반환함.
--                                           (년/월/일/시/분/초)
select now(), sysdate(), current_timestamp();

-- current_date() = curdate() : 현재 날짜를 반환함.(년/월/일)
-- current_time() = curtime() : 현재 시간을 반환함.(시/분/초)
select now(), current_date(), current_time();

-- year(날짜/시간) : 날짜/시간에서 년도를 반환함.
-- month(날짜/시간) : 날짜/시간에서 월을 반환함.
-- day(날짜/시간) : 날짜/시간에서 일을 반환함.
-- hour(날짜/시간) : 날짜/시간에서 시간을 반환함.
-- minute(날짜/시간) : 날짜/시간에서 분을 반환함.
-- second(날짜/시간) : 날짜/시간에서 초를 반환함.
select now(), year(now()), month(now()), day(now()),
       hour(now()), minute(now()), second(now());

select employee_id, last_name, job_id, year(hire_date) as "입사년도"
from employees;

-- date(날짜/시간) : 날짜/시간에서 날짜를 반환함.(년/월/일)
-- time(날짜/시간) : 날짜/시간에서 시간을 반환함.(시/분/초)
select now(), date(now()), time(now());

-- adddate(날짜, 기간) = date_add(날짜, 기간) : 날짜에 기간을 더한 날짜를 반환함.
-- subdate(날짜, 기간) = date_sub(날짜, 기간) : 날짜에 기간을 뺀 날짜를 반환함.
select adddate('2024-11-02', interval 35 day) as value1,
       adddate('2024-11-02', interval 2 month) as value2,
       date_add('2024-11-02', interval 1 year) as value3;

select subdate('2024-11-02', interval 35 day) as value1,
       subdate('2024-11-02', interval 2 month) as value2,
       date_sub('2024-11-02', interval 1 year) as value3;
       
-- addtime(날짜/시간, 시간) : 날짜/시간에서 시간을 더한 결과를 반환함.
-- subtime(날짜/시간, 시간) : 날짜/시간에서 시간을 뺀 결과를 반환함.
select now(), addtime(now(), '1:30:10');
select now(), subtime(now(), '1:30:10');

-- datediff(날짜1, 날짜2) : 날짜1 - 날짜2를 반환함.
-- timediff(시간1, 시간2) : 시간1 - 시간2를 반환함.
select datediff(current_date(), '2024-10-21');
select timediff(current_time(), '09:10:00');

select last_name, hire_date, datediff(now( ), hire_date) as "근무한 일수"
from employees;

-- dayofweek(날짜) : 날짜의 요일 값을 반환함.
--                  (1-일, 2-월, 3-화, 4-수, 5-목, 6-금, 7-토)
-- monthname(날짜) : 날짜의 월의 영문 이름을 반환함.
-- dayofyear(날짜) : 날짜가 1년 중 몇번째 날짜인지를 반환함.
select dayofweek(now()), monthname(now()), dayofyear(now());

select employee_id, last_name, hire_date, monthname(hire_date)
from employees;

-- last_day(날짜) : 날짜가 속한 월의 마지막 날짜를 반환함.
select last_day(now());

select employee_id, last_name, hire_date, last_day(hire_date),
       datediff(last_day(hire_date), hire_date)
from employees;

-- quarter(날짜) : 날짜가 4분기 중에서 몇 분기인지 반환함.
select quarter('2022-01-25'), quarter('2024-04-10'),
       quarter('2023-08-09'), quarter(now());

-- <연습문제>
-- 1.
select employee_id, last_name, salary, round(salary*1.155, 0) as "New Salary"
from employees;
       
-- 2.    
select employee_id, last_name, salary, round(salary*1.155, 0) as "New Salary",
       round(salary*1.155, 0) - salary as "Increase"
from employees;
-- (==)    
select employee_id, last_name, salary, round(salary*1.155, 0) as "New Salary",
       round(salary*0.155, 0) as "Increase"
from employees;

-- 3.
select employee_id, last_name, job_id, hire_date, department_id
from employees
where month(hire_date) = 2;
-- (==)
select employee_id, last_name, job_id, hire_date, department_id
from employees
where hire_date like '%-02-%';

-- 4.
select employee_id, last_name, hire_date, salary, department_id
from employees
where year(hire_date) between 1990 and 1995;
-- (==)
select employee_id, last_name, hire_date, salary, department_id
from employees
where hire_date between '1990-01-01' and '1995-12-31';

-- 5.
select last_name, hire_date, datediff(now(), hire_date) as "근무한 일수",
       floor(datediff(now(), hire_date)/7) as "근무한 주수"
from employees
where datediff(now(), hire_date)/7 < 1400;

-- 6. 
select employee_id, last_name, hire_date, 
       concat(quarter(hire_date), '분기') as "입사한 분기"
from employees;