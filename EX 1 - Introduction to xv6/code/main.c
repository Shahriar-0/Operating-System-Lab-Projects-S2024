#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Group's members");
MODULE_DESCRIPTION("this module print group's members name");

static int __init print_members_name(void) {
    printk(KERN_INFO "Group 1:\n- Matin Bazrafshan : 810100***\n- Sobhan Alaedini  : 810100***\n- Shahriar Attar   : 810100186\n Welcome :)\n");
    return 0;
}

static void __exit outro(void) {
    printk(KERN_INFO "Goodbye :)\n");
}

module_init(print_members_name);
module_exit(outro);