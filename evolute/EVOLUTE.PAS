PROGRAM Evolution;

USES  crt;
CONST grafx = 3;
      grafy = 2;

      maxx = 35;
      maxy = 20;

      hasen  = 20;
      woelfe = 10;

      ebene = 1;
      gras  = 2;
      hase  = 3;
      wolf  = 4;

      farbe: array[1..4] of integer = (8,2,14,4);

VAR   feld:   array[0..maxx+1] of array[0..maxy+1] of integer;
      x,y,i:  integer;
      anzahl: longint;
      c:      char;

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
  end
end;

PROCEDURE Grafik;
begin
  for x:=1 to maxx do
    for y:=1 to maxy do begin
      gotoxy(x*2+grafx,y+grafy);
      textcolor(farbe[feld[x,y]]);
      write('лл');
    end;
  gotoxy(grafx,grafy+maxy+2);
  textcolor(white);
  write('Zyklen: ',anzahl,'   ');
end;

PROCEDURE Zyklus;
begin
  x:=random(maxx)+1;
  y:=random(maxy)+1;
  case feld[x,y] of
    ebene: feld[x,y]:=gras;
    gras:  if umgebung(hase) then feld[x,y]:=hase;
    hase:  if umgebung(wolf) then feld[x,y]:=wolf;
    wolf:  feld[x,y]:=ebene
  end
end;

PROCEDURE Quadrat;
begin
  gotoxy(x*2+grafx,y+grafy);
  textcolor(farbe[feld[x,y]]);
  write('лл');
end;

BEGIN
  clrscr;
  textmode(co80);
  randomize;
  Neues_Feld;
  anzahl:=0;
  repeat
    Grafik;
    for i:=1 to anzahl do begin
      Zyklus;
      Quadrat;
    end;
    gotoxy(grafx+8,grafy+maxy+2);
    c:=readkey;
    if c=#8 then readln(anzahl)
  until c=#27;
  clrscr
END.
 