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
end

class User
  include Mongoid::Document

  field :name,     type: String
  field :identity, type: Array
  field :admin,    type: Boolean, default: false
end
