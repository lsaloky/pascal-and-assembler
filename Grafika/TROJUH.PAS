program Vyplnanie_trojuholnika_rekurziou;
const minx:word=60;maxx:word=259;miny:word=0;maxy:word=199;
var r:integer;
    stred,vlavo,vpravo:word;
procedure Nasob320;assembler;{prepise BX,AX}
asm
             mov bx,ax
             shl bx,6
             mov ah,al
             xor al,al
             add ax,bx
end;
procedure CakajVOI;assembler;
asm
             mov dx,03DAh  {tu zacina cakanie na VOI}
@vz1:        in al,dx
             and al,08h
             jnz @vz1
@vz2:        in al,dx
             and al,08h
             jz @vz2       {koniec cakania}
end;

procedure KresliTrojuholnik(iminx,imaxx,iminy,imaxy:integer);
var sx,sy,ss1x,ss2x:integer;
begin
  asm   {pouziva AX,DX,DI,CX. DH=pomhore,CH=pomvpravo,CL=pomvlavo}
             mov ax,iminx  {sx}
             add ax,imaxx
             shr ax,1
             mov sx,ax
             mov ax,iminy  {sy}
             add ax,imaxy
             shr ax,1
             mov sy,ax
             mov ax,iminx   {ss1x}
             add ax,sx
             shr ax,1
             mov ss1x,ax
             mov ax,imaxx   {ss2x}
             add ax,sx
             shr ax,1
             mov ss2x,ax

             mov ax,imaxy    {3x GetPixel}
             call Nasob320
             add ax,iminx
             mov di,ax
             mov ch,byte[es:di]
             shr ch,1

             mov ax,iminy
             call Nasob320
             add ax,sx
             mov di,ax
             mov dh,byte[es:di]
             shr dh,1

             mov ax,imaxy
             call Nasob320
             add ax,imaxx
             mov di,ax
             mov cl,byte[es:di]
             shr cl,1

             mov dl,ch  {3x PutPixel}
             add dl,dh
             mov ax,sy
             call Nasob320
             add ax,ss1x
             mov di,ax
             mov byte[es:di],dl

             mov dl,cl
             add dl,dh
             mov ax,sy
             call Nasob320
             add ax,ss2x
             mov di,ax
             mov byte[es:di],dl

             mov dl,ch
             add dl,cl
             mov ax,imaxy    {PutPixel}
             call Nasob320
             add ax,sx
             mov di,ax
             mov byte[es:di],dl
  end;
  if (imaxx-iminx)>r then begin
    KresliTrojuholnik(iminx,sx,sy,imaxy);
    KresliTrojuholnik(sx,imaxx,sy,imaxy);
    KresliTrojuholnik(ss1x,ss2x,iminy,sy);
  end;
end;

BEGIN
  asm
{ ----- inicializacia ----- }
             cld
             mov r,200
             mov ax,0A000h
             mov es,ax
             mov ax,0013h
             int 10h
{ ----- nastavenie farieb ----- }
             mov dx,03C8h
             mov cx,255
@Skok:       mov al,cl
             out dx,al
             inc dx
             out dx,al
             out dx,al
             out dx,al
             dec dx
             loop @Skok
{ ----- na zaciatok 3x PutPixel ----- }
             mov ax,maxy
             call Nasob320
             add ax,minx
             mov di,ax
             mov byte[es:di],100
             mov vlavo,di

             mov ax,maxy
             call NAsob320
             add ax,maxx
             mov di,ax
             mov byte[es:di],200
             mov vpravo,di

             mov cx,minx
             add cx,maxx
             shr cx,1
             mov ax,miny
             call Nasob320
             add ax,cx
             mov di,ax
             mov byte[es:di],37
             mov stred,di
  end;
  repeat
    KresliTrojuholnik(minx,maxx,miny,maxy);
    asm
             mov cx,17
@Opakuj:     call CakajVOI
             loop @Opakuj
             shr r,1
    end;
  until r<2;
  r:=r+1;
  asm
              mov cx,60
@ZnovaCakaj:  call CakajVOI
              loop @ZnovaCakaj
  end;
  repeat
    asm
             call CakajVOI
         {    mov cx,32000
             xor di,di
             xor ax,ax
         rep stosw     }
             add stred,640
             mov di,stred
             mov byte[es:di],37
             mov di,vlavo
             mov byte[es:di],100
             mov di,vpravo
             mov byte[es:di],200
    end;
    miny:=miny+2;
    KresliTrojuholnik(minx,maxx,miny,maxy);
  until Stred>64000;
  asm
    mov ah,0
    int 16h
    mov ax,3
    int 10h
  end;
END.