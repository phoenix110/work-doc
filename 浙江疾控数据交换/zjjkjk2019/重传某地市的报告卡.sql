/* 重传某地市的报告卡 */

-- 肿瘤报告卡
update zjjk_zl_bgk b set dt_xgsj = sysdate, vc_ccid= '湖州'
   where substr(vc_bgdw, 1, 6) <> '3305'
    and vc_bgkzt in ('0', '2', '6', '7')
    and vc_shbz in ('1', '3', '5', '6', '7', '8')
    and exists (select 1
          from zjjk_zl_hzxx a
         where b.vc_hzid = a.vc_personid
           and a.vc_hkqxdm like '3305%');
           
-- 肿瘤初访卡
update ZJJK_ZL_CCSFK a set vc_hzid = '湖州',  dt_xgsj = sysdate
where  a.vc_bgkid in (select vc_bgkid from zjjk_zl_bgk b where b.vc_ccid = '湖州');
 
-- 肿瘤随访卡
update ZJJK_ZL_SFK a set vc_hzid = '湖州',     dt_xgsj = sysdate
where  a.vc_bgkid in (select vc_bgkid from zjjk_zl_bgk b where b.vc_ccid = '湖州') ;

-- 糖尿病报告卡
update zjjk_tnb_bgk b set dt_xgsj = sysdate, vc_ccid= '湖州'
   where substr(vc_bgdw, 1, 4) <> '3305'
    and vc_bgkzt in ('0', '2', '6', '7')
    and vc_shbz in ('1', '3', '5', '6', '7', '8')
    and exists (select 1
          from zjjk_tnb_hzxx a
         where b.vc_hzid = a.vc_personid
           and a.vc_hkqx like '3305%');

-- 糖尿病初访卡和随访卡
update ZJJK_TNB_SFK a
   set vc_hzid = '湖州', dt_xgsj = sysdate
 where a.vc_bgkid in
       (select vc_bgkid from zjjk_tnb_bgk b where b.vc_ccid = '湖州');
       
-- 心脑报告卡
 update zjjk_xnxg_bgk b set dt_xgsj = sysdate, vc_ccid= '湖州'
   where b.VC_CZHKQX like '3305%'
   and substr(vc_bkdwyy, 1, 4) <> '3305'
   and vc_kzt in ('0','2','6','7')
   and vc_shbz in ('1','3','5','6','7','8');
   
-- 心脑初访卡
update ZJJK_XNXG_CFK a set vc_hzsfzh = '湖州',     dt_xgsj = sysdate 
where  a.vc_bgkid in (select vc_bgkid from zjjk_xnxg_bgk b where b.vc_ccid = '湖州');

-- 心脑随访卡
update ZJJK_XNXG_SFK a set vc_qydz = '湖州',     dt_xgsj = sysdate
where  a.vc_bgkid in (select vc_bgkid from zjjk_xnxg_bgk b where b.vc_ccid = '湖州');

-- 死亡报告卡
update zjmb_sw_bgk b set dt_xgsj = sysdate, vc_ccid= '湖州'
   where b.vc_hkqxdm like '3305%'
   and substr(VC_CJDWDM, 1, 4) <> '3305'
   and vc_bgklb in ('0','2','6','7')
   and vc_shbz in ('1','3','5','6','7','8');

   
