class ProductMailer < ApplicationMailer
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.product_mailer.in_stock.subject
  #
  def in_stock
    @product = params[:product]

    mail to: params[:subscriber].email, subject: "In stock"
  end
end
