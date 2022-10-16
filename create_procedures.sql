DELIMITER |
CREATE PROCEDURE procedure_open_new_receipt_and_get_id (IN salesman INT, OUT new_id INT)
BEGIN
    INSERT INTO table_receipts (salesman_id) VALUE (salesman);
    SELECT MAX(receipt_id) INTO new_id FROM table_receipts;
END |

DELIMITER |
CREATE PROCEDURE procedure_open_new_order_and_get_id (IN client INT, OUT new_id INT)
BEGIN
    INSERT INTO table_orders (client_id) VALUE (client);
    SELECT MAX(order_id) INTO new_id FROM table_orders;
END |

