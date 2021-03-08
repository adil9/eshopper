class InvoiceSerializer
  include JSONAPI::Serializer
  attributes :base_price, :delivery_charges, :tax_charges, :address_line1, :address_line2, :landmark,
             :zip_code
  has_one :invoice
end
