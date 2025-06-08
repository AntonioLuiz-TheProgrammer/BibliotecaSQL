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


DELIMITER $$

CREATE PROCEDURE RegistrarCliente (
    IN p_NomeCliente VARCHAR(255),
    IN p_EmailCliente VARCHAR(255),
    IN p_CPF CHAR(11)
)
BEGIN
    -- Verifica se já existe um cliente com o CPF informado
    IF NOT EXISTS (SELECT 1 FROM Cliente WHERE CPF = p_CPF) THEN
        INSERT INTO Cliente (NomeCliente, EmailCliente, CPF)
        VALUES (p_NomeCliente, p_EmailCliente, p_CPF);
    END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE RegistrarFuncionario (
    IN p_NomeFuncionario VARCHAR(255),
    IN p_EmailFuncionario VARCHAR(255),
    IN p_CPF CHAR(11),
    IN p_Salario FLOAT(7,2)
)
BEGIN
    -- Verifica se já existe um funcionário com o CPF informado
    IF NOT EXISTS (SELECT 1 FROM Funcionario WHERE CPF = p_CPF) THEN
        INSERT INTO Funcionario (NomeFuncionario, EmailFuncionario, CPF, Salario)
        VALUES (p_NomeFuncionario, p_EmailFuncionario, p_CPF, p_Salario);
    END IF;
END $$

DELIMITER ;
