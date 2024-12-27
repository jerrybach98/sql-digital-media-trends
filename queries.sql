-- Revenue and Sales Metrics
-- 1. What is the total revenue generated by the store?
SELECT SUM(Total) AS total_rev
FROM Invoice;
-- The store brought in a total revenue of $2328.60. 

-- 2. What are the top 10 best-selling tracks and albums by revenue?
-- Select Track and InvoiceLine, line join on Trackid, group by track, sum the revenue by track, sort them, show only the first 10 

SELECT Track.Name, Track.TrackId, Sum(InvoiceLine.Quantity) AS total_sold, SUM(InvoiceLine.Quantity*Track.UnitPrice) AS revenue 
FROM Track
JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Track.Name, Track.TrackId
ORDER BY revenue DESC LIMIT 10; 
-- The top selling tracks are: Hot Girl, Walkabout, Gay Witch Hunt, How to Stop an Exploding Man, Pilot, Phyllis's Wedding, The Fix, The Woman King, I Do, and The Glass Ballerina. This shows how many tracks were sold as well as their revenue. 

SELECT Album.Title AS album_title, SUM(InvoiceLine.Quantity*InvoiceLine.UnitPrice) AS album_revenue 
FROM Track
JOIN Album ON Album.AlbumId = Track.AlbumId
JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Album.Title
ORDER BY album_revenue DESC LIMIT 10;
-- 

-- Music and Artist Insights
-- 3. What genres of music are most popular?

-- Geographic Insights
-- 4. Which cities or countries generate the most revenue?

-- Transaction and Seasonal Trends
-- 5. Are there specific times of the year when sales are higher or lower?
-- 6. Which artist are popular by week, month, year?

-- Customer Insights:
-- 7. What can you tell me about our customers that are spending the most on [genre], [artist], etc.?

-- Time Based Analysis
-- 8. Advanced question(?)