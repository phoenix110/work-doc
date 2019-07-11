CREATE OR REPLACE Function STN
(
  Input_In    In Varchar2,
  Enhanced_In In Number := 0 --0 去除所有非数字类字符，转为数字  1 从左到右，获取第一个出现的连续数字 2 去掉所有非数字字符，包括小数点
) Return Number Is
  n_Index  Number;
  v_strOne Varchar2(2);
  v_Number Varchar2(1000);
  n_Output Number;
  --2016-10-30 by sxp
Begin

  If Enhanced_In = 0 Then
    --0 去除所有非数字类字符，转为数字,第二个小数点后的截断
    v_Number:=translate(Input_In, '0'||translate(Input_In, '#0123456789.', '#'), '0');
    v_Number:=v_Number||'..';
    v_Number:=substr(v_Number,1,instr(v_Number,'.',1,2)-1);
    n_Output := To_Number(v_Number);
  elsif Enhanced_In = 1 then
    --1 从左到右，获取第一个出现的连续数字
     v_Number:='';
     For n_Index In 1 .. Length(Input_In) Loop
          v_strOne:=Substr(Input_In, n_Index, 1);
            If Instr('0123456789.', v_strOne) > 0 Then
              if instr('0'||v_number,'.')>0 and v_strOne='.'  then
                exit;
              end if;
              v_Number := v_Number || v_strOne;
            else
              if length(v_Number)>0 then
                exit;
              end if;
            End If;
      End Loop;
     n_Output :=  To_Number(v_Number);
  elsif Enhanced_In = 2 then
    --2 去掉所有非数字字符，包括小数点
     v_Number:=translate(Input_In, '0'||translate(Input_In, '#0123456789', '#'), '0');
     n_Output :=  To_Number(v_Number);
  Else
    Begin
      n_Output := To_Number(Input_In);
    Exception
      When Others Then
         Return 0;
    End;
  end if;
  Return n_Output;
Exception
  When Others Then
    Return 0;
End STN;
