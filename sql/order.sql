create table Orders (
    order_id int auto_increment primary key,
    p_order_id varchar(36) null,
    client_id int not null,
    total foreign key (client_id) references Clients (client_id)
);

-- Trigger to set an uuid for public usage
create trigger before_insert_order before insert on Clients for each row begin if NEW.p_order_id is null then
set
    NEW.p_order_id = UUID ();

end if;

end;
