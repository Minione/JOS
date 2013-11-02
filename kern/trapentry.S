/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>



###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */
#define TRAPHANDLER(name, num, dpl)                 \
        .text;                                      \
        .globl name;                                \
        .type name, @function;                      \
        .align 2;                                   \
        name:                                       \
        pushl $(num);                               \
        jmp _alltraps;                              \
        .data;                                      \
        .long name;                                 \
        .long dpl

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num, dpl)            \
        .text;                                      \
        .globl name;                                \
        .type name, @function;                      \
        .align 2;                                   \
        name:                                       \
        pushl $0;                                   \
        pushl $(num);                               \
        jmp _alltraps;                              \
        .data;                                      \
        .long name;                                 \
        .long dpl


#define NOTRAP()\
        .data;\
        .long 0;\
        .long 0

.data
.global idt_off;
idt_off:

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */


TRAPHANDLER_NOEC(trap_DIVIDE, T_DIVIDE, 0);
TRAPHANDLER_NOEC(trap_DEBUG, T_DEBUG, 0);
TRAPHANDLER_NOEC(trap_NMI, T_NMI, 0);
TRAPHANDLER_NOEC(trap_BRKPT, T_BRKPT, 3);
TRAPHANDLER_NOEC(trap_OFLOW, T_OFLOW, 0);
TRAPHANDLER_NOEC(trap_BOUND, T_BOUND, 0);
TRAPHANDLER_NOEC(trap_ILLOP, T_ILLOP, 0);
TRAPHANDLER_NOEC(trap_DEVICE, T_DEVICE, 0);
TRAPHANDLER(trap_DBLFLT, T_DBLFLT, 0);
NOTRAP();
TRAPHANDLER(trap_TSS, T_TSS, 0);
TRAPHANDLER(trap_SEGNP, T_SEGNP, 0);
TRAPHANDLER(trap_STACK, T_STACK, 0);
TRAPHANDLER(trap_GPFLT, T_GPFLT, 0);
TRAPHANDLER(trap_PGFLT, T_PGFLT, 0);
NOTRAP();
TRAPHANDLER_NOEC(trap_FPERR, T_FPERR, 0);
TRAPHANDLER(trap_ALIGN, T_ALIGN, 0);
TRAPHANDLER_NOEC(trap_MCHK, T_MCHK, 0);
TRAPHANDLER_NOEC(trap_SIMDERR, T_SIMDERR, 0);
TRAPHANDLER_NOEC(trap_SYSCALL, T_SYSCALL, 3);


/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
    pushl %ds
    pushl %es
    pushal
    movl $GD_KD, %eax
    movw %ax, %ds
    movw %ax, %es
    pushl %esp
    call trap

