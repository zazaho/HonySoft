unit Utils;

interface

function WinExecAndWait32(FileName:String; Visibility : integer):integer;
function Date2Week(dDate:TDateTime):Integer;
function IsLeapYear( nYear: Integer ): Boolean;
function MonthDays( nMonth, nYear: Integer ): Integer;
procedure WriteStatusStrings;
procedure ReadStoredValues;
function iIsSub(sSub,sLong:String) :Boolean;

var
   bkrString,annString,vrzString,rtrString,warmString :String;
   UseWeekNummer: Boolean;

implementation

Uses Windows,SysUtils,Registry,dialogs;

procedure WriteStatusStrings;
begin
     with TRegistry.Create do
     Begin
          RootKey := HKEY_LOCAL_MACHINE;
          try
             OpenKey('Software\HonySoft\contractmanager\1.0\',True);
          Except
                ShowMessage('Ik kan geen toegang krijgen tot het systeem register');
                Exit;
          End;
          WriteString('warmString',warmString);
          WriteString('rtrString',rtrString);
          WriteString('vrzString',vrzString);
          WriteString('annString',annString);
          WriteString('bkrString',bkrString);
          CloseKey;
          Free;
     End;
end;

procedure ReadStoredValues;
begin
     with TRegistry.Create do
     Begin
          RootKey := HKEY_LOCAL_MACHINE;
          try
             OpenKey('Software\HonySoft\contractmanager\1.0\',True);
          Except
                ShowMessage('Ik kan geen toegang krijgen tot het systeem register');
                Exit;
          End;
          warmString := ReadString('warmString');
           rtrString := ReadString('rtrString');
           vrzString := ReadString('vrzString');
           annString := ReadString('annString');
           bkrString := ReadString('bkrString');
           UseWeekNummer := ReadBool('UseWeekNummer');
           CloseKey;
           Free;
     End;
end;

function WinExecAndWait32(FileName:String; Visibility : integer):integer;
var
  zAppName:array[0..512] of char;
  zCurDir:array[0..255] of char;
  WorkDir:String;
  StartupInfo:TStartupInfo;
  ProcessInfo:TProcessInformation;
begin
  StrPCopy(zAppName,FileName);
  GetDir(0,WorkDir);
  StrPCopy(zCurDir,WorkDir);
  FillChar(StartupInfo,Sizeof(StartupInfo),#0);
  StartupInfo.cb := Sizeof(StartupInfo);
  StartupInfo.dwFlags := STARTF_USESHOWWINDOW;
  StartupInfo.wShowWindow := Visibility;
  if not CreateProcess(nil,
    zAppName,                      { pointer to command line string }
    nil,                           { pointer to process security attributes }

    nil,                           { pointer to thread security attributes }
    false,                         { handle inheritance flag }
    CREATE_NEW_CONSOLE or          { creation flags }
    NORMAL_PRIORITY_CLASS,
    nil,                           { pointer to new environment block }
    nil,                           { pointer to current directory name }
    StartupInfo,                   { pointer to STARTUPINFO }
    ProcessInfo) then Result := -1 { pointer to PROCESS_INF }

  else begin
    WaitforSingleObject(ProcessInfo.hProcess,INFINITE);
    GetExitCodeProcess(ProcessInfo.hProcess,Result);
  end;
end;


function Date2Week(dDate:TDateTime):Integer;
var
 Dummy: Integer;
 nMonth, nDay, nYear: Word;
begin

//  nDayCount := 0;

  deCodeDate( dDate, nYear, nMonth, nDay );
{
  For X := 1 to ( nMonth - 1 ) do
    nDayCount := nDayCount + MonthDays( X, nYear );
  nDayCount := nDayCount + nDay;
}
Dummy := (
          Trunc( dDate - EncodeDate(nYear,1,1) ) +
          DayOfWeek( EncodeDate(nYear,1,1) ) -1) div 7 + 1;
If Dummy = 53 then
begin
     Dummy := 1;
     nYear := nYear + 1;
end;;
Result := 100*nYear+Dummy;
end;

function IsLeapYear( nYear: Integer ): Boolean;
begin
  Result := (nYear mod 4 = 0) and ((nYear mod 100 <> 0) or (nYear mod
400 = 0));
end;

function MonthDays( nMonth, nYear: Integer ): Integer;
const
  DaysPerMonth: array[1..12] of Integer = (31, 28, 31, 30, 31, 30, 31,
31, 30, 31, 30, 31);
begin
  Result := DaysPerMonth[nMonth];
  if (nMonth = 2) and IsLeapYear(nYear) then Inc(Result);
end;

function iIsSub(sSub,sLong:String) :Boolean;
Const CharTable : array[#0..#255] of byte = (
      0,1,2,3,4,5,6,7,8,9
     ,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29
     ,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49
     ,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,{a}97,98,99,100,101
     ,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121
     ,{z}122,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109
     ,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129
     ,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149
     ,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169
     ,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189
     ,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209
     ,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229
     ,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249
     ,250,251,252,253,254,255);

var
  tpSub, pSub,tpLong,pLong: PChar;

begin
  Result:= False;
  pSub := PChar(sSub);
  tpSub:= pSub;                      //Make temp pointer for substring.
  pLong := PChar(sLong);
  tpLong:= pLong; //Make temp pointer for string.
  while tpLong^ <> #0 do      //until end of String
  begin
    if (CharTable[tpSub^] = CharTable[tpLong^]) then     // are they equal ?
    begin
        while tpSub^ <> #0 do   // till end of substring
        begin
          if (CharTable[tpSub^] <> CharTable[tpLong^]) then break; //found difference
          inc(tpSub); inc(tpLong);   // next letter
        end;
        if tpSub^ = #0 then  // did we reach the end ?
        begin
            Result:= True;
            break;
        end;
    end
    else Inc(tpLong); // try on next letter . in string
    tpSub:= pSub;     // go back to first letter of substring again;
  end;
end;


end.
