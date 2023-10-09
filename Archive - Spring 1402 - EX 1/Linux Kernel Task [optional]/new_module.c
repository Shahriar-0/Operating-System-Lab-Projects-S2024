#include <linux/kernel.h>
#include <linux/module.h>

MODULE_LICENSE("GPL");

int init_module(void) {
    printk(KERN_INFO "Group Members:\n    - Ali Ghanbari\n    - Behrad Elmi\n    - Bita Nasiri\n");
    return 0;
}

void cleanup_module(void) {}
