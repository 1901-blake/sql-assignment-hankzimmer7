-- SQL Lab

-- 1.0	Setting up Postgres Chinook
-- In this section you will begin the process of working with the Oracle Chinook database
-- Task – Open the Chinook_PostgreSql.sql file and execute the scripts within.

-- 2.0 SQL Queries
-- In this section you will be performing various queries against the Postgres Chinook database.

-- 2.1 SELECT
-- Task – Select all records from the Employee table.
select * from employee;

-- Task – Select all records FROM the Employee table where last name is King.
select * from employee where lastname = 'King';

-- Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
select * from employee where firstname = 'Andrew' and reportsto is null;

-- 2.2 ORDER BY
-- Task – Select all albums in Album table and sort result set in descending order by title.
select * from album order by title desc;

-- Task – Select first name from Customer and sort result set in ascending order by city
select firstname from customer order by city;

-- 2.3 INSERT INTO
-- Task – Insert two new records into Genre table
insert into genre (genreid, name) values (26, 'K-pop');
insert into genre (genreid, name) values (27, 'Dance');

-- Task – Insert two new records into Employee table
insert into employee (employeeid, lastname, firstname, title, reportsto, birthdate, hiredate, address, city, state, country, postalcode, phone, fax, email)
values (9, 'Zimmer','Hank','Associate',6,'1980/7/5','2019/1/14','912 18th St','Tampa','FL','USA', '33613', '+1 (719) 239-1252','+1 (719) 323-1942', 'hank@chinookcorp.com');
insert into employee (employeeid, lastname, firstname, title, reportsto, birthdate, hiredate, address, city, state, country, postalcode, phone, fax, email)
values (10, 'Truman','Paula','Associate',6,'1990/3/12','2019/1/14','28 Broad Ave','Tampa','FL','USA', '33613', '+1 (215) 238-4892','+1 (215) 128-3719', 'paula@chinookcorp.com');

-- Task – Insert two new records into Customer table
insert into customer (customerId, firstname, lastname, address, city, country, postalcode, phone, email, supportrepid) 
values (60, 'Frank', 'Garrison', '73 1st Ave', 'Tampa', 'USA', '33613', '+1 (234) 231-2482', 'fgarrison@gmail.com', 3);
insert into customer (customerId, firstname, lastname, address, city, country, postalcode, phone, email, supportrepid) 
values (61, 'Beatrice', 'Brooks', '128 Bay St', 'Tampa', 'USA', '33613', '+1 (639) 753-6962', 'bbrooks@gmail.com', 5);

-- 2.4 UPDATE
-- Task – Update Aaron Mitchell in Customer table to Robert Walter
update customer set firstname = 'Robert', lastname = 'Walker' where firstname = 'Aaron' and lastname = 'Mitchell';

-- Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
update artist set name = 'CCR' where name = 'Creedence Clearwater Revival';

-- 2.5 LIKE
-- Task – Select all invoices with a billing address like “T%”
select * from invoice where billingaddress like 'T%';

-- 2.6 BETWEEN
-- Task – Select all invoices that have a total between 15 and 50
select * from invoice where total between 15 and 50;

-- Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
select * from employee where hiredate between '2003-06-01' and '2004-03-01';

-- 2.7 DELETE
-- Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
alter table invoice
drop constraint fk_invoicecustomerid;

alter table invoice
add constraint fk_invoicecustomerid
foreign key (customerid) references customer (customerid) on delete cascade on update cascade;

alter table invoiceline
drop constraint fk_invoicelineinvoiceid;

alter table invoiceline
add constraint fk_invoicelineinvoiceid
foreign key (invoiceid) references invoice (invoiceid) on delete cascade on update cascade;

delete from customer where firstname = 'Robert' and lastname = 'Walker';

-- 3.0	SQL Functions
-- In this section you will be using the Oracle system functions, as well as your own functions, to perform various actions against the database

-- 3.1 System Defined Functions
-- Task – Create a function that returns the current time.
create or replace function currentTime()
returns text as $$
begin
	return current_time;
 end;
$$ language plpgsql;

select currentTime();

-- Task – create a function that returns the length of a mediatype from the mediatype table
create or replace function mediatypeLength(idinput int)
returns int as $$
begin
	return (select length(name) from mediatype where mediatypeid = idinput);
 end;
$$ language plpgsql;

select mediatypeLength(1);

-- 3.2 System Defined Aggregate Functions
-- Task – Create a function that returns the average total of all invoices
create or replace function averageTotal()
returns float as $$
begin
	return avg(total) from invoice;
 end;
$$ language plpgsql;

select averageTotal();

-- Task – Create a function that returns the most expensive track
create or replace function mostExpensiveTrack()
returns text as $$
begin
	return (select name from track where unitprice = (select max(unitprice) from track));
 end;
$$ language plpgsql;

select mostExpensiveTrack();

-- 3.3 User Defined Scalar Functions
-- Task – Create a function that returns the average price of invoiceline items in the invoiceline table
create or replace function averageInvoicePrice()
returns float as $$
begin
	return (select avg(unitprice) from invoiceline);
 end;
$$ language plpgsql;

select averageInvoicePrice();

-- 3.4 User Defined Table Valued Functions
-- Task – Create a function that returns all employees who are born after 1968.
create or replace function bornAfter68()
returns setof employee as $$
begin
	return query (select * from employee where birthdate > '1968-12-31');
 end;
$$ language plpgsql;
=
select bornAfter68();

-- 4.0 Stored Procedures
--  In this section you will be creating and executing stored procedures. You will be creating various types of stored procedures that take input and output parameters.

-- 4.1 Basic Stored Procedure
-- Task – Create a stored procedure that selects the first and last names of all the employees.
create or replace function firstAndLastNames()
returns table (fname varchar, lname varchar) as $$
begin
    return query select firstname, lastname from employee;
end;
$$ language plpgsql;

select * from firstAndLastNames();

-- 4.2 Stored Procedure Input Parameters
-- Task – Create a stored procedure that updates the personal information of an employee.
create or replace function updateEmployee(e_id int, firstnameinput varchar, lastnameinput varchar, titleinput varchar, reportstoinput int, birthdateinput timestamp, hiredateinput timestamp, addressinput varchar, cityinput varchar, stateinput varchar, countryinput varchar, postalcodeinput varchar, phoneinput varchar, faxinput varchar, emailinput varchar)
returns void as $$
begin
    update employee set firstname = firstnameinput, lastname = lastnameinput, title = titleinput, reportsto = reportstoinput, birthdate = birthdateinput, hiredate = hiredateinput, address = addressinput, city = cityinput, state = stateinput, country = countryinput, postalcode = postalcodeinput, phone = phoneinput, fax = faxinput, email = emailinput
        where employeeid = e_id;
end;
$$ language plpgsql;

select updateEmployee(10, 'Harris'::varchar, 'Tina'::varchar, 'Trainee'::varchar, 2, '1982-05-14'::timestamp, '2019-01-28'::timestamp, '17 Maple St'::varchar, 'Miami'::varchar, 'FL'::varchar, 'CAN'::varchar, '42934'::varchar, '+1 425-2348'::varchar, '+1 712-3812'::varchar, 'tina@chinookcorp.com'::varchar);

-- Task – Create a stored procedure that returns the managers of an employee.
create or replace function employeeManager(e_id int)
returns text as $$
begin
	return (select lastname from employee
    where employeeid = (select reportsto from employee where employeeid = e_id));
end;
$$ language plpgsql;

select employeeManager(7);

-- 4.3 Stored Procedure Output Parameters
-- Task – Create a stored procedure that returns the name and company of a customer.
create or replace function customerSearch(c_id int)
returns table (customer_fname varchar, customer_lname varchar, customer_company varchar) as $$
begin
	return query (select firstname, lastname, company from customer 
		   where customerid = c_id);
end;
$$ language plpgsql;

select * from customerSearch(10);

-- 5.0 Transactions
-- In this section you will be working with transactions. Transactions are usually nested within a stored procedure.
-- Task – Create a transaction that given a invoiceId will delete that invoice (There may be constraints that rely on this, find out how to resolve them).
create or replace function deleteInvoice(invoice_id_input int)
returns void as $$
begin
	delete from invoice where invoiceid = invoice_id_input;
end;
$$ language plpgsql;

alter table invoiceline
drop constraint fk_invoicelineinvoiceid;

alter table invoiceline
add constraint fk_invoicelineinvoiceid
foreign key (invoiceid) references invoice (invoiceid) on delete cascade on update cascade;

select deleteInvoice(407);

-- Task – Create a transaction nested within a stored procedure that inserts a new record in the Customer table
create or replace function insertCustomer(customeridinput int, firstnameinput varchar, lastnameinput varchar, companyinput varchar, addressinput varchar, cityinput varchar, stateinput varchar, countryinput varchar, postalcodeinput varchar, phoneinput varchar, faxinput varchar, emailinput varchar, supportrepidinput int)
returns void as $$
begin
    insert into customer (customerid, firstname, lastname, company, address, city, state, country, postalcode, phone, fax, email, supportrepid) 
		   values (customeridinput, firstnameinput, lastnameinput, companyinput, addressinput, cityinput, stateinput, countryinput, postalcodeinput, phoneinput, faxinput, emailinput, supportrepidinput);
end;
$$ language plpgsql;

select insertCustomer(63, 'Yost'::varchar, 'Steph'::varchar, 'Nappins'::varchar, '384 5th Ave'::varchar, 'Tampa'::varchar, 'FL'::varchar, 'USA'::varchar, '61234'::varchar, '+1 382-29238'::varchar, '+1 382-9182'::varchar, 'steph@gmail.com'::varchar, 3);

-- 6.0 Triggers
-- In this section you will create various kinds of triggers that work when certain DML statements are executed on a table.

-- 6.1 AFTER/FOR
-- Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
create trigger employee_insert
    after insert on employee
    for each row
    execute procedure example_function();

-- Task – Create an after update trigger on the album table that fires after a row is inserted in the table
create trigger customer_update
    after update on customer
    for each row
    execute procedure example_function();

-- Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.
create trigger customer_delete
    after delete on customer
    for each row
    execute procedure example_function();

-- 7.0 JOINS
-- In this section you will be working with combing various tables through the use of joins. You will work with outer, inner, right, left, cross, and self joins.

-- 7.1 INNER
-- Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
select firstname, lastname, invoiceid from customer inner join invoice on customer.customerid = invoice.customerid;

-- 7.2 OUTER
-- Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
select customer.customerid, firstname, lastname, invoiceid, total from customer full outer join invoice on customer.customerid = invoice.customerid;

-- 7.3 RIGHT
-- Task – Create a right join that joins album and artist specifying artist name and title.
select name, title from album right join artist on album.artistid = artist.artistid;

-- 7.4 CROSS
-- Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
select name as artist, title as album from artist 
cross join album where artist.artistid = album.artistid 
order by artist.name asc;

-- 7.5 SELF
-- Task – Perform a self-join on the employee table, joining on the reportsto column.
select A.firstname as firstname, A.lastname as lastname, A.title, B.lastname as reportsto from employee A, employee B where A.reportsto = B.employeeid;
