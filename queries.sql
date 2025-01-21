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
-- The top-selling tracks by revenue are: Hot Girl, Walkabout, Gay Witch Hunt, How to Stop an Exploding Man, Pilot, Phyllis's Wedding, The Fix, The Woman King, I Do, and The Glass Ballerina. This ranking is based on revenue generated, though we also have the option to analyze by the quantity of tracks sold for further insights.
SELECT Album.Title AS album_title,
    SUM(InvoiceLine.Quantity * InvoiceLine.UnitPrice) AS album_revenue
FROM Track
    JOIN Album ON Album.AlbumId = Track.AlbumId
    JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
GROUP BY Album.Title
ORDER BY album_revenue DESC
LIMIT 10;
-- The top-selling albums by revenue are: Battlestar Galactica (Classic), Season 1, Minha Historia, The Office, Season 3, Heroes, Season 1, Lost, Season 2, Greatest Hits, Unplugged, Battlestar Galactica, Season 3, Lost, Season 3, and Acústico. Since albums are not sold as a single product, the revenue figures reflect the sales of individual tracks within each respective album.


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
-- Among the 25 genres, the five most popular based on track sales are Rock, Latin, Metal, Alternative & Punk, and Jazz. This ranking reflects track sales as a measure of popularity rather than revenue generated.


-- Geographic Insights
-- 4. Which states or countries generate the most revenue? I want to run a promotion in popular areas. 
SELECT BillingCountry,
    SUM(Total) AS country_revenue
FROM Invoice
GROUP BY BillingCountry
ORDER BY country_revenue DESC;1

SELECT BillingCountry,
    BillingState,
    SUM(Total) AS state_revenue
FROM Invoice
WHERE BillingCountry = "USA"
    OR BillingCountry = "Canada"
GROUP BY BillingCountry,
    BillingState
ORDER BY BillingCountry,
    state_revenue DESC;
-- The countries generating the most revenue are the USA, Canada, France, Brazil, and Germany. Within our top two countries, the states driving the highest revenue in the USA are California, Texas, and Utah, while the provinces leading in Canada are Ontario, Quebec, and British Columbia. These regions would be strategic targets for promotional campaigns.


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
-- The data indicates that while spending remains relatively steady throughout the year, sales revenue peaks in Q2 and reaches its lowest point in Q4, with a 4% variance in revenue between the two quarters.


-- Customer Insights:
-- 6. What can you tell me about our top spending customers?
SELECT Customer.CustomerId,
    CONCAT(Customer.FirstName, ' ', Customer.LastName) AS full_name,
    Track.Composer,
    SUM(InvoiceLine.Quantity * Track.UnitPrice) AS spent_on_artist
FROM Track
    JOIN InvoiceLine ON InvoiceLine.TrackId = Track.TrackId
    JOIN Invoice ON Invoice.InvoiceId = InvoiceLine.InvoiceId
    JOIN Customer ON Customer.CustomerId = Invoice.CustomerId
WHERE Track.Composer IS NOT NULL
GROUP BY Customer.CustomerId,
    full_name,
    Track.Composer
ORDER BY spent_on_artist DESC;
-- Given that we already have geographic insights, I have compiled a list of our top spending customers along with the artists they’ve supported. This information can be leveraged to personalize product recommendations and design targeted promotions, enhancing customer retention and loyalty.