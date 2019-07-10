select a.bgzdmc bgxm,
       case
         when a.diccode = 'P_XZDM' then
          nvl(pkg_zjmb_tnb.fun_getxzqhmc(a.bgqz), a.bgqz)
         when a.diccode is not null then
          nvl(pkg_zjmb_tnb.fun_getcommdic(a.diccode, a.bgqz), a.bgqz)
         else
          a.bgqz
       end bgqz,
       case
         when a.diccode = 'P_XZDM' then
          nvl(pkg_zjmb_tnb.fun_getxzqhmc(a.bghz), a.bghz)
         when a.diccode is not null then
          nvl(pkg_zjmb_tnb.fun_getdicnames(a.diccode, a.bghz), a.bghz)
         else
          a.bghz
       end bghz,
       a.cjr xgr,
       dts(a.cjsj, 1) xgsj,
       rownum rn
  from zjjk_yw_log_bgjl a
 where a.ywrzid = #{ywrzid}