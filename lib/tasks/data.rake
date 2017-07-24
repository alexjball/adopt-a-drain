require 'rake'

namespace :data do
  task load_things: :environment do
    require 'thing_importer'

    ThingImporter.load('https://data.sfgov.org/api/views/jtgq-b7c5/rows.csv?accessType=DOWNLOAD')
  end

  # move adoptions to closeby things
  # useful for rectifying adoptions of inconsistencies in the dataset (things
  # that are removed during scheduled import)
  task move_close_deleted_adoptions: :environment do
    require 'adoption_mover'

    ENV['ADOPTION_DELETION_FROM'] || raise('$ADOPTION_DELETION_FROM required')
    ENV['MAXIMUM_MOVEMENT_IN_FEET'] || raise('$MAXIMUM_MOVEMENT_IN_FEET required')

    adoption_deletion_from = Time.zone.parse(ENV['ADOPTION_DELETION_FROM'])

    moved_adoptions = AdoptionMover.move_close_deleted_adoptions(adoption_deletion_from, ENV['MAXIMUM_MOVEMENT_IN_FEET'])

    CSV($stdout) do |csv|
      csv << %w[from to]
      moved_adoptions.each do |from, to|
        csv << [from, to]
      end
    end
  end

  task auto_adopt: :environment do
    # Make random users adopt drains to test server load when generating API data

    if !Rails.env.production?
      Thing.first(10_000).each do |t|
        if t.user_id.blank?
          t.user_id = User.find_by('id' => Random.rand(1..User.last.id)).id
          t.save()
        end
      end
    end
  end
end
