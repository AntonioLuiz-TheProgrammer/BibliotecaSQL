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


DELIMITER $$

CREATE PROCEDURE EfetuarEmprestimo (
    IN p_ID_Exemplar INT,
    IN p_ID_Cliente INT,
    IN p_ID_Funcionario INT
)
BEGIN
    -- Verifica existência do exemplar, cliente e funcionário
    IF EXISTS (SELECT 1 FROM Exemplar WHERE ID_Exemplar = p_ID_Exemplar)
       AND EXISTS (SELECT 1 FROM Cliente WHERE ID_Cliente = p_ID_Cliente)
       AND EXISTS (SELECT 1 FROM Funcionario WHERE ID_Funcionario = p_ID_Funcionario) THEN

        -- Insere o empréstimo com data início hoje, data fim daqui 15 dias e ativo = 1
        INSERT INTO Emprestimo (ID_Exemplar, ID_Cliente, ID_Funcionario, DataInicio, DataFim, Ativo)
        VALUES (
            p_ID_Exemplar,
            p_ID_Cliente,
            p_ID_Funcionario,
            CURDATE(),
            DATE_ADD(CURDATE(), INTERVAL 15 DAY),
            1
        );

        -- Decrementa a quantidade do exemplar
        UPDATE Exemplar
        SET Quantidade = Quantidade - 1
        WHERE ID_Exemplar = p_ID_Exemplar;

    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Exemplar, Cliente ou Funcionario não encontrado.';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE EfetuarReserva (
    IN p_ID_Exemplar INT,
    IN p_ID_Cliente INT,
    IN p_ID_Funcionario INT
)
BEGIN
    -- Verifica existência do exemplar, cliente e funcionário
    IF EXISTS (SELECT 1 FROM Exemplar WHERE ID_Exemplar = p_ID_Exemplar)
       AND EXISTS (SELECT 1 FROM Cliente WHERE ID_Cliente = p_ID_Cliente)
       AND EXISTS (SELECT 1 FROM Funcionario WHERE ID_Funcionario = p_ID_Funcionario) THEN

        -- Insere a reserva com data início hoje e data fim daqui 15 dias
        INSERT INTO Reserva (ID_Exemplar, ID_Cliente, ID_Funcionario, DataInicio, DataFim)
        VALUES (
            p_ID_Exemplar,
            p_ID_Cliente,
            p_ID_Funcionario,
            CURDATE(),
            DATE_ADD(CURDATE(), INTERVAL 15 DAY)
        );

        -- Decrementa a quantidade do exemplar
        UPDATE Exemplar
        SET Quantidade = Quantidade - 1
        WHERE ID_Exemplar = p_ID_Exemplar;

    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Exemplar, Cliente ou Funcionario não encontrado.';
    END IF;
END$$

DELIMITER ;
