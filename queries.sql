select COUNT(customer_id) as customers_count from public.customers;
--Подсчет общего количества покупателей из таблицы customers--


select
    CONCAT(e.first_name, ' ', e.last_name) as seller,
    COUNT(s.sales_id) as operations,
    FLOOR(SUM(s.quantity * p.price)) as income
from sales s
inner join employees e on s.sales_person_id = e.employee_id 
inner join products p on s.product_id = p.product_id 
group by seller
order by income desc
limit 10;
--запрос на отчет с 10 лучшими продавцами у которых наибольшая суммарная выручка, отсортированных по выручке по убыванию--


select
    CONCAT(e.first_name, ' ', e.last_name) as seller,
    FLOOR(AVG(s.quantity * p.price)) as average_income
from sales s
inner join employees e on s.sales_person_id = e.employee_id 
inner join products p on s.product_id = p.product_id
group by seller
having AVG(s.quantity * p.price) < (
    select FLOOR(AVG(s.quantity * p.price)) as total_average
    from sales s
    inner join products p on s.product_id = p.product_id 
)
order by average_income;
--запрос на отчет с продавцами, чья выручка ниже средней выручки всех продавцов, отсортированных по возрастанию выручки--


with tab as (select
    CONCAT(e.first_name, ' ', e.last_name) as seller,
    EXTRACT(ISODOW from s.sale_date) as weekday,
    FLOOR(SUM(s.quantity * p.price)) as income,
    min(s.sale_date) as date
from sales s
inner join employees e on s.sales_person_id = e.employee_id 
inner join products p on s.product_id = p.product_id
group by seller, weekday
order by weekday, seller
)
--вспомогательный запрос для получения нужной сортировки с данными по выручке по каждому продавцу по дням--

select 
    tab.seller,
    to_char(tab.date, 'day') as day_of_week,
    tab.income
from tab;
--запрос на отчет с данными по выручке по каждому продавцу и дню недели, отсортрованных по дням недели с понедельника --

    select
        '16-25' as age_category,
        COUNT(age) as age_count
    from customers c 
    where age >= 16 and age <=25

    UNION 
    
    select
        '26-40' as age_category,
        COUNT(age) as age_count
    from customers c 
    where age >= 26 and age <=40

    UNION 
    
    select
        '40+' as age_category,
        COUNT(age) as age_count
    from customers c 
    where age > 40
    order by age_category;
 -- три запроса объединенных на отчет о количестве покупателей в разных возрастных группах: 16-25, 26-40 и 40+ --
   
   select 
    to_char(s.sale_date, 'YYYY-MM') as selling_month,
    COUNT(distinct s.customer_id) as total_customers,
    FLOOR(SUM(s.quantity * p.price)) as income
from sales s 
inner join products p on p.product_id = s.product_id 
group by selling_month
order by selling_month;
--запрос на получение данных по количеству уникальных покупателей и выручке, которую они принесли помесячно--

select DISTINCT ON (s.customer_id)
    (CONCAT(c.first_name, ' ', c.last_name)) as customer,
    s.sale_date,
    CONCAT(e.first_name, ' ', e.last_name) as seller
from sales s 
inner join products p on p.product_id = s.product_id
inner join customers c on s.customer_id = c.customer_id 
inner join employees e on s.sales_person_id = e.employee_id 
where p.price = 0
order by s.customer_id, s.sale_date;
/*запрос на отчет о покупателях, первая покупка которых была в ходе проведения акций 
(акционные товары отпускали со стоимостью равной 0), отсортированный по id покупателя
 */

