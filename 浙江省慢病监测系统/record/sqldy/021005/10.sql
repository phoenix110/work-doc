SELECT dm AS code, mc AS NAME
  FROM p_yljg a
 WHERE 1 = 1
   AND #{xzqh} IS NOT NULL
   AND a.xzqh LIKE SUBSTR(#{xzqh},0,6) || '%'
   AND EXISTS (SELECT 1
          FROM p_yljgjb b
         WHERE a.dm = b.jgdm
           AND jbgjb IN ('乡级','村级'))          