SELECT code, '[' || rownum || ']' || name name, diccode
  FROM (SELECT jlbh code,
               dts(dt_ksrq, 0) || '至' || dts(dt_jsrq, 0) 
               || '(' || ccts || '条)' 
               || '(' || decode(zt, '0', '停用', '1', '启用') || ')' name,
               'ZLFHSJ' diccode
          FROM zjjk_zlfhsj_sf
         ORDER BY zt DESC, szsj DESC, dt_jsrq DESC, dt_ksrq)                                   