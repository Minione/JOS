// program to cause a breakpoint trap

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
        cprintf("next instruction is int 3\n");
	asm volatile("int $3");
        cprintf("first instruction after int 3\n");
        cprintf("second instruction after int 3\n");
        cprintf("third instruction after int 3\n");
}

