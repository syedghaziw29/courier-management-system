insert into customerPhone values('0335-3132311','abc@gmail.com')
insert into customerPhone values('0335-1111111','bcd@gmail.com')
insert into customerPhone values('0335-2222222','efg@gmail.com')
insert into customerPhone values('0335-3333333','hij@gmail.com')

insert into customerCNIC values('Ghazi','42201-213123-1','0335-3132311','Jauhor')
insert into customerCNIC values('ALI','42201-213123-2','0335-1111111','Model')
insert into customerCNIC values('Laraib''42201-213123-3','0335-2222222','Model')
insert into customerCNIC values('Manzoor','42201-213123-4','0335-3333333','Gulshan')

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


