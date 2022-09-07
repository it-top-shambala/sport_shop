CREATE TRIGGER sales_log_history_insert AFTER INSERT ON
goods_sales FOR EACH ROW
    INSERT INTO History(log_type_id, goods_manufacturer, buyer_firstname, saler_firstname, sales_price, good_name, sales_date)
        VALUES (
                (SELECT trigger_type.Id FROM trigger_type WHERE trigger_type.type_name = 'insert'),
                (SELECT goods_manufacturer_name FROM goods_manufacturer WHERE Id = NEW.saled_goods_id),
                (SELECT first_name FROM Person WHERE Person.Id = NEW.goods_buyer_id ),
                (SELECT first_name FROM Person WHERE Person.Id = NEW.goods_seller_id),
                New.sales_price,
                (SELECT goods_name FROM goods WHERE goods.Id),
                NEW.sales_date
        );