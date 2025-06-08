create database  Biblioteca;
use Biblioteca;

create table Livros (
	ID_Livros int  primary key,
    ISBN int unique,
    Titulo varchar(255),
    Sinopse varchar(255),
    NumeroDePaginas int);

show columns from Livros;