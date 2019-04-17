program Zistovanie_poctu_slov_v_texte_a_podobne_prkotiny;
const Oddelovace:set of char=[#0..#32,',',';','.',':','(',')','[',']','-'];
      subor='c:\games\panzer\readme.txt';
type TPolozka=record
       ofset,pocet:word;
     end;
     TPoleRetazcov=array[1..65000] of char;{v nom su slova oddelene medzerou}
     Buffer=array[1..32768] of char;
var R:array[1..5000] of TPolozka;
    P:^TPoleRetazcov;
    B:^Buffer;
    konr,konp,czac,ckon,c1:word;  {najblizsi volny prvok}
    f:file;
    slovo:string;
BEGIN
  GetMem(p,SizeOf(TPoleRetazcov));
  GetMem(b,SizeOf(Buffer));
  Assign(f,subor);
  Reset(f,32768);
  konr:=1;konp:=1;czac:=1;ckon:=1;
  while not EOF(f) do
    BlockRead(f,b,1);

    slovo:='';
    while not b^[ckon] in Oddelovace do Inc(ckon);
    for c1:=czac to ckon do slovo:=slovo+b^[c1];
  end;
  FreeMem(b,SizeOf(Buffer));
  FreeMem(p,SizeOf(TPoleRetazcov));
END.