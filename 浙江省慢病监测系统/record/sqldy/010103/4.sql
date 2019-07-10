SELECT a.id,
       a.dm,
       a.jc text,
       a.gljgid sjid,
       CASE
         WHEN (SELECT COUNT(1)
                 FROM p_yljg c
                WHERE c.bz = 1
                  AND c.gljgid = a.id) > 0 THEN
          'true'
         ELSE
          'false'
       END isparent
  FROM p_yljg a
 WHERE 1 = 1
 START WITH a.id = '1101'
CONNECT BY a.gljgid = PRIOR id