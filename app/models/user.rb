class User
  include Mongoid::Document

  field :name,     type: String
  field :identity, type: Array
  field :admin,    type: Boolean, default: false
end
