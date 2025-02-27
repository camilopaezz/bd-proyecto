create table Sells (
    sell_id int auto_increment,
    quantity int unsigned not null,
    product_id int not null,
    foreign key (product_id) references Products (product_id)
);
