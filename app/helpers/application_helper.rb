module ApplicationHelper
  def checkbox(boolean)
    # defines an image (checkmark or empty square) for the view according to a boolean value
    if boolean
      image_tag("square_check.svg", size: "30x30")
    else
      image_tag("square_empty.svg", size: "30x30")
    end
  end

  def trim_zeroes(float)
    # removes trailing zeroes from a float. 14.5 -> 14.5 || 14.0 -> 14
    float = float == float.to_i ? float.to_i : float
  end

  def number_to_currency_ars(number)
    # changes separator and delimiter for views method number_to_currency according to locale to format currency in accordance to regional use
    if I18n.locale == :es
      number_to_currency(number, separator: ",", delimiter: ".") 
    else
      number_to_currency(number, separator: ".", delimiter: ",") 
    end
  end
end
