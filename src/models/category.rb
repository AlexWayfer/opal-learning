## Class for Category
class Category < Model
	attributes :id, :name

	def href
		"##{id}"
	end

	def active=(value)
		element.toggle_class 'active', value
	end
end
