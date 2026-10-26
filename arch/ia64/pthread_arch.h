#include <stdint.h>
#include <stddef.h>
#include "libc.h"

static inline uintptr_t __get_tp(void)
{
    uintptr_t tp;
    __asm__ ("mov %0 = r13" : "=r"(tp));
    return tp;
}

#define TLS_ABOVE_TP
#define GAP_ABOVE_TP 0
#define MC_PC sc_ip

/*
 * IA-64 local-exec tprel offsets are biased relative to TP.
 * The bias is at least 16 bytes (two pointers, the Itanium TCB/DTV
 * header), and grows to the TLS block alignment when that is larger.
 *
 * Empirically:
 *   small-align TLS: tprel bias = 16
 *   64-align TLS:    tprel bias = 64
 *   4096-align TLS:  tprel bias = 4096
 *
 * Generic musl TLS_ABOVE_TP computes:
 *
 *   TP = td + sizeof(struct pthread) + TP_OFFSET
 *
 * so we need:
 *
 *   TP_OFFSET = -max(16, tls_align)
 */
static inline size_t __ia64_tp_bias(void)
{
    size_t min_bias = 2 * sizeof(void *);
    return libc.tls_align > min_bias ? libc.tls_align : min_bias;
}

#define TP_OFFSET (-(long)__ia64_tp_bias())

