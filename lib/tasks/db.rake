namespace :db do
  task migrate: :environment do
    migrations_paths = [ Application.configuration.database_migrations_path ]

    migration_context = ActiveRecord::MigrationContext.new(
      migrations_paths,
      ActiveRecord::Base.connection.schema_migration
    )
    migration_context.migrate

    Rake::Task["db:schema:dump"].invoke
  end

  task rollback: :environment do
    migrations_paths = [ Application.configuration.database_migrations_path ]

    migration_context = ActiveRecord::MigrationContext.new(
      migrations_paths,
      ActiveRecord::Base.connection.schema_migration
    )
    migration_context.rollback

    Rake::Task["db:schema:dump"].invoke
  end

  namespace :schema do
    task dump: :environment do
      require 'active_record/schema_dumper'

      File.open(Application.configuration.database_schema_path, "w:utf-8") do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end
  end
end
