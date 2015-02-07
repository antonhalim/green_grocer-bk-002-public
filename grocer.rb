require 'pry'
require 'pry-nav'
def consolidate_cart(cart:[])
    foodhash = {}
    ## cart.each_with_objec({}) do |carthash, new_cart_hash|
    cart.each do |food|
      #cart is the array food = each index in array {"tempeh"=>}
      food.each do |food_name, attribute_hash|
        #food_name = "TEMPEH" attribute_hash = ":price"
          foodhash[food_name] ||= attribute_hash
          foodhash[food_name][:count] ||= 0
          foodhash[food_name][:count] +=1 
      end
    end  
  foodhash
end

def apply_coupons(cart:[], coupons:[])
    coupons.each do |coupon_hash|
      # coupon [{:item => "AVOCADO", :num => 2, :cost => 5.0}]
      coupon_hash.each do |coupon_keys, coupon_values|
        # :item, :num, :cost ---- #"AVOCADO", 2, 5.0
        if cart.keys.include?(coupon_values) && coupon_hash[:num] <= cart[coupon_values][:count]
            cart[coupon_values][:count] -= coupon_hash[:num]
            cart[coupon_values + " W/COUPON"] ||= {}
            cart[coupon_values + " W/COUPON"][:price] = coupon_hash[:cost]
            cart[coupon_values + " W/COUPON"][:clearance] = cart[coupon_values][:clearance]
            cart[coupon_values + " W/COUPON"][:count]||= 0
            cart[coupon_values + " W/COUPON"][:count] += 1
        end
      end
    end
    cart
end

def apply_clearance(cart:[])
    cart.each do |item, value|
      #"TEMPEH"  ---- #{:price => 3.0}
      if value[:clearance]
        value[:price] = (value[:price] * 0.8).round(2)
      end
    end
end

def checkout(cart: [], coupons: [])
    total = 0
    each = 0
    consolidated = consolidate_cart(cart: cart)
    couponed = apply_coupons(cart: consolidated, coupons: coupons)
    clearanced = apply_clearance(cart: couponed)
    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    clearanced.each do |item_array|
      total += item_array[1][:price]*item_array[1][:count]
      # binding.pry
    end

    if total > 100
      (total*0.9).round(2)
    else
      total.round(2)
    end
end