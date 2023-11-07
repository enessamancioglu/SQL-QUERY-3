/*
86. a.Bu ülkeler hangileri..?
87. En Pahalı 5 ürün
88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?
89. Ürünlerimin toplam maliyeti
90. Şirketim, şimdiye kadar ne kadar ciro yapmış..?
91. Ortalama Ürün Fiyatım
92. En Pahalı Ürünün Adı
93. En az kazandıran sipariş
94. Müşterilerimin içinde en uzun isimli müşteri
95. Çalışanlarımın Ad, Soyad ve Yaşları
96. Hangi üründen toplam kaç adet alınmış..?
97. Hangi siparişte toplam ne kadar kazanmışım..?
98. Hangi kategoride toplam kaç adet ürün bulunuyor..?
99. 1000 Adetten fazla satılan ürünler?
100. Hangi Müşterilerim hiç sipariş vermemiş..?
101. Hangi tedarikçi hangi ürünü sağlıyor ?
102. Hangi sipariş hangi kargo şirketi ile ne zaman gönderilmiş..?
103. Hangi siparişi hangi müşteri verir..?
104. Hangi çalışan, toplam kaç sipariş almış..?
105. En fazla siparişi kim almış..?
106. Hangi siparişi, hangi çalışan, hangi müşteri vermiştir..?
107. Hangi ürün, hangi kategoride bulunmaktadır..? Bu ürünü kim tedarik etmektedir..?
108. Hangi siparişi hangi müşteri vermiş, hangi çalışan almış, hangi tarihte, hangi kargo şirketi tarafından gönderilmiş hangi üründen kaç adet alınmış, hangi fiyattan alınmış, ürün hangi kategorideymiş bu ürünü hangi tedarikçi sağlamış
109. Altında ürün bulunmayan kategoriler
110. Manager ünvanına sahip tüm müşterileri listeleyiniz.
111. FR ile başlayan 5 karekter olan tüm müşterileri listeleyiniz.
112. (171) alan kodlu telefon numarasına sahip müşterileri listeleyiniz.
113. BirimdekiMiktar alanında boxes geçen tüm ürünleri listeleyiniz.
114. Fransa ve Almanyadaki (France,Germany) Müdürlerin (Manager) Adını ve Telefonunu listeleyiniz.(MusteriAdi,Telefon)
115. En yüksek birim fiyata sahip 10 ürünü listeleyiniz.
116. Müşterileri ülke ve şehir bilgisine göre sıralayıp listeleyiniz.
117. Personellerin ad,soyad ve yaş bilgilerini listeleyiniz.
118. 35 gün içinde sevk edilmeyen satışları listeleyiniz.
119. Birim fiyatı en yüksek olan ürünün kategori adını listeleyiniz. (Alt Sorgu)
120. Kategori adında 'on' geçen kategorilerin ürünlerini listeleyiniz. (Alt Sorgu)
121. Konbu adlı üründen kaç adet satılmıştır.
122. Japonyadan kaç farklı ürün tedarik edilmektedir.
123. 1997 yılında yapılmış satışların en yüksek, en düşük ve ortalama nakliye ücretlisi ne kadardır?
124. Faks numarası olan tüm müşterileri listeleyiniz.
125. 1996-07-16 ile 1996-07-30 arasında sevk edilen satışları listeleyiniz. 
*/
--86
select distinct ship_country, count(ship_country)
from orders
group by ship_country
order by ship_country;



-- 87
select unit_price from products
order by unit_price desc
limit 5;



-- 88
select count(*) as orderCounts from orders 
where customer_id='ALFKI';



-- 89
select sum(unit_price * units_in_stock) as totalCost
from products;



-- 90
select sum(unit_price * quantity) from order_details;



-- 91
select avg(unit_price) as averagePrice from products;



-- 92
select product_name, unit_price from products
order by unit_price desc
limit 1;



-- 93. Select the order with the minimum gain (unit_price * quantity).
select order_id, min(unit_price * quantity) as minGain
from order_details
group by order_id
order by minGain
limit 1;



-- 94
select customer_id, company_name
from customers
order by length(company_name) desc
limit 1;



-- 95
select first_name, last_name, extract(year from age(birth_date))
as age from employees;



-- 96
select products.product_name, sum(order_details.quantity) as totalsale
from products
join order_details on products.product_id = order_details.product_id
group by products.product_name
order by totalsale desc;



-- 97
select orders.order_id, sum(order_details.unit_price * order_details.quantity)
as totalGain from orders
inner join order_details on orders.order_id = order_details.order_id
group by orders.order_id;



-- 98
select categories.category_name, count(products.product_id) from categories
inner join products on categories.category_id = products.category_id
group by categories.category_name order by count;



-- 99
select products.product_name,
sum(order_details.quantity) from products
inner join order_details ON products.product_id = order_details.product_id
group by products.product_name
having sum(order_details.quantity) > 1000
order by sum;



-- 100
select customer_id, company_name from customers
where not exists (select 1 from orders
where customers.customer_id = orders.customer_id);



-- 101
select suppliers.company_name as supplier, products.product_name
as product from suppliers
join products on suppliers.supplier_id = products.supplier_id
order by supplier, product;



-- 102
select orders.order_id as OrderID, shippers.company_name as ShipperName,
orders.shipped_date as ShippedDate from orders
inner join shippers on orders.ship_via = shippers.shipper_id;



-- 103
select orders.order_id as orderId, customers.contact_name as customerName from orders
inner join customers on orders.customer_id = customers.customer_id;



-- 104
select first_name, last_name, count(*) from employees
inner join orders on employees.employee_id = orders.employee_id
group by employees.employee_id order by count;



-- 105
select first_name, last_name, count(*) from employees
inner join orders on employees.employee_id = orders.employee_id
group by employees.employee_id
order by count desc limit 1;



-- 106
select orders.order_id, employees.first_name, employees.last_name,
customers.company_name from orders
inner join customers on orders.customer_id = customers.customer_id
inner join employees on orders.employee_id = employees.employee_id;



-- 107
select products.product_id, products.product_name, categories.category_name,
company_name from products
inner join suppliers on suppliers.supplier_id = products.supplier_id
inner join categories on categories.category_id = products.category_id;



-- 108
select
orders.order_id,
customers.company_name,
customers.contact_name,
orders.shipped_date,
orders.ship_name,
products.product_name,
order_details.quantity,
categories.category_name,
suppliers.company_name
from orders 
inner join order_details on order_details.order_id = orders.order_id
inner join customers on customers.customer_id = orders.customer_id
inner join products on products.product_id = order_details.product_id
inner join suppliers on suppliers.supplier_id = products.supplier_id
inner join categories on categories.category_id = products.category_id;



-- 109
select categories.category_id, categories.category_name, products.product_name
from categories left join products on categories.category_id = products.category_id
where products.product_id is null;



-- 110
select contact_name, company_name, contact_title
from customers where contact_title like '%Manager';



-- 111
select customer_id, company_name from customers
where customer_id like 'FR%' and length(customer_id) = 5;



-- 112
select company_name, phone from customers
where phone like '(171)%';



-- 113
select product_name, quantity_per_unit from products
where quantity_per_unit like '%boxes%';



-- 114
select company_name, contact_name, phone, country from customers
where (country = 'France' or country = 'Germany') and contact_title like '%Manager'
order by country;



-- 115
select product_name, unit_price from products
order by unit_price desc
limit 10;



-- 116
select company_name, country, city
from customers
order by country, city;



-- 117
select first_name, last_name, extract(year from age(birth_date)) as age
from employees;



-- 118
select order_date, shipped_date, (shipped_date - order_date) as differencedays
from orders where (shipped_date - order_date) >= 35;



-- 119
select product_name, unit_price, products.category_id, categories.category_name
from products join categories on products.category_id = categories.category_id
order by unit_price desc
limit 1;



-- 120
select products.product_name, categories.category_name from products
join categories on products.category_id = categories.category_id
where categories.category_name like '%on%';



-- 121
select products.product_name, sum(order_details.quantity) as totalsalesquantity
from products join order_details on products.product_id = order_details.product_id
where products.product_name = 'Konbu'
group by products.product_name;



-- 122
select count(distinct products.product_id) as differentproductcount,
suppliers.country as country from products
join suppliers on products.supplier_id = suppliers.supplier_id
where suppliers.country = 'Japan'
group by suppliers.country;



-- 123
select
    max(freight) as maxshippingfee,
    min(freight) as minshippingfee,
    avg(freight) as avgshippingfee
from orders where extract(year from order_date) = 1997;



-- 124
select city, address, fax
from customers
where fax is not null and fax != ''
order by city;



-- 125
select ship_city, ship_name, shipped_date from orders
where orders.shipped_date between '1996-07-16' and '1996-07-30'
order by shipped_date;











