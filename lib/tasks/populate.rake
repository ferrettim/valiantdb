namespace :db do
  desc "Populate database with books"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    [Book].each
    
      Book.populate 10..100 do |product|
        product.title = Populator.words(1..5).titleize
        product.writer = Populator.words(2).titleize
        product.artist = Populator.words(2).titleize
        product.cover = Populator.words(2).titleize
        product.summary = Populator.sentences(2..10)
        product.pricenm = [5, 20, 100]
        product.rdate = 2.years.ago..Time.now
        product.created_at = 2.years.ago..Time.now
      end
    end
  end