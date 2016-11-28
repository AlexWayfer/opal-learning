require_relative 'component'
## Base class for Models
class Model < Component
	class << self
		def attributes(*attrs)
			attrs.each { |attribute| define_attribute attribute }
		end

		private

		def define_attribute(attribute)
			attr_reader attribute
			define_method "#{attribute}=" do |value|
				instance_variable_set "@#{attribute}", value
				bindings[attribute].each do |node, (field, *args)|
					node.send field, *args, send(attribute)
				end
				value
			end
		end
	end

	def initialize(attrs)
		attrs.each { |key, value| send "#{key}=", value }
	end

	def element=(value)
		super
		bindings.each do |method, (node, field, *args)|
			next unless node
			node.send field, *args, send(method)
		end
	end
end
