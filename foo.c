#include <stdio.h>

static const char str[] = {
#include "gmp.h"
};

extern void do_bar(void);
extern void do_foo(void);
void do_foo(void) {
    puts(str);
    do_bar();
}
