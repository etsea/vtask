module main

import task
import ui
import os
import v.pref

enum TaskArg {
	a
	c
	d
	l
}

struct ArgState {
	arg TaskArg
	state bool
}

fn process_args(args []string) []ArgState {
	mut returned_args := []ArgState{}

	is_windows := if pref.get_host_os() == pref.OS.windows { true } else { false }
	valid_args := [ TaskArg.a, TaskArg.c, TaskArg.d, TaskArg.l ]
	if is_windows {
		for arg in valid_args {
			formatted_arg := '/${arg}'
			current_arg := ArgState{
				arg: arg
				state: if formatted_arg in args { true } else { false }
			}
			returned_args << current_arg
		}
	} else {
		for arg in valid_args {
			formatted_arg := '-${arg}'
			current_arg := ArgState{
				arg: arg
				state: if formatted_arg in args { true } else { false }
			}
			returned_args << current_arg
		}
	}
	return returned_args
}

fn main() {
	repo := task.init_task_repository()!

	localized_args := process_args(os.args)

	for arg in localized_args {
		if arg.arg == TaskArg.a && arg.state == true {
			repo.add_task(os.args[2])!
			return
		} else if arg.arg == TaskArg.l && arg.state == true {
			tasks := repo.read_tasks()!
			ui.print_task_list(tasks)
			return
		} else if arg.arg == TaskArg.d && arg.state == true {
			task_id := os.args[2].int()
			repo.rm_task(task_id)!
			return
		} else if arg.arg == TaskArg.c && arg.state == true {
			repo.clear()!
			return
		}
	}

	ui.print_help_and_usage()
}
