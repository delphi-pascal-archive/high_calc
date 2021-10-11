unit ButCodes;

interface
uses
  Graphics;

const
  FrameCod=0;
  IndicatorCod=1;
  IndResCod=2;
  IndTreeCod=3;
  Indicator1Cod=4;
  IndRes1Cod=5;
  IndTree1Cod=6;

  bt_0=10;
  bt_1=11;
  bt_2=12;
  bt_3=13;
  bt_4=14;
  bt_5=15;
  bt_6=16;
  bt_7=17;
  bt_8=18;
  bt_9=19;
  bt_Plus=20;
  bt_Minus=21;
  bt_Mul=22;
  bt_Div=23;
  bt_Exe=24;
  bt_DecSeparator=25;
  bt_CloseForm=26;
  bt_ShowMemList=27;
  bt_AddToMemList=28;
  bt_Sin=29;
  bt_Cos=30;
  bt_ArcSin=31;
  bt_ArcCos=32;
  bt_tg=33;
  bt_Ctg=34;
  bt_ArcTg=35;
  bt_ArcCtg=36;
  bt_Ln=37;
  bt_Log=38;
  bt_lg=39;
  bt_Power=40;
  bt_Sqr=41;
  bt_Sqrt=42;
  bt_Clear=43;
  bt_Percent=44;
  bt_ChangeSign=45;
  bt_LogFile=46;
  bt_Ms=47;
  bt_Mr=48;
  bt_MPlus=49;
  bt_MMinus=50;
  bt_File=51;
  bt_Edit=52;
  bt_View=53;
  bt_Options=54;
  bt_Help=55;
  bt_PrevOp=56;
  bt_NextOp=57;
  IndBackCod=1001;
  IndResBackCod=1002;
  IndTreeBackCod=1003;

type
  TIndicatorColors=array[IndicatorCod..IndTreeCod] of TColor;

var
  IndicatorColors:TIndicatorColors;
implementation

end.
