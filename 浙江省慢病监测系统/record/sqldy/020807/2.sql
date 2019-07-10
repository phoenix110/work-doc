select count(1) hjsbs,
       nvl(sum(decode(vc_dzjg, '1', 1)), 0) zqsbs,
       nvl(sum(decode(vc_dzjg, '2', 1)), 0) cwsbs,
       a.vc_bgdw sbdw,
       nvl((select max(areaname) from ZJSJK_WS_CONFIG b where rpad(b.areacode,8,'0') = vc_bgdw and b.wstype = '1' ),a.vc_bgdw) sbdw_text,
       vc_bz,
       decode(a.vc_bz,
              '1',
              '肿瘤报卡',
              '2',
              '糖尿病报卡',
              '3',
              '心脑报卡',
              '4',
              '伤害报卡',
              '5',
              '死亡报卡',
              '6',
              '糖尿病初访卡',
              '7',
              '糖尿病随访卡',
              '8',
              '心脑初访卡',
              '9',
              '心脑随访卡',
              '10',
              '肿瘤初访卡',
              '11',
              '肿瘤随访卡',
              '12',
              '校验结果',
              a.vc_bz) sbxt
  from zjjk_dz a
  where a.vc_bgdw like #{vc_gldw}||'%'
  <if if(StringUtils.isNotBlank(#{vc_bgdw}))>
   and a.vc_bgdw like #{vc_bgdw}||'%'
  </if>
  <if if(StringUtils.isNotBlank(#{dt_drsj_ks}))>
     and DT_RKSJ >= std(#{dt_drsj_ks}, 1)
  </if>
  <if if(StringUtils.isNotBlank(#{dt_drsj_js}))>
      and DT_RKSJ <= std(#{dt_drsj_js}, 1)
  </if>
 group by a.vc_bz, a.vc_bgdw
 order by a.vc_bz                                                                                                                                                                                                                                                                                                                                                      