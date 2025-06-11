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