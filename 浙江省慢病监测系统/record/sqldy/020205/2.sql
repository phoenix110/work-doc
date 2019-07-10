select a.vc_bgkid,
      dts(a.dt_sczdrq,0) as dt_scjzrq,
       b.vc_sfzh,
       b.vc_hkshen,
       b.vc_hks,
       b.vc_hkqx,
       b.vc_hkjd,
       b.vc_hkjw,
       b.vc_hkxxdz,
       b.vc_hkshen vc_hkqcs,
       b.vc_hks vc_hkqcshi,
       b.vc_hkqx vc_hkqcqx,
       b.vc_hkjd vc_hkqcjd,
       b.vc_hkjw vc_hkqcjw,
       b.vc_hkxxdz vc_hkqcxx
  from zjjk_tnb_bgk a, zjjk_tnb_hzxx b
 where a.vc_hzid = b.vc_personid
   and a.vc_bgkid = #{vc_bgkid}