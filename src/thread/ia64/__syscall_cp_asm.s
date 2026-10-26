.global __syscall_cp_asm
.type __syscall_cp_asm, @function
__syscall_cp_asm:
    // in0 = cancel pointer, in1 = syscall nr, in2-in7 = args
    alloc r2 = ar.pfs, 8, 0, 6, 0
    ;;
    ld4 r14 = [in0]
    ;;
    cmp.ne p6, p0 = r0, r14
    (p6) br.cond.spnt.many __cp_cancel
    ;;
    mov out0 = in2
    mov out1 = in3
    mov out2 = in4
    mov out3 = in5
    mov out4 = in6
    mov out5 = in7
    mov r15 = in1
    ;;
__cp_begin:
    break 0x100000
    ;;
    cmp.eq p6, p0 = -1, r10
    ;;
    (p6) sub r8 = 0, r8
    ;;
__cp_end:
    br.ret.sptk.many b0

.global __cp_begin
.global __cp_end
.global __cp_cancel

__cp_cancel:
    /* Reached with __syscall_cp_asm's frame still current, and b0 still
       holding the return address into __syscall_cp_c.  __cancel() takes no
       arguments.  Tail-call it: it either exits the thread (pthread_exit)
       or returns -ECANCELED in r8, which becomes our return value.
       Do NOT br.call — that clobbers b0 and makes br.ret loop back here. */
    br.many __cancel

.section .data
.global __cp_begin_addr
.global __cp_end_addr
.global __cp_cancel_addr
__cp_begin_addr: data8 __cp_begin
__cp_end_addr:   data8 __cp_end
__cp_cancel_addr: data8 __cp_cancel
