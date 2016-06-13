namespace :db do
  desc "VEI Maintenance"
  task :maintainvei => :environment do
  	Book.where(:title => "Archer & Armstrong").where("rdate > ?", "2012-05-01").each do |a|
  		a.update_attribute :letters, 'Dave Lanphear'
  	end
  	Book.where("title like ?", "%Armor Hunters").where("rdate > ?", "2012-05-01").each do |b|
  		b.update_attribute :letters, 'Dave Sharpe'
  	end
  	Book.where(:title => "Bloodshot").where("rdate > ?", "2012-05-01").each do |c|
  		c.update_attribute :letters, 'Rob Steen'
  	end
  	Book.where(:title => "Bloodshot Reborn").each do |d|
  		d.update_attribute :letters, 'Dave Lanphear'
  	end
  	Book.where("title like ?", "%Book of Death%").each do |e|
  		e.update_attribute :letters, 'Dave Lanphear'
  	end
  	Book.where(:title => "Dead Drop").each do |f|
  		f.update_attribute :letters, 'Dave Lanphear'
  	end
  	Book.where(:title => "Divinity").each do |g|
  		g.update_attribute :letters, 'Dave Lanphear'
  	end
  	Book.where("title like ?", "Mirage").where("rdate > ?", "2012-05-01").each do |h|
  		h.update_attribute :letters, 'Dave Lanphear'
  	end
  	Book.where("title like ?", "Delinquents").each do |i|
  		i.update_attribute :letters, 'Dave Sharpe'
  	end
  	Book.where(:title => "Eternal Warrior").where("rdate > ?", "2012-05-01").each do |j|
  		j.update_attribute :letters, 'Dave Sharpe'
  	end
  	Book.where(:title => "Eternal Warrior: Days of Steel").each do |k|
  		k.update_attribute :letters, 'Dave Sharpe'
  	end
  	Book.where("title like ?", "Harbinger").where("rdate > ?", "2012-05-01").each do |l|
  		l.update_attribute :letters, 'Dave Sharpe'
  	end
    Book.where(:title => "Imperium").each do |m|
     	m.update_attribute :letters, 'Dave Sharpe'
    end
    Book.where(:title => "Ivar, Timewalker").each do |n|
      	n.update_attribute :letters, 'Dave Sharpe'
    end
    Book.where(:title => "Ninjak").where("rdate > ?", "2012-05-01").each do |o|
    	o.update_attribute :letters, 'Dave Sharpe'
    end
    Book.where("title like ?", "%Quantum%").where("rdate > ?", "2012-05-01").each do |p|
    	p.update_attribute :letters, 'Dave Lanphear'
    end
    Book.where(:title => "Rai").where("rdate > ?", "2012-05-01").each do |q|
    	q.update_attribute :letters, 'Dave Lanphear'
    end
    Book.where(:title => "Shadowman").where("issue < ?", "9").where("rdate > ?", "2012-05-01").each do |r|
    	r.update_attribute :letters, 'Rob Steen'
    end
    Book.where(:title => "Unity").where("rdate > ?", "2012-05-01").each do |s|
    	s.update_attribute :letters, 'Dave Sharpe'
    end
    Book.where(:title => "The Valiant").each do |t|
    	t.update_attribute :letters, 'Dave Lanphear'
    end
    Book.where(:title => "X-O Manowar").where("rdate > ?", "2012-05-01").each do |u|
    	u.update_attribute :letters, 'Dave Sharpe'
    end
    Book.where(:title => "Punk Mambo").each do |v|
      v.update_attribute :letters, 'Dave Lanphear'
    end
  end
end