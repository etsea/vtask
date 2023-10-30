module main

import task
import ui
import os
import v.vmod
import cli

fn main() {
	mod := vmod.decode(@VMOD_FILE) or {
		vmod.Manifest{
			name: 'vtask'
			description: 'A simple CLI task manager.'
			version: 'DEV:UNKNOWN'
		}
	}

	mut app := cli.Command{
		name: mod.name
		description: mod.description
		version: mod.version
		disable_man: true
		disable_flags: true
		sort_commands: true
	}
	mut list_cmd := cli.Command{
		name: 'list'
		description: 'Lists stored tasks.'
		execute: list_func
	}
	mut add_cmd := cli.Command{
		name: 'add'
		description: 'Adds a new task.'
		usage: '[My New Task Description]'
		required_args: 1
		execute: add_func
	}
	mut del_cmd := cli.Command{
		name: 'del'
		description: 'Deletes a task (or tasks) by ID.'
		usage: '[task_id ...]'
		required_args: 1
		execute: del_func
	}
	mut clear_cmd := cli.Command{
		name: 'clear'
		description: 'Clears all tasks from the repository.'
		execute: clear_func
	}

	app.add_commands([list_cmd, add_cmd, del_cmd, clear_cmd])
	app.setup()
	app.parse(os.args)
}

fn list_func(cmd cli.Command) ! {
	repo := task.init_task_repository()!
	tasks := repo.read_tasks()!
	ui.print_task_list(tasks)
}

fn add_func(cmd cli.Command) ! {
	task_content := cmd.args.join(' ')
	repo := task.init_task_repository()!
	repo.add_task(task_content)!
}

fn del_func(cmd cli.Command) ! {
	repo := task.init_task_repository()!
	for task_id in cmd.args {
		repo.rm_task(task_id.int())!
	}
}

fn clear_func(cmd cli.Command) ! {
	repo := task.init_task_repository()!
	repo.clear()!
}
