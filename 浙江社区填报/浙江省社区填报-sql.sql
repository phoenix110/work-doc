select * from rp_bdkz   -- 表单控制表
select * from TB_GXY_YYSZCXYYYMX  

-- 报表对应的表
-- rp_bdkz.bdflbs
/*  1 */     select * from rp_rkfnlxb            -- 人口分年龄性别统计表
/* 2,3 */    select * from rp_czrk_bdqk          -- 常住人口变动情况统计
/* 4 */      select * from rp_ldrk_bdqk          -- 流动人口变动情况统计表
/* 5 */      select * from rp_Czrk_Jkdahz        -- 常住人口家庭档案建档情况汇总表
/* 6 */      select * from rp_Czrk_Grdahz        -- 常住人口个人档案建档情况汇总
/* 7 */      select * from rp_Ldrk_Jtdahz        -- 流动人口家庭档案建档情况汇总
/* 8 */      select * from rp_Ldrk_Grdahz        -- 流动人口个人档案建档情况汇总表
/* 9 */      select * from rp_Czrk_Jkdazk        -- 常住人口健康档案建档工作质控情况汇总表
/* 10 */     select * from RP_LDRK_JKDAZK        -- 流动人口健康档案建档工作质控情况汇总表
/* 11,12,13,14,42 */  select * from rp_Gxy_Hzsqgzqk       -- 一级高血压患者社区管理工作情况汇总表
/* 15,16,17,18 */  select * from rp_Gxy_Gzsqglxg       -- 一级高血压患者社区管理效果汇总表
/* 19 */     select * from rp_Gxy_Gwrqgzqk       -- 高血压高危人群社区管理工作情况汇总表
/* 20 */     select * from rp_Gxy_Jcswyscyqk     -- 基层卫生服务机构35岁及以上首诊病人测血压工作情况汇总表 
/* 21 */     select * from rp_Gxy_Xjysswyscyqk   -- 县级及以上医疗机构35岁及以上首诊病人测血压工作情况汇总表
/* 22 */     select * from rp_Gxy_Sqgzzk         -- 高血压社区管理工作质控情况汇总表
/* 23,24,25,43 */     select * from rp_Tnb_Cgglsqgzqk     -- 常规管理糖尿病患者社区管理工作情况汇总表
/* 26,27,28 */     select * from rp_Tnb_Cgglsqglxg     -- 常规管理糖尿病患者社区管理效果汇总表
/* 29 */           select * from rp_Tnb_Gwrqsqgzqk     -- 糖尿病高危人群社区管理工作情况汇总表
/* 30 */     select * from rp_Tnb_Jcswyscxtqk          -- 基层卫生服务机构35岁及以上首诊病人测血糖工作情况汇总表
/* 31 */     select * from rp_Tnb_Qjysswyscxtqk        -- 县级及以上医疗机构35岁及以上首诊病人测血糖工作情况汇总表
/* 32 */     select * from rp_Tnb_Sqglgzzk             -- 糖尿病社区管理工作质控情况汇总表
/* 33,34,35,36 */  select * from rp_Jsb_Bqwdsqgzqk      -- 病情稳定重性精神病患者社区管理工作情况情况汇总表
/* 37,38,39,40 */  select * from rp_Jsb_Bqwdsqglxg     -- 病情稳定重性精神病患者社区管理效果汇总表
/* 41 */     select * from rp_Jsb_Sqgzqk               -- 重性精神病社区管理工作质控情况汇总表
/* 44 */     select * from rp_Gxy_Sqgzzk               -- 高血压社区管理工作质控情况汇总表
/* 45 */     select * from rp_Tnb_Sqglgzzk             -- 糖尿病社区管理工作质控情况汇总表

-- 所有报表和分类标识对应关系（总共45个）
 select t.code, t.name, t.remark1, t.operator
        from CODE_INFO t
       where t.code_info_id = 123
        -- and t.operator like '%B%'; -- 包含S为第一和第三季报要发的表，包含B为半年报要发的表，包含Y为年报要发的表

-- 各种状态字典表
select code,name from CODE_INFO t where t.code_info_id is null and t.type_id=1021
select code, name,description disc
            from CODE_INFO c
                where c.code_info_id = (select t.id
                    from CODE_INFO t where t.code_info_id is null
                        and t.code = 'C_COMM_SHZT') order by c.disp_order



县级医疗机构首诊测血压
select count(*) from rp_bdkz   -- 表单控制表
select count(*) from rp_Gxy_Xjysswyscyqk   -- 县级及以上医疗机构35岁及以上首诊病人测血压工作情况汇总表

select distinct TJND from rp_bdkz where TJND= '2018'
select distinct TJJD from rp_bdkz where TJND= '2019'
select distinct TJYD from rp_bdkz where TJND= '2018'
select distinct ZZSHZT from rp_bdkz where TJND= '2019'
select XTSCSJ , cjsj from rp_bdkz where TJND= '2019' and TJJD = '2' order by cjsj desc
ZZSHZT



