create or replace procedure      test_dump_csv
as
    l_rows  number;
begin
    l_rows := dump_csv( 'select * from T_icd10 where rownum < 25',',', 'D:\temp', 'test.dat' );
end;

