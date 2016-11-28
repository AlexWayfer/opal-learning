require 'forwardable'
require_relative 'component'
## Base class for Collections
class Collection < Component
	ITEM_SCOPE = :item

	def self.inherited(collection)
		collection.include Enumerable
		collection.extend Forwardable
		%i(each concat unshift []).each do |method|
			collection.def_delegators :items, method, method
		end
	end

	def initialize(items)
		@items = items
	end

	def items
		@items ||= []
	end

	def element=(node)
		item_element = node.find "[data-scope=#{self.class::ITEM_SCOPE}]"
		@items.each do |item|
			item.element = item_element.clone
			node << item.element
		end
		item_element.remove
		super
	end
end
