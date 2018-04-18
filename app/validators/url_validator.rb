class UrlValidator < ActiveModel::EachValidator
  URL_REGEX = /\.(gif|jpg|png)\Z/i
  def validate_each(record, attribute, value)
    unless value =~ URL_REGEX
      record.errors[attribute] << (options[:message] || "must be a URL for GIF, JPG or PNG image.")
    end
  end
end