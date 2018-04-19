class DiscountValidator < ActiveModel::Validator
  def validate(record)
    if record.price.present? && record.discount_price.present? && (record.price < record.discount_price)
      record.errors[:price] << ' must be greator than discount price'
    end
  end
end