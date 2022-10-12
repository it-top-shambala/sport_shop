delimiter |
create trigger log_history_sale
    after insert on sale
    for each row
    begin
        insert into history (id_product, price_sale, amount, id_seller, id_buyer)
            values (new.id_product, new.price_sale, new.amount, new.id_seller, new.id_buyer);
    end|

create trigger arhive_product_trigger
    after insert on sale
    for each row
    begin
        if (select availability from product where product.id=new.id_product)=0 then
            insert into arhive (name_product, type_product, start_price, manufacturer)
            values (
                (select name_product from product where product.id=new.id_product),
                (select type from type_product,product,type_product where product.id=new.id_product and id_type_product=type_product.id),
                (select start_price from product where product.id=new.id_product)
            );
            delete from product where product.id=new.id_product;
        end if;
    end |

create trigger checking_availability
    before insert on buyers
    for each row
    begin
        if (select count(*) from buyers where first_name=new.first_name and last_name=new.last_name and email=new.email) then
           rollback;
        end if;
    end |

create trigger cancel_delete_buyer
    before delete on buyers
    for each row
    begin
        if old.id>0 then
            signal sqlstate '45000' set message_text = 'cancel delete buyer';
        end if;
    end |

create trigger cancel_delete_sellers
    before delete on sellers
    for each row
    begin
        if old.date_employment between '2000-01-01 00:00:00' and '2015-01-01 00:00:00' then
            signal sqlstate '45000' set message_text = 'cancel delete sellser';
        end if;
    end |

create trigger set_discount
    before insert on sale
    for each row
    begin
        if (new.amount*new.price_sale+(select sum (amount*price_sale) from history))>50000 then
           select discount from buyers where new.id_buyer=buyers.id=15;
        end if ;
    end |

create trigger cancel_insert_by_manufacture
    before insert on product
    for each row
    begin
        if (select name_manufacture from manufacture where manufacture.id=new.id_manufacturer)='Спорт, солнце и штанга' then
            signal sqlstate '45000' set message_text = 'cancel insert product';
        end if;
    end |

create trigger check_availability_product
    after insert on sale
    for each row
    begin
        if (select availability from product where new.id_product=product.id)<=1 then
            insert into last_unit (id_product, availability)
                values (new.id_product, (select availability from product where new.id_product=product.id));
        end if;
    end |

create trigger check_insert_product
    before insert on product
    for each row
    begin
        if (select count (name_product) from product where name_product=new.name_product)>0 then
            update product set availability=new.availability;
        end if ;
    end |

create trigger dismiss_seller
    after delete on sellers
    for each row
    begin
        insert into arhive_sellers (last_name, first_name, post, gender, date_employment)
            VALUES (new.last_name, new.first_name, new.post, new.gender, new.date_employment);
    end |

create trigger cancel_employment
    before insert on sellers
    for each row
    begin
        if (select count(*) from sellers)>=6 then
            signal sqlstate '45000' set message_text = 'cancel insert seller';
        end if;
    end |