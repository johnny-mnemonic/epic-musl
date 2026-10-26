.global feclearexcept
.type feclearexcept, @function
feclearexcept:
    alloc r2 = ar.pfs, 1, 0, 0, 0
    ;;
    mov.m r3 = ar.fpsr
    ;;
    mov r15 = 0x3f
    ;;
    and r14 = in0, r15          /* excepts & FE_ALL_EXCEPT */
    ;;
    shl r14 = r14, 13           /* to FPSR flag position (bits 13-18) */
    ;;
    andcm r3 = r3, r14          /* clear flags, leave masks (bits 0-5) intact */
    ;;
    mov.m ar.fpsr = r3
    ;;
    mov r8 = 0
    br.ret.sptk.many b0

.global feraiseexcept
.type feraiseexcept, @function
feraiseexcept:
    alloc r2 = ar.pfs, 1, 0, 0, 0
    ;;
    mov.m r3 = ar.fpsr
    ;;
    mov r15 = 0x3f
    ;;
    and r14 = in0, r15
    ;;
    shl r14 = r14, 13
    ;;
    or r3 = r3, r14             /* set flag bits */
    ;;
    mov.m ar.fpsr = r3
    ;;
    mov r8 = 0
    br.ret.sptk.many b0

.global fetestexcept
.type fetestexcept, @function
fetestexcept:
    alloc r2 = ar.pfs, 1, 0, 0, 0
    ;;
    mov.m r3 = ar.fpsr
    ;;
    mov r15 = 0x3f
    ;;
    and r14 = in0, r15
    ;;
    shr.u r3 = r3, 13           /* flags down to bits 0-5 */
    ;;
    and r8 = r3, r14
    br.ret.sptk.many b0

.global fegetround
.type fegetround, @function
fegetround:
    alloc r2 = ar.pfs, 0, 0, 0, 0
    ;;
    mov.m r3 = ar.fpsr
    ;;
    extr.u r8 = r3, 10, 2       /* rounding bits 10-11 */
    br.ret.sptk.many b0

.global __fesetround
.type __fesetround, @function
__fesetround:
    alloc r2 = ar.pfs, 1, 0, 0, 0
    ;;
    mov.m r3 = ar.fpsr
    ;;
    movl r14 = 0xc00            /* mask bits 10-11 */
    ;;
    andcm r3 = r3, r14
    ;;
    dep r8 = in0, r0, 10, 2     /* place rounding value at bits 10-11 */
    ;;
    or r3 = r3, r8
    ;;
    mov.m ar.fpsr = r3
    ;;
    mov r8 = 0
    br.ret.sptk.many b0

.global fegetenv
.type fegetenv, @function
fegetenv:
    alloc r2 = ar.pfs, 1, 0, 0, 0
    ;;
    mov.m r3 = ar.fpsr
    ;;
    st8 [in0] = r3
    ;;
    mov r8 = 0
    br.ret.sptk.many b0

.global fesetenv
.type fesetenv, @function
fesetenv:
    alloc r2 = ar.pfs, 1, 0, 0, 0
    ;;
    mov r3 = in0
    ;;
    movl r14 = 0xc009804c0270033f   /* FE_DFL_ENV */
    movl r15 = 0xc009804c02700302   /* FE_NOMASK_ENV */
    ;;
    cmp.eq p6, p0 = r14, r3
    ;;
(p6) mov r3 = r14
(p6) br.cond.sptk.many .Lwrite
    ;;
    cmp.eq p6, p0 = r15, r3
    ;;
(p6) mov r3 = r15
(p6) br.cond.sptk.many .Lwrite
    ;;
    ld8 r3 = [r3]
    ;;
.Lwrite:
    movl r14 = 0x3fffffffffffffff   /* clear bits 62-63 (unwritable here) */
    ;;
    and r3 = r3, r14
    ;;
    mov.m ar.fpsr = r3
    ;;
    mov r8 = 0
    br.ret.sptk.many b0

