create table
    Orders (
        order_id int auto_increment primary key,
        p_order_id varchar(36) null,
        client_id int not null,
        total float (2) not null,
        quantity int unsigned not null,
        created_at datetime default CURRENT_TIMESTAMP,
        product_id int not null,
        foreign key (client_id) references Clients (client_id),
        foreign key (product_id) references Products (product_id),
    );

-- Trigger to set an uuid for public usage
DELIMITER / / CREATE TRIGGER before_insert_order BEFORE INSERT ON Orders FOR EACH ROW BEGIN IF NEW.p_order_id IS NULL THEN
SET
    NEW.p_order_id = UUID ();

END IF;

END / / DELIMITER;

DELIMITER / /
-- Trigger for INSERT operations
CREATE TRIGGER orders_insert_audit AFTER INSERT ON Orders FOR EACH ROW BEGIN
INSERT INTO
    Audit (table_name, action, record_id, description)
VALUES
    (
        'Orders',
        'INSERT',
        NEW.order_id,
        CONCAT (
            'Created order with ID ',
            NEW.order_id,
            ' for client ID ',
            NEW.client_id
        )
    );

END / /
-- Trigger for UPDATE operations
CREATE TRIGGER orders_update_audit AFTER
UPDATE ON Orders FOR EACH ROW BEGIN
INSERT INTO
    Audit (table_name, action, record_id, description)
VALUES
    (
        'Orders',
        'UPDATE',
        NEW.order_id,
        CONCAT (
            'Updated order with ID ',
            NEW.order_id,
            ' for client ID ',
            NEW.client_id
        )
    );

END / /
-- Trigger for DELETE operations
CREATE TRIGGER orders_delete_audit AFTER DELETE ON Orders FOR EACH ROW BEGIN
INSERT INTO
    Audit (table_name, action, record_id, description)
VALUES
    (
        'Orders',
        'DELETE',
        OLD.order_id,
        CONCAT (
            'Deleted order with ID ',
            OLD.order_id,
            ' for client ID ',
            OLD.client_id
        )
    );

END / / DELIMITER;