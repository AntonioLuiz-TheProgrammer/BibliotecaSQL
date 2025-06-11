
DELIMITER $$

-- Se o salário do funcionário for menor que o salário minimo, impede a atualização

CREATE TRIGGER evitar_reducao_salario
BEFORE insert ON Funcionario
FOR EACH ROW
BEGIN
    IF NEW.Salario < 1518.00 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Não é permitido o salário de um funcionário ser menor que o salário minimo.';
    END IF;
END$$

DELIMITER ;


DELIMITER $$
-- Impede o numero de exemplares ser negativo
create TRIGGER VerificarExemplar
BEFORE update on Exemplar
for each row
begin
	 IF NEW.Quantidade < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Não há exemplares disponíveis.';
    END IF;
    
end $$

DELIMITER ;


DELIMITER $$
-- Limita a um emprestimo ativo por cliente
CREATE TRIGGER LimitarEmprestimo
BEFORE insert ON Emprestimo
FOR EACH ROW
BEGIN
    IF  exists (select 1 from Emprestimo where ID_Cliente = new.ID_Cliente )
		and exists (select 1 from Emprestimo where ativo = 1 ) then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Não é permitido mais de um emprestimo.';
    END IF;
END$$

DELIMITER ;


-- Trigger 2: essa trigger é responsável por padronizar o formato do título do livro, tirando espaços em brancos no incio e fim, e tambem garantindo a primeira letra do titulo ser maiuscula 
DELIMITER $$

CREATE TRIGGER padronizar_titulo_livro
BEFORE INSERT ON Livros
FOR EACH ROW
BEGIN
    SET NEW.Titulo = TRIM(NEW.Titulo);
    
    IF LENGTH(NEW.Titulo) > 0 THEN
        SET NEW.Titulo = CONCAT(UPPER(SUBSTRING(NEW.Titulo, 1, 1)), LOWER(SUBSTRING(NEW.Titulo, 2)));
    END IF;
END$$

DELIMITER ;

-- evitar email repetido 

DELIMITER $$

CREATE TRIGGER evitar_email_cliente_repetido
BEFORE INSERT ON Cliente
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM Cliente WHERE EmailCliente = NEW.EmailCliente) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: E-mail já cadastrado.';
    END IF;
END$$

DELIMITER ;


DELIMITER $$


-- Impedir cadastro de livro com páginas negativas
CREATE TRIGGER validar_paginas_livro
BEFORE INSERT ON Livros
FOR EACH ROW
BEGIN
    IF NEW.NumeroDePaginas <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Número de páginas inválido.';
    END IF;
END$$

DELIMITER ;

 -- Detectar tentativa de reserva com exemplar esgotado

 DELIMITER $$

CREATE TRIGGER impedir_reserva_exemplar_zerado
BEFORE INSERT ON Reserva
FOR EACH ROW
BEGIN
    DECLARE qtd INT;
    SELECT Quantidade INTO qtd FROM Exemplar WHERE ID_Exemplar = NEW.ID_Exemplar;

    IF qtd <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Exemplar esgotado.';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER gerar_multa_automaticamente
AFTER UPDATE ON Emprestimo
FOR EACH ROW
BEGIN
    DECLARE dias_atraso INT;
    DECLARE valor_multa FLOAT;

    IF OLD.Ativo = 1 AND NEW.Ativo = 0 THEN
        SET dias_atraso = DATEDIFF(CURDATE(), OLD.DataFim);

        IF dias_atraso > 0 THEN
            SET valor_multa = dias_atraso * 2.00;

            INSERT INTO Multa (ID_Cliente, ID_Emprestimo, Valor, Ativo)
            VALUES (OLD.ID_Cliente, OLD.ID_Emprestimo, valor_multa, 1);
        END IF;
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER validar_CPF_funcionario
BEFORE INSERT ON Funcionario
FOR EACH ROW
BEGIN
    IF LENGTH(NEW.CPF) <> 11 OR NEW.CPF REGEXP '[^0-9]' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CPF inválido: deve conter exatamente 11 números.';
    END IF;
END$$

DELIMITER ;
