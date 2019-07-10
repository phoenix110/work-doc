select vc_sfkid,
       vc_bgkid,
       dts(dt_sfrq, 0) dt_sfrq,
       vc_sfys,
       dts(dt_cjsj, 0) dt_cjsj,
       vc_brsftnb,
       total,
       rn
  from (select vc_sfkid,
               vc_bgkid,
               dt_sfrq,
               vc_sfys,
               dt_cjsj,
               vc_brsftnb,
               total,
               rownum as rn
          from (select vc_sfkid,
                       vc_bgkid,
                       dt_sfrq,
                       vc_sfys,
                       dt_cjsj,
                       vc_brsftnb,
                       count(1) over() as total
                  from zjjk_tnb_sfk
                 where vc_bgkid = #{vc_bgkid}
                 order by dt_cjsj asc)
         where rownum <= #{rn_e})
 where rn >= #{rn_s}