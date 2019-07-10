with ncz as
 (SELECT b.vc_nczzd fldm,
         DECODE(b.vc_nczzd,
                '1',
                '蛛网膜下腔出血',
                '2',
                '脑出血',
                '3',
                '未分类',
                '5',
                '脑血栓形成',
                '4',
                '脑栓塞',
                '6',
                '分类不明',
                vc_nczzd) as jbmc,
         sum(decode(k.vc_cxyy, null, 1, 0)) SC_S,
         sum(decode(k.vc_cxyy, '4', 1, 0)) SW_S,
         sum(decode(k.vc_cxyy, '1', 1, 0)) SF_S,
         sum(decode(k.vc_hjqc,'1',1,0)) HKQC_S,
         sum(case
               when k.vc_cxyy is not null and k.vc_cxyy <> '1' and k.vc_cxyy <> '4' then
                1
               else
                0
             end) QT_S
    from zjjk_xnxg_bgk b ,
    (select c.* from (select s.*,ROW_NUMBER() OVER(PARTITION BY vc_bgkid  ORDER BY DT_SFRQ DESC) ROWN  from zjjk_xnxg_sfk s ) c where ROWN = 1) k
   where b.vc_nczzd is not null
     and k.vc_bgkid = b.vc_bgkid
     and b.vc_scbz = '2'
     and (B.vc_gldwdm like #{vc_gldw}||'%' )
     and b.vc_shbz in ('3', '5', '6', '7', '8')
     and b.vc_kzt in ('0', '2', '6', '7') 
     and to_char(b.dt_fbrq,'yyyy') = #{tjnd}
   group by b.vc_nczzd),
 gxb as (
  select vc_gxbzd fldm,
         DECODE(vc_gxbzd,
                '1',
                '急性心肌梗死',
                '2',
                '心性猝死',
                '3',
                '分类不明',
                vc_gxbzd) as jbmc,
         sum(decode(k.vc_cxyy, null, 1, 0)) SC_S,
         sum(decode(k.vc_cxyy, '4', 1, 0)) SW_S,
         sum(decode(k.vc_cxyy, '1', 1, 0)) SF_S,
         sum(decode(k.vc_hjqc,'1',1,0)) HKQC_S,
         sum(case
               when k.vc_cxyy is not null and k.vc_cxyy <> '1' and k.vc_cxyy <> '4' then
                1
               else
                0
             end) QT_S
    from zjjk_xnxg_bgk b,(select c.* from (
select s.*,ROW_NUMBER() OVER(PARTITION BY vc_bgkid  ORDER BY DT_SFRQ DESC) ROWN  from zjjk_xnxg_sfk s 
) c where ROWN = 1) k
   where b.vc_gxbzd is not null
     and k.vc_bgkid = b.vc_bgkid
     and b.vc_scbz = '2'
     and (B.vc_gldwdm like #{vc_gldw}||'%' )
     and b.vc_shbz in ('3', '5', '6', '7', '8')
     and b.vc_kzt in ('0', '2', '6', '7')
     and to_char(b.dt_fbrq,'yyyy') = #{tjnd}
   group by b.vc_gxbzd 
),
tnb as (
select vc_tnblx fldm,
       '' jbmc,
       sum(sc_s) sc_s,
       sum(sw_s) sw_s,
       sum(sf_s) sf_s,
       sum(hkqc_s) hkqc_s,
       sum(qt_s) qt_s
  from (select case
                 when b.vc_tnblx = '1' then
                  '1'
                 when b.vc_tnblx = '2' then
                  '2'
                 when b.vc_tnblx = '3' or vc_tnblx = '4' then
                  '3'
               end vc_tnblx,
               '' jbmc,
         sum(decode(k.vc_cxglyy, null, 1, 0)) SC_S,
         sum(decode(k.vc_cxglyy, '4', 1, 0)) SW_S,
         sum(decode(k.vc_cxglyy, '1', 1, 0)) SF_S,
         sum(decode(k.vc_hksfqc,'1',1,0)) HKQC_S,
         sum(case
               when k.vc_cxglyy is not null and k.vc_cxglyy <> '1' and k.vc_cxglyy <> '4' then
                1
               else
                0
             end) QT_S
  from zjjk_tnb_bgk b,(select c.* from (
  select s.*,ROW_NUMBER() OVER(PARTITION BY vc_bgkid  ORDER BY DT_SFRQ DESC) ROWN  from zjjk_tnb_sfk s 
  ) c where ROWN = 1) k
  where b.vc_tnblx is not null
    and b.vc_bgkid = k.vc_bgkid
    and b.vc_scbz = '0'
    and (b.vc_gldw like #{vc_gldw}||'%' )
    and b.vc_shbz in ('3', '5', '6', '7', '8')
    and b.vc_bgkzt in ('0', '2', '6', '7')
    and to_char(b.dt_sczdrq,'yyyy') = #{tjnd}
  group by b.vc_tnblx
) v group by v.vc_tnblx ),
zl as (
  select 
    '0' fldm,
    '肿瘤' jbmc,
     sum(decode(k.vc_cxglyy, null, 1, 0)) SC_S,
         sum(decode(k.vc_cxglyy, '4', 1, 0)) SW_S,
         sum(decode(k.vc_cxglyy, '1', 1, 0)) SF_S,
         sum(decode(k.vc_sfqc,'1',1,0)) HKQC_S,
         sum(case
               when k.vc_cxglyy is not null and k.vc_cxglyy <> '1' and k.vc_cxglyy <> '4' then
                1
               else
                0
             end) QT_S 
  from zjjk_zl_bgk b,(select c.* from (
  select s.*,ROW_NUMBER() OVER(PARTITION BY vc_bgkid  ORDER BY DT_SFRQ DESC) ROWN  from zjjk_zl_sfk s 
  ) c where ROWN = 1) k
  where b.vc_bgkid = k.vc_bgkid
    and b.vc_scbz = '0'
    and (b.vc_gldw like #{vc_gldw}||'%' )
    and b.vc_shbz in ('3', '5', '6', '7', '8')
    and b.vc_bgkzt in ('0', '2', '6', '7')
    and to_char(b.dt_sczdrq,'yyyy') = #{tjnd}
)

select jbzl,fldm,jbmc,sc,sw,hkqc,sf,qt,0 sort from (select '脑卒中' jbzl,fldm, q.mc jbmc,sc_s sc,sw_s sw, hkqc_s hkqc, sf_s sf, qt_s qt
  from ncz n,
    ( (select '1' dm,'蛛网膜下腔出血' mc from dual) union all (select '2' dm,'脑出血' mc from dual) 
     union all (select '3' dm,'未分类' mc from dual) union all (select '5' dm,'脑血栓形成' mc from dual)
      union all (select '4' dm,'脑栓塞' mc from dual) union all (select '6' dm,'分类不明' mc from dual) ) q
  where n.fldm(+) = q.dm
  order by q.dm) 
union all
select '脑卒中' jbzl,
       'xj' fldm,
       '小计' jbmc,
       sum(sc_s) sc,
       sum(sw_s) sw,
       sum(hkqc_s) hkqc,
       sum(sf_s) sf,
       sum(qt_s) qt,
       1 sort
  from ncz
union all  
select jbzl,fldm,jbmc,sc,sw,hkqc,sf,qt,3 sort from (select '冠心病' jbzl,fldm,x.mc jbmc,sc_s sc,sw_s sw, hkqc_s hkqc, sf_s sf, qt_s qt from gxb g,
    ((select '1' dm,'急性心肌梗死' mc from dual) union all (select '2' dm,'心性猝死' mc from dual) 
     union all (select '3' dm,'分类不明' mc from dual)) x
    where g.fldm(+) = x.dm  order by x.dm)
union all
select '冠心病' jbzl,
       'xj' fldm,
       '小计' jbmc,
       sum(sc_s) sc,
       sum(sw_s) sw,
       sum(hkqc_s) hkqc,
       sum(sf_s) sf,
       sum(qt_s) qt,
       4 sort
  from gxb
union all  
select jbzl,fldm,jbmc,sc,sw,hkqc,sf,qt,5 sort from (select '糖尿病' jbzl,fldm,x.mc jbmc,sc_s sc,sw_s sw, hkqc_s hkqc, sf_s sf, qt_s qt from tnb t,
    ((select '1' dm,'1型' mc from dual) union all (select '2' dm,'2型' mc from dual) 
     union all (select '3' dm,'其他' mc from dual)) x
    where t.fldm(+) = x.dm  order by x.dm)
union all
select '糖尿病' jbzl,
       'xj' fldm,
       '小计' jbmc,
       sum(sc_s) sc,
       sum(sw_s) sw,
       sum(hkqc_s) hkqc,
       sum(sf_s) sf,
       sum(qt_s) qt,
       6 sort
  from tnb
union all  
select '恶性肿瘤' jbzl,fldm,'恶性肿瘤' jbmc,sc_s sc,sw_s sw, hkqc_s hkqc, sf_s sf, qt_s qt,7 sort from zl
order by sort                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      