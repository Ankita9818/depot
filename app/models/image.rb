class Image < ApplicationRecord

  attr_reader :uploaded_image

  belongs_to :product
  after_commit :upload_product_image, on: [:create, :update]
  after_destroy_commit :delete_uploaded_image

  def uploaded_image=(img_details)
    @uploaded_image = img_details
    self.filename = uploaded_image.original_filename
    self.content_type = uploaded_image.content_type
    self.filepath = Rails.root.join('public', 'uploads', filename)
  end

  def get_relative_image_path
    UPLOADS_FOLDER_NAME + product_id.to_s + "/" + filename
  end

  private

  def upload_product_image
    create_product_directory
    delete_image(filepath_previous_change.first) if filepath_previous_change.first.present?
    update_columns(filepath: directory_path + "/" + filename)
    File.open(filepath, 'wb') do |uploaded_file|
      uploaded_file.write(uploaded_image.read)
    end
  end

  def delete_uploaded_image
    delete_image(filepath)
    remove_product_directory
  end

  def delete_image(file)
    File.delete(file) if File.exist?(file)
  end

  def directory_path
    @dir_path ||= Rails.root.to_s + "/public" + UPLOADS_FOLDER_NAME + product_id.to_s
  end

  def create_product_directory
    FileUtils.mkdir_p directory_path unless File.directory?(directory_path)
  end

  def remove_product_directory
    Dir.rmdir(directory_path) if Dir.exists?(directory_path) && Dir.entries(directory_path).length <= 2
  end
end
