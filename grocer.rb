require 'pry'

def find_item_by_name_in_collection(name, collection)
  new_hash = {}
  i = 0
  while i < collection.length do 
    collection[i]
    if collection[i][:item] == name
      return collection[i]
    end
    i += 1
  end 
  #nil is implicitly applied
end

def consolidate_cart(cart)
  new_cart = []
  j = 0 
  while j < cart.length do 
    nc_item = find_item_by_name_in_collection(cart[j][:item], new_cart)
    if nc_item != nil                 #<- If the item DOES appear in my cart,                                     add 1 to its count. (it isn't nil)
      nc_item[:count] += 1
    else
      nc_item = {                     #<- this compiles new item information                                      and puts it in my cart with a count                                     of 1
        :item => cart[j][:item],
        :price => cart[j][:price],
        :clearance => cart[j][:clearance],
        :count => 1 
      }
      new_cart << nc_item
    end
    j += 1
  end
 return new_cart 
end

def apply_coupons(cart, coupons)
  k = 0 
  while k < coupons.length do 
    cart_item = find_item_by_name_in_collection(coupons[k][:item], cart)
    coupon_name = "#{coupons[k][:item]} W/COUPON"  
    cart_item_w_coupon = find_item_by_name_in_collection(coupon_name, cart)
    if cart_item && cart_item[:count] >= coupons[k][:num]
      if cart_item_w_coupon
        cart_item_w_coupon[:count] += coupons[k][:num]  
        cart_item[:count] -= coupons[k][:num]
      else
        cart_item_w_coupon = {
          :item => coupon_name, 
          :price => coupons[k][:cost] / coupons[k][:num],
          :clearance => cart_item[:clearance],
          :count => coupons[k][:num]
        }   
        cart << cart_item_w_coupon
        cart_item[:count] -= coupons[k][:num]
      end
    end
    k += 1 
  end 
  return cart
end

def apply_clearance(cart)
  l = 0 
  while l < cart.length do
    if cart[l][:clearance]
      cart[l][:price] = (cart[l][:price] - (cart[l][:price] * 0.20)).round(2)
    end
    l += 1
  end 
  return cart
end

def checkout(cart, coupons)
 consolidated_cart = consolidate_cart(cart)
 couponed_cart = apply_coupons(consolidated_cart, coupons)
 final_cart = apply_clearance(couponed_cart)
  total = 0 
  m = 0 
  while m < final_cart.length do
    total += final_cart[m][:price] * final_cart[m][:count]
    m += 1
  end
  if total > 100 
    total -= (total * 0.10) 
  end 
  return total
end
