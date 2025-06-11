DELIMITER $$
-- Se o novo salário do funcionário for menor que o antigo, impede a atualização
CREATE TRIGGER evitar_reducao_salario
BEFORE UPDATE ON Funcionario
FOR EACH ROW
BEGIN
    IF NEW.Salario < OLD.Salario THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Erro: Não é permitido reduzir o salário de um funcionário.';
    END IF;
END$$

DELIMITER ;
