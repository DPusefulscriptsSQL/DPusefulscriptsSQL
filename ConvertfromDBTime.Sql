declare @DBzone varchar(100)

Select @DBzone=value from Site_Parameters where parm_id = 192;
    SELECT c.Comment_Id,
            c.TopOfChain_Id,
            EntryOn = dbo.fnServer_CmnConvertFromDbTime(c.Entry_On,'UTC'),
            ModifiedOn = dbo.fnServer_CmnConvertFromDbTime(c.Modified_On,'UTC'),
            --EntryOn = Dateadd(second,Datediff(SECOND,getdate() , getutcdate()),c.Entry_On),
            --ModifiedOn = Dateadd(second,Datediff(SECOND,getdate() , getutcdate()),c.Modified_On),
			EntryOn = c.Entry_On at time zone @DBzone at time zone 'utc',
            u.User_Id,
            u.UserName,
            CommentText = convert(nvarchar(max), Coalesce(c.Comment_Text, c.comment)),(SELECT  COUNT(*) FROM COMMENTS CC WHERE CC.TopOfChain_Id=c.TopOfChain_Id) AS comment_count,
            (SELECT ca.attachments from comment_attachment ca where ca.comment_id=c.Comment_Id) AS attachments
    FROM Comments c
    JOIN Users u on u.User_Id = c.User_Id
    WHERE c.Comment_Id = 3401
    or c.TopOfChain_Id = 3401
    Order BY 3 DESC


	 c.Entry_On at time zone @DBzone at time zone 'utc'
	 
	 SQL Server 2016 +