create table admin(
adminId int identity(1,1),
adminName varchar(20),
adminPass varchar(25),
primary key (adminId)
)

create table customerPhone(
custPhone varchar(25),
custEmail varchar(25),
primary key (custPhone)
)

create table customerCNIC(
custName varchar(50),
custCNIC varchar(50),
custPhone varchar(25),
custAddress varchar(75),
primary key (custCNIC),
foreign key (custPhone) references customerPhone(custPhone)
)

create table customer(
custid int identity(1,1),
custCNIC varchar(50),
custPass varchar(50),
primary key (custid),
foreign key (custCNIC) references customerCNIC(custCNIC)
)

create table EmpPhone(
empPhone varchar(25),
empEmail varchar(25),
primary key (empPhone)
)

create table empCNIC(
empname varchar(50),
empCNIC varchar(50),
empPhone varchar(25),
empAddress varchar(75),
primary key (empCNIC),
foreign key (empPhone) references empPhone(empPhone)
)

create table empSalary(
empDesignation varchar(20),
empDepartment varchar(20),
empSal int,
primary key (empDesignation,empDepartment)
)

create table orderr (
orderId int identity(1,1),
orderWeight varchar(25),
orderDeliveryStatus varchar(25),
custID int,
primary key (orderid),
foreign key (custID) references customer(custID)
)

create table package(
pkgId int identity(1,1),
numberOfOrders int,
pkgweight varchar(20),
pkgheight varchar(20),
deliveryCity varchar(20),
primary key (pkgid),
inDeliveryID int,
)


create table transport (
vehicleno varchar(20),
vehicleName varchar(20),
vehicleType varchar(20),
primary key (vehicleno),
)

create table branch(
branchcode int identity(1,1),
branchcity varchar(20),
branchpostcode int,
vehicleno varchar(20),
primary key (branchcode),
foreign key (vehicleno) references transport(vehicleno)
)

create table warehouse(
warehouseCity varchar(20),
wareHouseCapacity varchar(50),
primary key (warehouseCity),
pkgId int,
orderId int,
branchcode int,
foreign key (pkgId) references package(pkgId),
foreign key (orderId) references orderr(orderId),
foreign key (branchcode) references branch(branchcode)

)
create table Billing(
PaymentID int identity(1,1),
paymentType varchar(20),
govtTax varchar(20),
charges int,
orderid int,
primary key (PaymentID),
foreign key (orderid) references orderr(orderid)
)

create table inDelivery(
inDeliveryID int identity(1,1),
pickupdate varchar(20),
deliverydate varchar(20),
statuss varchar(20),
orderid int,
primary key (inDeliveryID),
foreign key (orderid) references orderr(orderid)
)

create table outDelivery(
outDeliveryID int identity(1,1),
pickupDate varchar(20),
deliveryDate varchar(20),
statuss varchar(20),
pkgid int,
primary key (outDeliveryID),
foreign key (pkgid) references package(pkgid)
)

create Table TrackHistory(
datee varchar(20),
statuss varchar(20),
locationn varchar(20),
trackHistory varchar(75),
primary key (trackhistory),
)

create table shipmentDetail(
origin varchar(75),
destination varchar(75),
bookingdate varchar(75),
shipmentDetail varchar(75),
primary key (shipmentDetail),
)

create table tracking(
trackingID int identity(1,1),
shipmentDetail varchar(75),
TrackHistory varchar(75),
primary key (trackingID),
inDeliveryID int,
outDeliveryID int,
foreign key (shipmentDetail) references shipmentDetail(shipmentDetail),
foreign key (TrackHistory) references TrackHistory(TrackHistory),
foreign key (inDeliveryID) references inDelivery(inDeliveryID),
foreign key (outDeliveryID) references outDelivery(outDeliveryID),
)

create table Employee(
empid int identity (1,1),
empCNIC varchar(50),
empPass varchar(50),
empDOJ varchar(50),
empDesignation varchar(20),
empDepartment varchar(20),
branchcode int,
primary key (empid),
foreign key (empCNIC) references empCNIC(empCNIC),
foreign key (empDesignation,empDepartment) references empSalary(empDesignation,empDepartment),
foreign key (branchcode) references branch(branchcode)
)

insert into customerPhone values('0335-3132311','abc@gmail.com')
insert into customerPhone values('0335-1111111','bcd@gmail.com')
insert into customerPhone values('0335-2222222','bcd@gmail.com')
insert into customerPhone values('0335-3333333','bcd@gmail.com')

insert into customerCNIC values('Ghazi','42201-213123-1','0335-3132311','Jauhor')
insert into customerCNIC values('ALI','42201-213123-2','0335-1111111','Model')
insert into customerCNIC values('42201-213123-3','0335-2222222','Model')
insert into customerCNIC values('42201-213123-4','0335-3333333','Gulshan')

insert into customer values ('42201-213123-1','1234')
insert into customer values ('42201-213123-2','12345')
insert into customer values ('42201-213123-3','234')
insert into customer values ('42201-213123-4','123123')

select * from customer

create table customer_audit(
auditid int not null primary key,
action_performed varchar(200),
)

create trigger tr_customer_audit
on customer
after insert 
as 
begin
	declare @id int
	Select @id=custid from inserted

	insert into customer_audit values 
	(1,'A customer has created account '+ cast(GETDATE() as varchar(50)))
end

select * from customer_audit

create view customer_vw as
select C.custcnic,CC.custphone,CC.custAddress,CP.custemail from customerphone CP
inner join customerCNIC CC 
on CC.custphone=CP.custphone
inner join Customer C 
on CC.custCNIC=C.custCNIC

Select * from customer_vw


create procedure customer_count
as
begin
select COUNT(custid) as [Total Customer] from customer 
end

exec customer_count

create function customer2_phone(@custid int)
returns table
as
return(select CC.custphone from customerCNIC CC
inner join customer C
on C.custCNIC=CC.custCNIC
where @custid=custid)


select * from customer2_phone(2)
