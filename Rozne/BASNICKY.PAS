program Srandovne_basnicky;
uses Crt,Printer;
const b:array[1..7,0..6] of string=(('Myjavy','Veznice','Podmosta','Moravy','Blazninca','Zlatej Idky','Afriky'),
                                    ('ukryl','zabil','nakreslil','priviazal','namastil','pribil','zakopol'),
                                    ('hlavu','ruku','zenu','nohu','milenku','pistol','kravu'),
                                    ('do predstavy','do zihlavy','do polevy','do mrakavy','do chladnicky','do diery',
                                    'do truhly'),
                                    ('hral Warcrft II','sa bil','zapiskal','rysoval','sa opil','sa prizabil','programoval'),
                                    ('na PP 06','na chodniku','v panelaku','na senniku','na Ataricku','pri butiku',
                                    'na PP 06 '),
                                    ('kedy sa pomylil','preco sa otocil','kde sa narodil','ako si zakuril','preco sa nenarodil'
                                    ,'kedy mi zaplatil','preco ma navstivil'));
       a:array[1..5] of string=('Bol jeden stary debil z ','ktory','svoju','raz za sumraku','a nikdy nezistil');
var x,y,pom1:integer;
    s,k:string;
    ch:char;
begin
x:=0;y:=0;
ClrScr;
writeln('Chces vystup na tlaciaren? A/N');
ch:=readkey;
if (ch='A') or (ch='a') then ch:='1'
  else ch:='0';
Randomize;
repeat
  Inc(x);
  writeln(a[x]);
  if ch='1' then writeln(lst,a[x]);
  Inc(y);
  pom1:=random(7);
  s:=b[y,pom1];
  writeln(s);
  if ch='1' then writeln(lst,s);
  if (y=3) or (y=5) then
  begin
    inc(y);
    pom1:=random(7);
    s:=b[y,pom1];
    writeln(s);
    if ch='1' then writeln(lst,s);
  end;
until x=5;
repeat until keypressed;
end.