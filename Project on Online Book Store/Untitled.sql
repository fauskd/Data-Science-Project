#Basic Queries
#1) Retrieve all books in the "Fiction" genre
select distinct(Genre) from books;
select count(distinct(Genre)) from books;
select * from books where Genre = 'Fiction';



#2) Find books published after the year 1950
select * from books where Published_Year > 1950;


#3) List all customers from the Canada
select * from customers where country = 'Canada';


#4) Show orders placed in November 2023
select * from orders 
where Order_Date between '2023-11-01' and '2023-11-30';


#5) Retrieve the total stock of books available
select sum(Stock) as Total_stock from books;


#6) Find the details of the most expensive book
select * from books order by Price desc;
select * from books order by Price desc limit 1;

#7) Show all customers who ordered more than 1 quantity of a book
select * from orders where Quantity >= 2;


#8) Retrieve all orders where the total amount exceeds $100
select Quantity, Total_Amount from orders where Total_Amount > 100;


#9) List all genres available in the Books table
select distinct(Genre) from books;


#10) Find the book with the lowest stock
select Book_ID, Stock from books order by Stock limit 50; 


#11) Calculate the total revenue generated from all orders
select sum(Total_Amount) as Revenue from orders;




-- Advance Queries
-- 1) Retrieve the total number of books sold for each genre
select Genre as each_genre, sum(Quantity) as total_sold
from orders
join books
on orders.Book_ID = books.Book_ID
group by Genre;


-- 2) Find the average price of books in the "Fantasy" genre
select avg(Price) as avg_price
from books
where Genre = 'Fantasy';


-- 3) List customers who have placed at least 2 orders
select o.Customer_ID, c.Name,count(o.Order_ID) as book_order
from orders as o
join customers as c
on o.Customer_ID = c.Customer_ID 
group by o.Customer_ID, c.Name
having count(Order_ID) >= 2;


-- 4) Find the most frequently ordered book
select o.Book_ID, b.Title as title, count(o.Order_ID) as order_count
from orders as o
join books as b
on o.Book_ID = b.Book_ID
group by o.Book_ID, b.title
order by order_count desc
limit 1;



-- 5) Show the top 3 most expensive books of 'Fantasy' Genre
select * from books
where Genre = 'Fantasy'
order by Price desc
limit 3;


-- 6) Retrieve the total quantity of books sold by each author
select b.Author, sum(o.Quantity) as total_sold
from books as b
join orders as o
on b.Book_ID = o.Book_ID
group by b.Author
order by total_sold desc;


-- 7) List the cities where customers who spent over $30 are located
select distinct c.City, o.Total_Amount
from customers as c
join orders as o
on o.Customer_ID = c.Customer_ID
where o.Total_Amount > 30
;


-- 8) Find the customer who spent the most on orders
select c.Customer_ID, c.Name, sum(o.Total_Amount) as total_spent
from customers as c
join orders as o on c.Customer_ID = o.Customer_ID
group by c.Customer_ID, c.Name
order by total_spent desc
limit 1;


-- 9) Calculate the stock remaining after fulfilling all orders
SELECT 
    b.Book_ID,
    b.Title,
    b.Stock,
    COALESCE(SUM(o.Quantity), 0) AS ordered_quantity,
    b.Stock - COALESCE(SUM(o.Quantity), 0) AS Remaining_quantity
FROM
    books AS b
        JOIN
    orders AS o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID, b.Title, b.Stock;


