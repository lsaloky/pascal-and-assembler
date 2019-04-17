unit Disky;
                                INTERFACE
               {B=byte,S=sektor,C=cluster,R=root dir}
var Parametre:record
                 CisloDisku,OvladacDisku:byte;
                 BNaS:word;
                 SNaC,ShiftFaktor:byte;
                 SkryteS:word;
                 KopiiFAT:byte;
                 RPocetPoloziek,PrvyDatovyS,NajvyssiC,SNaFAT,PrvySPreR:word;
                 AdresaOvladaca:pointer;
                 MediaDescriptor,Rezerva:byte;
                 NasledujuciBlokParametrov:pointer;
                 PrvyVolnyC,PocetVolnychC:word;
               end;
Procedure NastavDisk(Disk:char);
Function AktualnyDisk:Char;
Function PocetDiskov:byte;
Function BNaS:word;
Function SNaC:word;
Function CSpolu:word;
Function CVolnych:word;
Procedure DiskInfo;

                              IMPLEMENTATION
Function PocetDiskov:byte;assembler;
asm
             mov ah,19h
             int 21h      {zisti aktualny disk}
             mov dl,al
             mov ah,0Eh
             int 21h      {nastav disk (v AL sa vrati pocet diskov)}
end;
Procedure NastavDisk(Disk:char);assembler;
asm
             mov dl,Disk
             sub dl,65
             mov ah,0Eh
             int 21h
end;
Function AktualnyDisk:Char;assembler;
asm
             mov ah,19h
             int 21h
             add al,65
end;
Function BNaS:word;assembler;
asm
             mov dl,0             {aktualny disk}
             mov ah,36h
             int 21h              {DiskInfo}
             mov ax,cx
end;
Function SNaC:word;assembler;
asm
             mov dl,0             {aktualny disk}
             mov ah,36h
             int 21h              {DiskInfo}
end;
Function CSpolu:word;assembler;
asm
             mov dl,0             {aktualny disk}
             mov ah,36h
             int 21h              {DiskInfo}
             mov ax,dx
end;
Function CVolnych:word;assembler;
asm
             mov dl,0             {aktualny disk}
             mov ah,36h
             int 21h              {DiskInfo}
             mov ax,bx
end;
Procedure DiskInfo;assembler;
asm
             mov ah,1Fh
             lea bx,Parametre
             int 21h
end;
BEGIN
END.
