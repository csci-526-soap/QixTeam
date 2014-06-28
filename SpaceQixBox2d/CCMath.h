/*
	初等函数 - elementary function
	线性函数: linear function
	二次函数: quadratic function
	幂函数: power function
	指数函数: exponential function
	对数函数: logarithmic funciton
	三角函数: trigonometric function
	反三角函数: inverse trigonometic function
*/
#define	CC_LINEAR(a, b, x)                  (a * x + b)
#define	CC_QUADRATIC(a, x, b, c)            (a * pow(x ,2) + b * x + c)
#define	CC_POWER(x, a)                      (pow(x, a))
#define	CC_EXPONENTIAL(a, x)                (pow(a, x))
#define	CC_LOGARITHMIC(a, x)                (log(a, x))
#define	CC_TRIGONOMETRIC_SIN(x)             (sin(x))
#define	CC_TRIGONOMETRIC_COS(x)             (cos(x))
#define	CC_TRIGONOMETRIC_TAN(x)             (tan(x))
#define	CC_TRIGONOMETRIC_COT(x)             (cot(x))
#define	CC_TRIGONOMETRIC_SEC(x)             (SEC(x))
#define	CC_TRIGONOMETRIC_CSC(x)             (CSC(x))
#define	CC_TRIGONOMETRIC_ARCSIN(x)          (arcsin(x))
#define	CC_TRIGONOMETRIC_ARCCOS(x)          (arccos(x))