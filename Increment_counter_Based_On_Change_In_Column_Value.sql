declare @t table (
    Id int primary key,
    Value int not null
);

insert into @t (Id, Value)
values
(1, 3),
(2, 3),
(3, 2),
(4, 2),
(5, 2),
(6, 3),
(7, 0),
(8, 0);

select sq.Id, sq.Value,
    sum(case when sq.pVal = sq.Value then 0 else 1 end) over(order by sq.Id) as [Counter]
from (
    select t.Id, t.Value, lag(t.Value, 1, null) over(order by t.Id) as [pVal]
    from @t t
) sq
order by sq.Id;