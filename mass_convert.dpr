program mass_convert;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  StringListUnicodeSupport,
  Encoding,
  IniFiles;

var
  cp: TEncoding;
  S : TStringList;
  Settings: TIniFile;
  sRec: TSearchRec;
  codepage: string;
begin
  S := TStringList.Create();
  Settings := TIniFile.Create('settings.ini');
  codepage := Settings.ReadString('main','codepage','unicode');
  cp := TEncoding.Create();
  if FindFirst('*.*', faAnyFile, sRec) = 0 then
  begin
    repeat
      if (sRec.Name <> '.') AND (sRec.Name <> '..') AND (Copy(LowerCase(sRec.Name), 0, Length('mass_convert.')) <> 'mass_convert.')
          AND (LowerCase(sRec.Name) <> 'settings.ini') AND ((sRec.Attr AND faDirectory) <> faDirectory) then
      begin
        WriteLn(sRec.Name);
        S.LoadFromFile(sRec.Name);
        if (Lowercase(codepage) = 'unicode') then
          S.SaveToFile(sRec.Name, cp.Unicode)
        else if (Lowercase(codepage) = 'utf8') OR (Lowercase(codepage) = 'utf-8') then
          S.SaveToFile(sRec.Name, cp.UTF8)
        else if (Lowercase(codepage) = 'cp1251') OR (Lowercase(codepage) = 'windows-1251') OR (Lowercase(codepage) = 'ascii') then
          S.SaveToFile(sRec.Name, cp.ASCII);
      end;
    until FindNext(sRec) <> 0;
    FindClose(sRec);
  end;

end.
 