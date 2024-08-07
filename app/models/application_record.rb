class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def trim_zeroes(float)
    # removes trailing zeroes. 14.5 -> 14.5 || 14.0 -> 14
    float = float == float.to_i ? float.to_i : float
  end
end
