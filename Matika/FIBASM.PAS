program Fibonacciho_postupnost_rekurzivne_v_assembleri;
{pouzitelne do Fib(23)}
function Fib(a:word):word;assembler;
var PrvySuc:word;
asm
             cmp a,2
             jb @UzVieme
             dec a
             push a
             call Fib
             mov PrvySuc,ax
             dec a
             push a
             call Fib
             add ax,PrvySuc
             jmp @Koniec
@UzVieme:    mov ax,1
@Koniec:
end;
BEGIN
  writeln(Fib(23));
END.