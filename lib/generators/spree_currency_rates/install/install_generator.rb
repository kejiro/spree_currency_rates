module SpreeCurrencyRates
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :auto_run_migrations, type: :boolean, default: false
      source_root File.expand_path('templates', __dir__)

      def add_javascripts
        append_file 'vendor/assets/javascripts/spree/backend/all.js', "//= require spree/backend/spree_currency_rates\n"
      end

      def add_stylesheets
        inject_into_file 'vendor/assets/stylesheets/spree/backend/all.css', " *= require spree/backend/spree_currency_rates\n", before: %r{\*\/}, verbose: true
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_currency_rates'
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask('Would you like to run the migrations now? [Y/n]'))
        if run_migrations
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end

      def add_files
        template 'config/initializers/spree_currency_rates.rb', 'config/initializers/spree_currency_rates.rb'
      end

    end
  end
end
