load data 
infile "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\denormalized_movie_db.csv"
into table denormalized
columns terminated by ';';

show variables like "secure_file_priv";

insert into movies(movie_id,title,ranking,rating,year,votes,duration,oscars,budget)
select distinct movie_id,title,ranking,rating,year,votes,duration,oscars,budget
from denormalized;

insert into genres(movie_id,genre_name)
select distinct movie_id,genre_name
from denormalized;

insert into languages(movie_id,language_name)
select distinct movie_id,language_name
from denormalized;





