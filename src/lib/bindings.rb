require 'forwardable'
require 'set'
## Class for Node bindings
class Bindings
	include Enumerable
	extend Forwardable

	def_delegators :@binds, :each, :each

	def initialize(model, node = nil, root_node = node)
		@model = model
		@binds = {}
		return unless node
		@node = node
		return if !node.is_a?(Element) || node.data('scope') && node != root_node
		bind_text
		bind_attrs
		bind_events
		# @node.remove_attribute('data-scope')
		node.children.each { |child| merge self.class.new @model, child, root_node }
	end

	def [](key)
		return [] if key.nil?
		@binds[key] ||= []
	end

	def each
		@binds.each do |key, args|
			yield(key, *args)
		end
	end

	def merge(bindings)
		return unless bindings.is_a? Bindings
		bindings.each do |key, value|
			self[key] << value
		end
	end

	private

	def bind_text
		self[@node.data('text')] << [@node, :text]
	end

	def bind_attrs
		@node.data.each do |key, value|
			key_parts = key.gsub(/([a-z])([A-Z])/, '\1-\2').downcase.split('-')
			next unless key_parts.first == 'attr'
			self[value] << [@node, :attr, key_parts[1..-1].join('-')]
		end
	end

	def bind_events
		@node.data.each do |key, value|
			key_parts = key.gsub(/([a-z])([A-Z])/, '\1-\2').downcase.split('-')
			next unless key_parts.first == 'event'
			@node.on key_parts.last do |event|
				@model.send value, event
			end
		end
	end
end
