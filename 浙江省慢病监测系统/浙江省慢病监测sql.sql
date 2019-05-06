-- 所有的sql语句，要新增或者修改，手动改数据库
select * from sqldy where rownum < 2;

-- 存储过程，包名 GCMC 包名.过程名
select * from prody where rownum < 2;

-- 系统日志，存储过程执行的记录
SELECT * FROM TB_LOG where rownum < 2;

-- 业务日志
SELECT * FROM ZJJK_YW_LOG where rownum < 2;

select * from sqldy where mkbh = '020205';-- 糖尿病初随访
select * from sqldy where mkbh = '020302';-- 肿瘤初访
select * from sqldy where mkbh = '020303'; -- 肿瘤随访

-- 自己添加肿瘤随访提醒 VC_GLDW = '331002'为区县级别的
-- update zjjk_zl_bgk set NB_KSPF = 40, DT_SFSJ = add_months(sysdate, -2) where VC_BGKID in ('ex1800000003696','ex1800000003697','ex1800000003698')；
-- update zjjk_zl_bgk set VC_GLDW = '331002', vc_sdqrzt = '1', vc_sfcf = '3', dt_swrq = null, vc_swyy = null, vc_shbz = '3', vc_bgkzt = '0',NB_KSPF = 40, DT_SFSJ = add_months(sysdate, -2),dt_sfrq = add_months(sysdate, -2) where VC_BGKID in ('ex1800000003696','ex1800000003697','ex1800000003698');
 
