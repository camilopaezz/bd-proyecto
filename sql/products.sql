-- Create Table
create table
    Products (
        product_id int auto_increment primary key,
        stock int unsigned default 0 null,
        name varchar(200) not null,
        price float(2) not null,
        category_id int not null,
        spec_id int not null,
        foreign key (category_id) references Category (category_id),
        foreign key (spec_id) references Specs (spec_id)
    );
