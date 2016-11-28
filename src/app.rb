require_relative 'lib/component'
require_relative 'models/categories'
require_relative 'models/category'
require_relative 'models/bookmarks'
## Class for Application
class App < Component
	attr_reader :categories, :bookmarks

	def initialize
		puts 'Wow, running opal!'
		@categories ||= Categories.new
		@categories.unshift Category.new(id: '', name: 'All')
		@bookmarks ||= Bookmarks.new
		Document.ready? do
			self.element = Element.find '[data-scope=app]'
			@categories.element = element.find '[data-scope=categories]'
			@bookmarks.element = element.find '[data-scope=bookmarks]'
		end
	end
end
