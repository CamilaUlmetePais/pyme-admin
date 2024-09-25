module ApplicationHelper
  # Defines an image (checkmark or empty square) for the view according to a boolean value
  # 
  # @!method checkbox(boolean)
  # @param boolean [Boolean] 
  # @return [image_tag] On <tt>true</tt>, it shows a checkmark. On <tt>false</tt>, it shows an empty box.
  def checkbox(boolean)
    if boolean
      image_tag("square_check.svg", size: "30x30")
    else
      image_tag("square_empty.svg", size: "30x30")
    end
  end

  # Changes separator and delimiter for views method number_to_currency according to locale to format currency in accordance to regional use. The decimal point is used in anglophone countries, while in Latin America and most of Europe the default is the decimal comma.  
  # 
  # @!method number_to_regional_currency(number)
  # @param number [Float] the number to format as currency
  # @return [String] a string containing the desired number formatted as currency. 
  # @example Format a number as currency according to regional convention.
  #   number = number_to_regional_currency(1234.5)
  #   
  #   "$1,234.5"  # EN locale  
  #   "$1.234,5"  # other locales  
  def number_to_regional_currency(number)
    if I18n.locale == :en
      number_to_currency(number, separator: ".", delimiter: ",") 
    else
      number_to_currency(number, separator: ",", delimiter: ".")
    end
  end

  # Removes trailing zeroes from a float for cleaner display in views. 
  # 
  # @!method trim_zeroes(float)
  # @param float [Float] 
  # @return [Float] A float without zeroes after the delimiter
  # @example Clean up a float to show in views
  #   clean_float = trim_zeroes(14.0)
  #   clean_float = 14
  # @example Clean up a float to show in views
  #   clean_float = trim_zeroes(7.50)
  #   clean_float = 7.5
  # @example Clean up a float to show in views
  #   clean_float = trim_zeroes(2.5)
  #   clean_float = 2.5
  def trim_zeroes(float)
    float = float == float.to_i ? float.to_i : float
  end
 
end
