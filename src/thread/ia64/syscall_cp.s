.global __ia64_syscall_cp_asm
.hidden __ia64_syscall_cp_asm
.type __ia64_syscall_cp_asm, @function

.text
.align 16
__ia64_syscall_cp_asm:
    alloc r2 = ar.pfs, 8, 0, 6, 0 ;;

    /* Syscall execution track */
    ld4 r3 = [in0] ;;
    cmp.ne p6, p0 = r3, r0 ;;
(p6) br.cond.spnt 2f ;;

    mov r15 = in1
    mov out0 = in2
    mov out1 = in3
    mov out2 = in4
    mov out3 = in5
    mov out4 = in6
    mov out5 = in7 ;;
    break 0x100000 ;;

    /* Normal Return Execution Bundle */
    br.ret.sptk.many b0 ;;

2:  /* Cancellation Branch Hook */
    /* __cancel is .hidden, so we can call it directly. */
    br.call.sptk.many b0 = __cancel ;;

