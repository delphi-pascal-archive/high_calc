program Mathdemo;

uses
  Forms,
  Plane in 'PLANE.PAS' {PlaneGraphs},
  Surface in 'SURFACE.PAS' {SurfaceForm},
  Ani1 in 'ANI1.PAS' {AniForm},
  Mdemo1 in 'MDEMO1.PAS' {DemoForm},
  Spcurv in 'SPCURV.PAS' {SpaceCurveForm};

{$R *.RES}

begin
  Application.CreateForm(TDemoForm, DemoForm);
  Application.Run;
end.
