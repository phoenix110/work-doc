select t.id,
       t.yhm,
       dts(t.czsj,1) czsj,
       t.ip,
       t.gjdq,
       t.cs,
       t.bgkid,
       t.ywjlid,
       t.bgklx,
       decode(t.bgklx, '01', '糖尿病', '02', '肿瘤', '03', '心脑', '04', '出生登记', '05', '死亡登记', '06', '死亡无名尸', '07', '伤害监测', t.bgklx) bgklx_text,
       t.gnmk,
       t.gnmc,
       t.czlx,
       decode(t.czlx, '01', '新增', '02', '修改', '03', '审核', '04', '删除', '05', '导入', '06', '导出', t.czlx) czlx_text,
       t.jgdm,
       t.total,
       xzdm.mc csmc,
       (CASE WHEN t.bgklx = '01' AND t.ywjlid IS NOT NULL THEN (SELECT tnb.vc_bgkcode FROM zjjk_tnb_bgk tnb WHERE tnb.vc_bgkid = t.bgkid)
            WHEN t.bgklx = '03' AND t.ywjlid IS NOT NULL THEN (SELECT xnxg.vc_bgkbh FROM zjjk_xnxg_bgk xnxg WHERE xnxg.vc_bgkid = t.bgkid)
            ELSE t.bgkid END) kh,
       t.rn,
       case when bgklx = '01' then
            (select vc_hzxm from zjjk_tnb_bgk a, zjjk_tnb_hzxx b where a.vc_hzid = b.vc_personid and a.vc_bgkid = t.bgkid)
       when bgklx = '02' then
            (select vc_hzxm from zjjk_zl_bgk a, zjjk_zl_hzxx b where a.vc_hzid = b.vc_personid and a.vc_bgkid = t.bgkid)
       when bgklx = '03' then
            (select vc_hzxm from zjjk_xnxg_bgk a where a.vc_bgkid = t.bgkid)
       when bgklx = '04' then
            (select vc_xsrid from zjmb_cs_bgk a where a.vc_bgkid = t.bgkid)
       when bgklx = '05' then
            (select vc_xm from zjmb_sw_bgk a where a.vc_bgkid = t.bgkid)
       when bgklx = '06' then
            (select vc_xm from zjmb_sw_bgk_wm a where a.vc_bgkid = t.bgkid)
       when bgklx = '07' then
            (select vc_xm from zjmb_shjc_bgk a where a.vc_bgkid = t.bgkid)
       end hzxm
  from (select id,
               yhm,
               czsj,
               ip,
               gjdq,
               cs,
               bgkid,
               ywjlid,
               bgklx,
               gnmk,
               gnmc,
               czlx,
               jgdm,
               total,
               rownum rn
          from (select id,
                       yhm,
                       czsj,
                       ip,
                       gjdq,
                       cs,
                       bgkid,
                       ywjlid,
                       bgklx,
                       gnmk,
                       gnmc,
                       czlx,
                       jgdm,
                       count(1) over() total
                  from zjjk_yw_log
                  where jgdm like #{vc_gldw} || '%'
                  <if if(StringUtils.isNotBlank(#{gjz}))>
                    and gnmc like '%' || #{gjz} || '%'
                  </if>
                  <if if(StringUtils.isNotBlank(#{dt_drsj_ks}))>
                    and czsj >= std(#{dt_drsj_ks}, 1)
                  </if>
                  <if if(StringUtils.isNotBlank(#{dt_drsj_js}))>
                    and czsj <= std(#{dt_drsj_js}, 1)
                  </if>
                  <if if(StringUtils.isNotBlank(#{bgklx}))>
                    AND bgklx = #{bgklx}
                  </if>
                  <if if(StringUtils.isNotBlank(#{bgklx}) && StringUtils.isNotBlank(#{bgkh}) && "01".equals(#{bgklx}))>
                    AND EXISTS (SELECT 1 FROM zjjk_tnb_bgk b1 WHERE b1.vc_bgkid = bgkid AND b1.vc_bgkcode = #{bgkh})
                  </if>
                  <if if(StringUtils.isNotBlank(#{bgklx}) && StringUtils.isNotBlank(#{bgkh}) && "03".equals(#{bgklx}))>
                    AND EXISTS (SELECT 1 FROM zjjk_xnxg_bgk b3 WHERE b3.vc_bgkid = bgkid AND b3.vc_bgkbh = #{bgkh})
                  </if>
                  <if if(StringUtils.isNotBlank(#{bgklx}) && StringUtils.isNotBlank(#{bgkh}) && !"01".equals(#{bgklx}) && !"03".equals(#{bgklx}))>
                    AND bgkid = #{bgkh}
                  </if>
                  order by czsj desc
                  )
         where rownum <= #{rn_e}) t, p_xzdm xzdm
 where rn >= #{rn_s}
  and t.cs = xzdm.dm(+)                                                                                                                                                