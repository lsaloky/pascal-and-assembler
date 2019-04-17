program Prezerac_DBF_suborov;
type THlavicka=record
       Verzia,Rok,Mesiac,Den:byte;
       PZaz:longint;                     {pocet zaznamov}
       DlzHlav,DlzZaz:word;              {dlzka hlavicky,zaznamu}
       Rezerva:array[1..20] of byte;
     end;
     TPopisPolozky=record
       Meno:array[1..11] of char;
       Typ:char;
       Adresa:pointer;{v pamati (???) }
       Len,Dec:byte;  {dlzka,pocet des. miest}
       Rezerva:array[1..14] of integer;
     end;
var f:file;
    c1,AktZaz,PocPol:integer;   {aktualny zaznam,pocet poloziek v zazname}
    Hlavicka:THlavicka;
    PopPol:array[1..128] of TPopisPolozky;
    Zaznam:array[1..4000] of char;   {tu je samotny zaznam databazy}

procedure VypisZaznam;
var pc1,pc2,AktPol:word;  {aktualna polozka zaznamu}
begin
  pc1:=2;
  for AktPol:=1 to PocPol-1 do begin
    with PopPol[AktPol] do begin
      write(Meno,': ');
      case Typ of
        'C','N':for pc2:=1 to Len do begin {je to retazec alebo cislo}
              write(Zaznam[pc1]);
              Inc(pc1);
            end;
        'L':begin
              Inc(pc1);
              write('Form t Logical !!!');
            end;
        'M':begin
              pc1:=pc1+10;
              write('Form t Memo !!!');
            end;
        'D':begin {je to datum}
              write(Zaznam[pc1+7],Zaznam[pc1+8],'.',Zaznam[pc1+5],Zaznam[pc1+6],',',
                    Zaznam[pc1+1],Zaznam[pc1+2],Zaznam[pc1+3],Zaznam[pc1+4]);
              pc1:=pc1+8;
            end;
      end;
      readln;
    end;
  end;
end;

BEGIN
  Assign(f,'c:\windows\temp\clients.dbf');
  Reset(f,1);
  BlockRead(f,Hlavicka,32);             {nacitanie hlavicky}
  PocPol:=0;
  repeat                                {nacitanie popisu poloziek}
    Inc(PocPol);
    BlockRead(f,PopPol[PocPol],32);
  Until PopPol[PocPol].Meno[1]=#13;     {#13 - koniec pola poloziek}
  Seek(f,Hlavicka.DlzHlav);             {tu zacinaju data}
  {offset 1 je '*' pre zmazany zaznam, ' ' pre normalny}
  BlockRead(f,Zaznam,Hlavicka.DlzZaz);  {nacitanie prveho zaznamu}
  VypisZaznam;
  Close(f);
END.



