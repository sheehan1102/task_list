class TodoList
	attr_reader :tasks, :user

	def initialize(user)
		@user = user
		@tasks = []
		@todo_store = YAML::Store.new("./public/tasks.yml")
	end

	def add_task(task)
		@tasks << task
	end

	def delete_task(id)
		@tasks.delete_if { |task| task.id == id }
	end

	def find_task_by_id(id)
		@tasks.find { |task| task.id == id }
	end

	def sort_by_created(direction = 'ASC')
		if direction == 'ASC'
			@tasks.sort do |a, b|
				a.created_at <=> b.created_at
			end
		elsif direction == 'DESC'
			@tasks.sort do |a, b|
				b.created_at <=> a.created_at
			end
		end
				
	end

	def save
		@todo_store.transaction do
			@todo_store[@user] = @tasks
		end
	end

	def load_tasks
		file = YAML.load_file(File.join('./public/tasks.yml'))
		file[@user]
	end

	def incomplete_tasks
		@tasks.select { |task| !task.complete? }
	end
end