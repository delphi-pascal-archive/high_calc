unit FunDefConst;

interface
Uses
  ComCtrls,SysUtils,VarUnit,Forms;

type
  TFunDefs=array[1..135] of TFuncDesc;

Const
  igConstants=1;
  igOperators=2;
  igLogicalOperators=3;
  igGeneralFunctions=4;
  igTrigonometricFunctions=5;
  igSpecialFunctionsAndSeries=6;
  igPrimesAndNumbers=7;
  igIntegrals=8;
  igFunctionPlotsAndGraphs=9;
  igFinancialFunctions=10;
  igVariables=11;
  igConvertionsFunctions=12;

const
//I. Constants
  cE=2.71828182845905;          // - Euler's number
  cPi=3.14159265358979;         //- perimeter of half of a unit circle
  cCatalan=0.915965594177219;   //  - Catalan's constant
  cG=0.577215664901533;         // - Euler's Gamma constant
  cTrue=1;                   //true - true value
  cFalse=0;                 //false - false value
//II. Arithmetical operators
  oAddition=1;         // + (addition) - addition
  oSubtraction=2;      // - (subtraction) - subtraction
  oMultiplication=3;   // * (multiplication, product) - multiplication, product
  oDivision=4;         // / (division) - division
  oModulo=5;           // m (modulo) - modulo
  oPercentage=6;       // % (percentage) - percentage
  oIntegerDivision=7;  // | (integer division) - integer division
  oPower=8;            // ^ (power) - power
  oFactorial=9;        // ! (factorial) - factorial
  oRoot=10;            // \ (root) - root
  oTenPower=11;        // e - ten-power
  oSetVariable=12;     // = - set a variable
  oTestsEqualValues=13;// ? - tests equal values
  oBigger=14;          // > - compares values (bigger)
  oSmaller=15;         // < - compares values (smaller)
//III. Logical operators
  oXor=16;             //xor - bitwise xor
  oXnor=17;            //xnor - bitwise xnor
  oAnd=18;             //& (and) - bitwise and
  oNand=19;            //nand - bitwise nand
  oOr=20;              //or - bitwise or
  oNor=21;             //nor - bitwise nor
  oNot=22;             //Not - bitwise not
  oShl=23;             //Shl - bitwise shift left
  oShr=24;             //Shr - bitwise shift right
//IV. General Functions
  oLcm=25;             //Lcm - least common multiple
  oGcd=26;             //Gcd - greatest common divisor
  oMin=27;             //Min - smallest value
  oMax=28;             //Max - largest value
  oFrac=29;            //Frac - fractional part
  oAbs=30;             //Abs - absolute value
  oIntg=31;            //Intg - integer value
  oRound=32;           //Round - round to closest integer
  oTrunc=33;           //Trunc - truncate to closest integer
  oLogten=34;          //Logten - 10-base logarithm
  oLogN=35;            //LogN - N-base logarithm
  oExp=36;             //Exp - exponential
  oLn=37;              //Ln , Log - natural logarithm
  oCeil=38;            //Ceil - ceiling
  oFloor=39;           //Floor - floor
  oSqrt=40;            //Sqrt - square root
  oSqr=41;             //Sqr - power of two
  oRandom=42;          //Random - random number
  oAverage=43;         //Average - average number
  oSum=44;             //Sum - addition
  oMul=45;             //Mul - product}
//V. Trigonometric Functions
//Константы тригонометрических функций
  oSin=46;             // sine
  oCos=47;             // cosine
  oTan=48;             // tangent
  oCot=49;             // cotangent
  oSinh=50;            // hyperbolic sine
  oCosh=51;            // hyperbolic cosine
  oTanh=52;            // hyperbolic tangent
  oArcsin=53;          // inverse sine
  oArccos=54;          // inverse cosine
  oArctan=55;          // inverse tangent
  oArccot=56;          // inverse cotangent
  oArcsinh=57;         // inverse hyperbolic sine
  oArccosh=58;         // inverse hyperbolic cosine
  oArctanh=59;         // inverse hyperbolic tangent
  oArccoth=60;         // inverse hyperbolic cotangent
  oSec=61;             // secant
  oCsc=62;             // cosecant
  oSech=63;            // hyperbolic secant
  oCsch=64;            // hyperbolic cosecant
  oArcsec=65;          // inverse secant
  oArccsc=66;          // inverse cosecant
  oArcsech=67;         // inverse hyperbolic secant
  oArccsch=68;         // inverse hyperbolic cosecant
//VI. Special Functions and Series
  oFib=69;             //Fib - Fibonacci integers
  oBinom=70;           //Binom - binomial coefficients
  oGamma=71;           //Gamma - Euler's function
  oBeta=72;            //Beta - Euler's beta function
  oHarmonic=73;        //Harmonic - harmonic function
  oPochhammer=74;      //Pochhammer - general pochhammer function
  oFermat=75;          //Fermat - Fermat numbers
  oBth=76;             //Bth - iterative binomial theorem
  oBman=77;            //Bman - standard binomial theorem
//VII. Primes and Numbers
  oPhi=78;             //Phi , EInd - Euler's indicator (totient function)
  oPrime=79;           //Prime - prime number
  oPrimeC=80;          //PrimeC - number of primes
  oPrimeN=81;          //PrimeN - numbered prime
  oMersenne=82;        //Mersenne - mersenne number
  oMersenneGen=83;     //MersenneGen - mersenne generator number
  oMersGen=84;         //MersGen - mersenne number for a generator
  oGenMers=85;         //GenMers - generator for a mersenne number
  oPerfect=86;         //Perfect - perfect number
  oSigma=87;           //Sigma - sum of positive n-power divisors
  oTau=88;             //Tau - sum of positive divisors
  oMoebius=89;         //Moebius, Mu - moebius function
  oSafeprime=90;       //Safeprime - safe prime
//VIII. Integrals
  oStudent=91;         //Student Integral Approximations - student integral approximations
  oGauss=92;           //Exact Gauss Integrals - exact integral approximations
  oDilog=93;           //Dilog - dilogarithm integral
  oDawson=94;          //Dawson - dawson integral
  oErf=95;             //Erf - error function
  oErfc=96;            //Erfc - complimentary error function
  oSi=97;              //Si - sine integral
  oCi=98;              //Ci - cosine integral
  oSsi=99;             //Ssi - shifted sine integral
  oShi=100;            //Shi - hyperbolic sine integral
//  oChi=101;            //Chi - hyperbolic cosine integral
//  oFresnelC=102;       //FresnelC - fresnel cosine integral
//  oFresnelS=103;       //FresnelS - fresnel sine integral
  oProtect=101;        //Функция снятия ограничения по времени
  oThanks=102;         //Благодарность за регистрацию
  oNewFuncs=103;       //Включение всех функций
  oFresnelF=104;       //FresnelF - fresnel cosine auxiliary
  oFresnelG=105;       //FresnelG - fresnel sine auxiliary
  oEllipticE=106;      //EllipticE - elliptic integrals of the second kind
  oEllipticCE=107;     //EllipticCE - complimentary elliptic integral of the second kind
  oEllipticK=108;      //EllipticK - elliptic integrals of the first kind
  oEllipticCK=109;     //EllipticCK - complimentary elliptic integral of the first kind
//IX. Function Plots and Graphs
  oPlot=110;           //Plot -  2D plot
  oZPlot=111;          //ZPlot - 3D plot
//X. Financial Functions
  oSln=112;            //Sln - straight line depreciation
  oSyd=113;            //Syd - sum of year digits depreciation
  oCterm=114;          //Cterm - number of compounding periods
  oTerm=115;           //Term - number of compounding periods with periodic deposits
  oPmt=116;            //Pmt - payment amount per interval on loan or annuity
  oRate=117;           //Rate - interest rate
  oPv=118;             //Pv - initial value of loan or annuity
  oNpv=119;            //Npv - present value of sequence of cash flows
  oFv=120;             //Fv - accumulated amount
  oDb=121;             //Db - fixed-declining balance depreciation
  oDdb=122;            //Ddb - double-declining balance depreciation
  oExtFin=123;         //Extended Financial - extended versions

//Преобразование системы исчисления
  oH=124;              //Из шестнадцатеричной в десятичную
  oO=125;              //Из восьмеричной в десятичную
  oB=126;              //Из двоичной в десятичную
  oXBase=127;              //Из произвольной 2-32 в десятичную
//
  oMandl=128;          //Построение множества Мандельброта
//Преобразование угловых величин
  oDeg=129;
  oDegToRad=130;
  oDegToGrad=131;
  oRadToDeg=132;
  oRadToGrad=133;
  oGradToDeg=134;
  oGradToRad=135;



  //FunDefs:array[1..123] of TFuncDesc=(
  FunDefs:TFunDefs=(

//II. Arithmetical Operators
    (Id:2;GroupId:igOperators;FunId:'+';ArgNum:150;NeedBrackets:false;FunDesc:'Addition';HighPrec:true;MathCoProc:true;Syntax:'expression + expression';HtmlHelp:'ref-plus.html'),
    (Id:2;GroupId:igOperators;FunId:'-';ArgNum:150;NeedBrackets:false;FunDesc:'Subtraction';HighPrec:true;MathCoProc:true;Syntax:'expression - expression';HtmlHelp:'ref-minus.html'),
    (Id:2;GroupId:igOperators;FunId:'*';ArgNum:200;NeedBrackets:false;FunDesc:'Multiplication';HighPrec:true;MathCoProc:true;Syntax:'expression * expression';HtmlHelp:'ref-multiplication.html'),
    (Id:2;GroupId:igOperators;FunId:'/';ArgNum:200;NeedBrackets:false;FunDesc:'Division';HighPrec:true;MathCoProc:true;Syntax:'expression / expression';HtmlHelp:'ref-division.html'),
    (Id:2;GroupId:igOperators;FunId:'MOD';ArgNum:200;NeedBrackets:false;FunDesc:'Modulo';HighPrec:false;MathCoProc:true;Syntax:'expression MOD expression';HtmlHelp:'ref-modulo.html'),
    (Id:2;GroupId:igOperators;FunId:'%';ArgNum:200;NeedBrackets:false;FunDesc:'Percentage';HighPrec:false;MathCoProc:true;Syntax:'expression % expression';HtmlHelp:'ref-percentage.html'),
    (Id:2;GroupId:igOperators;FunId:'|';ArgNum:200;NeedBrackets:false;FunDesc:'Integer division';HighPrec:false;MathCoProc:true;Syntax:'expression | expression';HtmlHelp:'ref-intdiv.html'),
    (Id:2;GroupId:igOperators;FunId:'^';ArgNum:300;NeedBrackets:false;FunDesc:'Power';HighPrec:false;MathCoProc:true;Syntax:'expression ^ expression';HtmlHelp:'ref-power.html'),
    (Id:2;GroupId:igOperators;FunId:'!';ArgNum:400;NeedBrackets:false;FunDesc:'Factorial';HighPrec:false;MathCoProc:false;Syntax:'expression !';HtmlHelp:'ref-factorial.html'),
    (Id:2;GroupId:igOperators;FunId:'\';ArgNum:200;NeedBrackets:false;FunDesc:'Root';HighPrec:false;MathCoProc:false;Syntax:'expression \ expression';HtmlHelp:'ref-root.html'),
    (Id:2;GroupId:igOperators;FunId:'e';ArgNum:200;NeedBrackets:false;FunDesc:'Ten-power';HighPrec:false;MathCoProc:false;Syntax:'expression E expression';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igOperators;FunId:'=';ArgNum:90;NeedBrackets:false;FunDesc:'Set a variable';HighPrec:false;MathCoProc:true;Syntax:'variable = expression';HtmlHelp:'ref-equal.html'),
    (Id:2;GroupId:igOperators;FunId:'?';ArgNum:200;NeedBrackets:false;FunDesc:'Tests equal values';HighPrec:false;MathCoProc:true;Syntax:'expression ? expression';HtmlHelp:'ref-question.html'),
    (Id:2;GroupId:igOperators;FunId:'>';ArgNum:120;NeedBrackets:false;FunDesc:'Compares values (bigger)';HighPrec:false;MathCoProc:true;Syntax:'expression > expression';HtmlHelp:'ref-biffer.html'),
    (Id:2;GroupId:igOperators;FunId:'<';ArgNum:120;NeedBrackets:false;FunDesc:'Compares values (smaller)';HighPrec:false;MathCoProc:true;Syntax:'expression < expression';HtmlHelp:'ref-smaller.html'),

//III. Logical Operators
    (Id:2;GroupId:igLogicalOperators;FunId:'XOR'; ArgNum:200;NeedBrackets:false;FunDesc:'Bitwise xor';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-xor.html'),
    (Id:2;GroupId:igLogicalOperators;FunId:'XNOR';ArgNum:200;NeedBrackets:false;FunDesc:'Bitwise xnor';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-xnor.html'),
    (Id:2;GroupId:igLogicalOperators;FunId:'AND'; ArgNum:200;NeedBrackets:false;FunDesc:'Bitwise and';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-and.html'),
    (Id:2;GroupId:igLogicalOperators;FunId:'NAND';ArgNum:200;NeedBrackets:false;FunDesc:'Bitwise nand';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-nand.html'),
    (Id:2;GroupId:igLogicalOperators;FunId:'OR';  ArgNum:200;NeedBrackets:false;FunDesc:'Bitwise or';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-or.html'),
    (Id:2;GroupId:igLogicalOperators;FunId:'NOR'; ArgNum:200;NeedBrackets:false;FunDesc:'Bitwise nor';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-nor.html'),
    (Id:2;GroupId:igLogicalOperators;FunId:'NOT'; ArgNum:1;NeedBrackets:true;  FunDesc:'Bitwise not';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-not.html'),
    (Id:2;GroupId:igLogicalOperators;FunId:'SHL'; ArgNum:200;NeedBrackets:false;FunDesc:'Bitwise shift left';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-shl.html'),
    (Id:2;GroupId:igLogicalOperators;FunId:'SHR'; ArgNum:200;NeedBrackets:false;FunDesc:'B1itwise shift right';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-shr.html'),//24

//IV. General Functions
    (Id:2;GroupId:igGeneralFunctions;FunId:'LCM';ArgNum:1; NeedBrackets:True;FunDesc:'Least common multiple';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-lcm.html'),
    (Id:2;GroupId:igGeneralFunctions;FunId:'GCD';ArgNum:1; NeedBrackets:True;FunDesc:'Greatest common divisor';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-gcd.html'),
    (Id:2;GroupId:igGeneralFunctions;FunId:'MIN';ArgNum:-1;NeedBrackets:True;FunDesc:'Smallest value';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-min.html'),
    (Id:2;GroupId:igGeneralFunctions;FunId:'MAX';ArgNum:-1;NeedBrackets:True;FunDesc:'Largest value';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-max.html'),
    (Id:2;GroupId:igGeneralFunctions;FunId:'FRAC';ArgNum:1;NeedBrackets:True;FunDesc:'Fractional part';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-frac.html'),
    (Id:2;GroupId:igGeneralFunctions;FunId:'ABS';ArgNum:1; NeedBrackets:True;FunDesc:'Absolute value';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-abs.html'),
    (Id:2;GroupId:igGeneralFunctions;FunId:'INTG';ArgNum:1;NeedBrackets:True;FunDesc:'Integer value';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-intg.html'),
    (Id:2;GroupId:igGeneralFunctions;FunId:'ROUND';ArgNum:1;NeedBrackets:True;FunDesc:'Round to closest integer';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-round.html'),
    (Id:2;GroupId:igGeneralFunctions;FunId:'TRUNC';ArgNum:1;NeedBrackets:True;FunDesc:'Truncate to closest integer';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-trunc.html'),
    (Id:2;GroupId:igGeneralFunctions;FunId:'LG';ArgNum:1;NeedBrackets:True;FunDesc:    '10-base logarithm';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-logten.html'),
    (Id:2;GroupId:igGeneralFunctions;FunId:'LOG';ArgNum:2;NeedBrackets:True;FunDesc:   'N-base logarithm';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-logn.html'),
    (Id:2;GroupId:igGeneralFunctions;FunId:'EXP';ArgNum:1;NeedBrackets:True;FunDesc:   'Exponential';HighPrec:True;MathCoProc:true;Syntax:'';HtmlHelp:'ref-exp.html'),
    (Id:2;GroupId:igGeneralFunctions;FunId:'LN';ArgNum:1;NeedBrackets:True;FunDesc:    'Natural logarithm';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-ln.html'),
    (Id:2;GroupId:igGeneralFunctions;FunId:'CEIL';ArgNum:1;NeedBrackets:True;FunDesc:  'Ceiling';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-ceil.html'),
    (Id:2;GroupId:igGeneralFunctions;FunId:'FLOOR';ArgNum:1;NeedBrackets:True;FunDesc: 'Floor';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-floor.html'),
    (Id:2;GroupId:igGeneralFunctions;FunId:'SQRT';ArgNum:1;NeedBrackets:True;FunDesc:  'Square root';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-sqrt.html'),
    (Id:2;GroupId:igGeneralFunctions;FunId:'SQR';ArgNum:1;NeedBrackets:True;FunDesc:   'Power of two';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-sqr.html'),
    (Id:2;GroupId:igGeneralFunctions;FunId:'RANDOM';ArgNum:1;NeedBrackets:True;FunDesc:'Random number';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-random.html'),
    (Id:2;GroupId:igGeneralFunctions;FunId:'AVG';ArgNum:-1;NeedBrackets:True;FunDesc:  'Average number';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-average.html'),
    (Id:2;GroupId:igGeneralFunctions;FunId:'SUM';ArgNum:-1;NeedBrackets:True;FunDesc:  'Addition';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-sum.html'),
    (Id:2;GroupId:igGeneralFunctions;FunId:'MUL';ArgNum:-1;NeedBrackets:True;FunDesc:  'Product';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-mul.html'),//45

//V. Trigonometric Functions
    (Id:2;GroupId:igTrigonometricFunctions;FunId:'SIN';ArgNum:1;NeedBrackets:True;FunDesc:    'Sine';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-sin.html'),
    (Id:2;GroupId:igTrigonometricFunctions;FunId:'COS';ArgNum:1;NeedBrackets:True;FunDesc:    'Cosine';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-cos.html'),
    (Id:2;GroupId:igTrigonometricFunctions;FunId:'TAN';ArgNum:1;NeedBrackets:True;FunDesc:    'Tangent';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-tan.html'),
    (Id:2;GroupId:igTrigonometricFunctions;FunId:'CTG';ArgNum:1;NeedBrackets:True;FunDesc:    'Cotangent';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-cot.html'),
    (Id:2;GroupId:igTrigonometricFunctions;FunId:'HSIN';ArgNum:1;NeedBrackets:True;FunDesc:   'Hyperbolic sine';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-sinh.html'),
    (Id:2;GroupId:igTrigonometricFunctions;FunId:'HCOS';ArgNum:1;NeedBrackets:True;FunDesc:   'Hyperbolic cosine';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-cosh.html'),
    (Id:2;GroupId:igTrigonometricFunctions;FunId:'HTAN';ArgNum:1;NeedBrackets:True;FunDesc:   'Hyperbolic tangent';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-tanh.html'),
    (Id:2;GroupId:igTrigonometricFunctions;FunId:'ARCSIN';ArgNum:1;NeedBrackets:True;FunDesc: 'Inverse sine';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-arcsin.html'),
    (Id:2;GroupId:igTrigonometricFunctions;FunId:'ARCCOS';ArgNum:1;NeedBrackets:True;FunDesc: 'Inverse cosine';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-arccos.html'),
    (Id:2;GroupId:igTrigonometricFunctions;FunId:'ARCTAN';ArgNum:1;NeedBrackets:True;FunDesc: 'Inverse tangent';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-arctan.html'),
    (Id:2;GroupId:igTrigonometricFunctions;FunId:'ARCCTG';ArgNum:1;NeedBrackets:True;FunDesc: 'Inverse cotangent';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-arccot.html'),
    (Id:2;GroupId:igTrigonometricFunctions;FunId:'HARCSIN';ArgNum:1;NeedBrackets:True;FunDesc:'Inverse hyperbolic sine';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-arcsinh.html'),
    (Id:2;GroupId:igTrigonometricFunctions;FunId:'HARCCOS';ArgNum:1;NeedBrackets:True;FunDesc:'Inverse hyperbolic cosine';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-arccosh.html'),
    (Id:2;GroupId:igTrigonometricFunctions;FunId:'HARCTAN';ArgNum:1;NeedBrackets:True;FunDesc:'Inverse hyperbolic tangent';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-arctanh.html'),
    (Id:2;GroupId:igTrigonometricFunctions;FunId:'HARCCTG';ArgNum:1;NeedBrackets:True;FunDesc:'Inverse hyperbolic cotangent';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-arccoth.html'),
    (Id:2;GroupId:igTrigonometricFunctions;FunId:'SEC';ArgNum:1;NeedBrackets:True;FunDesc:    'Secant';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-sec.html'),
    (Id:2;GroupId:igTrigonometricFunctions;FunId:'CSC';ArgNum:1;NeedBrackets:True;FunDesc:    'Cosecant';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-csc.html'),
    (Id:2;GroupId:igTrigonometricFunctions;FunId:'HSEC';ArgNum:1;NeedBrackets:True;FunDesc:   'Hyperbolic secant';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-sech.html'),
    (Id:2;GroupId:igTrigonometricFunctions;FunId:'HCSC';ArgNum:1;NeedBrackets:True;FunDesc:   'Hyperbolic cosecant';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-csch.html'),
    (Id:2;GroupId:igTrigonometricFunctions;FunId:'ARCSEC';ArgNum:1;NeedBrackets:True;FunDesc: 'Inverse secant';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-arcsec.html'),
    (Id:2;GroupId:igTrigonometricFunctions;FunId:'ARCCSC';ArgNum:1;NeedBrackets:True;FunDesc: 'Inverse cosecant';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-arccsc.html'),
    (Id:2;GroupId:igTrigonometricFunctions;FunId:'HARCSEC';ArgNum:1;NeedBrackets:True;FunDesc:'Inverse hyperbolic secant';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-arcsech.html'),
    (Id:2;GroupId:igTrigonometricFunctions;FunId:'HARCCSC';ArgNum:1;NeedBrackets:True;FunDesc:'Inverse hyperbolic cosecant';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-arccsch.html'),

//VI.Special Functions and Series
    (Id:2;GroupId:igSpecialFunctionsAndSeries;FunId:'FIB';ArgNum:1;NeedBrackets:True;FunDesc:       'Fib - Fibonacci integers';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-fib.html'),//69
    (Id:2;GroupId:igSpecialFunctionsAndSeries;FunId:'BINOM';ArgNum:200;NeedBrackets:True;FunDesc:   'Binomial coefficients';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igSpecialFunctionsAndSeries;FunId:'GAMMA';ArgNum:200;NeedBrackets:True;FunDesc:   'Gamma - Euler''s function';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igSpecialFunctionsAndSeries;FunId:'BETA';ArgNum:200;NeedBrackets:True;FunDesc:    'Beta - Euler''s beta function';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igSpecialFunctionsAndSeries;FunId:'HARMONIC';ArgNum:200;NeedBrackets:True;FunDesc:'Harmonic function';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igSpecialFunctionsAndSeries;FunId:'POCHHAMMER';ArgNum:2;NeedBrackets:True;FunDesc:'General pochhammer function';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-pochhammer.html'),
    (Id:2;GroupId:igSpecialFunctionsAndSeries;FunId:'FERMAT';ArgNum:200;NeedBrackets:True;FunDesc:  'Fermat numbers';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igSpecialFunctionsAndSeries;FunId:'BTH';ArgNum:3;NeedBrackets:True;FunDesc:       'Iterative binomial theorem';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-bth.html'),
    (Id:2;GroupId:igSpecialFunctionsAndSeries;FunId:'BMAN';ArgNum:3;NeedBrackets:True;FunDesc:      'Standard binomial theorem';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-bman.html'),

//VII. Primes and Numbers
    (Id:2;GroupId:igPrimesAndNumbers;FunId:'PHI';ArgNum:200;NeedBrackets:True;FunDesc:        'Euler''s indicator (totient function;Syntax:'')';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igPrimesAndNumbers;FunId:'PRIME';ArgNum:200;NeedBrackets:True;FunDesc:      'Prime number';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igPrimesAndNumbers;FunId:'PRIMEC';ArgNum:200;NeedBrackets:True;FunDesc:     'Number of primes';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igPrimesAndNumbers;FunId:'PRIMEN';ArgNum:200;NeedBrackets:True;FunDesc:     'Numbered prime';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igPrimesAndNumbers;FunId:'MERSENNE';ArgNum:200;NeedBrackets:True;FunDesc:   'Mersenne number';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igPrimesAndNumbers;FunId:'MERSENNEGEN';ArgNum:200;NeedBrackets:True;FunDesc:'Mersenne generator number';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igPrimesAndNumbers;FunId:'MERSGEN';ArgNum:200;NeedBrackets:True;FunDesc:    'Mersenne number for a generator';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igPrimesAndNumbers;FunId:'GENMERS';ArgNum:200;NeedBrackets:True;FunDesc:    'Generator for a mersenne number';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igPrimesAndNumbers;FunId:'PERFECT';ArgNum:200;NeedBrackets:True;FunDesc:    'Perfect number';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igPrimesAndNumbers;FunId:'SIGMA';ArgNum:200;NeedBrackets:True;FunDesc:      'Sum of positive n-power divisors';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igPrimesAndNumbers;FunId:'TAU';ArgNum:200;NeedBrackets:True;FunDesc:        'Sum of positive divisors';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igPrimesAndNumbers;FunId:'MOEBIUS';ArgNum:200;NeedBrackets:True;FunDesc:    'Moebius function';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igPrimesAndNumbers;FunId:'SAFEPRIME';ArgNum:200;NeedBrackets:True;FunDesc:  'Safe prime';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),//90

//VIII. Integrals
    (Id:2;GroupId:igIntegrals;FunId:'STUDENT';ArgNum:200;NeedBrackets:True;FunDesc:   'Student integral approximations';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igIntegrals;FunId:'GAUSS';ArgNum:200;NeedBrackets:True;FunDesc:     'Exact integral approximations';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igIntegrals;FunId:'DILOG';ArgNum:200;NeedBrackets:True;FunDesc:     'Dilogarithm integral';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igIntegrals;FunId:'DAWSON';ArgNum:200;NeedBrackets:True;FunDesc:    'Dawson integral';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igIntegrals;FunId:'ERF';ArgNum:200;NeedBrackets:True;FunDesc:       'Error function';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igIntegrals;FunId:'ERFC';ArgNum:200;NeedBrackets:True;FunDesc:      'Complimentary error function';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igIntegrals;FunId:'SI';ArgNum:200;NeedBrackets:True;FunDesc:        'Sine integral';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igIntegrals;FunId:'CI';ArgNum:200;NeedBrackets:True;FunDesc:        'Cosine integral';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igIntegrals;FunId:'SSI';ArgNum:200;NeedBrackets:True;FunDesc:       'Shifted sine integral';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igIntegrals;FunId:'SHI';ArgNum:200;NeedBrackets:True;FunDesc:       'Hyperbolic sine integral';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igIntegrals;FunId:'CHI';ArgNum:200;NeedBrackets:True;FunDesc:       'Hyperbolic cosine integral';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igIntegrals;FunId:'FRESNELC';ArgNum:200;NeedBrackets:True;FunDesc:  'Fresnel cosine integral';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igIntegrals;FunId:'FRESNELS';ArgNum:200;NeedBrackets:True;FunDesc:  'Fresnel sine integral';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igIntegrals;FunId:'FRESNELF';ArgNum:200;NeedBrackets:True;FunDesc:  'Fresnel cosine auxiliary';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igIntegrals;FunId:'FRESNELG';ArgNum:200;NeedBrackets:True;FunDesc:  'Fresnel sine auxiliary';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igIntegrals;FunId:'ELLIPTICE';ArgNum:200;NeedBrackets:True;FunDesc: 'Elliptic integrals of the second kind';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igIntegrals;FunId:'ELLIPTICCE';ArgNum:200;NeedBrackets:True;FunDesc:'Complimentary elliptic integral of the second kind';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igIntegrals;FunId:'ELLIPTICK';ArgNum:200;NeedBrackets:True;FunDesc: 'Elliptic integrals of the first kind';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igIntegrals;FunId:'ELLIPTICCK';ArgNum:200;NeedBrackets:True;FunDesc:'Complimentary elliptic integral of the first kind';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),

//IX. Function Plots and Graphs
    (Id:2;GroupId:igFunctionPlotsAndGraphs;FunId:'PLOT';ArgNum:4;NeedBrackets:True;FunDesc: '2D plot';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-plot1.html'),
    (Id:2;GroupId:igFunctionPlotsAndGraphs;FunId:'ZPLOT';ArgNum:7;NeedBrackets:True;FunDesc:'3D plot';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-zplot3.html'),

//X. Financial Functions
    (Id:2;GroupId:igFinancialFunctions;FunId:'SLN';ArgNum:3;NeedBrackets:True;FunDesc:    'Straight line depreciation';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-sln.html'),
    (Id:2;GroupId:igFinancialFunctions;FunId:'SYD';ArgNum:4;NeedBrackets:True;FunDesc:    'Sum of year digits depreciation';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-syd.html'),
    (Id:2;GroupId:igFinancialFunctions;FunId:'CTERM';ArgNum:200;NeedBrackets:True;FunDesc:'Number of compounding periods';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igFinancialFunctions;FunId:'TERM';ArgNum:200;NeedBrackets:True;FunDesc: 'Number of compounding periods with periodic deposits';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igFinancialFunctions;FunId:'PMT';ArgNum:200;NeedBrackets:True;FunDesc:  'Payment amount per interval on loan or annuity';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igFinancialFunctions;FunId:'RATE';ArgNum:200;NeedBrackets:True;FunDesc: 'Interest rate';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igFinancialFunctions;FunId:'PV';ArgNum:200;NeedBrackets:True;FunDesc:   'Initial value of loan or annuity';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igFinancialFunctions;FunId:'NPV';ArgNum:200;NeedBrackets:True;FunDesc:  'Present value of sequence of cash flows';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igFinancialFunctions;FunId:'FV';ArgNum:200;NeedBrackets:True;FunDesc:   'Accumulated amount';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igFinancialFunctions;FunId:'DB';ArgNum:200;NeedBrackets:True;FunDesc:   'Fixed-declining balance depreciation';HighPrec:false;MathCoProc:false;Syntax:'';HtmlHelp:'ref-.html'),
    (Id:2;GroupId:igFinancialFunctions;FunId:'DDB';ArgNum:4;NeedBrackets:True;FunDesc:    'Duble-declining balance depreciation';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-ddb.html'),
    (Id:2;GroupId:igFinancialFunctions;FunId:'EXTFIN';ArgNum:200;NeedBrackets:True;FunDesc:'Extended versions';HighPrec:false;MathCoProc:false;Syntax:''),//123
//Преобразование системы исчисления
    (Id:2;GroupId:igConvertionsFunctions;FunId:'H';ArgNum:1;NeedBrackets:True;FunDesc:   'Hexadecimal';HighPrec:true;MathCoProc:true;Syntax:'';HtmlHelp:'functions_converting_angles__deg.html'),
    (Id:2;GroupId:igConvertionsFunctions;FunId:'O';ArgNum:1;NeedBrackets:True;FunDesc:   'Octal';HighPrec:true;MathCoProc:true;Syntax:'';HtmlHelp:'functions_converting_angles__deg.html'),
    (Id:2;GroupId:igConvertionsFunctions;FunId:'B';ArgNum:1;NeedBrackets:True;FunDesc:    'Binary';HighPrec:true;MathCoProc:true;Syntax:'';HtmlHelp:'functions_converting_angles__deg.html'),
    (Id:2;GroupId:igConvertionsFunctions;FunId:'XBASE';ArgNum:2;NeedBrackets:True;FunDesc:'Any base';HighPrec:true;MathCoProc:true;Syntax:'';HtmlHelp:'functions_converting_angles__deg.html'),//127
//
    (Id:2;GroupId:igFunctionPlotsAndGraphs;FunId:'MANDL';ArgNum:3;NeedBrackets:True;FunDesc:'Mandelblrot set';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'ref-Mandl.html'),//128
//Преобразование угловых величин
    (Id:2;GroupId:igConvertionsFunctions;FunId:'DEG';ArgNum:3;NeedBrackets:True;FunDesc:'Degrees, Minutes, Seconds to integral and fractional of degrees';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'functions_converting_angles__deg.html'),
    (Id:2;GroupId:igConvertionsFunctions;FunId:'DEGTORAD';ArgNum:3;NeedBrackets:True;FunDesc:   'Degrees to radians';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'functions_converting_angles__deg.html'),
    (Id:2;GroupId:igConvertionsFunctions;FunId:'DEGTOGRAD';ArgNum:3;NeedBrackets:True;FunDesc:   'Degrees to grads';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'functions_converting_angles__deg.html'),
    (Id:2;GroupId:igConvertionsFunctions;FunId:'RADTODEG';ArgNum:1;NeedBrackets:True;FunDesc:    'Radians to degrees';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'functions_converting_angles__deg.html'),
    (Id:2;GroupId:igConvertionsFunctions;FunId:'RADTOGRAD';ArgNum:1;NeedBrackets:True;FunDesc:'Radians to grads';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'functions_converting_angles__deg.html'),
    (Id:2;GroupId:igConvertionsFunctions;FunId:'GRADTODEG';ArgNum:1;NeedBrackets:True;FunDesc:    'Grads to degrees';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'functions_converting_angles__deg.html'),
    (Id:2;GroupId:igConvertionsFunctions;FunId:'GRADTORAD';ArgNum:1;NeedBrackets:True;FunDesc:'Grads to radians';HighPrec:false;MathCoProc:true;Syntax:'';HtmlHelp:'functions_converting_angles__deg.html')//135
    );


Groups:array[1..12] of TGroupRec=(
  (id:1;GroupName:'Constants';Node:nil;HtmlHelp:''),
  (id:1;GroupName:'Arithmetical operators';Node:nil;HtmlHelp:'ref-operators.html'),
  (id:1;GroupName:'Logical operators';Node:nil;HtmlHelp:'ref-logical.html'),
  (id:1;GroupName:'General Functions';Node:nil;HtmlHelp:'ref-general.html'),
  (id:1;GroupName:'Trigonometric Functions';Node:nil;HtmlHelp:'ref-trigonometric.html'),
  (id:1;GroupName:'Special Functions and Series';Node:nil;HtmlHelp:'ref-special.html'),
  (id:1;GroupName:'Primes and Numbers';Node:nil;HtmlHelp:'ref-.html'),
  (id:1;GroupName:'Integrals';Node:nil;HtmlHelp:'ref-.html'),
  (id:1;GroupName:'Graphs And Plots';Node:nil;HtmlHelp:'ref-Plots.html'),
  (id:1;GroupName:'Financial Functions';Node:nil;HtmlHelp:'ref-financial.html'),
  (id:1;GroupName:'Variables';Node:nil;HtmlHelp:'Variables.htm'),
  (id:1;GroupName:'Convertions';Node:nil;HtmlHelp:'functions_converting_angles__deg.html'));

procedure InitGroups(Tree:TTreeView);
procedure InitTree(Tree:TTreeView;FileName:TFileName;CoProc:boolean);

implementation

function NodeByText(Tree:TTreeView;Text:string):TTreeNode;
var
  i,n:integer;
begin
  with Tree do begin
    n:=Items.Count-1;
    for i:=0 to n do
      if Items[i].Text=Text then begin
        Result:=Items[i];
        exit;
      end;
  end;
  Result:=nil;
end;

procedure InitGroups(Tree:TTreeView);
var
  i:integer;
begin
  for i:=Low(Groups) to High(Groups) do with Groups[i] do begin
    Node:=NodeByText(Tree,GroupName);
    if Node<>nil then
      Node.Data:=@Groups[i];
  end;
end;

procedure InitTree(Tree:TTreeView;FileName:TFileName;CoProc:boolean);
var
  i:integer;
  TreeNode:TTreeNode;
begin
  try
    Tree.LoadFromFile(FileName);
  except
    raise Exception.Create('Error file reading: '+FileName);
  end;
  InitGroups(Tree);
  for i:=Low(FunDefs) to High(FunDefs) do with Tree.Items,FunDefs[i] do begin
    if (MathCoProc and CoProc) or (HighPrec and (not CoProc)) then begin
      TreeNode:=AddChild(Groups[GroupId].Node,FunId);
      TreeNode.Data:=@FunDefs[i];
    end;
  end;
  VarBuf.LoadVariablesToTree(Tree,Groups[igVariables].Node);
  ConstBuf.SetTree(Tree,Groups[igConstants].Node);
  ConstBuf.LoadToTree;
end;

end.
