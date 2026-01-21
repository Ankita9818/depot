class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ IMAGE_URL_REGEX
      record.errors.add(attribute, :has_invalid_format)
    end
  end
end
