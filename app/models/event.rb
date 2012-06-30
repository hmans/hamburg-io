class Event
  include Mongoid::Document

  field :title,       type: String
  field :url,         type: String
  field :description, type: String
  field :starts_at,   type: DateTime
  field :ends_at,     type: DateTime
  field :location,    type: String
  field :verified,    type: Boolean, default: false

  attr_accessible :title, :url, :description, :starts_at, :ends_at, :location
  attr_accessible :title, :url, :description, :starts_at, :ends_at, :location, :verified, :as => :admin

  validates_presence_of :title, :url, :starts_at

  default_scope order_by(starts_at: :asc)

  scope :verified, -> { where(verified: true) }
  scope :in_the_future, -> { where(:starts_at.gt => Time.now) }
  scope :this_week, -> do
    t = Time.now
    where(:starts_at.gte => t.beginning_of_week, :starts_at.lt => t.end_of_week)
  end
  scope :next_week, -> do
    t = 1.week.from_now
    where(:starts_at.gte => t.beginning_of_week, :starts_at.lt => t.end_of_week)
  end
  scope :later, -> do
    t = 2.week.from_now
    where(:starts_at.gte => t.beginning_of_week)
  end
end
