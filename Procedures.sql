CREATE PROCEDURE RegistrarLivro (IN ISBN int, Titulo varchar(255), Sinopse varchar(255),
 NumeroDePaginas int, BestSeller bit, Endereco varchar(255),  NomeEditora varchar(255),
 NomeAutor varchar(255), NomeCategoria varchar(255))
BEGIN

		if ISBN not in (Livros) then
			insert into Livros values(ISBN, Titulo, Sinopse, NumeroDePaginas, BestSeller);
            
		if NomeEditora not in (Editora) then
			insert into Editora values(NomeEditora, Endereco);
        
        if NomeAutor not in  (Autor) then
			insert into Autor values(NomeAutor);
            
		if NomeCategoria not in (NomeCategoria) then
			insert into Categoria values(NomeCategoria);
	
	
END
