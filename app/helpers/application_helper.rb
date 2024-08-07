module ApplicationHelper
  def checkbox(boolean)
    # defines an image (checkmark or empty circle) for the view according to a boolean value
    if boolean
      image_tag("black_check.png", size: "30x30")
    else
      image_tag("black_empty.png", size: "30x30")
    end
  end

  def true?(string)
    string == "true"
  end
end
