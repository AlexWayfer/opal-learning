## Class for Category
class Categories < Collection
	attr_accessor :current

	def current=(category)
		@current.active = false if @current
		category.active = true
		@current = category
	end

	def select(event)
		node = event.target.closest('[data-scope="item"]')
		return if node.empty?
		category = @items.find { |item| item.id == node.data('id') }
		self.current = category
	end
end
