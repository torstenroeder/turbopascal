Unit Turtle;

Interface

Var
  Xcor, Ycor: Integer;

Function TurtleX: integer;
Function TurtleY: integer;
Function TurtleHeading: integer;

Procedure ShowTurtle;
Procedure HideTurtle;
Procedure Forwd(Laenge: Real);
Procedure Right(Winkel:Real);
Procedure Left(Winkel: Real);
Procedure PutTurtle(X,Y: Real);
Procedure Push(X,Y: Real);
Procedure Back(Laenge: Real);
Procedure Home;
Procedure WhiteTrace;
Procedure BlackTrace;
Procedure Unten;
Procedure Oben;

Implementation

Uses Graph;

Var
   Xakt,Yakt:      Real;
   Heading:        Real;
   ShowTurtleFlag: Boolean;
   Farbe:          Byte;


Function TurtleX: integer;
begin
  TurtleX:=round(Xakt)
end;

Function TurtleY: integer;
begin
  TurtleY:=round(-Yakt)
end;

Function TurtleHeading: integer;
begin
  TurtleHeading:=round(Heading)
end;

Procedure ShowTurtle;
begin
  ShowTurtleFlag:=true;
end;

Procedure HideTurtle;
begin
  ShowTurtleFlag:=false;
end;

Procedure Forwd(Laenge: Real);
  Var  Xalt, Yalt, XMitte, YMitte, Zerr:Real;
       Xasp,Yasp: Word;
  Begin Xalt:= Xakt; Yalt:= Yakt;
    XMitte := GetMaXX div 2;
    YMitte := GetMaXY div 2;
    Xakt:= Xakt - Laenge*sin(Heading*pi/180);
    GetAspectRatio(Xasp,Yasp); Zerr := Xasp/Yasp;
    Yakt:= Yakt- Zerr * Laenge*cos(Heading*pi/180);
    Xcor:= Round(Xakt + XMitte); Ycor := Round(Yakt + YMitte);
    If ShowTurtleFlag
      then line(Round(Xalt+XMitte),Round(Yalt+YMitte),Xcor,Ycor);
  End;

Procedure Right(Winkel: Real);
  begin  Heading:= Heading - Winkel;
    while (Heading > 180) or (Heading < -180) do
      begin
        if Heading >  180 then Heading:= Heading - 360;
        if Heading < -180 then Heading:= Heading + 360;
      end;
  end;

Procedure Left(Winkel: Real);
  begin Right(-Winkel) end;

Procedure PutTurtle(X,Y: Real);
begin
  Xakt:=X;
  Yakt:=-Y;
  Xcor:=Round(Xakt);
  Ycor:=Round(Yakt);
  Heading:= 0;
end;

Procedure Push(X,Y: Real);
begin
  Xakt:=X;
  Yakt:=-Y;
  Xcor:=Round(Xakt);
  Ycor:=Round(Yakt);
end;

Procedure Oben;
begin
  PutTurtle(0,GetMaxY/2); heading:=180
end;

Procedure Unten;
begin
  PutTurtle(0,GetMaxY/2)
end;

Procedure Back(Laenge: Real);
  Begin Forwd(-Laenge) End;

Procedure Home;
  Begin PutTurtle(0,0);End;

Procedure BlackTrace;
  Begin SetColor(GetBkColor); End;

Procedure WhiteTrace;
  Begin SetColor(Farbe); End;

Begin
  Heading:=180;
  ShowTurtle;
  Farbe:= 15
End.
