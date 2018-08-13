class Quote
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  belongs_to :search, index: true

  field :quote, type: String
  field :author, type: String
  field :author_about, type: String
  field :tags, type: Array

  def as_json(options={})
    super(except: [:'_id', :search_id])
  end
end
