 SELECT a.emailid, a.scsj, b.oname, a.fileid
  FROM zjjk_email_files a, t_file_source b
 WHERE a.fileid = b.id
   AND a.emailid = #{emailid}
 ORDER BY a.scsj DESC