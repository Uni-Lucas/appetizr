require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Appetizr
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets tasks))

    config.action_view.field_error_proc = Proc.new { |html_tag, instance| 
      html_tag
    }
    config.exceptions_app = self.routes
    config.action_dispatch.show_exceptions = true

    config.promoted_restaurant = 41
    config.EINAEATS_WEB = "https://www.einaeats.com"
    config.EINAEATS_GO_TO_RESTAURANT = "https://www.einaeats.com/platosrestaurantes"
    config.EINAEATS_LOGIN = "https://www.einaeats.com/login"
    config.EINAEATS_GET_ALL_DISHES_FROM_RESTAURANT = "https://www.einaeats.com/api/v1/dishes"
    config.EINAEATS_GET_ALL_RESTAURANTS = "https://www.einaeats.com/api/v1/restaurants"

    config.APPETIZR_API = "https://apikoitz-c07343faff5f.herokuapp.com"
    
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
