create or replace package      ZJJK_CSV_EXPORT is

  -- Author  : SEAN
  -- Created : 2012-8-21 14:18:19
  -- Purpose :

  PROCEDURE SQL_TO_CSV
    (
        P_QUERY IN VARCHAR2,                        -- SQL
        P_DIR IN VARCHAR2,                          -- oracle directory DB_CSV_EXP
        P_FILENAME IN VARCHAR2                      -- CSV名
    );

end ZJJK_CSV_EXPORT;

