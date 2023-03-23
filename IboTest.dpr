program IboTest;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  IB_Components;

var
  conn : TIB_Connection;
  qry, lk : TIB_Query;
  upd : TIB_Query;

begin
  try
    conn := TIB_Connection.Create(nil);
    conn.Database := 'CCARE';
    conn.Username := 'sysdba';
    // set %ISC_PASSWORD% or conn.Password
    conn.Open;

    upd := TIB_Query.Create(nil);
    upd.IB_Connection := conn;
    //upd.SQL.Text := 'select * from medication_request where medication_request_id = :mri';
    //upd.SQL.Text := 'select * from medication_request where medication_request_id = char_to_uuid(:mris)';
    //upd.SQL.Text := 'select medication_request_id, status from medication_request where medication_request_id = char_to_uuid(''73148719-5C41-4BF2-B4AC-278CD3074113'')';
    upd.SQL.Text := 'select medication_request_id, status from medication_request where medication_request_id = x''731487195C414BF2B4AC278CD3074113''';
    upd.RequestLive := True;
    upd.Prepare;
    //upd.ParamByName('mri').Trimming := ctNone;
    //upd.ParamByName('mri').ColData := #$73#$14#$87#$19#$5C#$41#$4B#$F2#$B4#$AC#$27#$8C#$D3#$07#$41#$13;
    //upd.ParamByName('mris').AsString := '73148719-5C41-4BF2-B4AC-278CD3074113';
    upd.Open;
    upd.First;
    if upd.EOF then
    begin
      writeln('nope');
      exit;
    end;

    Writeln(Format('STATUS = %d', [Integer(upd.FieldValues['STATUS'])]));
    upd.Edit;
    upd.FieldValues['STATUS'] := 3;
    upd.Post;

    exit;

    lk := TIB_Query.Create(nil);
    lk.IB_Connection := conn;

    qry := TIB_Query.Create(nil);
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

insert into types (id, name) values (x'CD00AB00000000000000000000000000', 'bar');
insert into types (id, name) values (x'AB00CD00000000000000000000000000', 'foo');
select * from types;
insert into names (id, name, type_id) values (1, 'eric', x'AB00CD00000000000000000000000000');
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
