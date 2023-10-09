#include <linux/module.h>
#include <linux/kernel.h>

MODULE_LICENSE("GPL");

int init_module(void)
{
	printk(KERN_INFO "Group 1:\n- Saman Eslami Nazari : 810199375\n- Pasha Barahimi      : 810199385\n- Misagh Mohaghegh    : 810199484\n");
	return 0;
}

void cleanup_module(void) {}

