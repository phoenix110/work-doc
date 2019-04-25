-- 所有的sql语句，要新增或者修改，手动改数据库
select * from sqldy where rownum < 2;

-- 存储过程，包名 GCMC 包名.过程名
select * from prody where rownum < 2;

-- 系统日志，存储过程执行的记录
SELECT * FROM TB_LOG where rownum < 2;

-- 业务日志
SELECT * FROM ZJJK_YW_LOG where rownum < 2;
