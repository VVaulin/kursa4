-- Creating schema in DB

CREATE SCHEMA IF NOT EXISTS hotel;

-- Adding tables to schema

SET search_path TO hotel;
CREATE TABLE "customer_profile" (
	"customer_id" serial NOT NULL,
	"join_date" DATE NOT NULL,
	CONSTRAINT "customer_profile_pk" PRIMARY KEY ("customer_id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "company" (
	"customer_id" integer NOT NULL,
	"company_name" TEXT NOT NULL,
	"contact_person" TEXT NOT NULL,
	"ITN" TEXT NOT NULL,
	"phone_number" TEXT NOT NULL,
	"mail" TEXT NOT NULL,
	CONSTRAINT "company_pk" PRIMARY KEY ("customer_id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "person" (
	"customer_id" integer NOT NULL,
	"first_last_name" TEXT NOT NULL,
	"passport" TEXT NOT NULL,
	"phone_number" TEXT NOT NULL,
	"mail" TEXT NOT NULL,
	CONSTRAINT "person_pk" PRIMARY KEY ("customer_id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "booking" (
	"booking_id" serial NOT NULL,
	"customer_id" integer NOT NULL,
	"discount" FLOAT NOT NULL,
	"prepayment" integer NOT NULL,
	"rejection" BOOLEAN NOT NULL,
	CONSTRAINT "booking_pk" PRIMARY KEY ("booking_id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "check_in" (
	"check_in_id" serial NOT NULL,
	"booking_id" integer,
	"customer_id" integer NOT NULL,
	"room_id" integer NOT NULL,
	"arrival_date" DATE NOT NULL,
	"departure_date" DATE NOT NULL,
	CONSTRAINT "check_in_pk" PRIMARY KEY ("check_in_id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "reviews" (
	"check_in_id" integer NOT NULL,
	"price_evaluation" integer NOT NULL,
	"service_evaluation" integer NOT NULL,
	"content" TEXT NOT NULL,
	CONSTRAINT "reviews_pk" PRIMARY KEY ("check_in_id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "complaint" (
	"complaint_id" serial NOT NULL,
	"check_in_id" integer NOT NULL,
	"type_of_complaint" varchar(32) NOT NULL,
	"content" TEXT NOT NULL,
	"date_of_complaint" DATE NOT NULL,
	CONSTRAINT "complaint_pk" PRIMARY KEY ("complaint_id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "booking_composition" (
	"booking_id" integer NOT NULL,
	"room_id" integer NOT NULL,
	"start_of_booking" DATE NOT NULL,
	"finish_of_booking" DATE NOT NULL,
	CONSTRAINT "booking_composition_pk" PRIMARY KEY ("booking_id","room_id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "orders" (
	"order_id" serial NOT NULL,
	"check_in_id" integer NOT NULL,
	"service_id" integer NOT NULL,
	"payment_status" BOOLEAN NOT NULL,
	"quantity" integer NOT NULL,
	CONSTRAINT "orders_pk" PRIMARY KEY ("order_id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "types_of_services" (
	"service_id" serial NOT NULL,
	"name" TEXT NOT NULL,
	"price" FLOAT NOT NULL,
	CONSTRAINT "types_of_services_pk" PRIMARY KEY ("service_id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "availability_of_service" (
	"housing_id" integer NOT NULL,
	"service_id" integer NOT NULL,
	CONSTRAINT "availability_of_service_pk" PRIMARY KEY ("housing_id","service_id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "housing" (
	"housing_id" serial NOT NULL,
	"name" TEXT NOT NULL,
	"class" integer NOT NULL,
	"numb_of_floor" integer NOT NULL,
	"total_number_of_rooms" integer NOT NULL,
	CONSTRAINT "housing_pk" PRIMARY KEY ("housing_id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "rooms" (
	"room_id" serial NOT NULL,
	"housing_id" integer NOT NULL,
	"floor" integer NOT NULL,
	"room_number" integer NOT NULL,
	"number_of_seats" integer NOT NULL,
	"price" FLOAT NOT NULL,
	CONSTRAINT "rooms_pk" PRIMARY KEY ("room_id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "types_of_maintenance" (
	"type_id" serial NOT NULL,
	"name" TEXT NOT NULL,
	"price" FLOAT NOT NULL,
	CONSTRAINT "types_of_maintenance_pk" PRIMARY KEY ("type_id")
) WITH (
  OIDS=FALSE
);



CREATE TABLE "rooms_maintenance" (
	"maintenance_id" integer NOT NULL,
	"room_id" integer NOT NULL,
	"type_id" integer NOT NULL,
	"date_time" DATE NOT NULL,
	CONSTRAINT "rooms_maintenance_pk" PRIMARY KEY ("maintenance_id")
) WITH (
  OIDS=FALSE
);




ALTER TABLE "company" ADD CONSTRAINT "company_fk0" FOREIGN KEY ("customer_id") REFERENCES "customer_profile"("customer_id");

ALTER TABLE "person" ADD CONSTRAINT "person_fk0" FOREIGN KEY ("customer_id") REFERENCES "customer_profile"("customer_id");

ALTER TABLE "booking" ADD CONSTRAINT "booking_fk0" FOREIGN KEY ("customer_id") REFERENCES "customer_profile"("customer_id");

ALTER TABLE "check_in" ADD CONSTRAINT "check_in_fk0" FOREIGN KEY ("booking_id") REFERENCES "booking"("booking_id");
ALTER TABLE "check_in" ADD CONSTRAINT "check_in_fk1" FOREIGN KEY ("customer_id") REFERENCES "person"("customer_id");
ALTER TABLE "check_in" ADD CONSTRAINT "check_in_fk2" FOREIGN KEY ("room_id") REFERENCES "rooms"("room_id");

ALTER TABLE "reviews" ADD CONSTRAINT "reviews_fk0" FOREIGN KEY ("check_in_id") REFERENCES "check_in"("check_in_id");

ALTER TABLE "complaint" ADD CONSTRAINT "complaint_fk0" FOREIGN KEY ("check_in_id") REFERENCES "check_in"("check_in_id");

ALTER TABLE "booking_composition" ADD CONSTRAINT "booking_composition_fk0" FOREIGN KEY ("booking_id") REFERENCES "booking"("booking_id");
ALTER TABLE "booking_composition" ADD CONSTRAINT "booking_composition_fk1" FOREIGN KEY ("room_id") REFERENCES "rooms"("room_id");

ALTER TABLE "orders" ADD CONSTRAINT "orders_fk0" FOREIGN KEY ("check_in_id") REFERENCES "check_in"("check_in_id");
ALTER TABLE "orders" ADD CONSTRAINT "orders_fk1" FOREIGN KEY ("service_id") REFERENCES "types_of_services"("service_id");

ALTER TABLE "availability_of_service" ADD CONSTRAINT "availability_of_service_fk0" FOREIGN KEY ("housing_id") REFERENCES "housing"("housing_id");
ALTER TABLE "availability_of_service" ADD CONSTRAINT "availability_of_service_fk1" FOREIGN KEY ("service_id") REFERENCES "types_of_services"("service_id");

ALTER TABLE "rooms" ADD CONSTRAINT "rooms_fk0" FOREIGN KEY ("housing_id") REFERENCES "housing"("housing_id");

ALTER TABLE "rooms_maintenance" ADD CONSTRAINT "rooms_maintenance_fk0" FOREIGN KEY ("room_id") REFERENCES "rooms"("room_id");
ALTER TABLE "rooms_maintenance" ADD CONSTRAINT "rooms_maintenance_fk1" FOREIGN KEY ("type_id") REFERENCES "types_of_maintenance"("type_id");

-- Creating procedures, functions and views

SET search_path TO hotel;
CREATE OR REPLACE PROCEDURE hotel.insert_person(
	IN flname text,
	IN pass text,
	IN numb text,
	IN mail text)
LANGUAGE 'plpgsql'
AS $BODY$
declare
per int;
begin
select max(customer_id) from customer_profile into per;
insert into customer_profile(customer_id, join_date)
values (per + 1, current_date);
insert into person(customer_id, first_last_name, passport, phone_number, mail)
values (per + 1,flname, pass, numb, mail);
end;
$BODY$;
ALTER PROCEDURE hotel.insert_person(text, text, text, text)
    OWNER TO postgres;

CREATE OR REPLACE PROCEDURE hotel.insert_company(
	IN comp_name text,
	IN contact_name text,
	IN itn text,
	IN numb text,
	IN mail text)
LANGUAGE 'plpgsql'
AS $BODY$
declare
per int;
begin
select max(customer_id) from customer_profile into per;
insert into customer_profile(customer_id, join_date)
values (per + 1, current_date);
insert into company(customer_id, company_name, contact_person, "ITN", phone_number, mail)
values (per + 1, comp_name, contact_name, itn, numb, mail);
end;
$BODY$;
ALTER PROCEDURE hotel.insert_company(text, text, text, text, text)
    OWNER TO postgres;

CREATE OR REPLACE VIEW hotel.active_bookings
 AS
 SELECT per.first_last_name,
    comp.company_name,
    b.prepayment,
    bc.start_of_booking,
    bc.finish_of_booking
   FROM hotel.booking b
     JOIN hotel.booking_composition bc ON bc.booking_id = b.booking_id
     FULL JOIN hotel.person per ON per.customer_id = b.customer_id
     FULL JOIN hotel.company comp ON b.customer_id = comp.customer_id
  WHERE bc.start_of_booking > CURRENT_DATE
  ORDER BY bc.start_of_booking, comp.company_name, per.first_last_name;

ALTER TABLE hotel.active_bookings
    OWNER TO postgres;

CREATE OR REPLACE PROCEDURE hotel.change(
	IN type_of_client text,
	IN name_ text,
	IN date_ date)
LANGUAGE 'plpgsql'
AS $BODY$
declare
per int;
begin
if type_of_client = 'Компания'
then
	select boo.customer_id into per from company comp
	inner join booking boo
	on comp.customer_id = boo.customer_id
	inner join booking_composition bc
	on bc.booking_id = boo.booking_id
	where company_name = name_ and start_of_booking = date_;
elseif type_of_client = 'Клиент'
then
	select boo.customer_id into per from person pe
	inner join booking boo
	on boo.customer_id = pe.customer_id
	inner join booking_composition bc
	on bc.booking_id = boo.booking_id
	where first_last_name = name_ and booking_id is not NULL;
end if;

update booking
set rejection = 'True'
where customer_id = per; 
end;
$BODY$;
ALTER PROCEDURE hotel.change(text, text, date)
    OWNER TO postgres;

CREATE OR REPLACE VIEW hotel.today_check_in
 AS
 SELECT p.first_last_name,
    p.phone_number,
    r.room_number,
    h.name AS name_of_housing
   FROM hotel.person p
     JOIN hotel.booking b ON b.customer_id = p.customer_id
     JOIN hotel.booking_composition bc ON bc.booking_id = b.booking_id
     JOIN hotel.rooms r ON r.room_id = bc.room_id
     JOIN hotel.housing h ON h.housing_id = r.housing_id
  WHERE bc.start_of_booking = CURRENT_DATE;

ALTER TABLE hotel.today_check_in
    OWNER TO postgres;

CREATE OR REPLACE VIEW hotel.free_rooms
 AS
 SELECT DISTINCT r.room_number,
    h.name AS name_of_housing
   FROM hotel.booking_composition bc
     LEFT JOIN hotel.check_in ch ON ch.booking_id = bc.booking_id
     JOIN hotel.rooms r ON r.room_id = ch.room_id
     JOIN hotel.housing h ON h.housing_id = r.housing_id
  WHERE NOT (EXISTS ( SELECT booking_composition.room_id
           FROM hotel.booking_composition
          WHERE bc.room_id = ch.room_id AND (CURRENT_DATE < bc.start_of_booking OR CURRENT_DATE > bc.finish_of_booking))) AND NOT (EXISTS ( SELECT 1
           FROM hotel.check_in
          WHERE ch.room_id = bc.room_id AND CURRENT_DATE >= ch.arrival_date AND CURRENT_DATE <= ch.departure_date))
  ORDER BY h.name, r.room_number;

ALTER TABLE hotel.free_rooms
    OWNER TO postgres;

CREATE OR REPLACE VIEW hotel.list_of_services
 AS
 SELECT ts.name AS service,
    ts.price,
    hou.name AS house
   FROM hotel.types_of_services ts
     JOIN hotel.availability_of_service ava ON ts.service_id = ava.service_id
     JOIN hotel.housing hou ON hou.housing_id = ava.housing_id
  WHERE ava.housing_id = ANY (ARRAY[1, 2])
  ORDER BY hou.housing_id;

ALTER TABLE hotel.list_of_services
    OWNER TO postgres;

CREATE OR REPLACE FUNCTION hotel.zakazy(
	ch_in_id integer)
    RETURNS TABLE(order_id integer, housing_name text, num_of_room integer, flname text, name_service text, serv_quantity integer, payment_stat boolean) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
    ROWS 1000

AS $BODY$
begin
return query
select ord.order_id, h.name, r.room_number, first_last_name, ts.name, ord.quantity, payment_status
from types_of_services ts
inner join orders ord on ts.service_id = ord.service_id
inner join check_in ch on ch.check_in_id = ord.check_in_id
inner join person pe on ch.customer_id = pe.customer_id
inner join rooms r on ch.room_id = r.room_id
inner join housing h on r.housing_id = h.housing_id
where ch_in_id = ch.check_in_id
order by payment_status;
end;
$BODY$;

ALTER FUNCTION hotel.zakazy(integer)
    OWNER TO postgres;

CREATE OR REPLACE PROCEDURE hotel.dolg(
	IN fio text,
	OUT phone text,
	OUT summa integer)
LANGUAGE 'plpgsql'
AS $BODY$
declare
begin
	select per.phone_number, sum(price * quantity) into phone, summa
	from person per
	inner join check_in ch
	on ch.customer_id = per.customer_id
	inner join orders ord
	on ch.check_in_id = ord.check_in_id
	inner join types_of_services tp
	on tp.service_id = ord.service_id
	where (current_date between arrival_date and departure_date) and payment_status = 'False'
	and ch.customer_id = (select customer_id from person where first_last_name = fio)
	group by per.phone_number, ch.customer_id;
end;
$BODY$;
ALTER PROCEDURE hotel.dolg(text)
    OWNER TO postgres;

CREATE OR REPLACE PROCEDURE hotel.ord(
	IN flname text,
	IN service integer,
	IN status boolean,
	IN amount integer)
LANGUAGE 'plpgsql'
AS $BODY$
declare
per int;
ret int;
serv int;
begin
select max(order_id) from orders into per;
select service_id from orders ord into serv
inner join types_of_of_services tos
on ord.service_id = tos.service_id
where tos.name = service;
select check_in_id from check_in ch into ret
inner join person pe on ch.customer_id = pe.customer_id
where flname = first_last_name
and
current_date between arrival_date and departure_date;
insert into orders(order_id, check_in_id, service_id, payment_status, quantity)
values(per+1, ret , serv, status, amount);
end;
$BODY$;
ALTER PROCEDURE hotel.ord(text, integer, boolean, integer)
    OWNER TO postgres;

CREATE OR REPLACE PROCEDURE hotel.dele(
	IN flname text,
	IN service_name text)
LANGUAGE 'plpgsql'
AS $BODY$
declare 
fo int;
up int;
begin

select ch.customer_id into fo from person per
inner join check_in ch
on per.customer_id = ch.customer_id
where per.first_last_name = flname and current_date between ch.arrival_date and ch.departure_date;

select order_id into up from orders ord
inner join types_of_services ts 
on ts.service_id = ord.service_id
inner join check_in ch
on ch.check_in_id = ord.check_in_id
where ch.customer_id = fo and ts.name = service_name
order by order_id desc
limit 1;
delete from orders
where order_id = up;
end;
$BODY$;
ALTER PROCEDURE hotel.dele(text, text)
    OWNER TO postgres;
