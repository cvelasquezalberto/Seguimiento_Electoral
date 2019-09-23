USE [BD_REPORTE_OPERACIONAL]
GO
/****** Object:  StoredProcedure [Maestro].[Usp_Sel_Reporte]    Script Date: 14/11/2018 11:22:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [Maestro].[Usp_Sel_Reporte]
AS
BEGIN
	SET NOCOUNT ON

	SELECT   IdReporte			AS IdReporte
			,UPPER(Descripcion)	AS Descripcion
			,IdSubProceso
	FROM Maestro.Reporte 

	SET NOCOUNT OFF
END