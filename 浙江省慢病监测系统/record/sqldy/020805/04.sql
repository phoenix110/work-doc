SELECT COUNT(1) AS total
  FROM zjjk_email_mx a, zjjk_email_sjr b
 WHERE a.vc_emailid = b.emailid
   AND b.vc_scbz = 2
   AND b.vc_sfyd = 2
   AND b.sjrid = #{czyjgdm}