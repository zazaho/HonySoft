unit initdb;

interface

procedure DummyConnectDatabases;
procedure ConnectDatabases;
procedure DisConnectDatabases;
procedure ChangeDatabases(NewVerkoperDb,NewPostCodeDb,NewContractDb: String);
procedure WriteNewUploadDir(NewDir:String);

var
   RootDir,contractdb,verkoperdb,postcodedb,uploaddir : String;

implementation
Uses Registry,Sysutils,Forms,Windows,Dialogs,DataMod;

procedure WriteNewUploadDir(NewDir:String);
Var
   Reg:TRegistry;
begin
     reg := Tregistry.create;
     with reg do
     Begin
          RootKey := HKEY_LOCAL_MACHINE;
          try
             OpenKey('Software\HonySoft\contractmanager\1.0\',True);
          Except
                ShowMessage('Ik kan geen toegang krijgen tot het systeem register');
                Exit;
          End;
          Reg.WriteString('Uploaddir',NewDir);
          UploadDir := NewDir;
     End;
end;

procedure DisConnectDatabases;
begin
     With MastData do
     Begin
          Verkoper.Active := False;
          Postcode.Active := False;
          Contract.Active := False;
     End;
end;

procedure ChangeDatabases(NewVerkoperDb,NewPostCodeDb,NewContractDb: String);

Var
   Reg:TRegistry;

begin
     Reg := Tregistry.Create;
     Reg.RootKey := HKEY_LOCAL_MACHINE;
     try
     Reg.OpenKey('Software\HonySoft\contractmanager\1.0\',True);
     Except
     ShowMessage('Ik kan geen toegang krijgen tot het systeem register');
     Exit;
     End;
     Reg.WriteString('verkoperdb',NewVerkoperDb);
     Reg.WriteString('postcodedb',NewPostCodeDb);
     Reg.WriteString('contractdb',NewContractDb);
end;

procedure ConnectDatabases;
Var
   Reg:TRegistry;
begin
     Rootdir := ExtractFilePath(Application.Exename);
     Reg := Tregistry.Create;
     Reg.RootKey := HKEY_LOCAL_MACHINE;
     try
     Reg.OpenKey('Software\HonySoft\contractmanager\1.0\',True);
     Except
     ShowMessage('Ik kan geen toegang krijgen tot het systeem register');
     Exit;
     End;
     if Reg.ValueExists('UploadDir') then
     uploaddir := Reg.ReadString('UploadDir')
     Else
     uploaddir := RootDir+'upload';
     if Reg.ValueExists('contractdb') then
     contractdb := Reg.ReadString('contractdb')
     Else
     contractdb := 'contract.db';
     if Reg.ValueExists('verkoperdb') then
     verkoperdb := Reg.ReadString('verkoperdb')
     Else
     verkoperdb := 'verkoper.db';
     if Reg.ValueExists('postcodedb') then
     Begin
     postcodedb := Reg.ReadString('postcodedb');
     End
     Else
     postcodedb := 'postcode.db';
     with MastData do
     Begin
          With Verkoper do
          Begin
               DatabaseName := Rootdir+'verkoper';
               TableName := verkoperdb;
               Try
                  Open
               Except
                     ShowMessage('Ik kan de verkoper gegevens in: '+Rootdir+
                     'verkoper\'+verkoperdb+' niet openen.');
               End;
          End;
          With Postcode do
          Begin
               DatabaseName := Rootdir+'postcode';
               TableName := postcodedb;
               Try
                  Open
               Except
                     ShowMessage('Ik kan de postcode gegevens in: '+Rootdir+
                     'postcode\'+postcodedb+' niet openen.');
               End;
          End;
          With Contract do
          Begin
               DatabaseName := Rootdir+'Contract';
               TableName := Contractdb;
               Try
                  Open
               Except
                     ShowMessage('Ik kan de verkoop gegevens in: '+Rootdir+
                     'Contract\'+Contractdb+' niet openen.');
               End;
          End;
     End;
end;

procedure DummyConnectDatabases;
Var
   Reg:TRegistry;
begin
     Rootdir := ExtractFilePath(Application.Exename);
     Reg := Tregistry.Create;
     Reg.RootKey := HKEY_LOCAL_MACHINE;
     try
     Reg.OpenKey('Software\HonySoft\contractmanager\1.0\',True);
     Except
     ShowMessage('Ik kan geen toegang krijgen tot het systeem register');
     Exit;
     End;
     if Reg.ValueExists('contractdb') then
     contractdb := Reg.ReadString('contractdb')
     Else
     contractdb := 'contract.db';
     if Reg.ValueExists('verkoperdb') then
     verkoperdb := Reg.ReadString('verkoperdb')
     Else
     verkoperdb := 'verkoper.db';
     if Reg.ValueExists('postcodedb') then
     Begin
     postcodedb := Reg.ReadString('postcodedb');
     End
     Else
     postcodedb := 'postcode.db';
end;

end.
