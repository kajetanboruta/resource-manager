class TagFilterQuery < Patterns::Query
  include ActiveRecord::Sanitization::ClassMethods
  queries Tag

  private

  def query
    relation.where('name LIKE :name',
                   name: "%#{sanitize_sql_like(name)}%")
  end

  def name
    options.fetch(:name)
  end

  def tag_category_id
    options.fetch(:tag_category_id)
  end
end
