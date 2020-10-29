PROGRAM tiles;

{ Autor:   Torsten Roeder
  Version: 1.10
  Datum:   12.12.1999 }

USES  crt,speaker;
TYPE  stone   = record
                  col: integer;
                  sym: integer
                end;
      highscr = record
                  score: integer;
                  tiles: integer;
                  name:  string[15]
                end;
CONST quit:     boolean=false;
      endgame:  boolean=false;
      newgame:  boolean=true;
      undone:   boolean=true;
      symbol:   array[0..6] of char=('.','*','#','-','x','o','/');
VAR   board:    array[0..13] of array[0..9] of stone;
      tile:     array[0..72] of stone;
      high:     highscr;
      datei:    file of highscr;
      len:      string;
      a:        char;
      kox,koy,unx,uny:  integer;
      i,j,t:    integer;
      turn:     integer;
      score,unscore:    integer;


FUNCTION ncol(pos:integer):integer;
begin
  case pos of
    0: ncol:=board[kox,koy].col;
    1: ncol:=board[kox,koy-1].col;
    2: ncol:=board[kox+1,koy].col;
    3: ncol:=board[kox,koy+1].col;
    4: ncol:=board[kox-1,koy].col
  end
end;

FUNCTION nsym(pos:integer):integer;
begin
  case pos of
    0: nsym:=board[kox,koy].sym;
    1: nsym:=board[kox,koy-1].sym;
    2: nsym:=board[kox+1,koy].sym;
    3: nsym:=board[kox,koy+1].sym;
    4: nsym:=board[kox-1,koy].sym
  end
end;

FUNCTION placeok: boolean;
var colors,symbols: integer;
begin
  placeok:=true;
  board[kox,koy]:=tile[turn];
  if ncol(1)+ncol(2)+ncol(3)+ncol(4)=0 then placeok:=false;
  for i:=1 to 4 do
    if  (ncol(i)>0)
    and ((ncol(i)<>tile[turn].col)
          and (nsym(i)<>tile[turn].sym))
    then placeok:=false;
  for i:=1 to 5 do
  begin
    case i of
      1: kox:=kox+1;
      2: kox:=kox-2;
      3: begin kox:=kox+1; koy:=koy+1 end;
      4: koy:=koy-2;
      5: koy:=koy+1
    end;
    colors:=0; symbols:=0;
    for j:=1 to 4 do
    begin
      if (ncol(j)>0) and (ncol(j)=board[kox,koy].col) then colors:=colors+1;
      if (nsym(j)>0) and (nsym(j)=board[kox,koy].sym) then symbols:=symbols+1
    end;
    if (colors>2) or (symbols>2) then placeok:=false
  end
end;


PROCEDURE init;
begin
  t:=1;
  for i:=1 to 6 do
    for j:=1 to 6 do
    begin
      tile[t].col:=i;
      tile[t+1].col:=i;
      tile[t].sym:=j;
      tile[t+1].sym:=j;
      t:=t+2
    end;
  tile[0].col:=0;
  tile[0].sym:=0;
  randomize
end;

PROCEDURE initscores;
begin
  assign(datei,'tilehigh.dat');
  {$I-}
  reset(datei);
  if ioresult <> 0 then
  begin
    rewrite(datei);
    if ioresult <> 0 then
    begin
      clrscr;
      write('Fehler beim Anlegen von "Tilehigh.dat".');
      halt
    end;
    for i:=0 to 9 do
    begin
      seek(datei,i);
      high.score:=50+sqr(10-i) div 2;
      high.tiles:=66-sqr(i+1) div 3;
      high.name:='Horst';
      write(datei,high)
    end
  end;
  close(datei)
  {$I+}
end;

PROCEDURE mix;
var help:    stone;
    new:     integer;
    tilesok: boolean;
begin
  for i:=1 to 72 do
  begin
    new:=random(72)+1;
    help:=tile[i]; tile[i]:=tile[new]; tile[new]:=help
  end;
  repeat
    tilesok:=true;
    for i:=67 to 71 do
      for j:=i+1 to 72 do
        if (tile[i].col=tile[j].col) or (tile[i].sym=tile[j].sym) then
        begin
          new:=random(66)+1;
          help:=tile[j]; tile[j]:=tile[new]; tile[new]:=help;
          tilesok:=false
        end
  until tilesok
end;

PROCEDURE initgame;
begin
  for i:=0 to 13 do
    for j:=0 to 9 do
    begin
      board[i,j].col:=0; board[i,j].sym:=0
    end;
  board[1,1]:=tile[67];board[12,1]:=tile[68];
  board[1,8]:=tile[69];board[12,8]:=tile[70];
  board[6,4]:=tile[71];board[7,5]:=tile[72];
  undone:=true;
  endgame:=false;
  kox:=1; koy:=1; turn:=1; score:=0;
  textbackground(0);
  clrscr;
  textcolor(7);
  gotoxy(10,13);
  write('(U)ndo last move    (Q)uit');
  gotoxy(10,14);
  write('(H)elp me           (E)nd Game')
end;

PROCEDURE showboard;
begin
  for i:=1 to 12 do
    for j:=1 to 8 do
    begin
      textcolor(board[i,j].col+8);
      gotoxy(2*i+10,j+2);
      write(symbol[board[i,j].sym])
    end
end;

PROCEDURE text;
begin
  textcolor(7);
  gotoxy(2,4);
  write(turn,'/66');
  gotoxy(2,8);
  write('+',score);
  gotoxy(2,6);
  textcolor(tile[turn].col+8);
  write(symbol[tile[turn].sym])
end;

PROCEDURE settile;
begin
  if placeok then
    begin
      t:=1;
      for i:=1 to 4 do
        if ncol(i)>0 then t:=t*2;
      score:=score+t div 2;
      case t div 2 of
        2: playsnd('ceg>c<');
        4: playsnd('cf5>24<pp<5>24>13<');
        8: playsnd('fa>cd<g<h>df4ceg>c<');
      end;
      turn:=turn+1;
      unx:=kox; uny:=koy; unscore:=t div 2;
      undone:=false;
      showboard; text
    end
  else
    board[kox,koy]:=tile[0]
end;

PROCEDURE undo;
begin
  turn:=turn-1;
  board[unx,uny]:=tile[0];
  score:=score-unscore;
  showboard; text;
  undone:=true
end;

PROCEDURE help;
var x,y: integer;
begin
  t:=0;
  x:=kox; y:=koy;
  textcolor(15);
  for kox:=1 to 12 do
    for koy:=1 to 8 do
      if ncol(0)=0 then
      begin
        if placeok then
        begin
          gotoxy(2*kox+10,koy+2);
          write('.');
          t:=t+1
        end;
        board[kox,koy]:=tile[0]
      end;
  kox:=x; koy:=y
end;

PROCEDURE action;
begin
  a:=readkey;
  case a of
    #72: if koy>1 then koy:=koy-1;
    #77: if kox<12 then kox:=kox+1;
    #80: if koy<8 then koy:=koy+1;
    #75: if kox>1 then kox:=kox-1;
    #13: if ncol(0)=0 then settile;
    'u': if not undone then undo;
    'h': help;
    'e': endgame:=true;
    'q': halt
  end
end;

PROCEDURE youwon;
begin
  textcolor(15);
  gotoxy(2,4);
  write(' You ');
  gotoxy(2,6);
  write('Won !');
  gotoxy(2,8);
  write('+',score)
end;

PROCEDURE gameover;
begin
  textcolor(15);
  gotoxy(2,4);
  write(' Game');
  gotoxy(2,6);
  write('Over !');
  gotoxy(2,8);
  write('+',score)
end;

PROCEDURE highscores;
var nam: string[15];
    num: integer;
begin
  reset(datei);
  for i:=0 to 9 do
  begin
    seek(datei,i);
    read(datei,high);
    if score > high.score then
    begin
      clrscr;
      writeln(' Congratulations !   Place ',i+1,'.');
      writeln;
      writeln(' Enter your name:');
      write  (' > ...............');
      gotoxy(4,4);
      readln(nam);
      for j:=8 downto i do
      begin
        seek(datei,j);
        read(datei,high);
        seek(datei,j+1);
        write(datei,high)
      end;
      seek(datei,i);
      high.score:=score;
      high.tiles:=turn-1;
      high.name:=nam;
      write(datei,high);
      i:=9
    end
  end;
  clrscr;
  for i:=0 to 9 do
  begin
    seek(datei,i);
    read(datei,high);
    str(i+1,len);
    gotoxy(8-length(len),i+2);
    write(i+1,'. ....................');
    gotoxy(10,i+2);
    write(high.name);
    str(high.score,len);
    gotoxy(32-length(len),i+2);
    write(high.score,'/',high.tiles)
  end;
  close(datei)
end;


BEGIN
  init;
  initsnd;
  playsnd('---*');
  initscores;
  repeat
    if newgame then mix;
    initgame;
    showboard;
    text;
    repeat
      gotoxy(2*kox+10,koy+2);
      action
    until (turn=67) or endgame;
    if turn=67 then youwon else gameover;
    highscores;
    textcolor(7);
    gotoxy(10,13);
    write('Game Options: (S)ame  (N)ew  (E)xit');
    repeat a:=readkey until a in ['s','n','e'];
    if a='s' then newgame:=false;
    if a='n' then newgame:=true;
    if a='e' then quit:=true
  until quit;
  endsnd;
  clrscr;
  textcolor(7)
END.
