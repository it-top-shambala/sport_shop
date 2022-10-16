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


DELIMITER |
CREATE PROCEDURE procedure_refresh_nomenclature_amount_after_receipt_payment (IN id INT)
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE item_id INT;
  DECLARE nom_id INT;

  DECLARE all_item_ids CURSOR FOR SELECT receipt_item_id
                                  FROM table_receipt_items WHERE receipt_id=id;

  DECLARE all_nom_ids CURSOR FOR SELECT nomenclature_id
                                  FROM table_receipt_items WHERE receipt_id=id;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN all_item_ids;
  OPEN all_nom_ids;
  read_loop: LOOP
    FETCH all_item_ids INTO item_id;
    FETCH all_nom_ids INTO nom_id;
    IF done THEN
      LEAVE read_loop;
    END IF;
    SET @sold_amount := function_get_receipt_item_amount(item_id);
    SET @total_amount := function_get_nomenclature_amount(nom_id);
    UPDATE table_nomenclatures
    SET amount=@total_amount-@sold_amount
    WHERE nomenclature_id=nom_id;
    END LOOP;
  CLOSE all_item_ids;
  CLOSE all_nom_ids;
END|


DELIMITER |
CREATE PROCEDURE procedure_refresh_nomenclature_amount_after_order_payment (IN id INT)
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE item_id INT;
  DECLARE nom_id INT;

  DECLARE all_item_ids CURSOR FOR SELECT order_item_id
                                  FROM table_order_items WHERE order_id=id;

  DECLARE all_nom_ids CURSOR FOR SELECT nomenclature_id
                                  FROM table_order_items WHERE order_id=id;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN all_item_ids;
  OPEN all_nom_ids;
  read_loop: LOOP
    FETCH all_item_ids INTO item_id;
    FETCH all_nom_ids INTO nom_id;
    IF done THEN
      LEAVE read_loop;
    END IF;
    SET @sold_amount := function_get_order_item_amount(item_id);
    SET @total_amount := function_get_nomenclature_amount(nom_id);
    UPDATE table_nomenclatures
    SET amount=@total_amount-@sold_amount
    WHERE nomenclature_id=nom_id;
    END LOOP;
  CLOSE all_item_ids;
  CLOSE all_nom_ids;
END|

