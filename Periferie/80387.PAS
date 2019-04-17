program Instrukcie_koprocesora;
const Fakt:word=1000;
var x,y,z:extended;
    pomocna:word;
BEGIN
{ ----- pozor, pri vypoctoch moze nastat 8087 stack overflow !!! ----- }
{rychlost: 2.250.000 nasobeni za sekundu
           1.800.000 odcitani za sekundu (???)
           1.000.000 odmocnin za sekundu
           4.500.000 absolutnych hodnot za sekundu
           6.000.000 sinusov za sekundu (???)
           4.500.000 arcustangensov za sekundu (???)

  rychlosti su zle urcen‚, lebo po chv¡li je argument bl¡zky k nule.}

  x:=0.224;
  y:=1.432;
  asm
             fld x
             fld x
             fmul           {x^2}
             fldpi
             fdiv           {(x^2)/pi}
             fld y
             fadd           {(x^2)/pi+y}
             dw 0FFD9h      {cos ((x^2)/pi+y)}
             fstp x         {uloz hodnotu}

             fldln2
             fld y
             fyl2x          {prirodzeny logaritmus}
             fstp y         {uloz}

             fld1           {pocitanie faktorialu - nahraj jednotku}
             xor ax,ax
@Znova:      inc ax
             mov Pomocna,ax
             fild Pomocna
             fmulp ST(1),ST {nasob}
             cmp ax,Fakt
             jl @Znova
             fstp z
  end;
  writeln(x);
  writeln(cos(0.224*0.224/pi+1.432));
  writeln(y);
  writeln(Ln(1.432));
  writeln('1000! je ',z);
  x:=2.4564878E+0041;
  y:=-8.4326534609E-0023;
  asm
             mov bx,300
             fld x
@ZvonkaZnova:mov cx,60000
@Znova:      {fld y}      {vyrad pri unarnych operaciach}
             fptan {dw 0FED9h} {fabs} {fsqrt} {fsubp st(1),st} {fmulp st(1),st}
             loop @Znova
             dec bx
             jnz @ZvonkaZnova
  end;

{ zoznam instrukcii:   BINARNE
    fadd            scita dve cisla na vrchole zasobnika
    fmul,fdiv,fsub  analogicky
                       UNARNE
    fld x           nahra cislo do zasobnika koprocesora
    fstp            ulozi cislo, vyznam toho P neviem
    fabs            absolutna hodnota vrcholu zasobnika
    fsqrt           2. odmocnina
    fptan           arcus tangens
    dw 0FED9h       sinus (LEN 386)
    dw 0FFD9h       cosinus (LEN 386)
                       BEZ OPERATOROV
    fldpi           pi na vrchol zasobnika
    fldln2          ln(2)
    fldl2e          log2(e)
    fld1            1
                       NIEKTORE DALSIE
    fild,fst,fsubr,fcom,fcomp,f2xmar,fbld,fbstp,fchsr,fdecstpr,ffreeva,
    fincstpr,fld1r,fldcw,fpremr,fptan,fsqrtr,fstcw}
END.