#include <stdio.h>

static const char str[] = {
#include "gmp.h"
};

extern void do_bar(void);
void do_bar(void) {
    puts("bar before");
    puts(str);
    puts("bar after");
}
