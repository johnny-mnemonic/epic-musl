.global __crtjmp
.type __crtjmp, @function
__crtjmp:
    /* in0 = target code address, in1 = new stack pointer */
    alloc r2 = ar.pfs, 2, 0, 0, 0
    ;;
    adds r12 = -16, in1   /* _start does sp+16 to reach argc */
    mov b6 = in0          /* branch target = code address */
    ;;
    br.sptk.many b6       /* jump to the entry point */
