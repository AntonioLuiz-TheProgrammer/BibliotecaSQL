-- Trigger 1: Se o novo salário do funcionário for menor que o antigo, impede a atualização, garantindo que o novo salario do funcionario seja obrigatoriamente maior que o salario antigo
DELIMITER $$

CREATE TRIGGER evitar_reducao_salario
BEFORE UPDATE ON Funcionario
FOR EACH ROW
BEGIN
    IF NEW.Salario < OLD.Salario THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Não é permitido reduzir o salário de um funcionário.';
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
