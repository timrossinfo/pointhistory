namespace :epub do
  task generate: :environment do
    EpubBuilder.new.build
  end
end
