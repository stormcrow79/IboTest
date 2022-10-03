program IboTest;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  IB_Components;

var
  conn : TIB_Connection;
  qry, lk : TIB_Query;

begin
  try
    conn := TIB_Connection.Create(nil);
    //conn.Server := 'localhost/3051';
    conn.Database := 'CCARE';
    conn.Username := 'sysdba';                                              
    conn.Password := '******';
    conn.Open;

    lk := TIB_Query.Create(Nil);
    lk.IB_Connection := conn;

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

    lk.SQL.text := 'select id, name from types';
    qry.SQL.Text := 'select id, name, type_id from names';

    lk.open;
    lk.First;

    qry.open;
    qry.Edit;
    qry.FieldByName('name').AsString := 'zeus';
    qry.FieldByName('type_id').ColData := lk.FieldByName('id').ColData;
    qry.Post;

    Writeln('done!');
    Readln;
  except
    on E:Exception do
      Writeln(E.Classname, ': ', E.Message);
  end;
end.
