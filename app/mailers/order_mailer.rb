class OrderMailer < ApplicationMailer

  default from: 'ankitadixit.rails@gmail.com'
  def received(order)
    @order = order
    @line_items = order.line_items.includes(product: :images)

    @line_items.each do |li|
      li.product.images.each do |img|
        attachments[img.filename] = File.read(img.filepath)
      end
    end

    headers['X-SYSTEM-PROCESS-ID'] = Process.pid
    I18n.with_locale(@order.user.language) do
      mail to: order.user.email, subject: t('.subject')
    end
  end

  def shipped(order)
    @order = order
    mail to: order.email, subject: 'Pragmatic Store Order Shipped'
  end
end