class LiveAssetsGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates", __FILE__)

  def copy_initializer_file
    copy_file "live_assets.js", "app/assets/javascripts/live_assets.js"
    copy_file "live_assets_helper.rb", "app/helpers/live_assets_helper.rb"
    copy_file "live_assets_controller.rb", "app/controllers/live_assets_controller.rb"
  end

  def gsub_manifests
    gsub_file 'app/views/layouts/application.html.erb', /javascript_include_tag.+/ do |match|
      "#{match}\n  <%= live_assets if Rails.env.development? %>"
    end

    gsub_file 'config/routes.rb', /\.application\.routes\.draw.+/ do |match|
      "#{match}\n\n  get 'live_assets/sse'"
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
      content.sub!(flag, *args, &block)                                             # use sub! instead of original gsub!
      File.open(path, 'wb') { |file| file.write(content) }
    end
  end
end