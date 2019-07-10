SELECT vc_emailid,
       vc_xxbt,
       vc_xxlb,
       DECODE(vc_xxlb,1,'通知消息','2','普通消息') vc_xxlb_ms,
       vc_xxview,
       DECODE(vc_sfyd,1,'已阅读','2','新邮件') vc_sfyd_ms,
       vc_sfyd,
       vc_cjyh,
       to_char(vc_cjrq,'yyyy-mm-dd HH24:mi:ss') vc_cjrq,
       sjrid,
       vc_cjyhjgid,
       vc_cjyhjgid_mc,
       vc_scbz,
       total,
       rn
  FROM (SELECT vc_emailid,
               vc_xxbt,
               vc_xxlb,
               vc_xxview,
               vc_sfyd,
               vc_cjyh,
               vc_cjrq,
               sjrid,
               vc_cjyhjgid_mc,
               vc_cjyhjgid,
               vc_scbz,
               total,
               rownum rn
          FROM (SELECT a.vc_emailid,
                       a.vc_xxbt,
                       a.vc_xxlb,
                       a.vc_xxview,
                       b.vc_sfyd,
                       a.vc_cjyh,
                       a.vc_cjrq,
                       b.sjrid,
                       c.mc vc_cjyhjgid_mc,
                       a.vc_cjyhjgid,
                       b.vc_scbz,
                       COUNT(1) over() AS total
                  FROM zjjk_email_mx a, zjjk_email_sjr b, p_yljg c
                 WHERE a.vc_emailid = b.emailid
                   AND b.vc_scbz = 2
                   AND a.vc_cjyhjgid = c.dm
          <if if(StringUtils.isNotBlank(#{czyjgdm}))>
                   AND b.sjrid = #{czyjgdm}
          </if>          
          <if if(StringUtils.isNotBlank(#{vc_xxbt}))>
                   AND LOWER(a.vc_xxbt) LIKE '%'||LOWER(#{vc_xxbt})||'%'
          </if>
          <if if(StringUtils.isNotBlank(#{vc_cjyh}))>
                   AND (a.vc_cjyh LIKE '%'||#{vc_cjyh}||'%' OR c.mc LIKE '%'||#{vc_cjyh}||'%')
          </if>
          <if if(StringUtils.isNotBlank(#{vc_cjrq_ks}))>
                   AND a.vc_cjrq >= to_date(#{vc_cjrq_ks},'yyyy-mm-dd')
          </if>
          <if if(StringUtils.isNotBlank(#{vc_cjrq_js}))>
                   AND a.vc_cjrq <= to_date(#{vc_cjrq_js},'yyyy-mm-dd')
          </if>
              ORDER BY a.vc_cjrq DESC)
          WHERE rownum <= #{rn_e})
 WHERE rn >= #{rn_s}                                                                                                                                            