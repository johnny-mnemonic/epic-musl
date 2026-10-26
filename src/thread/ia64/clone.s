.global __clone
.type __clone, @function
__clone:
    /* in0=func in1=stack in2=flags in3=arg in4=ptid in5=tls in6=ctid in7=stack_size */
    alloc r2 = ar.pfs, 8, 0, 8, 0
    ;;
    /* Reserve 16 bytes for func/arg just below the stack pointer */
    add r14 = -16, in1          /* r14 = stack - 16 */
    ;;
    st8 [r14] = in0             /* func */
    ;;
    add r16 = 8, r14
    ;;
    st8 [r16] = in3             /* arg */
    ;;
    /* clone2 base/size: base = stack - stack_size */
    sub r16 = in1, in7          /* r16 = ustack_base (stack_limit) */
    ;;
    mov r17 = in7               /* r17 = ustack_size (FULL size; kernel reserves 16) */
    ;;
    mov out0 = in2              /* flags          */
    mov out1 = r16              /* ustack_base    */
    mov out2 = r17              /* ustack_size    */
    mov out3 = in4              /* parent_tidptr  */
    mov out4 = in6              /* child_tidptr   */
    mov out5 = in5              /* tls            */
    mov r15 = 1213              /* __NR_clone2    */
    ;;
    break 0x100000
    ;;
    cmp.eq p6, p0 = -1, r10
    ;;
(p6) mov r8 = -1
(p6) br.ret.sptk.many b0
    cmp.eq p6, p0 = 0, r8
    ;;
(p6) br.cond.sptk.many .Lchild
    br.ret.sptk.many b0

.Lchild:
    ld8 r14 = [sp], 8           /* r14 = func descriptor pointer */
    ;;
    ld8 r15 = [sp]              /* r15 = arg */
    ;;
    ld8 r16 = [r14], 8          /* r16 = descriptor->ip */
    ;;
    ld8 r1  = [r14]             /* r1  = descriptor->gp (global pointer) */
    ;;
    alloc r2 = ar.pfs, 0, 0, 1, 0
    ;;
    mov out0 = r15              /* arg -> callee in0 */
    mov b6 = r16                /* target IP */
    ;;
    br.call.sptk.many b0 = b6
    ;;
    /* start() returned; exit(r8) */
    mov out0 = r8
    mov r15 = 1025              /* __NR_exit */
    ;;
    break 0x100000
    ;;
    break 0x100000

