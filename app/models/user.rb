class User < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  acts_as_messageable
  acts_as_follower
  acts_as_followable
  ratyrate_rater
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :lockable, :trackable, :validatable, :omniauthable
  validates :name, presence: true

  validates_format_of :email, :without => TEMP_EMAIL_REGEX, on: :update

  before_create :add_to_list

  has_attached_file :avatar, :styles => { :medium => "350x200#",
                                          :thumb => "260x150#",
                                          :mini => "52x30#" },
                             :convert_options => {
                                          :medium => "-quality 75 -strip",
                                          :thumb => "-quality 75 -strip",
                                          :mini => "-quality 75 -strip" },
                             :default_url => "https://s3.amazonaws.com/valiantdb/images/noimage.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  belongs_to :level
  has_many :events, :dependent => :destroy
  has_many :wishes, :dependent => :destroy
  has_many :wished_books, :through => :wishes, source: :book, :dependent => :destroy
  has_many :owns, :dependent => :destroy
  has_many :owned_books, :through => :owns, source: :book, :dependent => :destroy
  has_many :sales, :dependent => :destroy
  has_many :forsale_books, :through => :sales, source: :book, :dependent => :destroy
  has_many :itemwishes, :dependent => :destroy
  has_many :wished_collectibles, :through => :itemwishes, source: :collectible, :dependent => :destroy
  has_many :itemowns, :dependent => :destroy
  has_many :owned_collectibles, :through => :itemowns, source: :collectible, :dependent => :destroy
  has_many :itemsales, :dependent => :destroy
  has_many :forsale_collectibles, :through => :itemsales, source: :collectible, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :pollvotes, dependent: :destroy
  has_many :pollvote_options, through: :pollvotes
  has_many :booksubs, :dependent => :destroy

  def add_to_list
    if Rails.env.production?
      list_id = ENV["MAILCHIMP_LIST"]
      @gb = Gibbon::Request.new
      subscribe = @gb.lists(list_id).members.create(body: {email_address: self.email, status: "subscribed", double_optin: false})
      # Do something with subscription errors here
    end
  end

  def online?
  	updated_at > 10.minutes.ago
  end

  def should_generate_new_friendly_id?
    slug.nil? || name_changed?
  end

  def wishes?(book)
  	book.wishes.where(user_id: id).any?
  end

  def itemwishes?(collectible)
    collectible.itemwishes.where(user_id: id).any?
  end

  def owns?(book)
  	book.owns.where(user_id: id).any?
  end

  def itemowns?(collectible)
    collectible.itemowns.where(user_id: id).any?
  end

  def sales?(book)
    book.sales.where(user_id: id).any?
  end

  def itemsales?(collectible)
    collectible.itemsales.where(user_id: id).any?
  end

  def rank
    User.where("owns_count > ?", owns_count).count + 1
  end

  def points_rank
    User.where("score > ?", score).count + 1
  end

  def pollvoted_for?(poll)
    pollvotes.any? {|v| v.pollvote_option.poll == poll }
  end

  def mailboxer_name
    self.name
  end

  def mailboxer_email(object)
    self.email
  end

  def self.to_csv
    attributes = %w{id name email created_at owned_books wished_books ratings_given}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |user|
        csv << user.attributes.values_at(*attributes)
      end
    end
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
      email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
      email = auth.info.email if email_is_verified
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          name: auth.extra.raw_info.name,
          #username: auth.info.nickname || auth.uid,
          avatar: auth.extra.info.image,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end

  def add_points(new_points, event_string)
    update_score_and_level(new_points)
    log_event(new_points, event_string)
  end

  def deduct_points(points_to_deduct, event_string)
    add_points(-points_to_deduct, event_string)
  end

  private
    def update_score_and_level(new_points)
      new_score = self.score += new_points
      self.update_attribute(:score, new_score)

      new_level = Level.find_level_for_score(new_score)
      if new_level && (!self.level || new_level.number > self.level.number)
        self.update_attribute(:level_id, new_level.id)
      end
    end

    def log_event(points, text)
      events.create(:points => points, :text => text)
    end
end
