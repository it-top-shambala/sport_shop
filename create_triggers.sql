delimiter |
create trigger log_history_sale
    after insert on sale
    for each row
    begin
        insert into history (id_product, price_sale, amount, id_seller, id_buyer)
            value (new.id_product, new.price_sale, new.amount, new.id_seller, new.id_buyer);
    end|

create trigger arhive_product_trigger
    after insert on sale
    for each row
    begin
        if (select availability from product where product.id=new.id_product)=0 then
            insert into arhive (name_product, type_product, start_price, manufacturer)
            VALUE (
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
           rollback 
        end if;
    end |