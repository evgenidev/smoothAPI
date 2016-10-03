# smoothPayApi.rb

require 'uri'
require 'net/http'
require 'net/https'

class SmoothPayApi

	def pay(merchant_id, token, smoothpay_amount, items)

		@merchant_id = merchant_id
		transaction_details = []
		success = true;
		
		items.each do |item|
			transaction_details << {
				:charged_price => item.price,
				:description => '',
				:name => item.name,
				:quantity => item.quantity,
				:sku => item.code,
				:category => item.category,
				:standard_price => item.price
			}
		end

		@toSend = {
			"store_id" => merchant_id,
			"token" => token,
			"total" => smoothpay_amount,
			"order_details" => transaction_details
		}.to_json

		uri = URI.parse("http://smoothpay.com/zuppler/zuppler_pay_post.php")
		https = Net::HTTP.new(uri.host,uri.port)
		https.use_ssl = true
		req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
		req.body = "[ #{@toSend} ]"

		res = https.request(req)
		if res.body.transaction_id.nil?
			success = false;
		#puts "Response #{res.code} #{res.message}: #{res.body}"

		return_info = ResponseData.new(success, res.body.result, res.body)
		return return_info
	end

	def refund(transaction_id, amount)

		success = true;
		@toSend = {
			"merchant_id" => @merchant_id,
			"refund_amount" => amount,
			"original_transaction_id" => transaction_id
		}.to_json

		uri = URI.parse("https://www.smoothpayserver.com/refund")
		https = Net::HTTP.new(uri.host,uri.port)
		https.use_ssl = true
		req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
		req.body = "[ #{@toSend} ]"

		res = https.request(req)
		if res.body.transaction_id.nil?
			success = false;
		#puts "Response #{res.code} #{res.message}: #{res.body}"

		return_info = ResponseData.new(success, res.body.result, res.body)
		return return_info
	end

end

class ResponseData
	attr_accessor :success
	attr_accessor :message
	attr_accessor :data

	def initialize(success, message, data)
		@success = success
		@message = message
		@data = data
	end
end