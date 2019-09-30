/* 定时任务1(所有病种报卡和初随访卡):每天凌晨01:00，每次发送updatetime在当天01：00之前的数据，发送完成后，删除掉updatetime在当天01：00之前的数据。
   定时任务2(未审核的死亡卡):每10分钟，每次发送dt_cjsj在当前时间之前的未上传的数据，发送完成后，根据发送完的id集合更新状态为已上传。
   ZJMB_SW_WJW_BGK.vc_wjw_scbz 卫健委上传标志，默认为0未上传，1为已上传
*/

-- 死亡报告卡，更新上传
select * from MIDDLEOF_ZJMB_SW_BGK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE != 'delete' order by updatetime asc;
-- 死亡报告卡，删除上传
select * from MIDDLEOF_ZJMB_SW_BGK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE = 'delete' order by updatetime asc;


-- 心脑报告卡，更新上传
select * from MIDDLEOF_ZJJK_XNXG_BGK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE != 'delete' order by updatetime asc;
-- 心脑报告卡，删除上传
select * from MIDDLEOF_ZJJK_XNXG_BGK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE = 'delete' order by updatetime asc;


-- 心脑初访，更新上传
select * from MIDDLEOF_ZJJK_XNXG_CFK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE != 'delete' order by updatetime asc;
-- 心脑初访，删除上传
select * from MIDDLEOF_ZJJK_XNXG_CFK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE = 'delete' order by updatetime asc;


-- 心脑随访，更新上传
select * from MIDDLEOF_ZJJK_XNXG_SFK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE != 'delete' order by updatetime asc;
-- 心脑随访，删除上传
select * from MIDDLEOF_ZJJK_XNXG_SFK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE = 'delete' order by updatetime asc;


-- 肿瘤报告卡，更新上传
select * from MIDDLEOF_ZJJK_ZL_BGK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE != 'delete' order by updatetime asc;
-- 肿瘤报告卡，删除上传
select * from MIDDLEOF_ZJJK_ZL_BGK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE = 'delete' order by updatetime asc;


-- 肿瘤初访，更新上传
select * from MIDDLEOF_ZJJK_ZL_CCSFK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE != 'delete' order by updatetime asc;
-- 肿瘤初访，删除上传
select * from MIDDLEOF_ZJJK_ZL_CCSFK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE = 'delete' order by updatetime asc;


-- 肿瘤随访，更新上传
select * from MIDDLEOF_ZJJK_ZL_SFK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE != 'delete' order by updatetime asc;
-- 肿瘤随访，删除上传
select * from MIDDLEOF_ZJJK_ZL_SFK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE = 'delete' order by updatetime asc;


-- 糖尿病随访，更新上传
select * from MIDDLEOF_ZJJK_TNB_SFK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE != 'delete' order by updatetime asc;
-- 糖尿病随访，删除上传
select * from MIDDLEOF_ZJJK_TNB_SFK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE = 'delete' order by updatetime asc;


-- 伤害随访，更新上传
select * from MIDDLEOF_ZJMB_SHJC_BGK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE != 'delete' order by updatetime asc;
-- 伤害随访，删除上传
select * from MIDDLEOF_ZJMB_SHJC_BGK where updatetime <= to_date('2019-07-18 01:00:00','yyyy-MM-dd HH24:mi:ss')
and OPERATE = 'delete' order by updatetime asc;