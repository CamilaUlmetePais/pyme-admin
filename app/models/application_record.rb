class ApplicationRecord < ActiveRecord::Base 
  primary_abstract_class

  
  # Removes trailing zeroes from a float for cleaner display in views. 
  # 
  # @!method trim_zeroes(float)
  # @param float [Float] 
  # @return [Float] A float without zeroes after the delimiter
  # @example Clean up a float to show in views
  #   clean_float = trim_zeroes(14.0)
  #   clean_float = 14
  #   
  #   clean_float = trim_zeroes(7.50)
  #   clean_float = 7.5
  #   
  #   clean_float = trim_zeroes(2.5)
  #   clean_float = 2.5
  def trim_zeroes(float)
    float = float == float.to_i ? float.to_i : float
  end
end
