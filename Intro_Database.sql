-- Introdução a Banco de Dados - SQL Server : Criando IntroDB

CREATE DATABASE [IntroDB]
 ON  PRIMARY 
( NAME = N'IntroDB', FILENAME = N'C:\MSSQL_Data\IntroDB.mdf' , SIZE = 20480KB , FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'IntroDB_log', FILENAME = N'C:\MSSQL_Data\IntroDB_log.ldf' , SIZE = 20480KB , FILEGROWTH = 65536KB )
 WITH LEDGER = OFF
GO
