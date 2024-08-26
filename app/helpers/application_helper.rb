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
end
