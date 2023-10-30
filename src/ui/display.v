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

fn get_digit_count(number int) int {
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
	max_digits := get_digit_count(high_id)

	println(tl_header)
	for _, task in tasks {
		pad_amt := max_digits - get_digit_count(task.id)
		padding := strings.repeat_string(' ', pad_amt)
		print(padding)
		println('[${task.id}] ${task.title}')
	}
	println(tl_footer)
}
