module ApplicationHelper
  def checkbox(boolean)
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
