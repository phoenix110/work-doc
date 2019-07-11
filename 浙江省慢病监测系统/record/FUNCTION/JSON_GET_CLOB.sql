CREATE OR REPLACE Function Json_Get_Clob(Data_In Clob,
                                         Str_In  Varchar2) Return Clob Is
  n      Number;
  Len    Number;
  i      Number;
  Offset Number;

  p_What Varchar2(10);

  v_Data   Clob;
  v_Out    Clob;
  v_Buffer Clob;
Begin
  v_Data := Data_In;
  p_What := Str_In; ---截取的字符串
  --add by xintian 0912
  If Dbms_Lob.Instr(v_Data, '"'||p_What||'":')=0 Then
    Return Null;

  End If;
  --add by xintian 0912

  n := Dbms_Lob.Instr(v_Data, '"'||p_What||'":') + Lengthb('"'||p_What||'":"')  ;
  Len := Dbms_Lob.Getlength(v_Data); ----总长度
 dbms_lob.createtemporary(v_out,TRUE);
  i := 1;
  While (i <= Ceil(Len / 4000)) Loop
    If i = 1 Then
      v_Out := Dbms_Lob.Substr(v_Data, 4000, n);
    -- dbms_output.put_line(i||'1:'||to_char(v_Out));

      If Dbms_Lob.Instr(v_Out, '"') > 0 Then
        v_Out := Dbms_Lob.Substr(v_Out, Dbms_Lob.Instr(v_Out, '"') - 1);
        --dbms_output.put_line(i||'2:'||to_char(v_Out));
         return v_out;

      End If;
    Else
      Offset := (i - 1) * 4000 + n;
      v_Buffer := Dbms_Lob.Substr(v_Data, 4000, Offset);
       --dbms_output.put_line(i||'1:'||to_char(v_Buffer));

      If Dbms_Lob.Instr(v_Buffer, '"') > 0 Then
        v_Buffer := Dbms_Lob.Substr(v_Buffer, Dbms_Lob.Instr(v_Buffer, '"') - 1);
         --  dbms_output.put_line(i||'2:'||to_char(v_Buffer));

        Dbms_Lob.Append(v_Out, v_Buffer);
        ---- insert into t_temp_clob(t) values(v_Out);
        Return v_Out;
      End If;

      Dbms_Lob.Append(v_Out, v_Buffer);
    End If;
    i := i + 1;
  End Loop;
  ----insert into t_temp_clob(t) values(v_Out);
  Return v_Out;
End;
