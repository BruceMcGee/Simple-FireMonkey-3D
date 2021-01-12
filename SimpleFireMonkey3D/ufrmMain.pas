unit ufrmMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  System.Math.Vectors, FMX.MaterialSources, FMX.Controls3D, FMX.Objects3D,
  FMX.Viewport3D, FMX.Ani, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TfrmMain = class(TForm)
    Viewport3D1: TViewport3D;
    Sphere1: TSphere;
    TextureMaterialSource1: TTextureMaterialSource;
    FloatAnimation1: TFloatAnimation;
    lblBrand: TLabel;
    Dummy1: TDummy;
    Camera1: TCamera;
    btnResetCamera: TButton;
    procedure Viewport3D1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure Viewport3D1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Single);
    procedure Viewport3D1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; var Handled: Boolean);
    procedure Viewport3D1Gesture(Sender: TObject;
      const EventInfo: TGestureEventInfo; var Handled: Boolean);
    procedure btnResetCameraClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FMouseDown: TPointF;
    FLastDistance: Integer;
    FOriginalRotationAngleX: Single;
    FOriginalRotationAngleY: Single;
    FOriginalZoom: Single;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}


// TfrmMain
// ============================================================================
procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FOriginalRotationAngleX := Dummy1.RotationAngle.X;
  FOriginalRotationAngleY := Dummy1.RotationAngle.Y;
  FOriginalZoom := Camera1.Position.Z;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.btnResetCameraClick(Sender: TObject);
begin
  Dummy1.RotationAngle.Point := TPoint3D.Zero;
  Dummy1.RotationAngle.X := FOriginalRotationAngleX;
  Dummy1.RotationAngle.Y := FOriginalRotationAngleY;

  Camera1.Position.Z := FOriginalZoom;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.Viewport3D1Gesture(Sender: TObject;
  const EventInfo: TGestureEventInfo; var Handled: Boolean);
var
  LDelta: Single;
begin
  if EventInfo.GestureID = igiZoom then
  begin
    if (TInteractiveGestureFlag.gfBegin in EventInfo.Flags) then
      FLastDistance := EventInfo.Distance;

    LDelta := (EventInfo.Distance - FLastDistance) / 40;
    Camera1.Position.Z := Camera1.Position.Z + LDelta;

    FLastDistance := EventInfo.Distance;
  end;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.Viewport3D1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Single);
begin
  FMouseDown := PointF(X, Y);
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.Viewport3D1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Single);
begin
  if ssLeft in Shift then
  begin
    Dummy1.RotationAngle.X := Dummy1.RotationAngle.X -
      ((Y - FMouseDown.Y) * 0.3);
    Dummy1.RotationAngle.Y := Dummy1.RotationAngle.Y +
      ((X - FMouseDown.X) * 0.3);
    FMouseDown := PointF(X, Y);
  end;
end;

// ----------------------------------------------------------------------------
procedure TfrmMain.Viewport3D1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; var Handled: Boolean);
begin
  Camera1.Position.Z := Camera1.Position.Z + WheelDelta / 40;
end;

end.
