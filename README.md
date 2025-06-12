#  Sistema de Gerenciamento de Biblioteca (Projeto Acadêmico)

Este repositório contém um projeto de **sistema de gerenciamento de biblioteca**, desenvolvido como parte de um trabalho acadêmico.  
O objetivo principal foi aplicar conceitos de **bancos de dados relacionais**, incluindo a criação de tabelas, relacionamentos, *stored procedures* e *triggers* para automatizar e validar operações no banco de dados.

---

## 🎲 Estrutura do Banco de Dados

O banco de dados, chamado `Biblioteca`, foi projetado para gerenciar livros, autores, editoras, clientes, funcionários, exemplares e as operações de empréstimo e reserva.
---



## 📚 Tabelas

- `Livros`: ISBN, Título, Sinopse, Número de Páginas, BestSeller  
- `Editora`: Nome, Endereço  
- `Autor`: Nome do autor  
- `Categoria`: Categoria dos livros  
- `Cliente`: Nome, Email, CPF  
- `Funcionario`: Nome, Email, CPF, Salário  
- `Exemplar`: Detalhes das cópias físicas e quantidade disponível  
- `Reserva`: Reservas de exemplares por clientes  
- `Emprestimo`: Informações sobre empréstimos  
- `Multa`: Gerenciamento de multas associadas aos empréstimos  
- `Livro_Autor`: Relaciona Livros e Autores (N:N)  
- `Livro_Editora`: Relaciona Livros e Editoras (N:1)  
- `Livro_Categoria`: Relaciona Livros e Categorias (N:N)

---



## 🔎 Stored Procedures

As *stored procedures* foram criadas para encapsular regras de negócio e facilitar a manipulação de dados.

- `RegistrarLivro`: Registra um livro com seus autores, editoras e categorias, evitando duplicidades  
- `RegistrarCliente`: Cadastra cliente, validando CPF único  
- `RegistrarFuncionario`: Cadastra funcionário com CPF validado  
- `EfetuarEmprestimo`: Registra empréstimo, define datas e ajusta quantidade disponível  
- `EfetuarReserva`: Cria uma reserva com controle de data e quantidade  
- `AdicionarExemplar`: Adiciona novos exemplares a um livro  
- `DevolverLivro`: Processa devolução e atualiza quantidade disponível  
- `PagarMulta`: Marca multa como paga  
- `BuscarLivro`: Retorna livros com título parcial correspondente  
- `ListarEmprestimosAtivosPorCliente`: Lista empréstimos ativos de um cliente  
- `AdicionarSaldoCliente`: Adiciona saldo à conta do cliente (valor positivo)  
- `ComprarLivro`: Simula compra de livro, debita saldo, valida dados e saldo

---



## ⚙️ Triggers

As *triggers* foram implementadas para garantir integridade e regras de negócio:

- `evitar_reducao_salario`: Impede salário abaixo do mínimo para novos funcionários  
- `padronizar_titulo_livro`: Padroniza títulos (capitalização e espaços)  
- `VerificarExemplar`: Evita que a quantidade de exemplares fique negativa  
- `LimitarEmprestimo`: Limita cliente a um empréstimo ativo por vez  
- `evitar_email_cliente_repetido`: Bloqueia e-mails duplicados para clientes  
- `validar_paginas_livro`: Exige número de páginas maior que zero  
- `impedir_reserva_exemplar_zerado`: Impede reserva sem exemplares disponíveis  
- `gerar_multa_automaticamente`: Cria multa por atraso na devolução, com cálculo automático  
- `validar_CPF_funcionario`: Garante CPF com exatamente 11 dígitos numéricos

---
