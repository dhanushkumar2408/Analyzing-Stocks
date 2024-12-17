-- 1.Total number of records in the dataset

select
count(*) as total_records from stockprices;

-- 2.Find the company with the highest average closing price

select
company,
round(avg(Close),2)as avg_closing_price
from stockprices
group by 1
order by 2 desc
limit 1;

-- Identify the day with the highest trading volume for each company

select
company,
date,
max(volume) as max_volume
from stockprices
group by 1,2
order by company,max_volume desc;

-- Calculate monthly average closing prices for a specific company(APPLE)

select
date_format(date,'%Y-%m') as month,
round(avg(close),2)as avg_closing_price
from stockprices
where Company = 'AAPL'
group by 1;

-- Find the total dividends paid by each company

select
company,
round(sum(dividends),2) as total_dividends
from stockprices
group by company
order by 2 desc;


-- Calculate the percentage change in closing price from the previous day for  APPLE

select
company,
DATE,
close,
lag(close)over(partition by Company order by date) as Previous_Close,
ROUND((close - lag(close) over(partition by company order by date))
/Lag(close)over(partition by Company order by date)*100,2) as percentage_change
from stockprices
where company = 'AAPL';

-- Calculate the percentage change in closing price from the previous day for MICROSOFT

select
company,
DATE,
close,
lag(close)over(partition by Company order by date) as Previous_Close,
ROUND((close - lag(close) over(partition by company order by date))
/Lag(close)over(partition by Company order by date)*100,2) as percentage_change
from stockprices
where company = 'MSFT';

-- Calculate the percentage change in closing price from the previous day for Google

select
company,
DATE,
close,
lag(close)over(partition by Company order by date) as Previous_Close,
ROUND((close - lag(close) over(partition by company order by date))
/Lag(close)over(partition by Company order by date)*100,2) as percentage_change
from stockprices
where company = 'GOOGL';

-- Calculate the percentage change in closing price from the previous day for AMAZON

select
company,
DATE,
close,
lag(close)over(partition by Company order by date) as Previous_Close,
ROUND((close - lag(close) over(partition by company order by date))
/Lag(close)over(partition by Company order by date)*100,2) as percentage_change
from stockprices
where company = 'AMZN';

-- Calculate the percentage change in closing price from the previous day for META

select
company,
DATE,
close,
lag(close)over(partition by Company order by date) as Previous_Close,
ROUND((close - lag(close) over(partition by company order by date))
/Lag(close)over(partition by Company order by date)*100,2) as percentage_change
from stockprices
where company = 'META';


--  Calculate the percentage change in closing price from the previous day for META

select
company,
DATE,
close,
lag(close)over(partition by Company order by date) as Previous_Close,
ROUND((close - lag(close) over(partition by company order by date))
/Lag(close)over(partition by Company order by date)*100,2) as percentage_change
from stockprices
where company = 'NFLX';

-- Identify stocks with a significant daily price drop (e.g., >5%)

select
date,
company,
open,
close,
round((open-close)/open*100,2) as drop_percentage
from stockprices
where (open-close)/open * 100 > 5;

-- Top 5 companies with the highest total trading volume

select
company,
sum(volume) as total_trading_volume
from stockprices
group by 1 
order by 2 desc
limit 5;

-- Find the stock splits that occurred and their dates

select
company,
date,
stock_split
from stockprices
where Stock_Split>0;

-- Weekly average closing prices

select
company,
week(date) as week_number,
year(date) as year,
round(avg(close),2) as avg_weekly_close
from stockprices
group by 1 ,2,3;

-- HIGHEST VOLUME TRADED

select
company,
max(volume) as Highest_volume_traded
from stockprices
group by 1
limit 1;


- FAANG Comparaitive Analysis
 
-- APPLE vs GOOGLE

select
a.date,
a.company as company1,
a.close as closingprice1,
b.company as company2,
b.close as closingprice2,
(a.close-b.close) as pricedifference
from stockprices a 
join 
stockprices b  on 
a.date = b.date  and a.company = 'AAPL' AND b.company = 'GOOGL'
ORDER BY a.date;

-- AMAZON VS NETFLIX

select
a.date,
a.company as company1,
a.close as closingprice1,
b.company as company2,
b.close as closingprice2,
(a.close-b.close) as pricedifference
from stockprices a 
join 
stockprices b  on 
a.date = b.date  and a.company = 'AMZN' AND b.company = 'NFLX'
ORDER BY a.date;

-- META VS GOOGLE

select
a.date,
a.company as company1,
a.close as closingprice1,
b.company as company2,
b.close as closingprice2,
(a.close-b.close) as pricedifference
from stockprices a 
join 
stockprices b  on 
a.date = b.date  and a.company = 'META' AND b.company = 'GOOGL'
ORDER BY a.date;


-- FAANG STOCKS ANALYSIS
SELECT
company,
date,
close,
lag(close)over(partition by company order by date) as Prev_close,
round(((close-lag(close)over(partition by company order by date))/
lag(close)over(partition by company order by date))*100,2) as Daily_Percentage_change
from stockprices
where company IN ('AAPL', 'META', 'AMZN', 'NFLX', 'GOOGL');

-- VOLATILITY ANALYSIS 

SELECT 
    Company, 
    DATE_FORMAT(Date, '%Y-%m') AS Month,
    ROUND(STDDEV(Close), 2) AS Volatility
FROM stockprices
WHERE Company IN ('AAPL', 'META', 'AMZN', 'NFLX', 'GOOGL')
GROUP BY Company, DATE_FORMAT(Date, '%Y-%m');

-- Profitability Analysis: Daily Profit Calculation

select
company,
date,
round((close-open),2) as daily_profit,
round(((close-open)/open)*100,2)as daily_profit_percentage
from stockprices
where company IN ('AAPL', 'META', 'AMZN', 'NFLX', 'GOOGL');

-- Comparative Analysis: Average Monthly Performance

select
company,
date_format(date,'%Y-%m') as month,
round(avg(close),2) as avg_close
from stockprices
where company IN ('AAPL', 'META', 'AMZN', 'NFLX', 'GOOGL')
group by 1,2
order by 2,3 desc;

-- Moving Averages (7-Day and 30-Day)

select
company,
date,
close,
round(avg(close)over(partition by company order by date rows between 6 preceding and current row),2) as Moving_7day_avg,
round(avg(close)over(partition by company order by date rows between 29 preceding and current row),2) as Moving_30day_avg
from stockprices
where company IN ('AAPL', 'META', 'AMZN', 'NFLX', 'GOOGL');

