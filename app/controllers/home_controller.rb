class HomeController < ApplicationController
  require 'open-uri'

  def index
    @sorted_products = []
  end

  def show
    if params[:palabra].include?(" ") || params[:palabra].empty?
      flash[:alert] = "No se permite ingresar mas de una palabra" if params[:palabra].include? " " 
      flash[:alert] = "No se ingreso ninguna palabra" if params[:palabra].empty?
      redirect_to root_path
    else
      @order = true
      @order = false if params[:asc] == "true"
      @sorted_products = search(params[:palabra], params[:cantidad].to_i).sort_by { |hsh| hsh[:price] } 
      @sorted_products = @sorted_products.reverse if @order == true 
    end
  end

  def search(palabra, cantidad) 
    cantidad = 20 if cantidad == 0
    doc = Nokogiri::HTML(open("https://www.liverpool.com.mx/tienda/?s=#{palabra}"))
    products = doc.css('li.product-cell')
    products[0..cantidad-1].map do |product|
      link = 'https://www.liverpool.com.mx' + product.css('.product-name').attr('href').value
      image = product.css('img').attr('data-original').value

      p2 = product.css('a')
      p3 = p2.css('input')


      p4 = p3.css(".gtmProdName")
      name = p4.at('input')['value']
      p4 = p3.css(".gtmPlPrice")
      price = p4.at('input')['value'].to_f
      { name: name, price: price, image: image, link: link }
    end
  end

end
