SELECT s.Sheet_Id, Sheet_Desc, Sheet_Type_Desc, Interval, sc.Result_On, Modified_On, 
convert(varchar(5),DateDiff(SS, sc.Result_On, Modified_On)/3600)+':'+convert(varchar(5),DateDiff(SS, sc.Result_On, Modified_On)%3600/60)+':'+convert(varchar(5),(DateDiff(SS, sc.Result_On, Modified_On)%60)) [Lag (hh:mm:ss)],
COUNT(sv.Var_Id) [Sheet Vars]
FROM dbo.Sheets s (NOLOCK)
JOIN dbo.Sheet_Type st (NOLOCK) ON st.Sheet_Type_Id = s.Sheet_Type
LEFT JOIN dbo.Sheet_Variables sv (NOLOCK) ON sv.Sheet_Id = s.Sheet_Id
JOIN dbo.Sheet_Columns sc (NOLOCK) ON sc.Sheet_Id = s.Sheet_Id
JOIN dbo.Sheet_Column_History sch (NOLOCK) ON sch.Sheet_Id = sc.Sheet_Id AND sc.Result_On = sch.Result_On AND sch.DBTT_Id = 2
WHERE s.Is_Active = 1 AND sc.Result_On > '2020-09-16 00:00:00.000'
GROUP BY s.Sheet_Id, Sheet_Desc, Sheet_Type_Desc, Interval, sc.Result_On, Modified_On
ORDER BY [Lag (hh:mm:ss)] Desc
GO

CREATE NONCLUSTERED INDEX  IX_tmp_Activities_SheetId_Status
ON [dbo].[Activities] ([Sheet_Id],[Activity_Status])
INCLUDE ([Activity_Id],[Activity_Type_Id],[KeyId],[KeyId1],[PU_Id],[Title])
GO