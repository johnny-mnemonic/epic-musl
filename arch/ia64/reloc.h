#define LDSO_ARCH "ia64"

#define REL_SYMBOLIC    R_IA64_DIR64LSB
#define REL_RELATIVE    R_IA64_REL64LSB
#define REL_PLT         R_IA64_IPLTLSB
#define REL_COPY        R_IA64_COPY
#define REL_DTPMOD      R_IA64_DTPMOD64LSB
#define REL_DTPOFF      R_IA64_DTPREL64LSB
#define REL_TPOFF       R_IA64_TPREL64LSB

/* Map unused or duplicate-handling generic musl macros to unique dummy case constants */
#define REL_GOT         101
#define REL_OFFSET      100

/* IA-64 specific function pointer relocations (using the exact types emitted) */
#define REL_FPTR        R_IA64_FPTR64LSB       /* 53 */
#define REL_LTOFF_FPTR  R_IA64_LTOFF_FPTR64LSB /* 54 (NOT 55) */

#define TPOFF_K         0

/* Make sure your remap_rel inline function maps both categories safely */
static inline int remap_rel(int type)
{
    if (type == R_IA64_DIR64LSB) return REL_SYMBOLIC;
    if (type == R_IA64_REL64LSB) return REL_RELATIVE;
    if (type == R_IA64_IPLTLSB) return REL_PLT;
    if (type == R_IA64_COPY)     return REL_COPY;
    if (type == R_IA64_DTPMOD64LSB) return REL_DTPMOD;
    if (type == R_IA64_DTPREL64LSB) return REL_DTPOFF;
    if (type == R_IA64_TPREL64LSB)  return REL_TPOFF;
    if (type == R_IA64_FPTR64LSB)   return REL_FPTR;
    if (type == R_IA64_LTOFF_FPTR64LSB)  return REL_LTOFF_FPTR; /* Match type 54 */
    return 0;
}

#define NEED_FDESC      1
#define REL_FUNCDESC    R_IA64_FPTR64LSB

/* IA-64: function pointers are descriptors {code_addr, gp_value}.
   __crtjmp dereferences the descriptor, sets new GP and SP, and branches. */
extern void __crtjmp(void *func, void *stack) __attribute__((noreturn));
#define CRTJMP(x, y) __crtjmp(x, y)

