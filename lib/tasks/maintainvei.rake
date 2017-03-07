namespace :db do
  desc "VEI Maintenance"
  task :maintainvei => :environment do
  	Comment.where("content like ?", "%CGC%").each do |a|
  		a.update_attribute :grader, 'CGC'
  	end
    Comment.where("content like ?", "%CBCS%").each do |a|
      a.update_attribute :grader, 'CBCS'
    end
    Comment.where("content like ?", "%PGX%").each do |a|
      a.update_attribute :grader, 'PGX'
    end
    Comment.where("content like ?", "%10.0%").each do |a|
  		a.update_attribute :cgcgrade, '10.0'
  	end
    Comment.where("content like ?", "%9.9%").each do |a|
  		a.update_attribute :cgcgrade, '9.9'
  	end
    Comment.where("content like ?", "%9.8%").each do |a|
  		a.update_attribute :cgcgrade, '9.8'
  	end
    Comment.where("content like ?", "%9.7%").each do |a|
  		a.update_attribute :cgcgrade, '9.7'
  	end
    Comment.where("content like ?", "%9.6%").each do |a|
  		a.update_attribute :cgcgrade, '9.6'
  	end
    Comment.where("content like ?", "%9.5%").each do |a|
  		a.update_attribute :cgcgrade, '9.5'
  	end
    Comment.where("content like ?", "%9.4%").each do |a|
  		a.update_attribute :cgcgrade, '9.4'
  	end
    Comment.where("content like ?", "%9.3%").each do |a|
  		a.update_attribute :cgcgrade, '9.3'
  	end
    Comment.where("content like ?", "%9.2%").each do |a|
  		a.update_attribute :cgcgrade, '9.2'
  	end
    Comment.where("content like ?", "%9.1%").each do |a|
  		a.update_attribute :cgcgrade, '9.1'
  	end
    Comment.where("content like ?", "%9.0%").each do |a|
  		a.update_attribute :cgcgrade, '9.0'
  	end
    Comment.where("content like ?", "%8.9%").each do |a|
  		a.update_attribute :cgcgrade, '8.9'
  	end
    Comment.where("content like ?", "%8.8%").each do |a|
  		a.update_attribute :cgcgrade, '8.8'
  	end
    Comment.where("content like ?", "%8.7%").each do |a|
  		a.update_attribute :cgcgrade, '8.7'
  	end
    Comment.where("content like ?", "%8.6%").each do |a|
  		a.update_attribute :cgcgrade, '8.6'
  	end
    Comment.where("content like ?", "%8.5%").each do |a|
  		a.update_attribute :cgcgrade, '8.5'
  	end
    Comment.where("content like ?", "%8.4%").each do |a|
  		a.update_attribute :cgcgrade, '8.4'
  	end
    Comment.where("content like ?", "%8.3%").each do |a|
  		a.update_attribute :cgcgrade, '8.3'
  	end
    Comment.where("content like ?", "%8.2%").each do |a|
  		a.update_attribute :cgcgrade, '8.2'
  	end
    Comment.where("content like ?", "%8.1%").each do |a|
  		a.update_attribute :cgcgrade, '8.1'
  	end
    Comment.where("content like ?", "%8.0%").each do |a|
  		a.update_attribute :cgcgrade, '8.0'
  	end
    Comment.where("content like ?", "%SS%").each do |a|
  		a.update_attribute :signature, true
  	end
    Comment.where("content like ?", "%Signature Series%").each do |a|
  		a.update_attribute :signature, true
  	end
  end
end
