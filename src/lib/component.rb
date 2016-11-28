require_relative 'bindings'
## Base class for Component
class Component
	attr_accessor :element

	def bindings
		@bindings ||= Bindings.new self
	end

	def element=(node)
		raise "Node for #{self.class} not found" if node.empty?
		@element = node
		@bindings = Bindings.new self, element
		node
	end
end
