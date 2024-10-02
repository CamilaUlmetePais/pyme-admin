FactoryBot.define do
  factory :product do
    name { "Apple pie" }
    price { 15 }
    unit { "u" }
    stock { 5 }
    notification_threshold {}
  end

  factory :supply do
    name { "Flour" }
    price { 10 }
    unit { "kg" }
    stock { "60" }
  end

  factory :supply_product_link do
    supply
    product
  end
  
  factory :supplier do
    name { "John" }
    account_balance { 0 }
    notification_threshold { -1000 }
  end
  
  factory :inflow_item do
    quantity { 3.5 }
    product
  end

  factory :inflow do
    total { 350 }
    payment_method { "cash" }
    inflow_item
  end

  factory :outflow_item do
    quantity { 5 }
    supply
  end

  factory :outflow do
    total { 10000 }
    paid { 10000 }
    payment_method { "debit" }
    supplier
    outflow_item
  end

  factory :notification do
    title { "test notification" }
    text { "test notification text" }
  end
  
  factory :reminder do
    title { "Pastry order for John Doe" }
    text { "John Doe ordered three apple pies, 15 cherry turnovers and 15 chocolate éclairs." }
    done { false }
    due_date { DateTime.now + 5.days }
  end
end