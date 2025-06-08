create database  Biblioteca;
use Biblioteca;

create table Livros (
	ID_Livros int  primary key auto_increment,
    ISBN int unique,
    Titulo varchar(255),
    Sinopse varchar(255),
    NumeroDePaginas int,
    BestSeller bit
    );

create table Editora(
	ID_Editora int primary key auto_increment,
    NomeEditora varchar(255),
    Endereco varchar(255));
    
create table Autor(
	ID_Autor int primary key auto_increment,
    NomeAutor varchar(255)
);

create table Categoria(
	ID_Categoria int primary key auto_increment,
    NomeCategoria varchar(255)
);

create table Cliente(
	ID_Cliente int primary key auto_increment,
    NomeCliente varchar(255),
    EmailCliente varchar(255),
    CPF char(11) unique
);

create table Funcionario(
	ID_Funcionario int primary key auto_increment,
	NomeFuncionario varchar(255),
    EmailFuncionario varchar(255),
    CPF char(11) unique,
    Salario float(7,2)
);

create table Exemplar(
	ID_Exemplar int primary key auto_increment,
    ID_Livros int,
    foreign key (ID_Livros) references Livros(ID_Livros) on update cascade on delete restrict,
    Quantidade int
);

create table Reserva(
	ID_Reserva int primary key auto_increment,
    ID_Exemplar int,
    foreign key (ID_Exemplar) references Exemplar(ID_Exemplar),
    ID_Cliente int,
    foreign key (ID_Cliente) references Cliente(ID_Cliente),
    ID_Funcionario int,
    foreign key (ID_Funcionario) references Funcionario(ID_Funcionario),
    DataInicio date,
    DataFim date
);

create table Emprestimo(
	ID_Emprestimo int primary key auto_increment,
    ID_Exemplar int,
    foreign key (ID_Exemplar) references Exemplar(ID_Exemplar),
    ID_Cliente int,
    foreign key (ID_Cliente) references Cliente(ID_Cliente),
    ID_Funcionario int,
    foreign key (ID_Funcionario) references Funcionario(ID_Funcionario),
    DataInicio date,
    DataFim date,
    Ativo bit
);

CREATE TABLE Livro_Autor (
	ID_Livro_Autor INT PRIMARY KEY AUTO_INCREMENT,
    ID_Livros INT,
    FOREIGN KEY (ID_Livros) REFERENCES Livros(ID_Livros),
    ID_Autor INT,
    FOREIGN KEY (ID_Autor) REFERENCES Autor(ID_Autor)
);

CREATE TABLE Livro_Editora (
	ID_Livro_Editora INT PRIMARY KEY AUTO_INCREMENT,
    ID_Livros INT,
    FOREIGN KEY (ID_Livros) REFERENCES Livros(ID_Livros),
    ID_Editora INT,
    FOREIGN KEY (ID_Editora) REFERENCES Editora(ID_Editora)
);

CREATE TABLE Livro_Categoria (
	ID_Livro_Categoria INT PRIMARY KEY AUTO_INCREMENT,
    ID_Livros INT,
    FOREIGN KEY (ID_Livros) REFERENCES Livros(ID_Livros),
    ID_Categoria INT,
    FOREIGN KEY (ID_Categoria) REFERENCES Categoria(ID_Categoria)
);

create table Multa(
	ID_Multa int primary  key auto_increment,
    ID_Cliente int, 
    foreign key (ID_Cliente) references Cliente(ID_Cliente) on update cascade on delete restrict,
    ID_Emprestimo int,
    foreign key (ID_Emprestimo) references Emprestimo(ID_Emprestimo) on update cascade on delete restrict,
    Valor float (6,2),
    ativo bit
);
