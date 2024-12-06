-- [SQL문법] 5-1. 단일행함수 - 문자함수
use hr;

-- 함수란?
-- 인수를 받아서 정해진 조작을 한 후 반드시 하나의 값을 반환함.
-- SQL함수 유형 : 단일행 함수, 다중행 함수(=그룹함수)

-- 단일행 함수
-- 행 당 하나의 결과값을 반환함.
-- 단일행함수 유형 : 문자함수, 숫자함수, 날짜함수,
--                변환함수, 제어흐름함수, 시스템정보함수

-- 문자함수
-- ascii(문자) : 문자의 아스키코드값을 반환함.
-- char(숫자) : 숫자(아스키코드값)에 해당되는 문자를 반환함.
select ascii('A'), ascii('a'), char(66);

-- length(문자열) : 문자열의 byte수를 반환함.
-- bit_length(문자열) : 문자열의 bit수를 반환함.
-- char_length(문자열) : 문자열의 문자의 개수를 반환함.
select employee_id, last_name, length(last_name) as "byte수",
       bit_length(last_name) as "bit수",
       char_length(last_name) as "문자의 개수"
from employees;

select length('아이티윌'), bit_length('아이티윌'), 
       char_length('아이티윌');
       
-- concat(인수1, 인수2, ..., 인수n) : n개의 인수를 연결해서 반환함.
-- concat_ws(구분자, 인수1, ..., 인수n) : 구분자와 함께 n개의 인수를
--                                     연결해서 반환함.
select employee_id, concat(first_name, last_name) as name,
       job_id, email
from employees;

select employee_id, 
       concat(last_name, '--', job_id, '--', email, '--', 
			  salary, '--', department_id) 
	   as emp_info
from employees;
-- (==)
select employee_id, 
       concat_ws('--', last_name, job_id, email, salary, department_id)
	   as emp_info
from employees;

-- instr(문자열, 특정문자) : 문자열로부터 특정 문자의 첫번째 위치값을 반환함.
select employee_id, last_name, instr(last_name, 'b')
from employees;

-- upper(문자열) : 문자열을 대문자로 변환함.
-- lower(문자열) : 문자열을 소문자로 변환함.
select employee_id, upper(last_name) as name, lower(email) as email
from employees;

-- left(문자열, 숫자) : 문자열을 왼쪽에서부터 숫자만큼 반환함.
-- right(문자열, 숫자) : 문자열을 오른쪽에서부터 숫자만큼 반환함.
-- substr(문자열, 시작위치, 숫자) : 문자열을 시작부터 숫자만큼 반환함.
select left('itwill busan', 6), right('itwill busan', 5),
       substr('itwill busan', 3, 7);
       
select left('981223-1122334', 6) as "생년월일";

select employee_id, last_name,
	   left(last_name, 3), substr(last_name, 1, 3)
from employees;

select employee_id, job_id,
       right(job_id, 3), substr(job_id, -3, 3)
from employees;

-- lpad(문자열, 전체자리수, 채울문자) : 문자열을 전체 자리수만큼 늘려서 출력하되
--                                남는 공간이 있다면 채울 문자로 채워주는 함수
--                                오른쪽 정렬할때 주로 사용됨.
-- rpad(문자열, 전체자리수, 채울문자) : 문자열을 전체 자리수만큼 늘려서 출력하되
--                                남는 공간이 있다면 채울 문자로 채워주는 함수
--                                왼쪽 정렬할때 주로 사용됨.
select lpad('itwill', 10, '*'), rpad('itwill', 10, '*');

select lpad(last_name, 20, '_') as "L-name", 
       rpad(first_name, 20, '_') as "F-name"
from employees;

-- ltrim(문자열) : 문자열의 왼쪽 공백을 제거함.
-- rtrim(문자열) : 문자열의 오른쪽 공백을 제거함.
-- trim(문자열) : 문자열의 앞/뒤(양쪽) 공백을 제거함.
-- trim(방향 특정문자 from 문자열) : 방향 - leading(앞), trailing(뒤), both(양쪽)
--                               문자열로부터 특정문자가 해당 방향에 있으면 제거함.
select ltrim('    SQL 문법   '), rtrim('    SQL 문법   '),
       trim('    SQL 문법   ');
select trim(both '_' from '__SQL_문법___');

-- replace(문자열, 특정문자, 다른문자) : 문자열에서 특정 문자를 다른 문자료 교체함.
select employee_id, last_name, email, 
       replace(phone_number, '.', '-') as phone
from employees;

-- space(길이) : 길이만큼의 공백을 반환함.
select concat('MySQL', '          ', 'DBMS') as test1;
-- (==)
select concat('MySQL', space(10), 'DBMS') as test2;
	   
-- <연습문제> 
-- 1.
SELECT last_name as "Name", LENGTH(last_name) as "Length"
FROM employees
WHERE left(last_name, 1) in ('J', 'M', 'A')
ORDER BY last_name;
-- (==)
SELECT last_name as "Name", LENGTH(last_name) as "Length"
FROM employees
WHERE substr(last_name, 1, 1) in ('J', 'M', 'A')
ORDER BY last_name;
-- (==)
SELECT last_name as "Name", LENGTH(last_name) as "Length"
FROM employees
WHERE last_name LIKE 'J%'
OR 	  last_name LIKE 'M%'
OR    last_name LIKE 'A%'
ORDER BY last_name;

-- 2.
SELECT last_name, LPAD(salary, 15, '$') as SALARY
FROM employees;

-- 3.
-- [정답] 
SELECT salary, CONCAT(last_name, RPAD(' ', truncate(salary/1000, 0) + 1, '*')) 
       as EMPLOYEES_AND_THEIR_SALARIES
FROM employees
ORDER BY salary DESC;

-- [오답]
-- lpad, rpad 함수는 두번째 인수(전체자리수)가 실수인 경우 반올림함!!!
SELECT salary, CONCAT(last_name, ' ', RPAD('*', salary/1000, '*')) 
       as EMPLOYEES_AND_THEIR_SALARIES
FROM employees
ORDER BY salary DESC;
-- (==)
SELECT salary, CONCAT(last_name, RPAD(' ', salary/1000+1, '*')) 
       as EMPLOYEES_AND_THEIR_SALARIES
FROM employees
ORDER BY salary DESC;