program Strazca_resetu;
uses Dos;
const s:array[0..6] of string[10]=('nedela','pomdelok','utorok','streda','stvrtok','piatok','sobota');
type a=record
         hod,min,sec,s100,rok,mes,den,dvt:word;
       end;
var vpamati:a;
    nadisku:file of a;
begin
  if ParamCount=0 then begin
    GetTime(vpamati.hod,vpamati.min,vpamati.sec,vpamati.s100);
    GetDate(vpamati.rok,vpamati.mes,vpamati.den,vpamati.dvt);
    Assign(nadisku,'c:\davky\c');
    Rewrite(nadisku);
    Write(nadisku,vpamati);
  end;
  if ParamStr(1)='v' then begin
    Assign(nadisku,'c:\davky\c');
    Reset(nadisku);
    Read(nadisku,vpamati);
    writeln('Datum:',vpamati.den,'.',vpamati.mes,'.',vpamati.rok);
    writeln('Cas:',vpamati.hod,':',vpamati.min,':',vpamati.sec);
  end;
end.