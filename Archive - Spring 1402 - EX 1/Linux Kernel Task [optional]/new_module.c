#include <linux/module.h>
#include <linux/kernel.h>

MODULE_LICENSE("GPL");

int init_module(void)
{
    printk(KERN_INFO "Group Members:\n    - Ali Ghanbari\n    - Behrad Elmi\n    - Bita Nasiri\n");
    return 0;
}

void cleanup_module(void) {}
