.global __set_thread_area
.type __set_thread_area, @function
__set_thread_area:
    alloc r2 = ar.pfs, 1, 0, 0, 0
    ;;
    mov r13 = in0        /* install the thread pointer */
    mov r8 = 0           /* return 0 */
    br.ret.sptk.many b0

