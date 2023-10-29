module task

import os
import json
import arrays

pub fn init_task_repository() !TaskRepository {
	mut file_path := os.config_dir()!
	file_path += '/vtask'
	directory_exists := os.exists(file_path)
	if !directory_exists {
		params := os.MkdirParams{}
		os.mkdir(file_path, params)!
	}
	file_path += '/vtask.json'
	file_exists := os.exists(file_path)
	if !file_exists {
		os.write_file(file_path, '[]')!
	}
	return TaskRepository{
		file_path: file_path
	}
}

pub fn (repo TaskRepository) clear() ! {
	mut repo_file := os.create(repo.file_path) or {
		return error('Could not create or open file: ${repo.file_path}')
	}
	_ = repo_file.write_string('[]')!

	repo_file.close()
}

pub fn (repo TaskRepository) read_tasks() ![]Task {
	file_contents := os.read_file(repo.file_path)!

	mut task_list := []Task{}
	if file_contents.trim_space().len == 0 {
		return task_list
	}

	task_list = json.decode([]Task, file_contents)!

	return task_list
}

fn find_next_id(tasks []Task, start_id int) int {
	if tasks.len == 0 {
		return 1
	} else {
		mut taken_ids := []int{}
		for task in tasks {
			taken_ids << task.id
		}
		old_max_id := arrays.max(taken_ids) or {
			return 1
		}
		return old_max_id + 1
	}
}

pub fn (repo TaskRepository) add_task(task_title string) ! {
	mut tasks := repo.read_tasks()!

	next_id := find_next_id(tasks, 1)

	current_task := Task{
		id: next_id
		title: task_title
	}

	tasks << current_task

	json_string := json.encode_pretty(tasks)

	mut repo_file := os.create(repo.file_path) or {
		return error('Could not create or open file: ${repo.file_path}')
	}
	_ = repo_file.write_string(json_string)!

	repo_file.close()
}

pub fn (repo TaskRepository) rm_task(rm_id int) ! {
	mut tasks := repo.read_tasks() or { panic(err) }

	for index, task in tasks {
		if task.id == rm_id {
			tasks.delete(index)
			break
		}
	}

	json_string := json.encode_pretty(tasks)

	mut repo_file := os.create(repo.file_path) or {
		return error('Could not create or open file: ${repo.file_path}')
	}

	_ = repo_file.write_string(json_string)!

	repo_file.close()
}
