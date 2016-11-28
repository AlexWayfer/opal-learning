require 'opal'
require_relative 'lib/jquery-3.1.1.min'
require 'opal-jquery'
require 'json'
require_relative 'lib/model'
require_relative 'lib/collection'
require_relative 'app'

app = App.new

## Development
require_relative 'data'
require_relative 'models/bookmark'
require_relative 'models/category'
data = JSON.parse(DATA)
app.bookmarks.concat(
	data['bookmarks'].map { |bookmark| Bookmark.new(bookmark) }
)
app.categories.concat(
	data['categories'].map { |category| Category.new(category) }
)

do_later = $$[:setTimeout]

do_later.call lambda {
	app.categories[2].name = 'Hui'
	puts 'Hui setted'
}, 2000

# require 'template'
# require 'views/app'
#
# template = Template['views/app']
#
# puts template.render
