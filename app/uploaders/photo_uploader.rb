class PhotoUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  def store_photo!
    raise
  end
  # Remove everything else
end
