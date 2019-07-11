create or replace procedure ZJJK_RKS_JCQ(
 xtlb in varchar2,--系统类别
 nf in varchar2,--年份
 dm in varchar2,--地区代码
 lx in varchar2,
 p_cur1 out zjjk_report.refcursor,
 p_cur2 out zjjk_report.refcursor
)
is
 p_cur3  zjjk_report.refcursor;
 p_cur4  zjjk_report.refcursor;
  sys    varchar2(100);
  a0     varchar2(100);
  a1     number(10, 0);
  a2     number(10, 0);
  a3     number(10, 0);
  a4      number(10, 0);
  a5      number(10, 0);
  a6      number(10, 0);
  a7      number(10, 0);
  a8      number(10, 0);
  a9      number(10, 0);
  a10      number(10, 0);
  a11      number(10, 0);
  a12      number(10, 0);
  a13      number(10, 0);
  a14      number(10, 0);
  a15      number(10, 0);
  a16      number(10, 0);
  a17      number(10, 0);
  a18      number(10, 0);
  a19      number(10, 0);
  a20      number(10, 0);
  a21      number(10, 0);
  a22      number(10, 0);
  a23      number(10, 0);
  --个案信息
  a24      number(10, 0);
  a25      number(10, 0);
  a26      number(10, 0);
  begin
  if lx=1 then
       delete from zjmb_rkglb t where t.vc_rkgls= dm and t.vc_rkglq= '99999999' and t.vc_nf=nf and t.vc_xtlb=xtlb;
       delete from zjmb_rkglb t where t.vc_rkgls= '99999999' and t.vc_nf=nf and t.vc_xtlb=xtlb;
       commit;
       open p_cur1 for
       select t.vc_lx a0,sum(t.VC_0NLD) a1,sum(t.VC_1NLD) a2,sum(t.VC_5NLD) a3,sum(t.VC_10NLD) a4
       ,sum(t.VC_15NLD) a5,sum(t.VC_20NLD) a6,sum(t.VC_25NLD) a7,sum(t.VC_30NLD) a8
       ,sum(t.VC_35NLD) a9,sum(t.VC_40NLD) a10,sum(t.VC_45NLD) a11,sum(t.VC_50NLD) a12
       ,sum(t.VC_55NLD) a13,sum(t.VC_60NLD) a14,sum(t.VC_65NLD) a15,sum(t.VC_70NLD) a16
       ,sum(t.VC_75NLD) a17,sum(t.VC_80NLD) a18,sum(t.VC_85NLD) a19,sum(t.VC_ZRKS) a20
       ,sum(t.VC_NHJ) a21,sum(t.VC_VHJ) a22,sum(t.VC_ZHJ) a23,sum(t.vc_ganhj) a24,sum(t.vc_gavhj) a25,sum(t.vc_gazhj) a26
       from zjmb_rkglb t,zjjk_rksjcq t1 where t.vc_rkglq=t1.vc_syqx
       and vc_rkgljd='99999999' and t.vc_nf = t1.vc_nf
       and t1.vc_sys = dm and t1.vc_xtlb=xtlb and t1.vc_nf=nf
       group by t.vc_lx;
        loop
        fetch p_cur1
          into a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25, a26;
        exit when p_cur1%notfound;
      insert into zjmb_rkglb t values (dm||nf||a0||xtlb,substr(dm,0,2)||'000000',dm,'99999999','99999999',

             a0,nf, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13,
             a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, xtlb, a24, a25, a26);
        commit;
      end loop;
      close p_cur1;

      open p_cur3 for
       select t.vc_lx a0,sum(t.VC_0NLD) a1,sum(t.VC_1NLD) a2,sum(t.VC_5NLD) a3,sum(t.VC_10NLD) a4
       ,sum(t.VC_15NLD) a5,sum(t.VC_20NLD) a6,sum(t.VC_25NLD) a7,sum(t.VC_30NLD) a8
       ,sum(t.VC_35NLD) a9,sum(t.VC_40NLD) a10,sum(t.VC_45NLD) a11,sum(t.VC_50NLD) a12
       ,sum(t.VC_55NLD) a13,sum(t.VC_60NLD) a14,sum(t.VC_65NLD) a15,sum(t.VC_70NLD) a16
       ,sum(t.VC_75NLD) a17,sum(t.VC_80NLD) a18,sum(t.VC_85NLD) a19,sum(t.VC_ZRKS) a20
       ,sum(t.VC_NHJ) a21,sum(t.VC_VHJ) a22,sum(t.VC_ZHJ) a23,sum(t.vc_ganhj) a24,sum(t.vc_gavhj) a25,sum(t.vc_gazhj) a26
       from zjmb_rkglb t where t.vc_rkglq='99999999' and t.vc_xtlb=xtlb and t.vc_nf=nf
       group by t.vc_lx;
        loop
        fetch p_cur3
          into a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25, a26;
        exit when p_cur3%notfound;
      insert into zjmb_rkglb t values ('33000000'||nf||a0||xtlb,substr('33000000',0,2)||'000000','99999999','99999999','99999999',
             a0,nf, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13,
             a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, xtlb, a24, a25, a26);
        commit;
      end loop;
      close p_cur3;


  else
       delete from zjmb_rkglb t where t.vc_rkglsf= dm and t.vc_rkglq= '99999999' and t.vc_nf=nf and t.vc_xtlb=xtlb;
       delete from zjmb_rkglb t where t.vc_rkgls= '99999999' and t.vc_nf=nf and t.vc_xtlb=xtlb;
       commit;
       open p_cur2 for
       select t.vc_lx a0,t1.vc_sys sys,sum(t.VC_0NLD) a1,sum(t.VC_1NLD) a2,sum(t.VC_5NLD) a3,sum(t.VC_10NLD) a4
       ,sum(t.VC_15NLD) a5,sum(t.VC_20NLD) a6,sum(t.VC_25NLD) a7,sum(t.VC_30NLD) a8
       ,sum(t.VC_35NLD) a9,sum(t.VC_40NLD) a10,sum(t.VC_45NLD) a11,sum(t.VC_50NLD) a12
       ,sum(t.VC_55NLD) a13,sum(t.VC_60NLD) a14,sum(t.VC_65NLD) a15,sum(t.VC_70NLD) a16
       ,sum(t.VC_75NLD) a17,sum(t.VC_80NLD) a18,sum(t.VC_85NLD) a19,sum(t.VC_ZRKS) a20
       ,sum(t.VC_NHJ) a21,sum(t.VC_VHJ) a22,sum(t.VC_ZHJ) a23,sum(t.vc_ganhj) a24,sum(t.vc_gavhj) a25,sum(t.vc_gazhj) a26
       from zjmb_rkglb t,zjjk_rksjcq t1 where t.vc_rkglq=t1.vc_syqx
       and vc_rkgljd='99999999' and t.vc_nf = t1.vc_nf
       and t1.vc_sysf = dm and t1.vc_xtlb=xtlb and t1.vc_nf=nf
       group by t.vc_lx,t1.vc_sys;
        loop
        fetch p_cur2
          into a0, sys, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25, a26;
        exit when p_cur2%notfound;
      insert into zjmb_rkglb t values (sys||nf||a0||xtlb,substr(sys,0,2)||'000000',sys,'99999999','99999999',
             a0,nf, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13,
             a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, xtlb, a24, a25, a26);
        commit;
      end loop;
      close p_cur2;

       open p_cur4 for
       select t.vc_lx a0,sum(t.VC_0NLD) a1,sum(t.VC_1NLD) a2,sum(t.VC_5NLD) a3,sum(t.VC_10NLD) a4
       ,sum(t.VC_15NLD) a5,sum(t.VC_20NLD) a6,sum(t.VC_25NLD) a7,sum(t.VC_30NLD) a8
       ,sum(t.VC_35NLD) a9,sum(t.VC_40NLD) a10,sum(t.VC_45NLD) a11,sum(t.VC_50NLD) a12
       ,sum(t.VC_55NLD) a13,sum(t.VC_60NLD) a14,sum(t.VC_65NLD) a15,sum(t.VC_70NLD) a16
       ,sum(t.VC_75NLD) a17,sum(t.VC_80NLD) a18,sum(t.VC_85NLD) a19,sum(t.VC_ZRKS) a20
       ,sum(t.VC_NHJ) a21,sum(t.VC_VHJ) a22,sum(t.VC_ZHJ) a23,sum(t.vc_ganhj) a24,sum(t.vc_gavhj) a25,sum(t.vc_gazhj) a26
       from zjmb_rkglb t where t.vc_rkglq='99999999' and t.vc_xtlb=xtlb and t.vc_nf=nf
       group by t.vc_lx;
        loop
        fetch p_cur4
          into a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25, a26;
        exit when p_cur4%notfound;
      insert into zjmb_rkglb t values ('33000000'||nf||a0||xtlb,substr('33000000',0,2)||'000000','99999999','99999999','99999999',
             a0,nf, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13,
             a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, xtlb, a24, a25, a26);
        commit;
      end loop;
      close p_cur4;
  end if;
end ZJJK_RKS_JCQ;
