-- Databricks notebook source
-- TABELA COM DIAS DE VENDAS (2018-01-01 ATÉ 2018-02-15) PARA VER SE TEVE VENDA NESSE PERIODO
-- SE A PESSOA ESTIVER NESSA BASE SIGNIFICA QUE ELA NÃO DEU CHURN


WITH tb_activate AS (

    SELECT idVendedor,
           MIN(date(dtPedido)) AS dtAtivacao
   
    FROM silver.olist.pedido t1

    LEFT JOIN silver.olist.item_pedido t2
    ON t1.idPedido = t2.idPedido 

    WHERE t1.dtPedido >= '2018-01-01'
    AND t1.dtPedido <= date_add('2018-01-01', 45)
    AND idVendedor IS NOT NULL

    GROUP BY 1
)

    SELECT t1.*,
           t2.*,
           t3.*,
           t4.*,
           t5.*,
           t5.*,
           t6.*,
           CASE WHEN t7.idVendedor IS NULL THEN 1 ELSE 0 END AS flChurn
           
    FROM silver.analytics.fs_vendedor_vendas t1
    
    LEFT JOIN silver.analytics.fs_vendedor_avaliacao t2
    ON t1.idVendedor = t2.idVendedor
    AND t1.dtReference = t2.dtReference
    
    LEFT JOIN silver.analytics.fs_vendedor_cliente t3
    ON t1.idVendedor = t3.idVendedor
    AND t1.dtReference = t3.dtReference
    
    
    LEFT JOIN silver.analytics.fs_vendedor_entrega t4
    ON t1.idVendedor = t4.idVendedor
    AND t1.dtReference = t4.dtReference
    
    LEFT JOIN silver.analytics.fs_vendedor_pagamentos t5
    ON t1.idVendedor = t5.idVendedor
    AND t1.dtReference = t5.dtReference
    
    LEFT JOIN silver.analytics.fs_vendedor_produto t6
    ON t1.idVendedor = t6.idVendedor
    AND t1.dtReference = t6.dtReference
    
    LEFT JOIN tb_activate t7
    ON t1.idVendedor = t7.idVendedor
    AND DATEDIFF(t7.dtAtivacao, t1.dtReference) + t1.qtdRecencia <= 45
    
    WHERE t1.qtdRecencia <=45
