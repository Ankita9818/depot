class Image < ApplicationRecord

  RELATIVE_DIRECTORY_PATH = '/images/'

  attr_reader :uploaded_image

  belongs_to :product
  before_save :set_filepath
  before_create :create_product_directory
  after_commit :upload_image_to_filesystem, on: [:create, :update]
  after_update_commit :remove_previous_image_from_filesystem
  after_destroy_commit :delete_uploaded_image

  def uploaded_image=(img_details)
    @uploaded_image = img_details
    self.filename = uploaded_image.original_filename
    self.content_type = uploaded_image.content_type
  end

  private

  def set_filepath
    self.filepath = Rails.root.join('public', 'images', product_id.to_s, filename)
    self.relative_filepath = RELATIVE_DIRECTORY_PATH + product_id.to_s + '/' + filename
  end

  def upload_image_to_filesystem
    File.open(filepath, 'wb') do |uploaded_file|
      uploaded_file.write(uploaded_image.read)
    end
  end

  def remove_previous_image_from_filesystem
    delete_image_from_filesystem(filepath_previous_change.first) if filepath_previous_change.first.present?
  end

  def delete_uploaded_image
    delete_image_from_filesystem(filepath)
    remove_product_directory
  end

  def delete_image_from_filesystem(file)
    File.delete(file) if File.exist?(file)
  end

  def directory_path
    File.dirname(filepath)
  end

  def create_product_directory
    Dir.mkdir directory_path unless Dir.exists?(directory_path)
  end

  def remove_product_directory
    Dir.rmdir(directory_path) if Dir.exists?(directory_path) && Dir.empty?(directory_path)
  end
end
