DELIMITER |
CREATE FUNCTION function_get_nomenclature_id (product_id INT) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE id INT DEFAULT 0;
    SELECT nomenclature_id INTO id
                           FROM table_nomenclatures
                           WHERE table_nomenclatures.product_id=product_id;
    RETURN id;
END|

DELIMITER |
CREATE FUNCTION function_get_nomenclature_amount (nomenclature_id INT) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE amount INT DEFAULT 0;
    SELECT amount INTO amount
                  FROM table_nomenclatures
                  WHERE table_nomenclatures.nomenclature_id=nomenclature_id;
    RETURN amount;
END|

DELIMITER |
CREATE FUNCTION function_get_receipt_total_price (receipt_id INT) RETURNS DOUBLE DETERMINISTIC
BEGIN
    DECLARE price DOUBLE DEFAULT 0.0;
    SELECT total_price INTO price
                  FROM table_receipts
                  WHERE table_receipts.receipt_id=receipt_id;
    RETURN price;
END|

DELIMITER |
CREATE FUNCTION function_get_order_total_price (order_id INT) RETURNS DOUBLE DETERMINISTIC
BEGIN
    DECLARE price DOUBLE DEFAULT 0.0;
    SELECT total_price INTO price
                  FROM table_orders
                  WHERE table_orders.order_id=order_id;
    RETURN price;
END|

DELIMITER |
CREATE FUNCTION function_get_nomenclature_price (nomenclature_id INT) RETURNS DOUBLE DETERMINISTIC
BEGIN
    DECLARE price DOUBLE DEFAULT 0.0;
    SELECT sell_price INTO price
                  FROM table_nomenclatures
                  WHERE table_nomenclatures.nomenclature_id=nomenclature_id;
    RETURN price;
END|

DELIMITER |
CREATE FUNCTION function_get_client_discount (client_id INT) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE client_discount INT DEFAULT 0;
    SELECT discount INTO client_discount FROM table_clients WHERE table_clients.client_id=client_id;
    RETURN client_discount;
END|

DELIMITER |
CREATE FUNCTION function_get_receipt_item_amount (item_id INT) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE sold_amount INT DEFAULT 0;
    SELECT amount INTO sold_amount FROM table_receipt_items WHERE table_receipt_items.receipt_item_id=item_id;
    RETURN sold_amount;
END|

DELIMITER |
CREATE FUNCTION function_get_order_item_amount (item_id INT) RETURNS INT DETERMINISTIC
BEGIN
    DECLARE sold_amount INT DEFAULT 0;
    SELECT amount INTO sold_amount FROM table_order_items WHERE table_order_items.order_item_id=item_id;
    RETURN sold_amount;
END|