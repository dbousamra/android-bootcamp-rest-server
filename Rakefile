task :environment do
  require './app'
end

desc "Run those specs"
task :spec do
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = %w{--colour --format documentation}
  end
end

namespace :db do
  desc "Drop db data"
  task :drop => :environment do
    Treasure.destroy_all
  end

  desc "Seed db data"
  task :seed => :environment do
    require 'faker'

    if Treasure.count == 0 
      Dir.glob('public/images/*.jpg') do |image_url|
        Treasure.create!(name: File.basename(image_url, ".*"), url: image_url)
      end
    end

    if Player.count == 0 
      10.times do
        Player.create!(name: Faker::Name.name)
      end
    end
  end
end
