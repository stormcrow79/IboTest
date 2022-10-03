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
    conn.Database := 'CCARE';
    conn.Username := 'sysdba';
    // set %ISC_PASSWORD%
    conn.Open;

    lk := TIB_Query.Create(Nil);
    lk.IB_Connection := conn;

    qry := TIB_Query.Create(Nil);
    qry.IB_Connection := conn;

(*
drop table names;
drop table types;

create table types (
    id char(16) character set octets primary key,
    name varchar(50));
create table names (
    id int,
    name varchar(50),
    type_id char(16) character set octets,
    constraint fk_values_type_id foreign key (type_id) references types (id));

insert into types (id, name) values (x'CD000000000000000000000000000000', 'bar');
insert into types (id, name) values (x'AB000000000000000000000000000000', 'foo');
select * from types;
insert into names (id, name, type_id) values (1, 'eric', x'AB000000000000000000000000000000');
select * from names;
*)

    lk.SQL.text := 'select id, name from types order by name';
    qry.SQL.Text := 'select id, name, type_id from names where id = :id';

    lk.Open;
    lk.First;

    qry.RequestLive := true;
    qry.Prepare;
    qry.ParamByName('id').AsInteger := 1;
    qry.Open;
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
