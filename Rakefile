namespace :build do
	task :require do
		require 'bundler'
		Bundler.require

		SRC_DIR = 'src'
		PUBLIC_DIR = 'public'

		@logger = Logger.new($stdout)
	end

	task scripts: [:require] do
		system 'bundle check || bundle install'

		require 'opal/util'

		OPAL_SRC = SRC_DIR
		OPAL_ENTRY = 'main'
		OPAL_OUTPUT = File.join PUBLIC_DIR, 'scripts', 'main.js'

		@logger.info "Building #{OPAL_ENTRY}.js from ./#{OPAL_SRC}" \
			" to #{OPAL_OUTPUT}..."

		Opal.append_path OPAL_SRC
		js = Opal::Builder.build(OPAL_ENTRY).to_s
		# js = Opal::Util.uglify js
		File.binwrite OPAL_OUTPUT, js
	end

	task styles: [:require] do
		require 'sass/plugin'

		SASS_DIR = File.join SRC_DIR, 'styles'
		CSS_DIR = File.join PUBLIC_DIR, 'styles'

		compiler = Sass::Plugin::Compiler.new(
			template_location: SASS_DIR,
			css_location: CSS_DIR
		)

		@logger.info "Compiling ./#{SASS_DIR} to ./#{CSS_DIR}"

		compiler.update_stylesheets
	end

	task views: [:require] do
		require 'erb'

		def render(template)
			file = Dir[File.join(__dir__, VIEWS_DIR, "#{template}.*")].first
			ERB.new(File.read(file)).result
		end

		VIEWS_DIR = File.join SRC_DIR, 'views'
		VIEWS_ENTRY = Dir[File.join VIEWS_DIR, 'index.*'].first
		VIEWS_OUTPUT = File.join PUBLIC_DIR, 'index.html'

		@logger.info "Building #{File.basename(VIEWS_ENTRY)} from ./#{VIEWS_DIR}" \
			" to #{VIEWS_OUTPUT}..."

		File.write VIEWS_OUTPUT, render(File.basename(VIEWS_ENTRY, '.*'))
	end

	task all: [:scripts, :styles, :views]

	task :watch do
		BUILDERS = {
			scripts: '{Gemfile,Rakefile,src/**/*.rb}',
			styles: 'src/**/*.scss',
			views: 'src/**/*.erb'
		}.freeze
		WATHCER = proc do |command, pattern|
			"filewatcher -d '#{pattern}' 'rake build:#{command}'"
		end
		# pattern = '{Gemfile,Rakefile,src/**/*.{rb,erb,scss}}'
		system BUILDERS.map(&WATHCER).join(' & ')
	end
end
