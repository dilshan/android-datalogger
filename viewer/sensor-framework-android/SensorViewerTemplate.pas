//////////////////////////////////////////////////////////////////////////////////////////////
// Sensor framework - Android viewer.
//
// Last update: 	06-07-2018 5:21AM.
// Author: 			Dilshan R Jayakody [jayakody2000lk@gmail.com]
// Platform: 		Android platform 21+
//
// Copyright (C) 2018 Dilshan R Jayakody.
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>.
//////////////////////////////////////////////////////////////////////////////////////////////

unit SensorViewerTemplate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMXTee.Engine, FMXTee.Chart.Functions,
  FMXTee.Series, FMXTee.Procs, FMXTee.Chart, FMX.TabControl, IdBaseComponent,
  IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, System.JSON,
  System.ImageList, FMX.ImgList;

type
  TSensorMapItem = class
  private
    sensorTimer: TTimer;
    sensorName: string;
    sensorTriggerLevel: Integer;
  public
    property SensorScanTimer: TTimer read sensorTimer;
    property SensorTitle: string read sensorName;
    property SensorTrigger: Integer read sensorTriggerLevel write sensorTriggerLevel;

    constructor Create(timer: TTimer; title: string);
  end;

  TfrmMain = class(TForm)
    Header: TToolBar;
    HeaderLabel: TLabel;
    tmrTemperature: TTimer;
    httpClient: TIdHTTP;
    pnlGraph: TPanel;
    chrtTemp: TChart;
    grpSensorSeries: TFastLineSeries;
    tbNavBar: TToolBar;
    btnBack: TSpeedButton;
    ImageList1: TImageList;
    btnFront: TSpeedButton;
    lblHeading: TLabel;
    pnlFooter: TPanel;
    sbMain: TStyleBook;
    pnlSensorValue: TPanel;
    Label2: TLabel;
    lblSensorReading: TLabel;
    pnlTrigger: TPanel;
    Label4: TLabel;
    tkTrigger: TTrackBar;
    tmrLight: TTimer;
    tmrSound: TTimer;
    tmrCarbonMonoxide: TTimer;
    grpSensorTrig: TFastLineSeries;
    procedure FormCreate(Sender: TObject);
    function GetSensorValue(ChannelId: integer; trigger : boolean) : integer;
    procedure tmrTemperatureTimer(Sender: TObject);
    procedure btnFrontClick(Sender: TObject);
    procedure updateSensorPage();
    procedure tmrLightTimer(Sender: TObject);
    procedure tmrSoundTimer(Sender: TObject);
    procedure tmrCarbonMonoxideTimer(Sender: TObject);
    procedure plotSensorValue(sensorVal : Integer);
    procedure tkTriggerChange(Sender: TObject);
    procedure plotSensorTrigger(level : Integer);
  private
    sensorIndex : integer;
    sensorTrigger: boolean;
    sensorMap: array[0..3] of TSensorMapItem;
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}
{$R *.LgXhdpiTb.fmx ANDROID}
{$R *.SmXhdpiPh.fmx ANDROID}
{$R *.LgXhdpiPh.fmx ANDROID}
{$R *.GGlass.fmx ANDROID}
{$R *.XLgXhdpiTb.fmx ANDROID}
{$R *.SSW3.fmx ANDROID}
{$R *.Moto360.fmx ANDROID}
{$R *.NmXhdpiPh.fmx ANDROID}

constructor TSensorMapItem.Create(timer: TTimer; title: string);
begin
  self.sensorTimer := timer;
  Self.sensorName := title;
  self.sensorTriggerLevel := 0;
end;

function TfrmMain.GetSensorValue(ChannelId: integer; trigger : boolean) : integer;
var
  requestStream: TStringStream;
  responseStr : string;
  triggerVal : integer;
  responseJson: TJSONObject;
begin
  result := 0;
  triggerVal := 0;

  if(trigger) then
    triggerVal := 1;

  requestStream := TStringStream.Create('{"sensorId":' + IntToStr(ChannelId) + ', "trigger":' + IntToStr(triggerVal) + '}');
  responseJson := TJSONObject.Create;
  try
    // TODO: Specify Raspberry Pi IP address into below line. 
    responseStr := httpClient.Post('http://192.168.1.4:8080/api', requestStream);
    if(Length(responseStr) > 0) then
    begin
      responseJson.Parse(BytesOf(responseStr), 0);
      result := StrToIntDef(responseJson.GetValue('sensorValue').Value, 0);
    end;
  finally
    FreeAndNil(requestStream);
    FreeAndNil(responseJson);
  end;
end;

procedure TfrmMain.tmrTemperatureTimer(Sender: TObject);
var
  currentTemp : integer;
begin
  currentTemp := GetSensorValue(0, sensorTrigger);
  lblSensorReading.Text := IntToStr(currentTemp);
  plotSensorValue(currentTemp);
  sensorTrigger := currentTemp >= round(tkTrigger.Value);
end;

procedure TfrmMain.tmrLightTimer(Sender: TObject);
var
  currentLight : integer;
begin
  currentLight := GetSensorValue(1, sensorTrigger);
  lblSensorReading.Text := IntToStr(currentLight);
  plotSensorValue(currentLight);
  sensorTrigger := currentLight >= round(tkTrigger.Value);
end;

procedure TfrmMain.tmrSoundTimer(Sender: TObject);
var
  currentAudio : integer;
begin
  currentAudio := GetSensorValue(2, sensorTrigger);
  lblSensorReading.Text := IntToStr(currentAudio);
  plotSensorValue(currentAudio);
  sensorTrigger := currentAudio >= round(tkTrigger.Value);
end;

procedure TfrmMain.tmrCarbonMonoxideTimer(Sender: TObject);
var
  currentCO : integer;
begin
  currentCO := GetSensorValue(3, sensorTrigger);
  lblSensorReading.Text := IntToStr(currentCO);
  plotSensorValue(currentCO);
  sensorTrigger := currentCO >= round(tkTrigger.Value);
end;

procedure TfrmMain.btnFrontClick(Sender: TObject);
begin
  sensorIndex := sensorIndex + TComponent(Sender).Tag;

  if(sensorIndex > 3) then
    sensorIndex := 3;

  if(sensorIndex < 0) then
    sensorIndex := 0;

  updateSensorPage();
end;

procedure TfrmMain.plotSensorValue(sensorVal : Integer);
begin
  with grpSensorSeries do
  begin
    Add(sensorVal);
    if(Count > 100) then
      Delete(0, 5, true);
  end;
end;

procedure TfrmMain.plotSensorTrigger(level : Integer);
var
  tempVal : integer;
begin
  grpSensorTrig.Clear;
  with grpSensorTrig do
  begin
    for tempVal := 0 to 100 do
      Add(level);
  end;
end;

procedure TfrmMain.tkTriggerChange(Sender: TObject);
var
  trackPos : Integer;
begin
  trackPos := round(tkTrigger.Value);
  sensorMap[sensorIndex].sensorTriggerLevel := trackPos;
  plotSensorTrigger(trackPos);
end;

procedure TfrmMain.updateSensorPage();
var
  sensorPos : Integer;
begin
  for sensorPos := 0 to 3 do
    sensorMap[sensorPos].sensorTimer.Enabled := false;

  grpSensorSeries.Clear;
  lblSensorReading.Text := 'Reading...';
  sensorTrigger := false;

  lblHeading.Text := sensorMap[sensorIndex].sensorName;
  tkTrigger.Value := sensorMap[sensorIndex].sensorTriggerLevel;
  sensorMap[sensorIndex].sensorTimer.Enabled := true;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  chrtTemp.Title.Text.Clear;

  sensorTrigger := false;
  sensorIndex := 0;

  sensorMap[0] := TSensorMapItem.Create(tmrTemperature, 'Temperature');
  sensorMap[1] := TSensorMapItem.Create(tmrLight, 'Light');
  sensorMap[2] := TSensorMapItem.Create(tmrSound, 'Sound');
  sensorMap[3] := TSensorMapItem.Create(tmrCarbonMonoxide, 'Carbon Monoxide');

  httpClient.Request.ContentType := 'application/json';

  updateSensorPage();
  plotSensorTrigger(round(tkTrigger.Value));
end;

end.
