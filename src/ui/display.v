module ui

import task
import term
import strings
import v.pref

fn get_highest_id(tasks []task.Task) int {
	mut highest_id := 0
	for _, task in tasks {
		if task.id > highest_id {
			highest_id = task.id
		}
	}

	return highest_id
}

fn get_no_digits(number int) int {
	mut testing := number
	mut digit_count := 0
	for testing > 0 {
		testing /= 10
		digit_count++
	}

	return digit_count
}

pub fn print_task_list(tasks []task.Task) {
	tl_header := term.header_left('TASK LIST', '=')
	tl_footer := term.h_divider('=')

	high_id := get_highest_id(tasks)
	max_digits := get_no_digits(high_id)

	println(tl_header)
	for _, task in tasks {
		pad_amt := max_digits - get_no_digits(task.id)
		padding := strings.repeat_string(' ', pad_amt)
		print(padding)
		println('[${task.id}] ${task.title}')
	}
	println(tl_footer)
}

pub fn print_help_and_usage() {
    println('VTASK - A Simple Task Management CLI')
    println('Usage:')

    is_windows := if pref.get_host_os() == pref.OS.windows { true } else { false }
    prefix := if is_windows { '/' } else { '-' }

    println('${prefix}a <task_name>   : Add a new task with the provided name.')
    println('${prefix}l               : List all the tasks.')
    println('${prefix}d <task_id>     : Delete a task with the provided ID.')
    println('${prefix}c               : Clear all tasks.')

    println('\nExamples:')
    println('vtask ${prefix}a "Buy groceries"        : Adds a new task titled "Buy groceries".')
    println('vtask ${prefix}l                        : Lists all the tasks.')
    println('vtask ${prefix}d 3                      : Deletes the task with ID 3.')
    println('vtask ${prefix}c                        : Clears all tasks from the list.')

    println('\nNote: Ensure to provide the correct task ID when using the delete (d) option.\nIncorrect ID will result in no action.')
}
