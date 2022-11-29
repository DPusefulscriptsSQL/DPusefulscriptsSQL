--Select * from Deepti  --Order By Id
;WIth s as(
SELECT 1 Id,'2018-08-01 14:45:43.000' Start_time,'2018-08-10 23:08:00.000' End_time,44 Prod_id UNION ALL
SELECT 2,'2018-08-10 23:08:00.000','2018-08-10 23:12:00.000',44 UNION ALL
SELECT 3,'2018-08-10 23:12:00.000','2018-08-10 23:14:00.000',44 UNION ALL
SELECT 4,'2018-08-10 23:14:00.000','2018-08-10 23:16:00.000',42 UNION ALL
SELECT 5,'2018-08-10 23:16:00.000','2018-08-10 23:18:00.000',42 UNION ALL
SELECT 6,'2018-08-10 23:18:00.000','2018-08-10 23:20:00.000',43 UNION ALL
SELECT 7,'2018-08-10 23:20:00.000','2018-08-10 23:22:00.000',43 UNION ALL
SELECT 8,'2018-08-10 23:22:00.000','2018-08-10 23:24:00.000',44 UNION ALL
SELECT 9,'2018-08-10 23:24:00.000','2018-08-10 23:26:00.000',45 UNION ALL
SELECT 10,'2018-08-10 23:26:00.000','2018-08-13 19:02:00.000',44 UNION ALL
SELECT 11,'2018-08-13 19:02:00.000','2018-08-13 19:06:00.000',45 UNION ALL
SELECT 12,'2018-08-13 19:06:00.000','2018-08-13 19:08:00.000',44 
)
,S2 As ( select Otr.Id, Otr.Prod_Id,Start_Time,End_Time,
    sum(case when Otr.Prev_Prod_Id = Otr.Prod_Id then 0 else 1 end) over(order by Otr.Id) as [SrNo]
from (
    select Inr.Id, Inr.Prod_Id, lag(Inr.Prod_Id, 1, null) over(order by Inr.Id) as [Prev_Prod_Id],Start_Time, End_Time
    from s Inr
) Otr
)
Select SrNo,Prod_Id, Min(Start_Time), Max(End_Time) from S2 Group by SrNo, Prod_id Order By SrNo