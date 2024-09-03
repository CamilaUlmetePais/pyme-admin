module ApplicationHelper
  def checkbox(boolean)
    # defines an image (checkmark or empty circle) for the view according to a boolean value
    if boolean
      image_tag("square_check.svg", size: "30x30")
    else
      image_tag("square_empty.svg", size: "30x30")
    end
  end

  def true?(string)
    string == "true"
  end

  def trim_zeroes(float)
    # removes trailing zeroes from a float. 14.5 -> 14.5 || 14.0 -> 14
    float = float == float.to_i ? float.to_i : float
  end
end
