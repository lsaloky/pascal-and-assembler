constructor TSpracuj.Init;
begin
  VelkostBuffera:=10;
end;

procedure TSpracuj.PridajRiadok;
begin
  GetMem(AktRiadok^.Text,Length(s)+1);
  Move(s,AktRiadok^.Text^,Length(s)+1);
  New(AktRiadok^.Dalsi);
  AktRiadok:=AktRiadok^.Dalsi;
  AktRiadok^.Dalsi:=nil;
end;
procedure TSpracuj.Dokument;
begin
  PoziciaBuffra:=1;
  Assign(f,NazovSub);
  Reset(f,1);
  while not EOF(f) do begin
	BlockRead(f,Buffer,10);
        Dekoduj;
  end;
  Close(f);
end;
destructor TSpracuj.Koniec;
begin
end;
Procedure TSpracuj.Parameter;
Begin
if Paramcount=1 then
   if  (Pos('.',paramstr(1))=0) and (length(paramstr(1))<8) then
   NazovSub:=paramstr(1)+'htm';
end;
Function TSpracuj.Blbost(CH:char):boolean;
Begin
if (ch=#13) or (ch=#10) or (ch=#0) then Blbost :=true
                                   else Blbost :=False;

End;
Procedure TSpracuj.vypisb;
Var i:integer;
Begin
For i:= 0 to VelkostBuffera-1 do
Write(Buffer[i]);
end;

procedure TSpracuj.Dekoduj;
var Znak:char;
	TAG:String;
{	Pozicia:integer;}
begin
	Pozicia:=0;
	s:='';
	Znak:=Buffer[Pozicia];
	while (Znak <> #0) AND (Pozicia < VelkostBuffera)  do begin

		if Znak<>'<' then begin

                        if Blbost(Znak) then
                                            write
                                        else
                                            s:=s+Znak; {podla vlastnosti TAG ho umiestni na miesto}
                    end
		else begin {zisti aky TAG to je}
                        if s<>'' then
                              	PridajRiadok;
                        s:='';
			TAG:='';
			repeat
				Inc(Pozicia);
                                Znak:=Buffer[Pozicia];
                                if Blbost(Znak) then
                                            write                                                            {}
                                                else
                                                TAG:=TAG+Znak; {TAG bude 				...>}
			until (Znak = #0) or (Znak = #13) or (Pozicia >= VelkostBuffera) or (Znak = '>') ;
		end;
                if (Znak <> #0) then begin
                	         Inc(Pozicia);
                                 Znak:=Buffer[Pozicia];
                                end;
	end;
end;
