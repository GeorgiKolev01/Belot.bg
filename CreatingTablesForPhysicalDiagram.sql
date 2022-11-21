create database Belotbg

use Belotbg

create table Genders(
	id int not null identity(1, 1) primary key,
	[name] varchar(10) not null
);

create table Users(
id int not null identity(1, 1) primary key,
username varchar(15) not null unique,
[password] varchar(50) not null,
email varchar(100) null,
gender_id int null foreign key references Genders(id) on delete set null,
[money] int,
wins int,
loses int,
is_vip bit not null,
last_sign_in date not null
);

create unique index unique_email
  on Users(email)
  where email is not null;

create table UsersFollowers(
	follower_id int not null foreign key references Users(id),
	followee_id int not null foreign key references Users(id) on delete cascade,
	[timestamp] datetime not null
);

create unique index uq_UsersFollowers
  on dbo.UsersFollowers(follower_id, followee_id);

  create table Clubs(
	id int not null identity(1, 1) primary key,
	[name] varchar(50) not null,
	[description] varchar(160) null,
	admin_id int not null foreign key references Users(id) on delete cascade,
	wins int,
	loses int,
	created_on date not null
	
);

create table BasicRoles(
	id int not null identity(1, 1) primary key,
	[name] varchar(10) not null,
)

create table ClubsUsers(
	club_id int not null foreign key references Clubs(id) on delete cascade,
	[user_id] int not null foreign key references Users(id),
	[role_id] int not null foreign key references BasicRoles(id)
);

create table UsersRating(
	[user_id] int not null foreign key references Users(id),
	rating_user_id int not null foreign key references Users(id) on delete cascade,
	rate int
);

create table ClubsRating(
	club_id int not null foreign key references Clubs(id),
	rating_user_id int not null foreign key references Users(id) on delete cascade,
	rate int
);

create table GameTypes(
	id int not null identity(1, 1) primary key,
	name_of_game varchar(20) not null,
	number_of_players int not null
);


create table Game(
	id int not null identity(1, 1) primary key,
	[type_id] int not null foreign key references GameTypes(id),
	stake int not null,
	reward int
);


go

create trigger trg_delete_user_references
on Users
instead of delete 
as
begin
	declare @deleted_user_id int
	set @deleted_user_id  = (select id from Deleted)
	delete from ClubsRating where rating_user_id  = @deleted_user_id
	delete from UsersRating where user_id  = @deleted_user_id
	delete from UsersFollowers where follower_id  = @deleted_user_id
	delete from UsersFollowers where followee_id  = @deleted_user_id
    delete from ClubsUsers where user_id  = @deleted_user_id
	delete from Users where id  = @deleted_user_id
end;


go

create procedure getUsersFollowingAndFollowers
as
begin
	set nocount on
	select u.username as [User],
		(
          select count(*)
          from UsersFollowers f
          where f.follower_id = u.id
		) as [Following],
		(
          select count(*)
          from UsersFollowers f
          where f.followee_id = u.id
		) as Followers
	from Users u
end;

go

create procedure getAvgRatingOfUsers
as
begin
set nocount on
select u.username as [User],
(
select round(avg(rate),1)
from UsersRating f
where f.user_id  =  u.id
)
from Users u
end;

go

create procedure getAvgRatingOfClubs
as
begin
set nocount on
select u.name as [Club],
(
select round(avg(rate),1)
from ClubsRating f
where f.club_id  =  u.id
)
from Clubs u
end;

insert into Genders(name)
values('Male'),
('Female'),
('Custom');

insert into Users
(username, [password], email, gender_id, [money], wins, loses, is_vip, last_sign_in)
values
('Georgi123', 'qwerty', 'georginiser@abg.bg', 1,2000, 12, 5, 0, '2022-11-18 13:25:18'),
('Vankata-tarikat', 'razbivach123', 'ivanivanov@abg.bg', 1,2031000, 1352, 122, 1, '2022-11-13 12:31:35'),
('Lorem Ipsum', 'aezakmi', 'gamingmachine@abg.bg', 3, 21000, 1, 0, 0, '2022-11-10 17:34:27'),
('Galena Stoeva', 'galkata', 'galenastoeva@gmail.com', 2, 5000, 8, 23, 0, '2022-11-19 11:42:21'),
('Vasil Krumov', 'vaskobelota3', 'vasenceto37@gmail.com', 1, 156000, 256, 34, 1, '2022-11-19 13:05:16')

insert into UsersFollowers
(follower_id, followee_id, [timestamp])
values
(1, 2, '2022-11-10 17:52:17'),
(1, 4, '2022-11-17 23:34:28'),
(2, 1, '2022-11-10 17:51:36'),
(3, 4, '2022-11-10 16:52:17'),
(3, 1, '2022-10-27 01:37:21'),
(1, 3, '2022-10-27 01:43:39')

insert into Clubs
([name], [description], admin_id, wins, loses, created_on)
values
('Belot owners', 'The best players belong there', 2, 436, 27, '2022-10-23 22:07:56'),
('Kapo', 'Players in this club are about to get to the top', 1, 17, 23, '2022-09-17 01:34:14')

insert into BasicRoles
([name])
values
('General'),
('Lieutenant'),
('Private')

insert into ClubsUsers
(club_id, [user_id], [role_id])
values
(3, 2, 2),
(3, 5, 3),
(4, 1, 2),
(4, 3, 4),
(4, 4, 4)

insert into UsersRating
([user_id], rating_user_id, rate)
values
(2, 5, 5),
(2, 1, 5),
(2, 4, 5),
(5, 2, 5),
(5, 1, 4),
(4, 2, 2),
(1, 2, 1)

insert into ClubsRating
(club_id, rating_user_id, rate)
values
(3, 5, 5),
(3, 1, 5),
(3, 4, 5),
(3, 2, 5),
(4, 1, 5),
(4, 3, 5),
(4, 2, 1)

insert into GameTypes
(name_of_game, number_of_players)
values
('Belot', 4),
('Tournament belot', 8),
('Tabla', 2),
('Santase', 2),
('Ne se sardi bace', 4),
('Blato', 3)

insert into Game
([type_id], stake, reward)
values
(1, 5000, 7000),
(1, 9000, 14000),
(1, 20000, 32000),
(2, 7000, 21000),
(2, 20000, 120000),
(3, 5000, 7000),
(3, 9000, 14000),
(3, 25000, 39000),
(4, 5000, 7000),
(4, 9000, 14000),
(4, 25000, 39000),
(5, 9000, 27000),
(6, 5000, 10000),
(6, 9000, 21000),
(6, 20000, 48000)