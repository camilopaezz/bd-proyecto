create table Orders (
    order_id int auto_increment primary key,
    p_order_id varchar(36) null,
    client_id int not null,
    total float(2) not null, 
    quantity int unsigned not null,
    created_at datetime default CURRENT_TIMESTAMP,
    product_id int not null,
    foreign key (client_id) references Clients (client_id),
    foreign key (product_id) references Products (product_id),
);

-- -- Procedure for setting the total
-- delimiter $$
-- create procedure update_total(in order_id, product_id)
-- begin
--   select price from Products where Products.pr
-- end;
-- $$

-- Trigger to set an uuid for public usage
create trigger before_insert_order before insert on Clients for each row begin if NEW.p_order_id is null then
set
    NEW.p_order_id = UUID ();

end if;

end;
