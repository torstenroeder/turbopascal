PROGRAM BioEvolution;

USES mouse,crt,Stuff;

CONST maxx  = 40;
      maxy  = 40;
      grafx =  4;
      grafy =  2;

      hintergrund =  0;
      rahmenfarbe =  1;
      textfarbe   = 15;
      zellenfarbe =  2;
      sterbfarbe  =  8;
      geburtfarbe =  6;
      buttons     =  3;

      Beding_A: set of 0..8 = [3];
      { neue Zelle }

      Beding_B: set of 0..8 = [2,3];
      { öberleben }

      symbol = #254;
      anzahl: longint = 10;
      ende:   boolean = false;

VAR   feld,neufeld,savefeld:
        array[0..maxx+1] of array[0..maxy+1] of 0..1;

      x,y,kox,koy,i: integer;

      mloc:     locrec;
      origmode: integer;
      c:        char;


FUNCTION Umgebung: integer;
var a,b,wert: integer;
begin
  wert:=-feld[x,y];
  for a:=x-1 to x+1 do
    for b:=y-1 to y+1 do
      inc(wert,feld[a,b]);
  umgebung:=wert;
end;

PROCEDURE Zyklus;
begin
  for x:=1 to maxx do
    for y:=1 to maxy do
      case feld[x,y] of
        0: if Umgebung in Beding_A
             then neufeld[x,y]:=1
             else neufeld[x,y]:=0;
        1: if Umgebung in Beding_B
             then neufeld[x,y]:=1
             else neufeld[x,y]:=0;
      end;
  for x:=1 to maxx do
    for y:=1 to maxy do
      feld[x,y]:=neufeld[x,y];
  WriteXY(grafx+15,grafy+maxy+2,Strg(i)+'/'+Strg(anzahl)+'     ');
end;

PROCEDURE Prognose;
begin
  for x:=1 to maxx do
    for y:=1 to maxy do
      case feld[x,y] of
        0: if Umgebung in Beding_A then
             Colorize(x+grafx,y+grafy,1,geburtfarbe)
           else Colorize(x+grafx,y+grafy,1,hintergrund);
        1: if Umgebung in Beding_B then
             Colorize(x+grafx,y+grafy,1,zellenfarbe)
           else Colorize(x+grafx,y+grafy,1,sterbfarbe)
      end
end;

PROCEDURE Neues_Feld;
begin
  for x:=0 to maxx+1 do
    for y:=0 to maxy+1 do begin
      feld[x,y]:=0;
      neufeld[x,y]:=0
    end;
end;

PROCEDURE Blau;
begin
  textbackground(rahmenfarbe);
  textcolor(textfarbe);
  clrscr;
  gotoxy(grafx,grafy+maxy+2); write('Zyklen: ',anzahl);
  textbackground(buttons); textcolor(rahmenfarbe);
  gotoxy(grafx,grafy+maxy+4);
  writeln('ﬂﬂﬂﬂﬂﬂ€ﬂﬂﬂﬂﬂﬂ€ﬂﬂﬂﬂﬂﬂ€ﬂﬂﬂﬂﬂﬂ€ﬂﬂﬂﬂﬂﬂ€ﬂﬂﬂﬂﬂﬂ€ﬂﬂﬂﬂﬂﬂ€ﬂﬂﬂﬂﬂﬂ');
  gotoxy(grafx,grafy+maxy+5);
  writeln(' RUN! € Prog € Zykl € Save € Load € Undo € Kill € Quit ');
  gotoxy(grafx,grafy+maxy+6);
  writeln('‹‹‹‹‹‹€‹‹‹‹‹‹€‹‹‹‹‹‹€‹‹‹‹‹‹€‹‹‹‹‹‹€‹‹‹‹‹‹€‹‹‹‹‹‹€‹‹‹‹‹‹');
  for y:=grafy+1 to grafy+maxy do
  begin
    for x:=1 to maxx do
      WriteXY(grafx+x,y,symbol);
    Colorize(grafx+1,y,maxx,hintergrund);
  end;
end;

PROCEDURE Grafik;
begin
  for x:=1 to maxx do
    for y:=1 to maxy do
      if feld[x,y]<>0 then begin
        Colorize(grafx+x,grafy+y,1,zellenfarbe);
      end
      else
        Colorize(grafx+x,grafy+y,1,hintergrund);
end;

BEGIN
  origmode:=lastmode;
  textmode(lo(lastmode)+font8x8);
  randomize;
  Neues_Feld;
  Blau;
  Grafik;
  CursorOff;
  mshow;
  repeat
    repeat mpos(mloc) until mloc.buttonstatus<>0;
    kox:=mloc.column div 8-grafx+1;
    koy:=mloc.row div 8-grafy+1;
    if (kox in [1..maxx]) and (koy in [1..maxy]) then
      case mloc.buttonstatus of
        1: begin
             mhide;
             feld[kox,koy]:=1;
             Colorize(grafx+kox,grafy+koy,1,zellenfarbe);
             mshow
           end;
        2: begin
             feld[kox,koy]:=0;
             Colorize(grafx+kox,grafy+koy,1,hintergrund);
           end
      end
    else if (koy in [grafy+maxy+2..grafy+maxy+4])
         and ((kox+8) mod 7<>0)
         and (mloc.buttonstatus=1) then
      case (kox+8) div 7 of
        1: for i:=1 to anzahl do begin
             Zyklus;
             Grafik;
           end;
        2: Prognose;
        3: begin
             window(grafx+8,grafy+maxy+2,grafx+11,grafy+maxy+2);
             textcolor(textfarbe);
             textbackground(hintergrund);
             clrscr;
             BlockCursor;
             readln(anzahl);
             CursorOff;
             if anzahl>100 then anzahl:=100;
             write(anzahl);
             window(1,1,80,50);
           end;
        4: for x:=1 to maxx do
             for y:=1 to maxy do
               savefeld[x,y]:=feld[x,y];
        5: begin
             for x:=1 to maxx do
               for y:=1 to maxy do
                 feld[x,y]:=savefeld[x,y];
             Grafik;
           end;
        6: begin
             for x:=1 to maxx do
               for y:=1 to maxy do
                 feld[x,y]:=neufeld[x,y];
             Grafik;
           end;
        7: begin
             Neues_Feld;
             Grafik;
           end;
        8: ende:=true;
      end;
  until ende;
  textmode(origmode);
  NormalCursor;
  clrscr
END.
