

/* 
SQL Music Store Data Analysis Project
Author: Poornima Singh
Date: 03-07-2025
Description: This project analyzes the music store database using SQL to extract insights on customers, sales, and transactions.
*/

/* 
Q1: Who is the senior-most employee based on job title?
*/

SELECT title, last_name, first_name
FROM employee
ORDER BY levels DESC
LIMIT 1;

/* 
Q2: Which countries have the most invoices?
*/

SELECT COUNT(*) AS invoice_count, billing_country
FROM invoice
GROUP BY billing_country
ORDER BY invoice_count DESC;

/* 
Q3: What are the top 3 values of total invoice?
*/

SELECT total
FROM invoice
ORDER BY total DESC
LIMIT 3;

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

SELECT SUM(total), billing_city FROM invoice
GROUP BY billing_city
ORDER BY SUM(total) DESC
LIMIT 1;

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

SELECT customer.customer_id, first_name, last_name, SUM(total) AS total_spending
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total_spending DESC
LIMIT 1;




/* Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

SELECT first_name, last_name, email
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
WHERE track_id IN (SELECT track_id FROM track
                   JOIN genre ON genre.genre_id= track.genre_id
				   WHERE genre.name LIKE 'Rock')
ORDER BY email ;


/* 
Q7: Which genre has sold the most tracks?
*/

SELECT g.name AS genre, COUNT(il.quantity) AS total_tracks_sold
FROM genre g
JOIN track t ON g.genre_id = t.genre_id
JOIN invoice_line il ON t.track_id = il.track_id
GROUP BY genre
ORDER BY total_tracks_sold DESC
LIMIT 1;

/* Q8: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

WITH Customter_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
		FROM invoice
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC,5 DESC)
SELECT * FROM Customter_with_country WHERE RowNo <= 1

