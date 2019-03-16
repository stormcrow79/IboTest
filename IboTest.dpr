program IboTest;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  IB_Components;

var
  conn : TIB_Connection;

begin
  try
    conn := TIB_Connection.Create(nil);
    conn.Database := 'c:\ccare\data\demo.fdb';
    conn.Username := 'sysdba';
    conn.Open;
    Writeln('done!');
    Readln;
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
