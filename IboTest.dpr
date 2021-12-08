program IboTest;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  IB_Components;

var
  conn : TIB_Connection;
  qry : TIB_Cursor;

begin
  try
    conn := TIB_Connection.Create(nil);
    conn.Database := 'CCARE';
    conn.Username := 'sysdba';
    conn.Password := '******';
    conn.Open;

    qry := TIB_Cursor.Create(Nil);
    qry.IB_Connection := conn;
//    qry.SQL.Text := 'select pat_id, full_name from patient where full_name like ''HUNT%'' ' +
//      'union all select pat_id, full_name from patient where full_name like ''BAXTER%''';

    qry.SQL.LoadFromFile('C:\Git\IboTest\test.sql');

    qry.Open;
    while not qry.Eof do
    begin
      writeln(qry.FieldByName('ix_result_no').AsString, #9, qry.FieldByName('patient_name').AsString);
      qry.Next;
    end;

    Writeln('done!');
    Readln;
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
