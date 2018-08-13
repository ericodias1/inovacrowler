class Search
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  field :term, type: String

  has_many :quotes

  def as_json(options={})
    super(except: [:'_id'])
  end
end
