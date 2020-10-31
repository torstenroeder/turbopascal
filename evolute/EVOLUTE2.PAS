PROGRAM Evolution;

USES  crt,Stuff;
CONST grafx = 3;
      grafy = 2;

      maxx = 70;
      maxy = 40;

      hasen    = 20;
      woelfe   = 50;
      menschen = 10;

      ebene  = 1;
      gras   = 2;
      hase   = 3;
      wolf   = 4;
      mensch = 5;

      farbe: array[1..5] of integer = (darkgray,green,yellow,red,lightcyan);

VAR   feld:   array[0..maxx+1] of array[0..maxy+1] of integer;
      menge:  array[1..5] of integer;
      x,y,i:  integer;
      anzahl: longint;
      c:      char;
      origmode: integer;

FUNCTION Umgebung(wert: integer): boolean;
var a,b: integer;
begin
  umgebung:=false;
  for a:=x-1 to x+1 do
    for b:=y-1 to y+1 do
      if (feld[a,b]=wert)
      and not ((x=a) and (y=b)) then umgebung:=true
end;

PROCEDURE Neues_Feld;
begin
  for x:=0 to maxx+1 do
    for y:=0 to maxy+1 do
      feld[x,y]:=ebene;
  for i:=1 to hasen do begin
    repeat
      x:=random(maxx)+1;
      y:=random(maxy)+1;
    until feld[x,y]=ebene;
    feld[x,y]:=hase
  end;
  for i:=1 to woelfe do begin
    repeat
      x:=random(maxx)+1;
      y:=random(maxy)+1;
    until feld[x,y]=ebene;
    feld[x,y]:=wolf
  end;
  for i:=1 to menschen do begin
    repeat
      x:=random(maxx)+1;
      y:=random(maxy)+1;
    until feld[x,y]=ebene;
    feld[x,y]:=mensch
  end
end;

PROCEDURE Grafik;
begin
  for x:=1 to maxx do
    for y:=1 to maxy do
      Colorize(grafx+x,grafy+y,1,farbe[feld[x,y]]);
  for x:=1 to maxx do
    for y:=1 to maxy do
      WriteXY(grafx+x,grafy+y,'Û');
  gotoxy(grafx,grafy+maxy+2);
  textcolor(white);
  write('Zyklen: ',anzahl,'   ');
end;

PROCEDURE Zyklus;
begin
  x:=random(maxx)+1;
  y:=random(maxy)+1;
  dec(menge[feld[x,y]]);
  case feld[x,y] of
    ebene:  feld[x,y]:=gras;
    gras:   if umgebung(hase) then feld[x,y]:=hase;
    hase:   if umgebung(wolf)
              then feld[x,y]:=wolf
                else
                  if umgebung(mensch)
                    then feld[x,y]:=mensch
                      else
                        if umgebung(hase)
                          then feld[x,y]:=gras;
    wolf:   if umgebung(mensch) then feld[x,y]:=mensch
              else feld[x,y]:=ebene;
    mensch: if umgebung(mensch) then feld[x,y]:=ebene
  end;
  inc(menge[feld[x,y]]);
end;

PROCEDURE Quadrat;
begin
  Colorize(x+grafx,y+grafy,1,farbe[feld[x,y]]);
end;

PROCEDURE Zaehlen;
begin
  for i:=1 to 4 do menge[i]:=0;
  for x:=1 to maxx do
    for y:=1 to maxy do
      inc(menge[feld[x,y]]);
end;

BEGIN
  origmode:=lastmode;
  textmode(lo(lastmode)+font8x8);
  clrscr;
  HideCursor;
  randomize;
  Neues_Feld;
  anzahl:=1;
  Grafik;
  Zaehlen;
  repeat
    for i:=1 to anzahl do begin
      Zyklus;
      Quadrat;
      textcolor(white);
      gotoxy(grafx,grafy+maxy+4);
      write(menge[ebene]:5,'E',
            menge[gras]:5,'G',
            menge[hase]:5,'H',
            menge[wolf]:5,'W',
            menge[mensch]:5,'M');
    end;
    gotoxy(grafx+8,grafy+maxy+2);
    c:=readkey;
    if c=#8 then begin
      BlockCursor;
      write('        ');
      gotoxy(grafx+8,grafy+maxy+2);
      ReadLongInt(Anzahl,1,MaxInt,true);
      if anzahl<0 then anzahl:=1;
      if anzahl>MaxInt then anzahl:=MaxInt;
      HideCursor;
      gotoxy(grafx,grafy+maxy+2);
      write('Zyklen: ',anzahl,'   ');
    end;
  until c=#27;
  textmode(origmode);
  NormalCursor;
  clrscr
END.
