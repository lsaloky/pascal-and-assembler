program Projekt_SpreadSheet_Lubo;
const ColsPerCell=8;
      MaxIDLen=10;
      MinRow='a';
      MaxRow='h';
      FakeNil=0;
      MaxCol=6;
      MaxLine=60;
type Counter=0..maxint;
     RowIndex=MinRow..MaxRow;
     ColIndex=FakeNil..MaxCol;
     LineType=array[1..MaxLine] of char;
     InputType=record
       Line:LineType;
       Length,Last:Counter;
     end;
     Token=(SINFUNC,COSFUNC,EXPFUNC,LNFUNC,SQRTFUNC,UMINUS,PLUS,MINUS,TIMES,
            DIVIDE,CELLABEL,LEFTPAREN,RIGHTPAREN,NUMBER,NOMORE,UNKNOWN,
            ACELLNAME,BADCELL);
     UserMsgs=(CMDPROMPT,CMDLIST,EXPRPROMPT,NORPAREN,NOLPAREN,NOFACTOR,EXTRA,
               EXTRAJUNK,NOLABEL,SORTFAILED,NOLINE,TOOLONG,TOOSHORT,CELLPROMPT,
               LABELPROMPT,LABELDEPENDS,BADACELLNAME,NOCURCELL,BADCELLLABEL,
               SHOWCELLMSG);
     CellContents=(EMPTY,ANEXPR,AVALUE,ALABEL);
     Commands=(HELP,CHANGECELL,ENTEREXPR,ENTERLABEL,BAD);
     CellID=record
       Name:RowIndex;
       Num:ColIndex;
     end;
     NodePtr=^Node;
     Node=record
       CellName:CellID;
       Op:Token;
       Value:real;
       Left,Right:NodePtr;
     end;
     DependPtr=^Depend;
     Depend=record
       Dependee:CellID;
       Next:DependPtr;
     end;
     Cell=record
       Cellexpr:NodePtr;
       CellLabel:InputType;
       DependList:DependPtr;
       Next:CellID;
       Count:Counter;
       Contents:CellContents;
     end;
procedure LuboInit;
BEGIN
END.