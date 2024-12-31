-- Revenue and Sales Metrics
-- 1. What is the total revenue generated by the store?
SELECT SUM(Total) AS total_rev
FROM Invoice;
-- The store brought in a total revenue of $2328.60. 


-- 2. What are the top 10 best-selling tracks and albums by revenue?
-- Select Track and InvoiceLine, line join on Trackid, group by track, sum the revenue by track, sort them, show only the first 10 
SELECT Track.Name,
    Track.TrackId,
    Sum(InvoiceLine.Quantity) AS total_sold,
    SUM(InvoiceLine.Quantity * Track.UnitPrice) AS revenue
FROM Track
    JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Track.Name,
    Track.TrackId
ORDER BY revenue DESC
LIMIT 10;
-- The top selling tracks by revenue are: Hot Girl, Walkabout, Gay Witch Hunt, How to Stop an Exploding Man, Pilot, Phyllis's Wedding, The Fix, The Woman King, I Do, and The Glass Ballerina. The data is based off of revenue generated but we can also see the quantity of tracks sold. 
SELECT Album.Title AS album_title,
    SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS album_revenue
FROM Track
    JOIN Album ON Album.AlbumId = Track.AlbumId
    JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Album.Title
ORDER BY album_revenue DESC
LIMIT 10;
-- The top selling albums by revenue are: Battlestar Galactica (Classic), Season 1, Minha Historia, The Office, Season 3, Heroes, Season 1, Lost, Season 2, Greatest Hits, Unplugged, Battlestar Galactica, Season 3, Lost, Season 3, Acústico. Since albums are not sold individually, the revenue is calculated from tracks sold within their respective albums. 


-- Music and Artist Insights
-- 3. What genres of music are most popular?
SELECT Genre.Name,
    SUM(InvoiceLine.Quantity) AS tracks_sold
FROM Track
    JOIN Genre ON Genre.GenreId = Track.GenreId
    JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Genre.Name
ORDER BY tracks_sold DESC
LIMIT 5;
-- Out of 25 genres, our most popular five are Rock, Latin, Metal, Alternative & Punk, and Jazz. These are based on tracks sold to measure popularity and not revenue generated. 


-- Geographic Insights
-- 4. Which cities or countries generate the most revenue? I want to run a promotion in popular areas. 
SELECT BillingCountry,
    SUM(Total) AS country_revenue
FROM Invoice
GROUP BY BillingCountry
ORDER BY country_revenue DESC;

SELECT BillingCountry,
    BillingState,
    SUM(Total) AS state_revenue
FROM Invoice
GROUP BY BillingCountry,
    BillingState
ORDER BY BillingCountry,
    state_revenue DESC;
-- The countries that generate the most revenue are: USA, Canada, France, Brazil, and Germany. Although, not every country categorizes regions by states. In our top two countries, CA/TX/UT generate the most revenue in the USA, while ON/QC/BC generate the most revenue in Canada. These would be good states to run promotions in. 



-- Transaction and Seasonal Trends
-- 5. Are there specific times of the year when sales are higher or lower?
SELECT (
        CASE
            WHEN MONTH(InvoiceDate) IN (1, 2, 3) THEN 'Q1'
            WHEN MONTH(InvoiceDate) IN (4, 5, 6) THEN 'Q2'
            WHEN MONTH(InvoiceDate) IN (7, 8, 9) THEN 'Q3'
            WHEN MONTH(InvoiceDate) IN (10, 11, 12) THEN 'Q4'
        end
    ) AS quarter,
    SUM(Total) AS total_sales
FROM Invoice
GROUP BY quarter
ORDER BY total_sales DESC;
-- Although spending seems to be relatively consistent throughout the year, sales generate the most revenue in Q2 and the least in Q4; with a 4% difference in revenue generated between the quarters. 

-- Customer Insights:
-- 6. What can you tell me about our customers that are spending the most on their favorite artists?
SELECT Customer.CustomerId, CONCAT(Customer.FirstName, ' ', Customer.LastName) AS full_name, Track.Composer, SUM(InvoiceLine.Quantity * Track.UnitPrice) AS spent_on_artist
FROM Track
    JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
    JOIN Invoice ON Invoice.InvoiceId = InvoiceLine.InvoiceId
    JOIN Customer ON Customer.CustomerId = Invoice.CustomerId
WHERE Track.Composer IS NOT NULL
GROUP BY Customer.CustomerId, full_name, Track.Composer
ORDER BY spent_on_artist DESC;
-- Since we already have geographic insights we can get the names of customers that spend a lot on their favorite artists. This can allow us to personalize product reccomendations or run promotions for customer retention and loyalty. 