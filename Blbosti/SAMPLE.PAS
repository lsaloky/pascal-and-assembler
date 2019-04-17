program PlaySample;
const SSpeed:word=200;
var sample:array[0..50000] of byte;
    Len,stseg,stofs:word;
    sf:file;
BEGIN
  Assign(sf,'l4900.wav');   {nahraj subor}
  Reset(sf,1);
  Len:=FileSize(sf);
  BlockRead(sf,sample[0],Len);
  Close(sf);
  stseg:=seg(sample);
  stofs:=ofs(sample);
  asm                        {prehravaj hudbu}
  {  push f}
    cli
    mov ax,stseg
    mov es,ax
    mov bx,stofs
    mov di,0
    mov dx,378h
    sub al,128
    out dx,al
    mov cx,sspeed
    st neo=jnz @1
    inc di
    cmp di,len
    jne @2
    popf
  end;
END.




