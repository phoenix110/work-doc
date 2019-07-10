select a.vc_bgkbh,
       decode(b.vc_zkid, b.vc_fkid, '主卡', '副卡') zfkbz_text,
       a.vc_bgkid,
       a.vc_hzxm,
       a.Vc_Hzsfzh,
       decode(vc_hzxb, '1', '男', '2', '女') vc_hzxb_text,
       decode(a.vc_czhks,
              '0',
              '浙江省' || pkg_zjmb_tnb.fun_getxzqhmc(a.vc_czhksi) ||
              pkg_zjmb_tnb.fun_getxzqhmc(a.vc_czhkqx) ||
              pkg_zjmb_tnb.fun_getxzqhmc(a.vc_czhkjd) || a.vc_czhkjw ||
              a.vc_czhkxxdz,
              '1',
              '外省') hjdz_text,
       dts(dt_hzcsrq, 0) dt_hzcsrq,
       dts(a.dt_cjsj, 0) dt_cjsj,
       dts(a.dt_qxshsj, 0) dt_qxshsj,
       decode(a.vc_shbz,
              '0',
              '医院未审核',
              '1',
              '医院审核通过',
              '2',
              '医院审核未通过',
              '3',
              '区县审核通过',
              '4',
              '区县审核未通过',
              '5',
              '市审核通过',
              '6',
              '市审核不通过',
              '7',
              '省审核通过',
              '8',
              '省审核不通过',
              a.vc_shbz) vc_shbz_text,
       decode(a.vc_kzt,
              '0',
              '可用卡',
              '2',
              '死卡',
              '3',
              '误诊卡',
              '4',
              '重复卡',
              '6',
              '失访卡',
              '5',
              '删除卡',
              '7',
              '死亡卡',
              a.vc_kzt) vc_bgkzt_text,
       decode(nvl(a.vc_sfcf, '0'), '0', '未访', '1', '已访', vc_sfcf) vc_sfcf_text,
       dts(dt_qzrq, 0) dt_qzrq
  from zjjk_xnxg_bgk a, zjjk_xnxg_bgk_zfgx b
 where a.vc_bgkid = b.vc_fkid
      and a.vc_gldwdm like #{vc_gldw} || '%'
   and a.vc_scbz = '2'
   and exists
 (select 1
          from zjjk_xnxg_bgk_zfgx gx
         where (gx.vc_fkid = #{vc_bgkid} or
               gx.vc_zkid = #{vc_bgkid})
           and (a.vc_bgkid = gx.vc_fkid or a.vc_bgkid = gx.vc_zkid))
   and rownum <= 200
 order by decode(b.vc_fkid, b.vc_zkid, 0, 1)                                                                                                                                                                                                                                                                        