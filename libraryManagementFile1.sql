create database library;

use library;

-- Crating table using import wizard
-- books table is imported
select * from books;
alter table books
modify isbn varchar(30);

alter table books
add primary key(isbn);

-- Branch table is imported
select * from branch;
-- Addding Primary key to branch table
alter table branch
modify branch_id varchar(10);

alter table branch
add primary key(branch_id);

-- Employee table imported
select * from employees;

alter table  employees
modify emp_id varchar(10);

alter table  employees
modify branch_id varchar(10);


alter table employees
add primary key(emp_id);

-- Memebers table added

select * from members;

alter table members
modify member_id varchar(10);

alter table members
add primary key(member_id);

-- issued status table added
select * from issued_status;

alter table issued_status
modify issued_member_id varchar(10);

alter table issued_status
modify issued_id varchar(10);

alter table issued_status
modify issued_book_isbn varchar(20);

 alter table issued_status
modify issued_emp_id varchar(20);


alter table issued_status
add primary key(issued_id);

-- return status table added
select * from return_status;

alter table return_status
modify return_id varchar(10);

alter table return_status
modify issued_id varchar(10);


alter table return_status
add primary key(return_id);

-- adding foreign keys 

alter table issued_status
add constraint fk_members
foreign key(issued_member_id)
references members(member_id);

alter table issued_status
add constraint fk_bboks
foreign key(issued_book_isbn)
references books(isbn);

select * from employees;

alter table employees
add constraint fk_branch
foreign key( branch_id)
references branch(branch_id);


alter table return_status
add constraint fk_issued_ID
foreign key(issued_id)
references issued_status(issued_id);

select *from return_status;

select *  from issued_status;

SELECT issued_id 
FROM return_status 
WHERE issued_id NOT IN (SELECT issued_id FROM issued_status);

INSERT INTO issued_status (issued_id)
SELECT DISTINCT issued_id FROM return_status
WHERE issued_id NOT IN (SELECT issued_id FROM issued_status);



-- CRUD Operation
-- Q1)Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
select * from books;

insert into books(isbn,book_title,category,rental_price,status,author,publisher)
values('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', '6.00', 'yes', 'Harper Lee', 'J.B. Lippincott & Co.'
 );
 
 -- Q2)  Update an Existing Member's Address
 select * from members;
 
update members
 set member_address="132 Main st"
 where member_id="C101";
 
 -- Q3)Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.
 select * from issued_status;
 
 delete from issued_status
 where issued_id='IS121';
 
-- Q4)  Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.
select * from issued_status
where issued_emp_id='E101';

-- Q5)  List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
select issued_emp_id, count(*) from issued_status
group by issued_emp_id
having count(*) >1;

-- CTAS (Create Table As Select)
-- Q 6)Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
select * from books;
select * from issued_status;

create table  book_issued_counnt
as(
select 
b.isbn,
b.book_title,
count(ist.issued_book_isbn)
from 
books as b
join 
issued_status as ist
on b.isbn = ist.issued_book_isbn
group by b.isbn, b.book_title);

select * from book_issued_counnt;

-- Q 7) Retrieve All Books in a Specific Category:
select * from books;

select * from books
where category='Classic';

-- Q8) Find Total Rental Income by Category

select * from issued_status;
select * from books;

select 
	b.category,
	sum(b.rental_price),
	count(*)
from
	books as b
join 
	issued_status as ist 
on 
	b.isbn=ist.issued_book_isbn
group by b.category;

-- Q 9) List Members Who Registered in the Last 180 Days:

select * from members;

select * from members
where reg_date >= current_date - interval 180 day;

-- Q10) List Employees with Their Branch Manager's Name and their branch details:
select * from employees;

select * from branch;

select 
	emp.*,
    b.manager_id,
    emp2.emp_name as manager
from 
	branch as b 
join 
	employees as emp
on 	b.branch_id=emp.branch_id
join
	employees as emp2
on b.manager_id=emp.emp_id
;

-- Q11) Create a Table of Books with Rental Price Above a Certain Threshold:
create table expensive_books as
 (
select * from books
where rental_price>'5'
);

select * from expensive_books
;

-- Q 12) Retrieve the List of Books Not Yet Returned
select * from return_status;
select * from issued_status;

select * from
issued_status as ist 
left join 
return_status as rts 
on 
ist.issued_id= rts.issued_id
where return_date is null;
