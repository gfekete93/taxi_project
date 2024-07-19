select 
	b.CuoponID,
	b.BetID,
	b.BetStake,
	b.BetOdds
from Bet b
left join Coupon c on b.CouponID =c.CuoponID 
ordered by c.CuoponPlacedDate asc 



select
	CouponID, 
	BetID, 
	BetStake, 
	EventName, 
	MarketName
	

select 
	b.CuoponID,
	b.BetID,
	b.BetStake,
	e.EventName,
	m.MarketName
from BetSelection bs 
left join Bet b on bs.BetID = b.BetID
left join Coupon c on b.CouponID =c.CuoponID
left join MarketSelection ms on bs.MarketSelectionID = ms.MarketSelectionID
left join Market m on ms.MarketID = m.MarketID 
left join Event e on m.EventID = e.EventID
where e.BetStake >= 10
and m.SettledStatus =  2
ordered by e.EventStartTime


select 

with BetRanked as
(
    select
		c.CustomerID, 
		c.CouponID, 
		b.BetID, 
		b.BetStake, 
		c.CouponPlacedDate,
        ROW_NUMBER() OVER (PARTITION BY c.CustomerID order by c.CouponPlacedDate DESC) as rn
	from Bet b
	left join Coupon c on b.CouponID =c.CuoponID 
	where (c.CouponPlacedDate >= '2017-10-11' and c.CouponPlacedDate <= '2018-10-10')
	and c.BetID is not null
)
select 
    CustomerID, 
    CouponID, 
    BetID, 
    BetStake, 
    CouponPlacedDate
from BetRanked
where rn = 1
order by CustomerID

select sum(b.BetStake) as TotalAmount, Month(c.CouponPlacedDate)  as Month
from Bet b left join Coupon c on b.CouponID = c.CouponId 
group by Month(c.CouponPlacedDate) 
order by Month


select avg(BetStake) as AvgStakePerBet, Month(c.CouponPlacedDate)  as Month
from Bet b left join Coupon c on b.CouponID = c.CouponId 
group by Month(c.CouponPlacedDate) 
order by Month


select sum(b.BetStake) as TotalAmount, Month(c.CouponPlacedDate)  as Month
from Bet b left join Coupon c on b.CouponID = c.CouponId 
where CouponStatus in (2,3)
group by Month(c.CouponPlacedDate) 
order by Month


select avg(BetStake) as AvgStakePerBet, Month(c.CouponPlacedDate)  as Month
from Bet b left join Coupon c on b.CouponID = c.CouponId 
where CouponStatus in (2,3)
group by Month(c.CouponPlacedDate) 
order by Month


with profitcalc  as 
(
	select 
	c.CustomerId,
	cu.CustomerName,
	SUM(
		case when c.CouponStatus = 2 then BetStake*BetOdds
		when c.CouponStatus = 3 then BetStake*-1
		else 0
		end 
		) as calc
from Bet b 
left join Coupon c on b.CouponID = c.CouponId 
left join Customer cu on c.CustomerId = cu.CustomerId
group by  
c.CustomerId,
cu.CustomerName
) 
select 
	CustomerId,
	CustomerName,
	case when calc >= 50 then 'VeryHigh'
		 when (calc <= 50 and calc >= 20) then 'High'
		 when (calc <= 20 and calc >= 0) then 'Mid'
		 when (calc <= 0and calc >= -50) then 'Low'
		 when calc <= -50 then 'VeryLow'
	End as [ClassificationName]
from profitcalc


DECLARE @CustomerName nvarchar(100) = 'Peter'
DECLARE @Datec datetime = DATEADD(mm, -12, GETDATE())

SELECT c.CouponID, c.CustomerID
from Coupon c 
LEFT JOIN Customer cu ON cu.CustomerID = c.CustomerID
WHERE c.CouponPlacedDate >= @Datec
  AND cu.CustomerName LIKE '%' + @CustomerName + '%'
