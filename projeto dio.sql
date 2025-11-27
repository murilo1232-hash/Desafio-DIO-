CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;
CREATE TABLE cliente(
idCliente INT PRIMARY KEY AUTO_INCREMENT,
    NomeCompleto VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Endereco VARCHAR(500)
);
CREATE TABLE cliente_PF(
    idCliente INT PRIMARY KEY,
    CPF CHAR(11) UNIQUE NOT NULL,
    DataNascimento DATE,
    FOREIGN KEY (idCliente) REFERENCES CLIENTE(idCliente)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
CREATE TABLE cliente_PJ(
    idCliente INT PRIMARY KEY,
    CNPJ CHAR(15) UNIQUE NOT NULL,
    RazaoSocial VARCHAR(255) NOT NULL,
    NomeFantasia VARCHAR(255),
    FOREIGN KEY (idCliente) REFERENCES CLIENTE(idCliente)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
CREATE TABLE pagamento(
    idPagamento INT PRIMARY KEY AUTO_INCREMENT,
    idCliente INT NOT NULL,
    TipoPagamento ENUM('Cartão', 'Boleto', 'Pix') NOT NULL,
    Detalhes VARCHAR(255),
    FOREIGN KEY (idCliente) REFERENCES CLIENTE(idCliente)
);
CREATE TABLE produto(
    idProduto INT PRIMARY KEY AUTO_INCREMENT,
    NomeProduto VARCHAR(255) NOT NULL,
    Categoria ENUM('Eletrônico', 'Vestuário', 'Alimentos', 'Móveis') NOT NULL,
    Valor DECIMAL(10, 2) NOT NULL DEFAULT 0.00
);
CREATE TABLE pedido(
    idPedido INT PRIMARY KEY AUTO_INCREMENT,
    idCliente INT NOT NULL,
    StatusPedido ENUM('Cancelado', 'Confirmado', 'Em Processamento') DEFAULT 'Em Processamento',
    Descricao TEXT,
    Frete DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (idCliente) REFERENCES CLIENTE(idCliente)
);
CREATE TABLE entrega(
    idPedido INT PRIMARY KEY,
    StatusEntrega VARCHAR(100) NOT NULL,
    CodigoRastreio VARCHAR(50) UNIQUE NOT NULL,
    DataPrevistaEntrega DATE,
    FOREIGN KEY (idPedido) REFERENCES PEDIDO(idPedido)
        ON DELETE CASCADE
);
CREATE TABLE fornecedor(
    idFornecedor INT PRIMARY KEY AUTO_INCREMENT,
    CNPJ CHAR(15) UNIQUE NOT NULL,
    RazaoSocial VARCHAR(255) NOT NULL,
    Contato VARCHAR(15)
);
CREATE TABLE vendedor (
    idVendedor INT PRIMARY KEY AUTO_INCREMENT,
    RazaoSocial VARCHAR(255) NOT NULL,
    CNPJ CHAR(15) UNIQUE,
    CPF CHAR(11) UNIQUE,
    Localizacao VARCHAR(255)
);
CREATE TABLE estoque(
    idEstoque INT PRIMARY KEY AUTO_INCREMENT,
    Localizacao VARCHAR(255) NOT NULL
);
CREATE TABLE produto_pedido(
    idPP_Produto INT,
    idPP_Pedido INT,
    Quantidade INT NOT NULL DEFAULT 1,
    StatusEnvio ENUM('Disponível', 'Sem Estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idPP_Produto, idPP_Pedido),
    FOREIGN KEY (idPP_Produto) REFERENCES PRODUTO(idProduto),
    FOREIGN KEY (idPP_Pedido) REFERENCES PEDIDO(idPedido)
);
CREATE TABLE produto_fornecedor(
    idPF_Produto INT,
    idPF_Fornecedor INT,
    Quantidade INT NOT NULL,
    PRIMARY KEY (idPF_Produto, idPF_Fornecedor),
    FOREIGN KEY (idPF_Produto) REFERENCES PRODUTO(idProduto),
    FOREIGN KEY (idPF_Fornecedor) REFERENCES FORNECEDOR(idFornecedor)
);
CREATE TABLE produto_estoque (
    idPE_Produto INT,
    idPE_Estoque INT,
    Quantidade INT NOT NULL,
    PRIMARY KEY (idPE_Produto, idPE_Estoque),
    FOREIGN KEY (idPE_Produto) REFERENCES PRODUTO(idProduto),
    FOREIGN KEY (idPE_Estoque) REFERENCES ESTOQUE(idEstoque)
);
CREATE TABLE produto_vendedor (
    idPV_Produto INT,
    idPV_Vendedor INT,
    Quantidade INT NOT NULL,
    PRIMARY KEY (idPV_Produto, idPV_Vendedor),
    FOREIGN KEY (idPV_Produto) REFERENCES PRODUTO(idProduto),
    FOREIGN KEY (idPV_Vendedor) REFERENCES VENDEDOR(idVendedor)
);
INSERT INTO CLIENTE (NomeCompleto, Email, Endereco) VALUES
('João Silva', 'joao@email.com', 'Rua A, 100, SP'),
('Maria Souza', 'maria@email.com', 'Av. B, 200, RJ'),
('Tech Solutions Ltda', 'techsol@email.com', 'Rua C, 300, MG'),
('Pedro Almeida', 'pedro@email.com', 'Travessa D, 400, BA');

INSERT INTO CLIENTE_PF (idCliente, CPF, DataNascimento) VALUES
(1, '11122233344', '1990-05-15'),
(2, '55566677788', '1985-11-20'),
(4, '99900011122', '2000-01-01');

INSERT INTO CLIENTE_PJ (idCliente, CNPJ, RazaoSocial, NomeFantasia) VALUES
(3, '123456789012345', 'Tech Solutions Comercio EIRELI', 'Tech Sol');

INSERT INTO PRODUTO (NomeProduto, Categoria, Valor) VALUES
('Smartphone X', 'Eletrônico', 1500.00),
('Camiseta Algodão', 'Vestuário', 50.00),
('Sofá 3 Lugares', 'Móveis', 3200.00),
('Monitor Gamer 27', 'Eletrônico', 950.00),
('Arroz 5kg', 'Alimentos', 25.00);

INSERT INTO ESTOQUE (Localizacao) VALUES
('São Paulo - Central'),
('Rio de Janeiro - Filial');

INSERT INTO FORNECEDOR (CNPJ, RazaoSocial, Contato) VALUES
('111111111111111', 'Eletro Mega Fornecedora', '987654321'),
('222222222222222', 'Texteis RJ', '999887766');

INSERT INTO PRODUTO_ESTOQUE (idPE_Produto, idPE_Estoque, Quantidade) VALUES
(1, 1, 80),
(2, 2, 450),
(3, 1, 5);

INSERT INTO PEDIDO (idCliente, StatusPedido, Frete) VALUES
(1, 'Confirmado', 35.00),
(2, 'Em Processamento', 12.50),
(3, 'Confirmado', 80.00),
(1, 'Cancelado', 20.00);

INSERT INTO PAGAMENTO (idCliente, TipoPagamento, Detalhes) VALUES
(1, 'Cartão', 'Visa Final 1234'),
(1, 'Pix', 'Chave Joao@email.com'),
(3, 'Boleto', 'Vencimento 2026-01-01');

INSERT INTO ENTREGA (idPedido, StatusEntrega, CodigoRastreio, DataPrevistaEntrega) VALUES
(1, 'Em Transporte', 'BR123456789BR', '2025-12-10'),
(2, 'Preparando Envio', 'BR987654321BR', '2025-12-15'),
(3, 'Entregue', 'BR111222333BR', '2025-12-01');

INSERT INTO PRODUTO_PEDIDO (idPP_Produto, idPP_Pedido, Quantidade) VALUES
(1, 1, 1),
(2, 2, 5),
(3, 3, 1),
(4, 3, 2),
(5, 1, 3);

INSERT INTO PRODUTO_ESTOQUE (idPE_Produto, idPE_Estoque, Quantidade) VALUES
(1, 1, 80),
(2, 2, 450),
(3, 1, 5);

INSERT INTO PRODUTO_VENDEDOR (idPV_Produto, idPV_Vendedor, Quantidade) VALUES
(1, 1, 50),
(2, 2, 100),
(4, 3, 20);

-- A pedidos foram feitos por cada cliente?
-- B Algum vendedor também é fornecedor?
-- C Relação de produtos fornecedores e estoques;
-- D Relação de nomes dos fornecedores e nomes dos produtos;

SELECT -- A pedidos foram feitos por cada cliente?
    C.NomeCompleto,
    COUNT(P.idPedido) AS TotalPedidosFeitos,
    -- Calcula o valor total (Preço do Produto * Quantidade) + Frete
    SUM(Prod.Valor * PP.Quantidade + P.Frete) AS ValorTotalGasto,
    CASE
        WHEN COUNT(P.idPedido) >= 2 THEN 'Cliente Fidelidade'
        ELSE 'Cliente Novo'
    END AS Categoria_Cliente_Compra
FROM
    CLIENTE C
INNER JOIN
    PEDIDO P ON C.idCliente = P.idCliente
INNER JOIN
    PRODUTO_PEDIDO PP ON P.idPedido = PP.idPP_Pedido
INNER JOIN
    PRODUTO Prod ON PP.idPP_Produto = Prod.idProduto
WHERE
    P.StatusPedido <> 'Cancelado'
GROUP BY
    C.NomeCompleto
ORDER BY
    ValorTotalGasto DESC;
    
SELECT -- B Algum vendedor também é fornecedor?
    V.RazaoSocial AS Vendedor,
    F.RazaoSocial AS Fornecedor,
    V.CNPJ
FROM
    VENDEDOR V
INNER JOIN
    FORNECEDOR F ON V.CNPJ = F.CNPJ;
    

SELECT -- C Relação de produtos fornecedores e estoques;
    Prod.NomeProduto,
    F.RazaoSocial AS FornecedorPrincipal,
    PE.Quantidade AS QtdEmEstoque,
    E.Localizacao AS LocalEstoque
FROM
    PRODUTO Prod
INNER JOIN
    PRODUTO_FORNECEDOR PF ON Prod.idProduto = PF.idPF_Produto
INNER JOIN
    FORNECEDOR F ON PF.idPF_Fornecedor = F.idFornecedor
LEFT JOIN -- Usamos LEFT JOIN para listar o produto mesmo que não esteja em estoque
    PRODUTO_ESTOQUE PE ON Prod.idProduto = PE.idPE_Produto
LEFT JOIN
    ESTOQUE E ON PE.idPE_Estoque = E.idEstoque
ORDER BY
    Prod.NomeProduto;
    
    
SELECT -- D Relação de nomes dos fornecedores e nomes dos produtos;
    F.RazaoSocial AS NomeFornecedor,
    P.NomeProduto
FROM
    PRODUTO_FORNECEDOR PF
INNER JOIN
    FORNECEDOR F ON PF.idPF_Fornecedor = F.idFornecedor
INNER JOIN
    PRODUTO P ON PF.idPF_Produto = P.idProduto
ORDER BY
    NomeFornecedor, P.NomeProduto;


