unit MyLib;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fphttpclient;
type

  { TForm1 }

  MyLibX = class(TObject)
  public
        procedure SendFileToIP(IPAddress: String; FileName: String);
        function GetFileFromIP(IPAddress: String; FileName:String):String;
        function GetCurrentSelectedFile(IPAddress: String): String;
        function GetDeviceName(IPAddress: String): String;
        function GetFiles(IPAddress: String): TStringList;
        function SelectCurrentFile(IPAddress, FName:String):String;
        function DeleteFile(IPAddress, FName: String):String;
  private

  end;

implementation

procedure MyLibX.SendFileToIP(IPAddress: String; FileName: String);
var
   Respo: TStringStream;
   S: String;
begin
  With TFPHttpClient.Create(Nil) do
      try
        Respo:=TStringStream.Create('');
        IPAddress := 'http://'+IPAddress+'/edit';
        FileFormPost(IPAddress,'PostFilenameParam',FileName,Respo);
        S:=Respo.DataString;
        Respo.Destroy;
      finally
        Free;
      end;
end;

function MyLibX.GetCurrentSelectedFile(IPAddress: String): String;
var
   S: String;
   HTP: TFPHTTPClient;
begin
   HTP:=TFPHTTPClient.Create(Nil);
   try
     S:=HTP.Get('http://'+IPAddress+'/GetCurrentFile.htm');
   except
     S:='';
   end;
   HTP.Free;
   result:=S;
end;

function MyLibX.SelectCurrentFile(IPAddress, FName:String):String;
var
   S: String;
   HTP: TFPHTTPClient;
begin
   HTP:=TFPHTTPClient.Create(Nil);
   try
     S:=HTP.Get('http://'+IPAddress+'/SelectFile.htm?File='+FName);
   except
     S:='';
   end;
   HTP.Free;
   result:=S;
end;

function MyLibX.DeleteFile(IPAddress, FName: String):String;
var
    S: String;
    HTP: TFPHTTPClient;
begin
    HTP:=TFPHTTPClient.Create(Nil);
    try
      S:=HTP.Get('http://'+IPAddress+'/DeleteFile.htm?File='+FName);
    except
      S:='';
    end;
    HTP.Free;
    result:=S;
end;

function MyLibX.GetDeviceName(IPAddress: String): String;
var
   S: String;
   HTP: TFPHTTPClient;
begin
   HTP:=TFPHTTPClient.Create(Nil);
   try
     S:=HTP.Get('http://'+IPAddress+'/GetDeviceName.htm');
   except
     S:='';
   end;
   HTP.Free;
   result:=S;
end;

function MyLibX.GetFileFromIP(IPAddress: String; FileName:String):String;
var
   S: String;
   HTP: TFPHTTPClient;
begin
   HTP:=TFPHTTPClient.Create(Nil);
   try
     S:=HTP.Get('http://'+IPAddress+'/GetFile.htm?LoadFile='+FileName);
   finally
     HTP.Free;
   end;
   result:=S;
end;

function MyLibX.GetFiles(IPAddress: String): TStringList;
var
   S: String;
   HTP: TFPHTTPClient;
   List: TStringList;
begin
    HTP:=TFPHTTPClient.Create(Nil);
    try
      S:=HTP.Get('http://'+IPAddress+'/FileNames.htm');
    finally
      HTP.Free;
    end;

    List:=TStringList.Create;
    List.Delimiter := ',';
    List.StrictDelimiter:=True;
    List.DelimitedText:=S;
    result:=List;
end;

end.
                     
