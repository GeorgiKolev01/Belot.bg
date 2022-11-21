use Belotbg

create table DWCreator(
id int not null identity(1, 1) primary key,
username varchar(15) not null unique,
gender varchar(10) not null,
wins int,
loses int,
is_vip bit not null,
);

create table DWCreatedOn(
id int not null identity(1, 1) primary key,
created_on datetime not null
);

create table DWRating(
id int not null identity(1, 1) primary key,
avg_rating int not null
);

create table DWClubs
(
id int not null identity(1, 1) primary key,
creator_id int not null foreign key references DWCreator(id),
created_on_id int not null foreign key references DWCreatedOn(id),
rate_id int not null foreign key references DWRating(id),
count_of_wins int,
count_of_loses int
);

create table DWLastSignIn
(
id int not null identity(1, 1) primary key,
[year] int not null,
month_number int not null,
month_name varchar(15) not null,
day_of_month int not null,
day_of_week int not null,
day_name varchar(10)
);

create table DWGender
(
id int not null identity(1, 1) primary key,
alt_id int not null foreign key references Genders(id),
gender varchar(15) not null
);

create table DWUserRated
(
id int not null identity(1, 1) primary key,
avg_rating float
);

create table DWUsers
(
id int not null identity(1, 1) primary key,
alt_id int not null foreign key references Users(id),
last_sign_in_id int null foreign key references DWLastSignIn(id),
gender_id int null foreign key references DWGender(id),
rated_id int null foreign key references DWUserRated(id),
following_count int not null,
followers_count int not null,
);