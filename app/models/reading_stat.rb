class ReadingStat
  include Mongoid::Document
  include Mongoid::Timestamps

  field :book_id, type: Integer
  field :total_readers, type: Integer
  field :average_rating, type: Float
  field :reading_time_minutes, type: Integer
  field :completion_rate, type: Float
  
  validates :book_id, presence: true
end 