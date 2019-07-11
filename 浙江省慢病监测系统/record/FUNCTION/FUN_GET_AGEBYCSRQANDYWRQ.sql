CREATE OR REPLACE Function Fun_Get_AgeByCsrqAndYwrq(D_csrq DATE,D_jsrq DATE)
Return number
Is
  N_Age number;
  N_csYear number;
  N_csMonth number;
  N_csDay number;
  N_jsYear number;
  N_jsMonth number;
  N_jsDay number;
Begin
   N_Age := -1;
   if D_csrq is null or D_jsrq is null then
      return N_Age;
   else
      N_csYear := to_number(to_char(D_csrq,'yyyy'));
      N_csMonth:= to_number(to_char(D_csrq,'MM'));
      N_csDay := to_number(to_char(D_csrq,'dd'));
      N_jsYear := to_number(to_char(D_jsrq,'yyyy'));
      N_jsMonth:= to_number(to_char(D_jsrq,'MM'));
      N_jsDay := to_number(to_char(D_jsrq,'dd'));
      N_Age := N_jsYear - N_csYear;
      if N_jsMonth < N_csMonth then
         N_Age := N_Age - 1;
      elsif N_jsMonth = N_csMonth then
         if N_jsDay < N_csDay then
            N_Age := N_Age - 1;
         end if;
      end if;
   end if;
   Return N_Age ;
Exception
   When Others Then
     Return N_Age ;
End Fun_Get_AgeByCsrqAndYwrq;
