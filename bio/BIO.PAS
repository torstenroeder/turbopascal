PROGRAM BioEvolution;

USES crt,Stuff;

CONST maxx  = 40;
      maxy  = 40;
      grafx =  5;
      grafy =  3;
      leer  =  0;
      zelle =  1;

      Beding_A: set of 0..8 = [3];
      { neue Zelle }

      Beding_B: set of 0..8 = [2,3];
      { öberleben }

      symbol = #254;
      anzahl: longint = 10;

VAR   feld,neufeld,savefeld:
        array[0..maxx+1] of array[0..maxy+1] of integer;

      x,y,kox,koy,i: integer;

      origmode: integer;
      c:        char;


FUNCTION Umgebung: integer;
var a,b,wert: integer;
begin
  wert:=-feld[x,y];
  for a:=x-1 to x+1 do
    for b:=y-1 to y+1 do
      wert:=wert+feld[a,b];
  umgebung:=wert;
end;

PROCEDURE Zyklus;
begin
  for x:=1 to maxx do
    for y:=1 to maxy do
      case feld[x,y] of
        leer:  if Umgebung in Beding_A
                 then neufeld[x,y]:=zelle
                 else neufeld[x,y]:=leer;
        zelle: if Umgebung in Beding_B
                 then neufeld[x,y]:=zelle
                 else neufeld[x,y]:=leer;
      end;
  for x:=1 to maxx do
    for y:=1 to maxy do
      feld[x,y]:=neufeld[x,y];
end;

PROCEDURE Neues_Feld;
begin
  for x:=0 to maxx+1 do
    for y:=0 to maxy+1 do begin
      feld[x,y]:=leer;
      neufeld[x,y]:=leer
    end;
end;

PROCEDURE Blau;
begin
  textbackground(blue);
  window(1,1,80,80);
  clrscr;
  textcolor(white);
  gotoxy(grafx,grafy+maxy+1); write('Zyklen: ',anzahl);
  gotoxy(grafx,grafy+maxy+3); writeln('<H> fÅr Hilfe');
  textbackground(black);
  window(grafx,grafy,grafx+maxx-1,grafy+maxy-1);
  clrscr;
  window(grafx,grafy,grafx+maxx,grafy+maxy);
end;

PROCEDURE Grafik;
begin
  kox:=wherex; koy:=wherey;
  window(grafx,grafy,grafx+maxx-1,grafy+maxy-1);
  clrscr;
  window(grafx,grafy,grafx+maxx,grafy+maxy);
  textcolor(green);
  for x:=1 to maxx do
    for y:=1 to maxy do
      if feld[x,y]=zelle then begin
        gotoxy(x,y);
        write(symbol)
      end;
  gotoxy(kox,koy);
end;

PROCEDURE Quadrat(z: integer);
begin
  if z=1 then begin
    textbackground(red);
    textcolor(yellow)
  end;
  if feld[wherex,wherey]=zelle then write(symbol) else write(' ');
  textbackground(black);
  textcolor(green);
  gotoxy(wherex-1,wherey);
end;

PROCEDURE Hilfe;
begin
  kox:=wherex; koy:=wherey;
  window(grafx,grafy,grafx+maxx-1,grafy+maxy-1);
  textcolor(white);
  clrscr;
  writeln;
  writeln(' Help - Screen');
  writeln(' -------------');
  writeln;
  writeln(' CR   Zelle setzen/lîschen');
  writeln(' ',#27#26#25#24,' Cursor bewegen (nein echt?)');
  writeln(' SPC  Zyklen starten');
  writeln('      Unterbrechen mit CR');
  writeln(' BS   Anzahl der Zyklen Ñndern');
  writeln;
  writeln(' <S>  Bild speichern');
  writeln(' <R>  Bild wiederherstellen');
  writeln(' <C>  Bild lîschen');
  writeln(' <U>  Bild restaurieren');
  writeln;
  write(' ZurÅck mit CR ');
  repeat until readkey=#13;
  Blau;
  gotoxy(kox,koy);
  Grafik;
end;

BEGIN
  origmode:=lastmode;
  textmode(lo(lastmode)+font8x8);
  randomize;
  Neues_Feld;
  BlockCursor;
  Blau;
  gotoxy(maxx div 3,maxy div 3);
  repeat
    Quadrat(1);
    c:=readkey;
    case c of
      #13: feld[wherex,wherey]:=1-feld[wherex,wherey];
      #72: begin Quadrat(0); if wherey>1 then gotoxy(wherex,wherey-1) end;
      #75: begin Quadrat(0); if wherex>1 then gotoxy(wherex-1,wherey) end;
      #77: begin Quadrat(0); if wherex<maxx then gotoxy(wherex+1,wherey) end;
      #80: begin Quadrat(0); if wherey<maxy then gotoxy(wherex,wherey+1) end;
      #8:  begin
             kox:=wherex; koy:=wherey;
             window(grafx+8,grafy+maxy+1,grafx+14,grafy+maxy+1);
             clrscr;
             textcolor(white);
             readln(anzahl);
             write(anzahl);
             window(grafx,grafy,grafx+maxx,grafy+maxy);
             gotoxy(kox,koy);
           end;
      'c': begin
             Neues_Feld;
             Grafik;
           end;
      's': for x:=1 to maxx do
             for y:=1 to maxy do
               savefeld[x,y]:=feld[x,y];
      'r': begin
             for x:=1 to maxx do
               for y:=1 to maxy do
                 feld[x,y]:=savefeld[x,y];
             Grafik;
           end;
      'u': begin
             for x:=1 to maxx do
               for y:=1 to maxy do
                 feld[x,y]:=neufeld[x,y];
             Grafik;
           end;
      ' ': for i:=1 to anzahl do begin
             Zyklus;
             Grafik;
             if keypressed then c:=readkey;
             if c=#13 then i:=anzahl;
           end;
      'h': Hilfe;
    end;
  until c=#27;
  textmode(origmode);
  NormalCursor;
  clrscr
END.
