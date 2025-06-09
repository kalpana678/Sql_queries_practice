/* This is a dataset of northwinddb and hospitaldb i have taken this from the online sql practice platform.
It has 3 levels of writting query Easy, Medium and Hard 
 */

-- question 1  Show the ProductName, CompanyName, CategoryName from the products, suppliers, and categories table
SELECT  product_name, company_name, category_name
from categories c 
join products p on c.category_id = p.category_id
join suppliers s on p.supplier_id = s.supplier_id;

--question 2 Show the category_name and the average product unit price for each category rounded to 2 decimal places.
select category_name, round(avg(unit_price),2) as avg_product_price
from categories c 
join products p on c.category_id = p.category_id
group by category_name ;
 
 -- question 3 Show the city, company_name, contact_name from the customers and suppliers table merged together.
--Create a column which contains 'customers' or 'suppliers' depending on the table it came from.
select city, company_name, contact_name, 'customers' as relationship 
from customers
Union 
select city , company_name , contact_name,  'suppliers'
from suppliers

-- question 4 Show the total amount of orders for each year/month.
select count(order_date), year(order_date) , month(order_date)
from orders 
group by  year(order_date), month(order_date)
 
-- question 5 Show the employee's first_name and last_name, a "num_orders" column with a count of the orders taken, and a column called "Shipped" that displays "On Time" if the order shipped_date is less or equal to the required_date, "Late" if the order shipped late, "Not Shipped" if shipped_date is null.

--Order by employee last_name, then by first_name, and then descending by number of orders.-
select e.first_name, e.last_name, count(o.order_id) as count_num,
(case 
	when o.shipped_date  > o.required_date then "Late"
    when o.shipped_date <= o.required_date then "OnTime"
    else 
    	"Not shipped"
    end) as shipped 

from employees e 
join orders o on e.employee_id = o.employee_id 
group by e.first_name, e.last_name, shipped
order by e.first_name, e.last_name, count_num desc

-- question 6 Show how much money the company lost due to giving discounts each year, order the years from most recent to least recent. Round to 2 decimal places
select   year(order_date) as 'order_yr', 
round(sum(p.unit_price * od.quantity * od.discount),2) as discount_amt
from orders o 
join order_details od on o.order_id = od.order_id
join products p on od. product_id = p.product_id 
group by year( o.order_date )
order by order_yr desc;

-- question 7 We need a breakdown for the total amount of admissions each doctor has started each year. Show the doctor_id, doctor_full_name, specialty, year, total_admissions for that year.
select doctor_id,    year( admission_date) as select_yr, 
  concat(first_name, '' , last_name) as dr_full_name, 
  count(admission_date) - lag(admission_date) over(partition by admission_date) as total_adm_yr,
  specialty
  from admissions as a 
  join doctors as d 
  on a.attending_doctor_id = d. doctor_id
  group by admission_date
  