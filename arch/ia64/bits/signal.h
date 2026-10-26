#if defined(_POSIX_SOURCE) || defined(_POSIX_C_SOURCE) \
 || defined(_XOPEN_SOURCE) || defined(_GNU_SOURCE) || defined(_BSD_SOURCE)

struct sigaltstack {
    void *ss_sp;
    int ss_flags;
    size_t ss_size;
};

#if defined(_XOPEN_SOURCE) || defined(_GNU_SOURCE) || defined(_BSD_SOURCE)
#define MINSIGSTKSZ 131027
#define SIGSTKSZ    262144
#endif

#if defined(_GNU_SOURCE) || defined(_BSD_SOURCE)
typedef unsigned long greg_t;
typedef unsigned long gregset_t[32];

struct ia64_fpreg {
    union {
        unsigned long __bits[2];
        long double __dummy;
    } __u;
} __attribute__((__aligned__(16)));
typedef struct ia64_fpreg fpregset_t[128];

struct sigcontext {
    unsigned long sc_flags;
    unsigned long sc_nat;
    stack_t sc_stack;
    unsigned long sc_ip;
    unsigned long sc_cfm;
    unsigned long sc_um;
    unsigned long sc_ar_rsc;
    unsigned long sc_ar_bsp;
    unsigned long sc_ar_rnat;
    unsigned long sc_ar_ccv;
    unsigned long sc_ar_unat;
    unsigned long sc_ar_fpsr;
    unsigned long sc_ar_pfs;
    unsigned long sc_ar_lc;
    unsigned long sc_pr;
    unsigned long sc_br[8];
    unsigned long sc_gr[32];
    struct ia64_fpreg sc_fr[128];
    unsigned long sc_rbs_base;
    unsigned long sc_loadrs;
    unsigned long sc_ar25;
    unsigned long sc_ar26;
    unsigned long sc_rsvd[12];
    sigset_t sc_mask;
};

// needed to avoid:
// "
// src/thread/pthread_cancel.c: In function ‘cancel_handler’:
// src/thread/pthread_cancel.c:52:39: error: ‘mcontext_t’ {aka ‘struct sigcontext’} has no member named ‘MC_PC’
//   52 |         uintptr_t pc = uc->uc_mcontext.MC_PC;
//      |
// "
#define MC_PC sc_ip

typedef struct sigcontext mcontext_t;
#else
typedef struct {
    unsigned long __space[4096/sizeof(long)];
} mcontext_t;
#endif

/*
 * The IA-64 Linux kernel pushes struct sigcontext onto the signal stack,
 * not a full POSIX ucontext_t. To make ucontext_t compatible with both
 * POSIX and the kernel's signal frame, we map its members onto the
 * corresponding fields inside mcontext_t.
 *
 * uc_link maps to sc_gr[0]. General register 0 is architecturally read-as-zero
 * and writes are ignored, so the kernel does not save/restore it. Glibc
 * historically used this slot to store uc_link for user-space getcontext/
 * setcontext, and the kernel harmlessly preserves it as 0 across signals.
 * sc_gr[0] is exactly at byte offset 200 (25 unsigned longs).
 */
typedef struct __ucontext {
    union {
        mcontext_t __mc;
        struct {
            unsigned long __pad[25];
            struct __ucontext *__link;
        } __uc;
    } __u;
} ucontext_t;

#define uc_mcontext __u.__mc
#define uc_sigmask  __u.__mc.sc_mask
#define uc_stack    __u.__mc.sc_stack
#define uc_link     __u.__uc.__link
#define uc_flags    __u.__mc.sc_flags

#define SA_NOCLDSTOP  1
#define SA_NOCLDWAIT  2
#define SA_SIGINFO    4
#define SA_ONSTACK    0x08000000
#define SA_RESTART    0x10000000
#define SA_NODEFER    0x40000000
#define SA_RESETHAND  0x80000000
#define SA_RESTORER   0x04000000

#endif

#define SIGHUP     1
#define SIGINT     2
#define SIGQUIT    3
#define SIGILL     4
#define SIGTRAP    5
#define SIGABRT    6
#define SIGIOT     SIGABRT
#define SIGBUS     7
#define SIGFPE     8
#define SIGKILL    9
#define SIGUSR1    10
#define SIGSEGV    11
#define SIGUSR2    12
#define SIGPIPE    13
#define SIGALRM    14
#define SIGTERM    15
#define SIGSTKFLT  16
#define SIGCHLD    17
#define SIGCONT    18
#define SIGSTOP    19
#define SIGTSTP    20
#define SIGTTIN    21
#define SIGTTOU    22
#define SIGURG     23
#define SIGXCPU    24
#define SIGXFSZ    25
#define SIGVTALRM  26
#define SIGPROF    27
#define SIGWINCH   28
#define SIGIO      29
#define SIGPOLL    SIGIO
#define SIGPWR     30
#define SIGSYS     31
#define SIGUNUSED  SIGSYS

#define _NSIG      65

