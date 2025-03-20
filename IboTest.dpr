program IboTest;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  IB_Components, IB_Session;

var
  conn : TIB_Connection;
  qry : TIB_Cursor;

begin
  if ParamCount < 4 then
  begin
    Writeln('Usage: IboTest.exe [server] [path] [username] [password]');
    exit;
  end;

  try
    conn := TIB_Connection.Create(nil);
    conn.Server := ParamStr(1);
    conn.Path := ParamStr(2);
    conn.Username := ParamStr(3);
    conn.Password := ParamStr(4);
    conn.Protocol := cpTCP_IP;
    conn.Open;

    qry := TIB_Cursor.Create(Nil);
    qry.IB_Connection := conn;
//    qry.SQL.Text := 'select pat_id, full_name from patient where full_name like ''HUNT%'' ' +
//      'union all select pat_id, full_name from patient where full_name like ''BAXTER%''';

    qry.SQL.LoadFromFile('.\test.sql');

    qry.Open;
    writeln(qry.Fields[0].FieldName);
    while not qry.Eof do
    begin
      writeln(qry.Fields[0].AsString);
      qry.Next;
    end;

    Writeln('done!');
    Readln;
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
