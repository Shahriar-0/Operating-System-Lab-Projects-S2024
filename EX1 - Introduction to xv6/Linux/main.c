#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Group's members");
MODULE_DESCRIPTION("this module print group's members name");

static void __init do_initcall_level(int level, char* command_line) {
    initcall_entry_t* fn;

    parse_args(initcall_level_names[level],
               command_line, __start___param,
               __stop___param - __start___param,
               level, level,
               NULL, ignore_unknown_bootoption);

    trace_initcall_level(initcall_level_names[level]);
    for (fn = initcall_levels[level]; fn < initcall_levels[level + 1]; fn++)
        do_one_initcall(initcall_from_entry(fn));
    const char* yourName = "1.Sobhan Alaeddini  2.Shariar Attar  3.Matin Bazrafshan";
    printk(KERN_INFO "Added by: %s\n", yourName);
}