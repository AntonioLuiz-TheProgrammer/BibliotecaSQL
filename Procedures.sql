DELIMITER $$

CREATE PROCEDURE RegistrarLivro (IN p_ISBN int, IN p_Titulo varchar(255), IN p_Sinopse varchar(255),
 IN p_NumeroDePaginas int, IN p_BestSeller bit, IN p_Endereco varchar(255), IN p_NomeEditora varchar(255),
 IN p_NomeAutor varchar(255), IN p_NomeCategoria varchar(255))
BEGIN
		declare varID_Livros int;
        declare varID_Autor int;
        declare varID_Editora int;
        declare varID_Categoria int;
        
		if not exists (select 1 from Livros where ISBN = p_ISBN) then
			insert into Livros(ISBN, Titulo, Sinopse, NumeroDePaginas, BestSeller) 
            values(p_ISBN, p_Titulo, p_Sinopse, p_NumeroDePaginas, p_BestSeller);
		end if;
        
		if not exists (select 1 from Editora where NomeEditora = p_NomeEditora) then
			insert into Editora(NomeEditora, Endereco)
            values(p_NomeEditora, p_Endereco);
        end if;
        
        if not exists (select 1 from Autor where NomeAutor = p_NomeAutor) then
			insert into Autor(NomeAutor)
            values(p_NomeAutor);
		end if;
        
		if not exists (select 1 from Categoria where NomeCategoria = p_NomeCategoria) then
			insert into Categoria(NomeCategoria)
            values(p_NomeCategoria);
		end if;
        
        select ID_Livros into varID_Livros from Livros where ISBN = p_ISBN;
        select ID_Autor into varID_Autor from Autor where NomeAutor = p_NomeAutor;
        select ID_Editora into varID_Editora from Editora where NomeEditora = p_NomeEditora;
        select ID_Categoria into varID_Categoria from Categoria where NomeCategoria = p_NomeCategoria;
        
        insert into livro_autor(ID_Livro, ID_Autor)
        values(varID_Livros, varID_Autor);
        
        insert into livro_Editora(ID_Livro, ID_Editora)
        values(varID_Livros, varID_Editora);
        
        insert into livro_Categoria(ID_Livro, ID_Categoria)
        values(varID_Livros, varID_Categoria);
	
END $$

DELIMITER ;

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
	
    
       -- Decrementa a quantidade do exemplar
        UPDATE Exemplar
        SET Quantidade = Quantidade - 1
        WHERE ID_Exemplar = p_ID_Exemplar;

    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Exemplar, Cliente ou Funcionario não encontrado.';
    END IF;
    
    
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

DELIMITER $$

CREATE PROCEDURE AdicionarExemplar (
    IN p_ID_Livro INT,
    IN p_Quantidade INT
)
BEGIN
    IF EXISTS (SELECT 1 FROM Exemplar WHERE ID_Livros = p_ID_Livro) THEN
        UPDATE Exemplar
        SET Quantidade = Quantidade + p_Quantidade
        WHERE ID_Livros = p_ID_Livro;
    ELSE
        INSERT INTO Exemplar (ID_Livros, Quantidade)
        VALUES (p_ID_Livro, p_Quantidade);
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE DevolverLivro (
    IN p_ID_Emprestimo INT
)
BEGIN
    DECLARE v_ID_Exemplar INT;

    SELECT ID_Exemplar INTO v_ID_Exemplar FROM Emprestimo WHERE ID_Emprestimo = p_ID_Emprestimo;

    UPDATE Exemplar
    SET Quantidade = Quantidade + 1
    WHERE ID_Exemplar = v_ID_Exemplar;

    UPDATE Emprestimo
    SET Ativo = 0
    WHERE ID_Emprestimo = p_ID_Emprestimo;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE PagarMulta (
    IN p_ID_Multa INT
)
BEGIN
    UPDATE Multa
    SET Ativo = 0
    WHERE ID_Multa = p_ID_Multa;
END$$

DELIMITER ;


DELIMITER $$

-- buscar livro
CREATE PROCEDURE BuscarLivro (
    IN p_TituloBusca VARCHAR(255)
)
BEGIN
    SELECT * FROM Livros
    WHERE Titulo LIKE CONCAT('%', p_TituloBusca, '%');
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE ListarEmprestimosAtivosPorCliente (
    IN p_ID_Cliente INT
)
BEGIN
    SELECT E.ID_Emprestimo, L.Titulo, Ex.ID_Exemplar, E.DataInicio, E.DataFim
    FROM Emprestimo E
    JOIN Exemplar Ex ON E.ID_Exemplar = Ex.ID_Exemplar
    JOIN Livros L ON Ex.ID_Livros = L.ID_Livros
    WHERE E.ID_Cliente = p_ID_Cliente AND E.Ativo = 1;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE AdicionarSaldoCliente (
    IN p_ID_Cliente INT,
    IN p_Valor FLOAT(7,2)
)
BEGIN
    IF p_Valor <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Valor inválido para adicionar saldo.';
    ELSE
        UPDATE Cliente
        SET Saldo = Saldo + p_Valor
        WHERE ID_Cliente = p_ID_Cliente;
    END IF;
END$$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE ComprarLivro (
    IN p_ID_Livro INT,
    IN p_ID_Cliente INT
)
BEGIN
    DECLARE v_preco FLOAT;
    DECLARE v_saldo FLOAT;

    SELECT Preco INTO v_preco FROM Livros WHERE ID_Livros = p_ID_Livro;
    SELECT Saldo INTO v_saldo FROM Cliente WHERE ID_Cliente = p_ID_Cliente;

    IF v_preco IS NULL OR v_saldo IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cliente ou livro não encontrado.';
    ELSEIF v_saldo < v_preco THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Saldo insuficiente para compra.';
    ELSE
        UPDATE Cliente SET Saldo = Saldo - v_preco WHERE ID_Cliente = p_ID_Cliente;
    END IF;
END$$

DELIMITER ;
