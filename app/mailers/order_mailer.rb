class OrderMailer < ApplicationMailer
  before_action { headers['X-SYSTEM-PROCESS-ID'] = Process.pid }

  default from: 'ankitadixit.rails@gmail.com'
  def received(order)
    @order = order
    @line_items = order.line_items.includes(product: :images)

    add_attachments(@line_items)

    I18n.with_locale(LANGUAGE_LOCALE[@order.user.language]) do
      mail to: order.user.email, subject: t('.subject')
    end
  end

  def shipped(order)
    @order = order
    mail to: order.email, subject: 'Pragmatic Store Order Shipped'
  end

  private def add_attachments(line_items)
    line_items.each do |li|
      li.product.images.each_with_index do |img, index|
        if index == 0
          attachments.inline[img.filename] = File.read(img.filepath)
        else
          attachments[img.filename] = File.read(img.filepath)
        end
      end
    end
  end
end
