class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ IMAGE_URL_REGEX
      record.errors[attribute] << (options[:message] || I18n.t('.errors.messages.invalid_url'))
    end
  end
end
