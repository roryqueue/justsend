defmodule ReadTracker do
  def create_pixel_path(base_path \\ ".") do
    # simply create a unique path for our new pixel
    # when that endpoint is hit, we will save the ping as an open
    # except maybe in cases when it is identifiable as google etc.
    # and then serve a 1*1 clear png
    pixel_dir <> UUID.uuid4()
  end
end