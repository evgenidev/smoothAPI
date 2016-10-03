# spec/model/smoothPayApi_spec.rb

# require 'smoothPayApi'

describe "smoothPayApi" do
	describe "#pay" do
		it "gets a response from pay" do
			VCR.use_cassette 'api_pay_example' do

				return_info = pay(1, '973681f0bfe00bd4e48af6c76a01e294', 39, [{"id" => 1, "name" => 'margherita', "price" => 9.99, "quantity" => 1, "category" => 'pizzas', "code" => 'abcd'}, {"id" => 2, "name" => 'alex', "price" => 3.99, "quantity" => 3, "category" => 'pizzas', "code" => 'abcd'}])
				return_info.success.should == true;

			end
		end
	end
	describe "#refund" do
		it "gets a response from refund" do
			VCR.use_cassette 'api_refund_example' do

				return_info = refund("example transaction id", 39)
				return_info.message.should == 'transaction failed';

			end
		end
	end
end