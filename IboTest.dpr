program IboTest;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  IB_Components;

var
  conn : TIB_Connection;
  qry : TIB_Query;

begin
  try
    conn := TIB_Connection.Create(nil);
    conn.Database := 'CCARE';
    conn.Username := 'sysdba';                                              
    conn.Password := '******';
    conn.Open;

    qry := TIB_Query.Create(Nil);
    qry.IB_Connection := conn;

(*
create table types (
    id char(16) character set octets primary key, 
    name varchar(50));
create table names (
    id int, 
    name varchar(50), 
    type_id char(16) character set octets,
    constraint fk_values_type_id foreign key (type_id) references types (id));

insert into types (id, name) values (char_to_uuid('AB000000-0000-0000-0000-000000000000'), 'foo');
*)

    qry.SQL.Text := 'update names set name = :name, type_id = :type_id where id = :id;';
    qry.Prepare;
    qry.Params.ByName('id').AsInteger := 1;
    qry.Params.ByName('name').AsString := 'fred';
    qry.Params.ByName('type_id').ColData := #$AB#10#0#0#0#0#0#0#0#0#0#0#0#0#0#0;
    qry.Execute;

    Writeln('done!');
    Readln;
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
