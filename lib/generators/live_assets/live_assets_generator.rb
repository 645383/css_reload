class LiveAssetsGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates", __FILE__)

  def copy_initializer_file
    copy_file "live_assets.js", "app/assets/javascripts/live_assets/live_assets.js"
    copy_file "live_assets_helper.rb", "app/helpers/live_assets_helper.rb"
    copy_file "live_assets_controller.rb", "app/controllers/live_assets/live_assets_controller.rb"
  end

  def gsub_manifests
    gsub_file 'app/assets/javascripts/application.js', /\/\= require.+/ do |match|
      "#{match}\n//= require live_assets/live_assets"
    end

    gsub_file 'app/views/layouts/application.html.erb', /javascript_include_tag.+/ do |match|
      "#{match}\n  <%= live_assets if Rails.env.development? %>"
    end

    gsub_file 'config/routes.rb', /Rails\.application\.routes\.draw do/ do |match|
      <<ROUTE
#{match}\n\n
  scope module: 'live_assets' do
    get 'live_assets/sse'
  end
ROUTE
    end

    gsub_file 'config/application.rb', /class Application < Rails::Application/ do |match|
      "#{match}\n    config.allow_concurrency = true"
    end
  end

  private

  def gsub_file(path, flag, *args, &block)
    return unless behavior == :invoke
    config = args.last.is_a?(Hash) ? args.pop : {}

    path = File.expand_path(path, destination_root)
    say_status :gsub, relative_to_original_destination_root(path), config.fetch(:verbose, true)

    unless options[:pretend]
      content = File.binread(path)
      content.sub!(flag, *args, &block) # use sub! instead of original gsub!
      File.open(path, 'wb') { |file| file.write(content) }
    end
  end
end