class Image < ApplicationRecord

  belongs_to :product
  after_commit :upload_product_image, on: [:create, :update]
  after_destroy_commit :delete_uploaded_image

  def uploaded_image=(img_details)
    @uploaded_image = img_details
    self.filename = @uploaded_image.original_filename
    self.content_type = @uploaded_image.content_type
    self.filepath = Rails.root.join('public', 'uploads', filename)
  end

  def get_relative_image_path
    UPLOADS_FOLDER_NAME + product.id.to_s + "/" + filename
  end

  private

  def upload_product_image
    dir = directory_path
    create_product_directory(dir)
    update_columns(filepath: dir + "/" + filename)
    File.open(filepath, 'wb') do |uploaded_file|
      uploaded_file.write(@uploaded_image.read)
    end
  end

  def delete_uploaded_image
    dir = directory_path
    File.delete(filepath) if File.exist?(filepath)
    remove_product_directory(dir)
  end

  def directory_path
    "#{Rails.root}/public/uploads/#{product.id}"
  end

  def create_product_directory(dir)
    FileUtils.mkdir_p dir unless File.directory?(dir)
  end

  def remove_product_directory(dir)
    Dir.rmdir(dir) unless Dir.exists?(dir) && Dir.entries(dir).length > 2
  end
end
