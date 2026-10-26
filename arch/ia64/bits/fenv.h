typedef unsigned long fexcept_t;
typedef unsigned long fenv_t;

/* Logical exception bits; stored in FPSR at bits 13-18 (shift << 13) */
#define FE_INVALID    (1 << 0)
#define FE_UNNORMAL   (1 << 1)
#define FE_DIVBYZERO  (1 << 2)
#define FE_OVERFLOW   (1 << 3)
#define FE_UNDERFLOW  (1 << 4)
#define FE_INEXACT    (1 << 5)
#define FE_ALL_EXCEPT 0x3f

/* Rounding modes: IA-64 hardware encoding (FPSR bits 10-11) */
#define FE_TONEAREST  0
#define FE_DOWNWARD   1
#define FE_UPWARD     2
#define FE_TOWARDZERO 3

#define FE_DFL_ENV ((const fenv_t *)0xc009804c0270033fUL)

