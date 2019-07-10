select id,
       xzqh,
       xzmc,
       ksrq,
       jsrq,
       tjnd,
       mbzl,
       decode(mbzl, 'tnb', '糖尿病', 'zl', '肿瘤', 'xn', '心脑') mbmc,
       nldm,
       nlmc,
       fb_m,
       fb_w,
       fb_s,
       cjsj,
       cjyh,
       cjjgdm,
       sort,
       dts(cjsj, 0) cjsj_ymd
  from zjjk_tjbb_nlxbbgfbl
  where id = #{id}
  order by sort       