CREATE DATABASE [BD_ERP_SEGURIDAD]
GO
USE [BD_ERP_SEGURIDAD]
GO

/****** Object:  Schema [Auditoria]    Script Date: 11/08/2018 07:45:58 p.m. ******/
CREATE SCHEMA [Auditoria]
GO
/****** Object:  Schema [Estructura]    Script Date: 11/08/2018 07:45:58 p.m. ******/
CREATE SCHEMA [Estructura]
GO
/****** Object:  Schema [Seguridad]    Script Date: 11/08/2018 07:45:58 p.m. ******/
CREATE SCHEMA [Seguridad]
GO
/****** Object:  UserDefinedTableType [Seguridad].[TypeEmpresaAplicacion]    Script Date: 11/08/2018 07:45:58 p.m. ******/
CREATE TYPE [Seguridad].[TypeEmpresaAplicacion] AS TABLE(
	[IdEmpresa] [int] NOT NULL,
	[IdAplicacion] [int] NOT NULL
)
GO
/****** Object:  UserDefinedTableType [Seguridad].[TypePaginaAccion]    Script Date: 11/08/2018 07:45:59 p.m. ******/
CREATE TYPE [Seguridad].[TypePaginaAccion] AS TABLE(
	[IdPaginaAccion] [int] NOT NULL,
	[IdPagina] [int] NOT NULL,
	[IdAccion] [int] NOT NULL,
	[ChkAgregar] [bit] NOT NULL
)
GO
/****** Object:  UserDefinedTableType [Seguridad].[TypePaginaGrupo]    Script Date: 11/08/2018 07:45:59 p.m. ******/
CREATE TYPE [Seguridad].[TypePaginaGrupo] AS TABLE(
	[IdPaginaAccion] [int] NOT NULL,
	[IdPagina] [int] NOT NULL,
	[IdGrupo] [int] NOT NULL
)
GO
/****** Object:  UserDefinedTableType [Seguridad].[TypePermisoPerfil]    Script Date: 11/08/2018 07:45:59 p.m. ******/
CREATE TYPE [Seguridad].[TypePermisoPerfil] AS TABLE(
	[IdEmpresa] [int] NOT NULL,
	[IdAplicacion] [int] NOT NULL,
	[IdModulo] [int] NOT NULL,
	[IdPagina] [int] NOT NULL,
	[IdAccion] [int] NOT NULL,
	[IdRol] [int] NOT NULL
)
GO
/****** Object:  UserDefinedTableType [Seguridad].[TypeUsuarioRol]    Script Date: 11/08/2018 07:45:59 p.m. ******/
CREATE TYPE [Seguridad].[TypeUsuarioRol] AS TABLE(
	[IdUsuario] [int] NOT NULL,
	[IdRol] [int] NOT NULL
)
GO
/****** Object:  UserDefinedTableType [Seguridad].[TypeUsuarios]    Script Date: 11/08/2018 07:45:59 p.m. ******/
CREATE TYPE [Seguridad].[TypeUsuarios] AS TABLE(
	[IdUsuario] [int] NOT NULL,
	[Usuario] [varchar](100) NOT NULL,
	[CodigoEmp] [varchar](100) NOT NULL,
	[NombreApellido] [varchar](100) NOT NULL,
	[IdEstado] [int] NOT NULL,
	[IdUsuarioTipo] [int] NOT NULL,
	[CodigoEmpresa] [varchar](100) NULL,
	[Sexo] [varchar](15) NULL,
	[EmailCoorporativo] [varchar](100) NOT NULL,
	[Correo] [varchar](150) NULL,
	[Direccion] [varchar](150) NULL,
	[DNI] [varchar](8) NULL,
	[IdSociedad] [int] NULL,
	[SociedadDescripcionCorta] [varchar](100) NULL,
	[IdAreaBU] [int] NULL,
	[AreaBUDescripcionCorta] [varchar](100) NULL,
	[IdCargo] [int] NULL,
	[CargoDescripcionCorta] [varchar](100) NULL,
	[IdComite] [int] NULL
)
GO
/****** Object:  StoredProcedure [Auditoria].[Usp_Ins_Auditoria]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Auditoria].[Usp_Ins_Auditoria]

 @IdAccion			INT
,@IdUsuario			INT
,@Descripcion		VARCHAR(MAX)
,@IdTablaReferencia	INT			
,@IdTipoAccion		CHAR(2)
,@IdReferencia		INT
,@UserName			VARCHAR(50)
,@IP				VARCHAR(15)
,@Fecha				DATETIME
AS
BEGIN
	INSERT INTO Seguridad.Auditoria_Transacional
	(
		 IdAccion			
		,IdUsuario			
		,DescripcionAuditoria		
		,IdTablaReferencia	
		,IdTipoAccion		
		,IdReferencia		
		,UserName			
		,IP
		,FechaOperacion				
	)
	VALUES 
	(
		 @IdAccion			
		,@IdUsuario			
		,@Descripcion		
		,@IdTablaReferencia	
		,@IdTipoAccion		
		,@IdReferencia		
		,@UserName			
		,@IP
		,@Fecha				
	)

	SELECT SCOPE_IDENTITY()
END


GO
/****** Object:  StoredProcedure [Auditoria].[Usp_Ins_Auditoria_UsuarioRol]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Auditoria].[Usp_Ins_Auditoria_UsuarioRol]
 @IdAccion			INT
,@IdUsuario			INT
,@Descripcion		VARCHAR(MAX)
,@IdTablaReferencia	INT			
,@IdTipoAccion		CHAR(2)
,@IdReferencia		INT
,@UserName			VARCHAR(50)
,@IP				VARCHAR(15)
,@Fecha				DATETIME
,@TypeRolUsuario AS [SEGURIDAD].[TYPEUSUARIOROL] READONLY
AS
BEGIN
	INSERT INTO Seguridad.Auditoria_Transacional
			(
			  IdAccion			
			 ,IdUsuario			
			 ,DescripcionAuditoria		
			 ,IdTablaReferencia	
			 ,IdTipoAccion		
			 ,IdReferencia		
			 ,UserName			
			 ,IP
			 ,FechaOperacion				
			)
	SELECT   @IdAccion			
			,@IdUsuario			
			,'Id Usuario:' + CAST([IDUSUARIO] AS VARCHAR(20)) + ' | Id Rol : ' + CAST([IDROL] AS VARCHAR(20))
			,@IdTablaReferencia	
			,@IdTipoAccion		
			,@IdReferencia		
			,@UserName			
			,@IP
			,@Fecha			
	FROM @TypeRolUsuario

	SELECT @@rowcount
END


GO
/****** Object:  StoredProcedure [dbo].[Usp_ReporteAplicacion]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Usp_ReporteAplicacion] --'0' ,'0' ,'0'
@IdAplicacion varchar(200), @IdRol varchar(200), @IdUsuario varchar(200)
AS
BEGIN
	SELECT 
	A.Nombre AS APLICACION,
	R.Nombre AS ROL,
	U.Usuario AS USUARIO,
	U.NombreApellido AS NOMBRE_USUARIO,
	U.CargoDescripcionCorta AS CARGO_USUARIO
	FROM Seguridad.Aplicacion A 
	LEFT JOIN Seguridad.Rol R ON (R.IdAplicacion = A.IdAplicacion)
	LEFT JOIN Seguridad.UsuarioRol UR ON (R.IdRol = UR.IdRol)
	LEFT JOIN Seguridad.Usuario U ON (U.IdUsuario = UR.IdUsuario)
	WHERE 
	((CONVERT(VARCHAR(200),A.IdAplicacion) = (@IdAplicacion)) OR  (@IdAplicacion = '0')) AND 
	((CONVERT(VARCHAR(200),R.IdRol) = (@IdRol)) OR  (@IdRol = '0')) AND 
	((CONVERT(VARCHAR(200),U.IdUsuario) = (@IdUsuario)) OR  (@IdUsuario = '0'))
END



GO
/****** Object:  StoredProcedure [dbo].[Usp_ReporteEmpresa]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Usp_ReporteEmpresa] --'0' ,'0' ,'0' ,'0'
@IdEmpresa varchar(200),@IdAplicacion varchar(200), @IdRol varchar(200), @IdUsuario varchar(200)
AS
BEGIN
	SELECT 
	E.Nombre + ' - ' + E.Abreviatura AS EMPRESA,
	A.Nombre AS APLICACION,
	R.Nombre AS ROL,
	U.Usuario AS USUARIO,
	U.NombreApellido AS NOMBRE_USUARIO,
	U.CargoDescripcionCorta AS CARGO_USUARIO
	FROM Seguridad.Empresa E 
	LEFT JOIN Seguridad.EmpresaAplicacion EA ON (E.IdEmpresa = EA.IdEmpresa)
	LEFT JOIN Seguridad.Aplicacion A ON (EA.Idaplicacion = A.IdAplicacion)
	LEFT JOIN Seguridad.Rol R ON (R.IdAplicacion = A.IdAplicacion)
	LEFT JOIN Seguridad.UsuarioRol UR ON (R.IdRol = UR.IdRol)
	LEFT JOIN Seguridad.Usuario U ON (U.IdUsuario = UR.IdUsuario)
	WHERE 
	((CONVERT(VARCHAR(200),E.IdEmpresa) = (@IdEmpresa)) OR  (@IdEmpresa = '0')) AND 
	((CONVERT(VARCHAR(200),A.IdAplicacion) = (@IdAplicacion)) OR  (@IdAplicacion = '0')) AND 
	((CONVERT(VARCHAR(200),R.IdRol) = (@IdRol)) OR  (@IdRol = '0')) AND 
	((CONVERT(VARCHAR(200),U.IdUsuario) = (@IdUsuario)) OR  (@IdUsuario = '0'))
END



GO
/****** Object:  StoredProcedure [dbo].[Usp_ReporteRoles]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Usp_ReporteRoles]
@IdRol varchar(200),@IdModulo varchar(200)
AS
BEGIN
	SELECT 
	R.Nombre AS ROL,
	M.Nombre AS MODULO,
	P.Nombre AS PAGINA,
	A.Nombre AS ACCION
	FROM Seguridad.PermisoPerfil PP
	LEFT JOIN Seguridad.Rol R ON (PP.IdRol = R.IdRol)
	LEFT JOIN Seguridad.Modulo M ON (M.IdModulo = PP.IdModulo)
	LEFT JOIN Seguridad.Pagina P ON (P.IdPagina = PP.IdPagina)
	LEFT JOIN Seguridad.Accion A ON (A.IdAccion = PP.IdAccion)
	WHERE 
	((CONVERT(VARCHAR(200),R.IdRol) = (@IdRol)) OR  (@IdRol = '0')) AND 
	((CONVERT(VARCHAR(200),M.IdModulo) = (@IdModulo)) OR  (@IdModulo = '0'))
END



GO
/****** Object:  StoredProcedure [dbo].[Usp_ReporteUsuarios]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[Usp_ReporteUsuarios] --'juan'
@NombreUsuario VARCHAR(200)
AS

SELECT 
	U.Usuario AS USUARIO,
	R.Nombre AS ROL,
	A.Nombre AS APLICACION,
	E.Nombre + ' - ' + E.Abreviatura AS EMPRESA
	FROM Seguridad.Empresa E 
	INNER JOIN Seguridad.EmpresaAplicacion EA ON (E.IdEmpresa = EA.IdEmpresa)
	INNER JOIN Seguridad.Aplicacion A ON (EA.Idaplicacion = A.IdAplicacion)
	INNER JOIN Seguridad.Rol R ON (R.IdAplicacion = A.IdAplicacion)
	INNER JOIN Seguridad.UsuarioRol UR ON (R.IdRol = UR.IdRol)
	INNER JOIN Seguridad.Usuario U ON (U.IdUsuario = UR.IdUsuario)
	WHERE U.NombreApellido like '' or U.NombreApellido like '%' + @NombreUsuario + '%'



GO
/****** Object:  StoredProcedure [Estructura].[Usp_Area_Buscar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROC [Estructura].[Usp_Area_Buscar]
@IdArea INT
AS
BEGIN
  SELECT
    IdArea,
    NombreArea,
    Descripcion,
    Estado
  FROM Estructura.Area 
  WHERE IdArea = @IdArea
END

GO
/****** Object:  StoredProcedure [Estructura].[Usp_Area_Listar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Estructura].[Usp_Area_Listar]
AS
BEGIN
SELECT      IdArea, 
			NombreArea, 
			Descripcion, 
			Estado
FROM         Estructura.Area
END

GO
/****** Object:  StoredProcedure [Estructura].[Usp_Cargo_Buscar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [Estructura].[Usp_Cargo_Buscar]
@IdCargo INT
AS 
BEGIN
	SELECT  c.IdCargo,
          c.NombreCargo,
          c.Descripcion,
          c.Estado
  FROM    Estructura.Cargo c
  WHERE   c.IdCargo = @IdCargo
END

GO
/****** Object:  StoredProcedure [Estructura].[Usp_Cargo_Listar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [Estructura].[Usp_Cargo_Listar]
AS 
BEGIN
	SELECT  c.IdCargo,
          c.NombreCargo,
          c.Descripcion,
          c.Estado
  FROM    Estructura.Cargo c
END

GO
/****** Object:  StoredProcedure [Estructura].[Usp_Sel_Area]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [Estructura].[Usp_Sel_Area]
AS

BEGIN

SELECT IdArea,Descripcion,Estado,NombreArea FROM Estructura.Area 

END
GO
/****** Object:  StoredProcedure [Estructura].[Usp_Update_CadenaAreas]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [Estructura].[Usp_Update_CadenaAreas]
@CodigoUsuario AS VARCHAR(100),
@CadenaIdArea AS VARCHAR(100)
AS
BEGIN

UPDATE BD_ERPChavinSeguridad.Seguridad.Usuario
SET IdAreas = @CadenaIdArea
WHERE Usuario = @CodigoUsuario

END
GO
/****** Object:  StoredProcedure [Seguridad].[ObtenerRolUsuario]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Seguridad].[ObtenerRolUsuario]
@IdUsuario int
AS
BEGIN
SELECT Emp.Nombre AS Empresa
	 ,SA.Nombre AS Aplicacion
	 ,SR.Nombre AS Rol
	 ,SR.FechaInicio
	 ,Usu.IdEstado 
	 FROM Seguridad.Usuario Usu
INNER  JOIN Seguridad.UsuarioRol Ur ON Ur.IdUsuario = Usu.IdUsuario
INNER JOIN Seguridad.Rol SR ON  SR.IdRol = Ur.IdRol
LEFT JOIN Seguridad.Aplicacion SA ON SA.IdAplicacion = SR.IdAplicacion
LEFT JOIN Seguridad.Empresa Emp ON usu.CodigoEmpresa = Emp.CodigoEmpresa
WHERE Ur.IdUsuario = @IdUsuario
ORDER BY  Aplicacion, Rol ASC
END

GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Accion_Buscar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Seguridad].[Usp_Accion_Buscar] 
(
	@IdPagina int,
	@IdsGrupo Varchar(100)
)
AS 
BEGIN	
	Select
	@IdPagina IdPagina,
	(Select PA.IdPaginaAccion From Seguridad.PaginaAccion PA Where PA.IdAccion = A.IdAccion And PA.IdPagina = @IdPagina) IdPaginaAccion,
	(Select PA.ChkAgregar From Seguridad.PaginaAccion PA Where PA.IdAccion = A.IdAccion And PA.IdPagina = @IdPagina) ChkAgregar,
	A.IdAccion, A.CodigoHTML, A.Nombre NombreAccion, A.Etiqueta, A.MensajeToolTip, 
	E.IdEstado, E.Nombre NombreEstado
	From Seguridad.Accion A
	Inner Join Estructura.Estado E On A.IdEstado = E.IdEstado
	Where IdGrupo in (Select item From ufnSplit(@IdsGrupo,','))
	
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Accion_Paginacion]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Seguridad].[Usp_Accion_Paginacion] 
	(
		@IdPagina int,
		@IdsGrupo Varchar(1000),
		
		@SortType VARCHAR(100), 
		@SortDir VARCHAR(50), 
		@Page INT, 
		@RowsPerPage INT, 
		@RowCount INT = 0 OUT 
	)
	AS 
	BEGIN
		BEGIN		
			WITH Accion AS
			(
				SELECT ROW_NUMBER() OVER 
				(ORDER BY
					--ASC
					CASE WHEN (@SortType = 'IdAccion' AND @SortDir = 'ASC') THEN A.IdAccion END ASC,
					--DESC
					CASE WHEN (@SortType = 'IdAccion' AND @SortDir = 'DESC') THEN A.IdAccion END DESC,
					--DEFAULT				
					CASE WHEN @SortType = '' THEN A.IdAccion END DESC 				
				)	
				AS ROWNUMBER,
				(Select PA.IdPaginaAccion From Seguridad.PaginaAccion PA Where PA.IdAccion = A.IdAccion And PA.IdPagina = @IdPagina) IdPaginaAccion,
				(Select PA.ChkAgregar From Seguridad.PaginaAccion PA Where PA.IdAccion = A.IdAccion And PA.IdPagina = @IdPagina) ChkAgregar,
				A.IdAccion, 
				A.CodigoHTML, 
				Upper(A.Nombre) NombreAccion, 
				Upper(A.Etiqueta) Etiqueta, 
				Upper(A.MensajeToolTip) MensajeToolTip, 
				E.IdEstado, 
				Upper(E.Nombre) NombreEstado,
				G.IdGrupo, 
				Upper(G.Codigo) CodigoGrupo, 
				Upper(G.Nombre) NombreGrupo, 
				Upper(G.Abreviatura) Abreviatura
				From Seguridad.Accion A
				Inner Join Estructura.Estado E On A.IdEstado = E.IdEstado
				Inner Join Estructura.Grupo G On G.IdGrupo = A.IdGrupo
				Where A.IdGrupo In (Select item From ufnSplit(@IdsGrupo,','))
			)
			SELECT 
				ROWNUMBER,
				IdPaginaAccion,
				ChkAgregar,
				IdAccion,
				CodigoHTML,
				NombreAccion,
				Etiqueta,
				MensajeToolTip,
				IdEstado,
				NombreEstado,
				IdGrupo, 
				CodigoGrupo, 
				NombreGrupo,
				Abreviatura
			FROM Accion
			WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page - 1) + 1) AND @Page * @RowsPerPage
			
			SET @RowCount = (
				SELECT COUNT(1)
				From Seguridad.Accion A
				Inner Join Estructura.Estado E On A.IdEstado = E.IdEstado
				Inner Join Estructura.Grupo G On G.IdGrupo = A.IdGrupo
				Where A.IdGrupo In (Select item From ufnSplit(@IdsGrupo,','))
			)	
		END
	END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Aplicacion_Actualizar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_Aplicacion_Actualizar]
(
@IdAplicacion int,
@Nombre Varchar(200),
@Descripcion Varchar(200),
@Url Varchar(200)
)
as
Begin
	Update Seguridad.Aplicacion 
	Set Nombre = @Nombre, Descripcion = @Descripcion,
	Url = @Url
	Where IdAplicacion = @IdAplicacion
	
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Aplicacion_ActualizarEstado]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_Aplicacion_ActualizarEstado]
(
@IdAplicacion int,
@IdEstado int
)
as
Begin
	Update Seguridad.Aplicacion 
	Set IdEstado = @IdEstado 
	Where IdAplicacion = @IdAplicacion
	
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Aplicacion_Buscar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_Aplicacion_Buscar]
(
@IdAplicacion int
)
as
Begin
	Select A.IdAplicacion, A.Nombre NombreAplicacion, A.Descripcion DescripcionAplicacion, A.Url, 
	ES.IdEstado, ES.Nombre NombreEstado
	From Seguridad.Aplicacion A
	Inner Join Estructura.Estado ES On ES.IdEstado = A.IdEstado
	Where IdAplicacion = @IdAplicacion
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Aplicacion_Existe]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Seguridad].[Usp_Aplicacion_Existe]
(
@IdEmpresa INT,
@AplicacionTitulo VARCHAR(200)
)
AS
BEGIN
	Declare @Exist int

	SET @Exist = (select count(*) 
			      from Seguridad.Aplicacion A
				  inner join Seguridad.EmpresaAplicacion EA on A.IdAplicacion = EA.IdAplicacion
				  where EA.IdEmpresa = @IdEmpresa and A.Nombre = @AplicacionTitulo)
	
	SELECT @Exist
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Aplicacion_Insertar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_Aplicacion_Insertar]
(
@Url Varchar(200),
@Nombre Varchar(200),
@Descripcion Varchar(200),
@IdAplicacion Int out
)
as
Begin
	
	
	Insert Seguridad.Aplicacion ( Nombre, Descripcion, Url, IdEstado)
	Values(@Nombre, @Descripcion, @Url, 1)
	
	Set @IdAplicacion = @@Identity
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Aplicacion_Listar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_Aplicacion_Listar]
as
Begin
	Select Distinct A.IdAplicacion, 
	upper(A.Nombre) NombreAplicacion, 
	upper(A.Descripcion) DescripcionAplicacion, 
	upper(A.Url) Url, 
	ES.IdEstado, 
	upper(ES.Nombre) NombreEstado
	From Seguridad.Aplicacion A
	Inner Join Seguridad.EmpresaAplicacion EA On EA.IdAplicacion = A.IdAplicacion 
	Inner Join Estructura.Estado ES On ES.IdEstado = A.IdEstado
	Inner Join Seguridad.Empresa E On E.IdEmpresa = EA.IdEmpresa
	
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Aplicacion_Listar_CentroAtencion]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_Aplicacion_Listar_CentroAtencion]
as
Begin
	Select Distinct 
	IdCentroAtencion,
	DescripcionCentroAtencion,
	Activo,
	IdArea,
	FechaRegistro,
	IdUsuarioRegistro
	From BD_ERP_MASTER.Maestro.CentroAtencion	
End


GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Aplicacion_Paginacion]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Seguridad].[Usp_Aplicacion_Paginacion] 
(
	@IdsEmpresa Varchar(1000),
	@Nombre Varchar(200),
	@Descripcion Varchar(200),
	
	@SortType VARCHAR(100), 
	@SortDir VARCHAR(50), 
	@Page INT, 
	@RowsPerPage INT, 
	@RowCount INT = 0 OUT 
)
AS 
BEGIN
	BEGIN		
		WITH Aplicacion AS
		(
			SELECT ROW_NUMBER() OVER 
			(ORDER BY
				--ASC
				CASE WHEN (@SortType = 'IdAplicacion' AND @SortDir = 'ASC') THEN A.IdAplicacion END ASC,
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'ASC') THEN A.Nombre END ASC,
				CASE WHEN (@SortType = 'Descripcion' AND @SortDir = 'ASC') THEN A.Descripcion END ASC,
				CASE WHEN (@SortType = 'Empresa.IdEmpresa' AND @SortDir = 'ASC') THEN E.IdEmpresa END ASC,
				CASE WHEN (@SortType = 'Empresa.Nombre' AND @SortDir = 'ASC') THEN E.Nombre END ASC,
				CASE WHEN (@SortType = 'Url' AND @SortDir = 'ASC') THEN A.Url END ASC,
				CASE WHEN (@SortType = 'Estado.IdEstado' AND @SortDir = 'ASC') THEN ES.IdEstado END ASC,
				CASE WHEN (@SortType = 'Estado.Nombre' AND @SortDir = 'ASC') THEN ES.Nombre END ASC,
				--DESC
				CASE WHEN (@SortType = 'IdAplicacion' AND @SortDir = 'DESC') THEN A.IdAplicacion END DESC,
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'DESC') THEN A.Nombre END DESC,
				CASE WHEN (@SortType = 'Descripcion' AND @SortDir = 'DESC') THEN A.Descripcion END DESC,
				CASE WHEN (@SortType = 'Empresa.IdEmpresa' AND @SortDir = 'DESC') THEN E.IdEmpresa END DESC,
				CASE WHEN (@SortType = 'Empresa.Nombre' AND @SortDir = 'DESC') THEN E.Nombre END DESC,
				CASE WHEN (@SortType = 'Url' AND @SortDir = 'DESC') THEN A.Url END DESC,
				CASE WHEN (@SortType = 'Estado.IdEstado' AND @SortDir = 'DESC') THEN ES.IdEstado END DESC,
				CASE WHEN (@SortType = 'Estado.Nombre' AND @SortDir = 'DESC') THEN ES.Nombre END DESC,
				--DEFAULT				
				CASE WHEN @SortType = '' THEN A.IdAplicacion END DESC 				
			)	
			AS ROWNUMBER,
			A.IdAplicacion,
			UPPER(A.Nombre) NombreAplicacion,
			UPPER(A.Descripcion) DescripcionAplicacion,
			UPPER(A.Url) Url,
			E.IdEmpresa,
			UPPER(E.Nombre) NombreEmpresa,
			E.Abreviatura,
			ES.IdEstado,
			UPPER(ES.Nombre) NombreEstado
			--TABLES 
			FROM Seguridad.EmpresaAplicacion EA 
			Inner Join Seguridad.Aplicacion A On A.IdAplicacion = EA.IdAplicacion
			Inner Join Seguridad.Empresa E On E.IdEmpresa = EA.IdEmpresa
			Inner Join Estructura.Estado ES On ES.IdEstado = A.IdEstado
			WHERE			
			(@IdsEmpresa = '' Or EA.IdEmpresa IN (Select item From dbo.ufnSplit(@IdsEmpresa,',')))
			And (@Descripcion = '' Or A.Descripcion Like '%' + @Descripcion + '%')	
			And (@Nombre = '' Or A.Nombre Like '%' + @Nombre + '%')		
		)
		SELECT 
			IdAplicacion,
			IdEmpresa,
			NombreEmpresa,
			Abreviatura,
			NombreAplicacion,
			DescripcionAplicacion,
			Url,
			IdEstado,
			NombreEstado
		FROM Aplicacion
		WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page - 1) + 1) AND @Page * @RowsPerPage
		
		SET @RowCount = (
			SELECT COUNT(1)
			FROM Seguridad.EmpresaAplicacion EA 
			Inner Join Seguridad.Aplicacion A On A.IdAplicacion = EA.IdAplicacion
			Inner Join Seguridad.Empresa E On E.IdEmpresa = EA.IdEmpresa
			Inner Join Estructura.Estado ES On ES.IdEstado = A.IdEstado
			WHERE			
			(@IdsEmpresa = '' Or EA.IdEmpresa IN (Select item From dbo.ufnSplit(@IdsEmpresa,',')))
			And (@Descripcion = '' Or A.Descripcion Like '%' + @Descripcion + '%')	
			And (@Nombre = '' Or A.Nombre Like '%' + @Nombre + '%')			
		)	
	END
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_AplicacionPorEmpresa]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_AplicacionPorEmpresa]
(
@IdEmpresa int
)
as
Begin
	Select Distinct A.IdAplicacion, A.Nombre NombreAplicacion, A.Descripcion DescripcionAplicacion, A.Url, 
	ES.IdEstado, ES.Nombre NombreEstado
	From Seguridad.Aplicacion A
	Inner Join Seguridad.EmpresaAplicacion EA On EA.IdAplicacion = A.IdAplicacion 
	Inner Join Estructura.Estado ES On ES.IdEstado = A.IdEstado
	Inner Join Seguridad.Empresa E On E.IdEmpresa = EA.IdEmpresa
	Where (/*@IdEmpresa = 0 Or */EA.IdEmpresa = @IdEmpresa)
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Area_Listar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [Seguridad].[Usp_Area_Listar]
--(
--	@IdUnidadOrganica int
--)
AS
BEGIN
	--Select [ID_AREA]
	--,[DESCRIPCION]
	--From [Estructura].[Areas]
	--where [ID_UNIDAD_ORGANICA] = @IdUnidadOrganica

	SELECT      IdArea, 
			NombreArea, 
			Descripcion, 
			Estado
FROM         Estructura.Area
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_AuditoriaAcceso]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Seguridad].[Usp_AuditoriaAcceso]
@Host		VARCHAR(100),
@Ip			VARCHAR(100),
@IdUsuario	INT
AS
BEGIN
	INSERT INTO Seguridad.Auditoria_Acceso
	VALUES(GETDATE(),@Host,@Ip,@IdUsuario)
	SELECT CAST(1 AS INT)
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_AutenticarSupervisor]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  CREATE procedure [Seguridad].[Usp_AutenticarSupervisor]-- 'JSACCATOMA','123456'
(
@Usuario VARCHAR(100),
@Clave VARCHAR(100)
)
as
begin 
select Distinct U.IdUsuario,U.NombreApellido
From Seguridad.Usuario U
Inner Join Seguridad.UsuarioRol UR On UR.IdUsuario = U.IdUsuario
--Inner Join Seguridad.Empresa E On E.CodigoEmpresa = (case when U.CodigoEmpresa  = 1 then 2 else U.CodigoEmpresa end )
Inner Join Seguridad.Rol R On R.IdRol = UR.IdRol 
where U.Usuario = @Usuario and  U.Contrasena = @Clave
--And (R.SiRango = 0 Or (R.SiRango = 1 And GetDate() between R.FechaInicio And R.FechaFin))
--And U.IdEstado = 1 AND UR.IdRol=3
end
GO
/****** Object:  StoredProcedure [Seguridad].[Usp_AutenticarUsuario]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Seguridad].[Usp_AutenticarUsuario]-- 'cqa2','R9PyBxbf1g/yzKfIMUG5gQ=='
(
@Usuario VARCHAR(100)
,@Clave VARCHAR(100)
)
as
begin 
	SELECT DISTINCT 
		U.IdUsuario
		,U.Usuario
		,U.CodigoEmp
		,U.NombreApellido
		,U.EmailCoorporativo
		,U.CodigoEmpresa
		,U.Sexo
		,U.EmailCoorporativo
		,U.Correo
		,U.Direccion
		,U.DNI
		,U.IdSociedad
		,U.SociedadDescripcionCorta
		,U.IdAreaBU
		,U.AreaBUDescripcionCorta
		,U.IdCargo
		,U.CargoDescripcionCorta
		,U.IdComite
		,E.ContentStyle
		,U.CambiarPassword
	FROM Seguridad.Usuario U
	INNER JOIN Seguridad.UsuarioRol UR 
		ON UR.IdUsuario = U.IdUsuario
	INNER JOIN Seguridad.Empresa E 
		ON E.CodigoEmpresa = U.CodigoEmpresa 
	INNER JOIN Seguridad.Rol R 
		ON R.IdRol = UR.IdRol 
	WHERE 
		Usuario = @Usuario AND Contrasena = @Clave
		AND (R.SiRango = 0 OR (R.SiRango = 1 AND GETDATE() BETWEEN R.FechaInicio AND R.FechaFin))
		AND U.IdEstado = 1
end


  


GO
/****** Object:  StoredProcedure [Seguridad].[Usp_AutenticarUsuario_Modo]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Seguridad].[Usp_AutenticarUsuario_Modo] --'jhugo','admin12345'
(
@Usuario VARCHAR(100),
@Contraseña VARCHAR(100)
)
as
begin
	DECLARE @Vigencia INT
	DECLARE @FechaClave DATETIME
	DECLARE @Diferencia INT
	DECLARE @Op INT
	
	SET @Vigencia = (select Vigencia_Contrasena from Seguridad.Politica)
	SET @FechaClave = (SELECT FechaCreacion_Clave FROM Seguridad.Usuario WHERE Usuario=@Usuario)
	SET @Diferencia = (SELECT CAST(DATEDIFF(DAY,GETDATE(),@FechaClave)AS INT))
	
	IF @Diferencia >= @Vigencia
		BEGIN
			SET @Op=1 -- Caducado
		END
	ELSE
		BEGIN
			SET @Op=0
		END
	
	IF @Op=1
		BEGIN
			select Distinct U.IdUsuario,U.Usuario, U.CodigoEmp,U.NombreApellido,U.EmailCoorporativo,
			U.CodigoEmpresa, U.Sexo, U.EmailCoorporativo, U.Correo, U.Direccion, U.DNI,
			U.IdSociedad, U.SociedadDescripcionCorta, U.IdAreaBU, U.AreaBUDescripcionCorta,
			U.IdCargo, U.CargoDescripcionCorta, /*U.IdComite*/1 AS Caduco, E.ContentStyle
			From Seguridad.Usuario U
			Inner Join Seguridad.UsuarioRol UR On UR.IdUsuario = U.IdUsuario
			Inner Join Seguridad.Empresa E On E.CodigoEmpresa = U.CodigoEmpresa 
			Inner Join Seguridad.Rol R On R.IdRol = UR.IdRol 
			where Usuario = @Usuario and  Contrasena = @Contraseña
			And (R.SiRango = 0 Or (R.SiRango = 1 And GetDate() between R.FechaInicio And R.FechaFin))
			And U.IdEstado = 1
		END
	ELSE
		BEGIN
			select Distinct U.IdUsuario,U.Usuario, U.CodigoEmp,U.NombreApellido,U.EmailCoorporativo,
			U.CodigoEmpresa, U.Sexo, U.EmailCoorporativo, U.Correo, U.Direccion, U.DNI,
			U.IdSociedad, U.SociedadDescripcionCorta, U.IdAreaBU, U.AreaBUDescripcionCorta,
			U.IdCargo, U.CargoDescripcionCorta, /*U.IdComite*/0 AS Caduco, E.ContentStyle
			From Seguridad.Usuario U
			Inner Join Seguridad.UsuarioRol UR On UR.IdUsuario = U.IdUsuario
			Inner Join Seguridad.Empresa E On E.CodigoEmpresa = U.CodigoEmpresa 
			Inner Join Seguridad.Rol R On R.IdRol = UR.IdRol 
			where Usuario = @Usuario and  Contrasena = @Contraseña
			And (R.SiRango = 0 Or (R.SiRango = 1 And GetDate() between R.FechaInicio And R.FechaFin))
			And U.IdEstado = 1
		END
	
end



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Bloquear_Usuario]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Seguridad].[Usp_Bloquear_Usuario] --'jhugo','admin12345'
(
@Username VARCHAR(100)
)
AS
BEGIN
	UPDATE Seguridad.Usuario SET Bloqueo=1,FechaBloqueo=GETDATE()
	WHERE Usuario=@Username
	SELECT CAST(1 AS INT)
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Empleados_Rol_Servicios]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Seguridad].[Usp_Empleados_Rol_Servicios]  --1, 6
@Opc int , @Rol int 
AS
BEGIN
	IF @Opc = 1 --EMPLEADOS PARA SELECCIONAR TODOS LOS AUDITORES
		BEGIN
			SELECT CodigoEmp FROM [BD_CoreSeguridad].[Seguridad].[UsuarioRol] UR
								 INNER JOIN [BD_CoreSeguridad].[Seguridad].[Usuario] U ON (U.IdUsuario=UR.IdUsuario)
								 WHERE IdRol = @Rol
		END
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Empresa_Actualizar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_Empresa_Actualizar]
(
@IdEmpresa int,
@Nombre Varchar(200),
@Abreviatura Varchar(15),
@CodigoEmpresa Varchar(100),
@ContentStyle Varchar(300)
)
as
Begin
	Update Seguridad.Empresa 
	Set Nombre = @Nombre, Abreviatura = @Abreviatura,
	CodigoEmpresa = @CodigoEmpresa, ContentStyle = @ContentStyle
	Where IdEmpresa = @IdEmpresa
	
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Empresa_ActualizarEstado]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_Empresa_ActualizarEstado]
(
@IdEmpresa int,
@IdEstado int
)
as
Begin
	Update Seguridad.Empresa 
	Set IdEstado = @IdEstado
	Where IdEmpresa = @IdEmpresa
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Empresa_Buscar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_Empresa_Buscar]
(
@IdEmpresa int
)
as
Begin
	Select E.IdEmpresa, ES.IdEstado, E.Nombre NombreEmpresa, E.Abreviatura, E.CodigoEmpresa, E.ContentStyle,
	ES.Nombre NombreEstado 
	from Seguridad.Empresa E
	Inner Join Estructura.Estado ES On ES.IdEstado = E.IdEstado
	Where IdEmpresa = @IdEmpresa
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Empresa_Insertar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_Empresa_Insertar]
(
@Nombre Varchar(200),
@Abreviatura Varchar(15),
@CodigoEmpresa Varchar(100),
@ContentStyle Varchar(300)
)
as
Begin
	Declare @Exist int
	Declare @Resultado int

	set @Exist = (select count(*) from Seguridad.Empresa where Nombre = @Nombre)

	IF (@Exist = 0)
	BEGIN
		Insert Into Seguridad.Empresa (IdEstado, Nombre, Abreviatura,CodigoEmpresa, ContentStyle)
		Values(1,@Nombre,@Abreviatura,@CodigoEmpresa, @ContentStyle)
		SELECT 1;
	END
	ELSE
	BEGIN 
		SELECT -1;
	END
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Empresa_Listar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_Empresa_Listar]
as
Begin
	Select E.IdEmpresa, E.Nombre NombreEmpresa, E.Abreviatura, E.CodigoEmpresa, E.ContentStyle,
	ES.IdEstado, ES.Nombre NombreEstado from Seguridad.Empresa E
	Inner Join Estructura.Estado Es On Es.IdEstado = E.IdEstado
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Empresa_Nombre]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Seguridad].[Usp_Empresa_Nombre]
(
@IdEmpresa INT
)
AS
BEGIN
	SELECT Nombre FROM Seguridad.Empresa WHERE IdEmpresa = @IdEmpresa
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Empresa_Paginacion]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Seguridad].[Usp_Empresa_Paginacion] 
(
	@Nombre Varchar(200),
	
	@SortType VARCHAR(100), 
	@SortDir VARCHAR(50), 
	@Page INT, 
	@RowsPerPage INT, 
	@RowCount INT = 0 OUT 
)
AS 
BEGIN
	BEGIN		
		WITH Empresa AS
		(
			SELECT ROW_NUMBER() OVER 
			(ORDER BY
				--ASC
				CASE WHEN (@SortType = 'IdEmpresa' AND @SortDir = 'ASC') THEN E.IdEmpresa END ASC,
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'ASC') THEN E.Nombre END ASC,
				CASE WHEN (@SortType = 'Abreviatura' AND @SortDir = 'ASC') THEN E.Abreviatura END ASC,
				CASE WHEN (@SortType = 'Estado.IdEstado' AND @SortDir = 'ASC') THEN ES.IdEstado END ASC,
				CASE WHEN (@SortType = 'Estado.Nombre' AND @SortDir = 'ASC') THEN ES.Nombre END ASC,
				--DESC
				CASE WHEN (@SortType = 'IdEmpresa' AND @SortDir = 'DESC') THEN E.IdEmpresa END DESC,
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'DESC') THEN E.Nombre END DESC,
				CASE WHEN (@SortType = 'Abreviatura' AND @SortDir = 'DESC') THEN E.Abreviatura END DESC,
				CASE WHEN (@SortType = 'Estado.IdEstado' AND @SortDir = 'DESC') THEN ES.IdEstado END DESC,
				CASE WHEN (@SortType = 'Estado.Nombre' AND @SortDir = 'DESC') THEN ES.Nombre END DESC,
				--DEFAULT				
				CASE WHEN @SortType = '' THEN E.IdEmpresa END DESC 				
			)	
			AS ROWNUMBER,
			E.IdEmpresa,
			UPPER(E.Nombre) NombreEmpresa,
			UPPER(E.Abreviatura) Abreviatura,
			ES.IdEstado,
			UPPER(ES.Nombre) NombreEstado,
			ContentStyle Ruc
			--TABLES 
			FROM Seguridad.Empresa E
			Inner Join Estructura.Estado ES On ES.IdEstado = E.IdEstado
			WHERE			
			(@Nombre = '' Or E.Nombre Like '%' + @Nombre + '%')			
		)
		SELECT 
			IdEmpresa,
			NombreEmpresa,
			Abreviatura,
			IdEstado,
			NombreEstado,
			Ruc
		FROM Empresa
		WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page - 1) + 1) AND @Page * @RowsPerPage
		
		SET @RowCount = (
			SELECT (COUNT(1))
			FROM Seguridad.Empresa E
			Inner Join Estructura.Estado ES On ES.IdEstado = E.IdEstado
			WHERE			
			(@Nombre = '' Or E.Nombre Like '%' + @Nombre + '%')		
		)	
	END
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_EmpresaAplicacion_Eliminar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Seguridad].[Usp_EmpresaAplicacion_Eliminar]
    @IdAplicacion int
as
begin
	Delete Seguridad.EmpresaAplicacion 
	Where IdAplicacion = @IdAplicacion
	
	Select 1
end



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_EmpresaAplicacion_Insertar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Seguridad].[Usp_EmpresaAplicacion_Insertar]
    @TypeEmpresaAplicacion AS [Seguridad].[TypeEmpresaAplicacion] READONLY
as
begin
	INSERT INTO Seguridad.EmpresaAplicacion(IdEmpresa,IdAplicacion) 
    SELECT IdEmpresa,IdAplicacion
    FROM @TypeEmpresaAplicacion
end



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_EmpresasPorAplicacion]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_EmpresasPorAplicacion]
(
@IdAplicacion int
)
as
Begin
	Select 
	E.IdEmpresa, 
	upper(E.Nombre) NombreEmpresa, 
	upper(E.Abreviatura) Abreviatura, 
	Cast (Case When EA.IdEmpresa is null then 0 else 1 end as bit ) [Check]
	from Seguridad.Empresa E
	Inner Join Estructura.Estado ES On ES.IdEstado = E.IdEstado
	left Join Seguridad.EmpresaAplicacion EA On EA.IdEmpresa = E.IdEmpresa And EA.IdAplicacion = @IdAplicacion
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_ExistContrasenaOperation]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Miguel,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Seguridad].[Usp_ExistContrasenaOperation] 
(@Contasena varchar(30))
AS
BEGIN
select (select count(*) from Seguridad.Usuario where CodigoEmp = @Contasena)
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_geListAgrupacion]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Seguridad].[Usp_geListAgrupacion] --0
	@IdModulo INT
AS
BEGIN

	SELECT  
		IdAgrupacion,
		Descripcion
	FROM Seguridad.ModuloAgrupacion
	WHERE IdAgrupacion = 0

	UNION ALL

	SELECT 
		IdAgrupacion,
		Descripcion
	FROM Seguridad.ModuloAgrupacion
	WHERE IdModulo = @IdModulo
	  AND IdModulo <> 0


END

GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Gest_Politica]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Seguridad].[Usp_Gest_Politica]
@LongMinima_Contrasena	INT,
@Vigencia_Contrasena	INT,
@Diferencia_ContrasenaUsuario	INT,
@NroMaximoIntentos		INT,
@DiasBloqueoUsuario		INT,
@ComplejidadContraseña	INT,
@CantidadContrasenaHist	INT
AS
BEGIN
	DECLARE @Count INT = (SELECT COUNT(*) FROM [Seguridad].[Politica])
	IF @Count = 0
		BEGIN
			INSERT INTO [Seguridad].[Politica] VALUES(@LongMinima_Contrasena,@Vigencia_Contrasena,@Diferencia_ContrasenaUsuario,
													  @NroMaximoIntentos,@DiasBloqueoUsuario,@ComplejidadContraseña,@CantidadContrasenaHist)
			SELECT CAST(1 AS INT)
		END
	ELSE
		BEGIN
			DECLARE @ID INT = (SELECT TOP 1 IdPolitica FROM [Seguridad].[Politica])
			UPDATE [Seguridad].[Politica] SET LongMinima_Contrasena=@LongMinima_Contrasena,
											  Vigencia_Contrasena=@Vigencia_Contrasena,
											  Diferencia_ContrasenaUsuario=@Diferencia_ContrasenaUsuario,
											  NroMaximoIntentos=@NroMaximoIntentos,
											  DiasBloqueoUsuario=@DiasBloqueoUsuario,
											  ComplejidadContraseña=@ComplejidadContraseña,
											  CantidadContrasenaHist=@CantidadContrasenaHist
										  WHERE IdPolitica=@ID
			SELECT CAST(1 AS INT)
		END
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Grupo_Listar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_Grupo_Listar]
as
Begin
	Select G.IdGrupo, G.Codigo, G.Nombre, G.Abreviatura,
	E.IdEstado, E.Nombre NombreEstado
	From Estructura.Grupo G
	Inner Join Estructura.Estado E On E.IdEstado = G.IdEstado 
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_GruposPorPagina]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_GruposPorPagina]
(
@IdPagina int
)
as
Begin
	Select G.IdGrupo, G.Codigo, G.Nombre NombreGrupo, G.Abreviatura,
	Cast (Case When IdPaginaGrupo is null then 0 else 1 end as Bit) [Check]
	From Estructura.Grupo G
	Left Join Seguridad.PaginaGrupo PG On PG.IdGrupo = G.IdGrupo And PG.IdPagina = @IdPagina
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_InsAuditoriaTransa]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Seguridad].[Usp_InsAuditoriaTransa]
@IdAccion	INT,
@IdUsuario	INT,
@Descripcion	VARCHAR(MAX)
AS
BEGIN
	INSERT INTO Seguridad.Auditoria_Transacional(IdAccion,IdUsuario,FechaOperacion,DescripcionAuditoria)
	VALUES(@IdAccion,@IdUsuario,GetDate(),@Descripcion)
	SELECT CAST(1 AS INT)
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_List_Politica]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Seguridad].[Usp_List_Politica]
AS
BEGIN
	SELECT LongMinima_Contrasena,
		   Vigencia_Contrasena,
		   Diferencia_ContrasenaUsuario,
		   NroMaximoIntentos,
		   DiasBloqueoUsuario,
		   ComplejidadContraseña,
		   CantidadContrasenaHist
	FROM [Seguridad].[Politica]
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Listar_AplicacionUsuario]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Seguridad].[Usp_Listar_AplicacionUsuario] --'juan.bernal'
@Usuario VARCHAR(15)
AS
BEGIN

	SELECT DISTINCT
					A.Url AS URL,
					A.Nombre AS APLICACION
					FROM Seguridad.Empresa E 
					INNER JOIN Seguridad.EmpresaAplicacion EA ON (E.IdEmpresa = EA.IdEmpresa)
					INNER JOIN Seguridad.Aplicacion A ON (EA.Idaplicacion = A.IdAplicacion)
					INNER JOIN Seguridad.Rol R ON (R.IdAplicacion = A.IdAplicacion)
					INNER JOIN Seguridad.UsuarioRol UR ON (R.IdRol = UR.IdRol)
					INNER JOIN Seguridad.Usuario U ON (U.IdUsuario = UR.IdUsuario)
					WHERE Usuario like @Usuario

END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Modulo_Actualizar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [Seguridad].[Usp_Modulo_Actualizar]
(
@IdModulo int,
@IdAplicacion int,
@Nombre Varchar(200),
@Descripcion Varchar(200)
)
as
Begin
	Update Seguridad.Modulo
	Set IdAplicacion = @IdAplicacion, Nombre = @Nombre, Descripcion = @Descripcion
	Where IdModulo = @IdModulo
	
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Modulo_ActualizarEstado]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_Modulo_ActualizarEstado]
(
@IdModulo int,
@IdEstado int
)
as
Begin
	Update Seguridad.Modulo
	Set IdEstado = @IdEstado
	Where IdModulo = @IdModulo
	
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Modulo_Buscar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_Modulo_Buscar]
(
@IdModulo int
)
as
Begin
	Select Distinct  M.IdModulo, M.Nombre NombreModulo, M.Descripcion DescripcionModulo,
	ES.IdEstado, ES.Nombre NombreEstado, 
	A.IdAplicacion, A.Nombre NombreAplicacion, A.Descripcion DescripcionAplicacion, A.Url
	From Seguridad.Modulo M
	Inner Join Estructura.Estado ES On ES.IdEstado = M.IdEstado
	Inner Join Seguridad.Aplicacion A On A.IdAplicacion = M.IdAplicacion
	Inner Join Seguridad.EmpresaAplicacion EA On EA.IdAplicacion = A.IdAplicacion
	Inner Join Seguridad.Empresa E On E.IdEmpresa = EA.IdEmpresa
	Where IdModulo = @IdModulo
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Modulo_Insertar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_Modulo_Insertar]
(
@IdAplicacion int,
@Nombre Varchar(200),
@Descripcion Varchar(200)
)
as
Begin
	declare @Exist int 
	set @Exist = (select count(*) from Seguridad.Modulo where IdAplicacion = @IdAplicacion and Nombre = @Nombre)

	IF (@Exist = 0)
	begin
		Insert Into Seguridad.Modulo (IdAplicacion, Nombre, Descripcion, IdEstado)
		Values (@IdAplicacion, @Nombre, @Descripcion, 1)
		select 1;
	end
	else
	begin
		select -1;
	end
		
	
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Modulo_Listar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_Modulo_Listar]
as
Begin
	Select  M.IdModulo, M.Nombre NombreModulo, M.Descripcion DescripcionModulo,
	ES.IdEstado, ES.Nombre NombreEstado, 
	A.IdAplicacion, A.Nombre NombreAplicacion, A.Descripcion DescripcionAplicacion, A.Url
	From Seguridad.Modulo M
	Inner Join Estructura.Estado ES On ES.IdEstado = M.IdEstado
	Inner Join Seguridad.Aplicacion A On A.IdAplicacion = M.IdAplicacion
	
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Modulo_Paginacion]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Seguridad].[Usp_Modulo_Paginacion] 
(
	@IdEmpresa int,
	@IdAplicacion int,
	@Nombre Varchar(200),
	@Descripcion Varchar(200),
	
	@SortType VARCHAR(100), 
	@SortDir VARCHAR(50), 
	@Page INT, 
	@RowsPerPage INT, 
	@RowCount INT = 0 OUT 
)
AS 
BEGIN
	BEGIN		
		WITH Modulo AS
		(
			SELECT ROW_NUMBER() OVER 
			(ORDER BY
				--ASC
				CASE WHEN (@SortType = 'IdModulo' AND @SortDir = 'ASC') THEN M.IdModulo END ASC,
				CASE WHEN (@SortType = 'Aplicacion.IdAplicacion' AND @SortDir = 'ASC') THEN A.IdAplicacion END ASC,
				CASE WHEN (@SortType = 'Aplicacion.Nombre' AND @SortDir = 'ASC') THEN A.Nombre END ASC,
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'ASC') THEN M.Nombre END ASC,
				CASE WHEN (@SortType = 'Descripcion' AND @SortDir = 'ASC') THEN M.Descripcion END ASC,
				CASE WHEN (@SortType = 'Estado.IdEstado' AND @SortDir = 'ASC') THEN ES.IdEstado END ASC,
				CASE WHEN (@SortType = 'Estado.Nombre' AND @SortDir = 'ASC') THEN ES.Nombre END ASC,
				--DESC
				CASE WHEN (@SortType = 'IdModulo' AND @SortDir = 'DESC') THEN M.IdModulo END DESC,
				CASE WHEN (@SortType = 'Aplicacion.IdAplicacion' AND @SortDir = 'DESC') THEN M.IdAplicacion END DESC,
				CASE WHEN (@SortType = 'Aplicacion.Nombre' AND @SortDir = 'DESC') THEN A.Nombre END DESC,
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'DESC') THEN M.Nombre END DESC,
				CASE WHEN (@SortType = 'Descripcion' AND @SortDir = 'DESC') THEN M.Descripcion END DESC,
				CASE WHEN (@SortType = 'Estado.IdEstado' AND @SortDir = 'DESC') THEN ES.IdEstado END DESC,
				CASE WHEN (@SortType = 'Estado.Nombre' AND @SortDir = 'DESC') THEN ES.Nombre END DESC,
				--DEFAULT				
				CASE WHEN @SortType = '' THEN M.IdModulo END DESC 				
			)	
			AS ROWNUMBER,
			M.IdModulo,
			UPPER(M.Nombre) NombreModulo,
			UPPER(M.Descripcion) DescripcionModulo,
			E.IdEmpresa,
			UPPER(E.Nombre) NombreEmpresa,
			E.Abreviatura,
			A.IdAplicacion,
			UPPER(A.Nombre) NombreAplicacion,
			UPPER(A.Descripcion) DescripcionAplicacion,			
			A.Url,
			ES.IdEstado,
			UPPER(ES.Nombre) NombreEstado
			--TABLES 
			FROM Seguridad.Modulo M 
			Inner Join Seguridad.Aplicacion A On A.IdAplicacion = M.IdAplicacion
			Inner Join Seguridad.EmpresaAplicacion EA On EA.IdAplicacion = A.IdAplicacion  
			Inner Join Seguridad.Empresa E On E.IdEmpresa = EA.IdEmpresa
			Inner Join Estructura.Estado ES On ES.IdEstado = M.IdEstado
			WHERE			
			(@IdEmpresa = 0 Or EA.IdEmpresa = @IdEmpresa)
			And (@IdAplicacion = 0 Or EA.IdAplicacion = @IdAplicacion)	
			And (@Nombre = '' Or M.Nombre Like '%' + @Nombre + '%')
			And (@Descripcion = '' or M.Descripcion Like '%' + @Descripcion + '%')	
		)
		SELECT 
			IdModulo,
			NombreModulo,
			DescripcionModulo,
			IdEmpresa,
			NombreEmpresa,
			Abreviatura,
			IdAplicacion,
			NombreAplicacion,
			DescripcionAplicacion,
			Url,
			IdEstado,
			NombreEstado
		FROM Modulo
		WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page - 1) + 1) AND @Page * @RowsPerPage
		
		SET @RowCount = (
			SELECT COUNT(1)
			FROM Seguridad.Modulo M 
			Inner Join Seguridad.Aplicacion A On A.IdAplicacion = M.IdAplicacion
			Inner Join Seguridad.EmpresaAplicacion EA On EA.IdAplicacion = A.IdAplicacion  
			Inner Join Seguridad.Empresa E On E.IdEmpresa = EA.IdEmpresa
			Inner Join Estructura.Estado ES On ES.IdEstado = M.IdEstado
			WHERE			
			(@IdEmpresa = 0 Or EA.IdEmpresa = @IdEmpresa)
			And (@IdAplicacion = 0 Or EA.IdAplicacion = @IdAplicacion)	
			And (@Nombre = '' Or M.Nombre Like '%' + @Nombre + '%')
			And (@Descripcion = '' or M.Descripcion Like '%' + @Descripcion + '%')	
		)	
	END
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_ModuloPorAplicacion]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_ModuloPorAplicacion]
(
@IdAplicacion int
)
as
Begin
	Select Distinct 
	M.IdModulo, 
	upper(M.Nombre) NombreModulo, 
	upper(M.Descripcion) DescripcionModulo,
	ES.IdEstado, 
	upper(ES.Nombre) NombreEstado, 
	A.IdAplicacion, 
	upper(A.Nombre) NombreAplicacion, 
	upper(A.Descripcion) DescripcionAplicacion, 
	upper(A.Url) Url
	From Seguridad.Modulo M
	Inner Join Estructura.Estado ES On ES.IdEstado = M.IdEstado
	Inner Join Seguridad.Aplicacion A On A.IdAplicacion = M.IdAplicacion
	Inner Join Seguridad.EmpresaAplicacion EA On EA.IdAplicacion = A.IdAplicacion
	Inner Join Seguridad.Empresa E On E.IdEmpresa = EA.IdEmpresa
	Where M.IdAplicacion  = @IdAplicacion
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_ObtenerRolesPorUsuario]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Seguridad].[Usp_ObtenerRolesPorUsuario]
(
	@NombreUsuario varchar(50)
)
AS
BEGIN
	select R.Nombre from Seguridad.Rol R 
	join Seguridad.UsuarioRol UR
	on UR.IdRol = R.IdRol
	join Seguridad.Usuario U
	on U.IdUsuario = UR.IdUsuario
	where U.Usuario = @NombreUsuario

END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_ObtenerSiteMap]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Seguridad].[Usp_ObtenerSiteMap]-- 21,'JSACCATOMA'
	@IdAplicacion int,
	@nombreUsuario varchar(50) 
AS
BEGIN
	
	DECLARE @Flag INT
	DECLARE @Int  INT
	DECLARE @Count INT
	DECLARE @Vigencia INT
	DECLARE @FechaClave DATETIME
	DECLARE @Diferencia INT
	DECLARE @Op INT
	
	DECLARE @IdAplicacion2 INT
	SET @IdAplicacion2 = @IdAplicacion
						
	SET @Flag = (select top 1 ISNULL(ModoUsuaio,0) from Seguridad.Usuario where Usuario=@nombreUsuario) --2
	SET @Int = (select top 1 IdUsuario from Seguridad.Usuario where Usuario=@nombreUsuario)--10
	SET @Count = 2
	SET @Vigencia = (select Vigencia_Contrasena from Seguridad.Politica)--30
	SET @FechaClave = (SELECT FechaCreacion_Clave FROM Seguridad.Usuario WHERE Usuario=@nombreUsuario)--2015-01-15 22:08:06.260
	SET @Diferencia = (SELECT CAST(DATEDIFF(DAY,GETDATE(),@FechaClave)AS INT)) --  -11
	
	IF @Diferencia >= @Vigencia
		BEGIN
			SET @Op=1 -- Caducado
		END
	ELSE
		BEGIN
			SET @Op=0
		END
	
	IF @Flag=2 AND @Op=1
		BEGIN
			
			WITH ListaMenu (IdPagina,Orden,Descripcion,Url,IdPaginaPadre,Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu)
			AS
			(	
				select 
				Isnull(P.IdPaginaPadre,PF.IdPagina) IdPaginaPadre, 
				0 as Orden,
				Isnull((Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
				(Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Nombre, 
				
				Case When IdPaginaPadre is null then P.Url else null end	,
				null, M.IdModulo as Visible, 
				0,
				
				Isnull((Select Top 1 Icono From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
				(Select Top 1 Icono From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Icono, 0 ,
				(Select Descripcion from [Seguridad].[ModuloAgrupacion]
				 where IdAgrupacion in (select top 1 IdAgrupacion from [Seguridad].[Pagina]
									    where IdPagina = isnull(P.IdPaginaPadre,PF.IdPagina))) as Agrupacion,
				(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
									    where IdPagina = isnull(P.IdPaginaPadre,PF.IdPagina))as TamanoMenu
				
				from Seguridad.Pagina P
				join Seguridad.Modulo M On P.IdModulo = P.IdModulo
				join Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
				join Seguridad.Rol R on R.IdRol = PF.IdRol
				join Seguridad.UsuarioRol UR on UR.IdRol = R.IdRol
				join Seguridad.Usuario U on U.IdUsuario = UR.IdUsuario
				join Seguridad.Aplicacion A on A.IdAplicacion = PF.IdAplicacion
				and U.Usuario = @nombreUsuario And A.IdAplicacion = @IdAplicacion2
				And (P.IdPaginaPadre is not null Or Not Exists(Select 1 From Seguridad.Pagina Where IdPaginaPadre = P.IdPagina and P.IdEstado = 1))
				and R.IdEstado = 1 AND P.IdPaginaPadre = 71
				and P.IdEstado = 1

				union all
			
				select P.IdPagina,	P.Orden as Orden,P.Nombre,P.Url,P.IdPaginaPadre IdPaginaPadre,P.Visible,P.Nivel as Nivel,Icono, 1 as LEVEL,--Level + 1,
				(Select Descripcion from [Seguridad].[ModuloAgrupacion]
				 where IdAgrupacion in (select top 1 IdAgrupacion from [Seguridad].[Pagina]
									    where IdPagina = P.IdPagina)) as Agrupacion,
				(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
									    where IdPagina = P.IdPagina) as TamanoMenu
				from Seguridad.Pagina P
				join Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
				join Seguridad.Rol R on R.IdRol = PF.IdRol
				join Seguridad.UsuarioRol UR on UR.IdRol = R.IdRol
				join Seguridad.Usuario U on U.IdUsuario = UR.IdUsuario
				join Seguridad.Aplicacion A on A.IdAplicacion = PF.IdAplicacion
				and U.Usuario = @nombreUsuario And A.IdAplicacion = @IdAplicacion2
				And P.IdPaginaPadre is not null
				and R.IdEstado = 1 AND P.IdPagina=72
				and P.IdEstado = 1
			)
			
			SELECT	DISTINCT IdPagina,Orden,Descripcion,Url,IdPaginaPadre,CAST(Visible as BIT)as Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu

			FROM	ListaMenu
			ORDER BY Orden
		END
	ELSE IF @Flag=2 AND @Count=1
		BEGIN
			
			WITH ListaMenu (IdPagina,Orden,Descripcion,Url,IdPaginaPadre,Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu)
			AS
			(	select top 1
				Isnull(P.IdPaginaPadre,PF.IdPagina) IdPaginaPadre, 
				0 as Orden,
				Isnull((Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
				(Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Nombre, 

				Case When IdPaginaPadre is null then P.Url else null end	,
				null, M.IdModulo as Visible, 0,

				Isnull((Select Top 1 Icono From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
				(Select Top 1 Icono From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Icono, 0,

				(Select Descripcion from [Seguridad].[ModuloAgrupacion]
				 where IdAgrupacion in (select top 1 IdAgrupacion from [Seguridad].[Pagina]
									    where IdPagina = PF.IdPagina)) as Agrupacion,
				(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
									    where IdPagina = PF.IdPagina)as TamanoMenu
				from Seguridad.Pagina P
				join Seguridad.Modulo M On P.IdModulo = P.IdModulo
				join Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
				And (P.IdPaginaPadre is not null Or Not Exists(Select 1 From Seguridad.Pagina Where IdPaginaPadre = P.IdPagina and P.IdEstado = 1))
				AND P.IdPaginaPadre=71
				and P.IdEstado = 1
				union all

				select P.IdPagina,P.Orden as Orden,P.Nombre,P.Url,P.IdPaginaPadre IdPaginaPadre,P.Visible,P.Nivel as Nivel,Icono, 1 as LEVEL,--Level + 1
				(Select Descripcion from [Seguridad].[ModuloAgrupacion]
				 where IdAgrupacion in (select top 1 IdAgrupacion from [Seguridad].[Pagina]
									    where IdPagina = P.IdPagina)) as Agrupacion,
				(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
									    where IdPagina = P.IdPagina)as TamanoMenu
				from Seguridad.Pagina P
				join Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
				join Seguridad.Rol R on R.IdRol = PF.IdRol
				join Seguridad.UsuarioRol UR on UR.IdRol = R.IdRol
				join Seguridad.Usuario U on U.IdUsuario = UR.IdUsuario
				join Seguridad.Aplicacion A on A.IdAplicacion = PF.IdAplicacion
				/*and U.Usuario = @nombreUsuario And A.IdAplicacion = @IdAplicacion*/
				And P.IdPaginaPadre is not null
				and R.IdEstado = 1 AND P.IdPagina=72
				and P.IdEstado = 1
			)
			
			SELECT	DISTINCT IdPagina,Orden,Descripcion,Url,IdPaginaPadre,CAST(Visible as BIT)as Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu
			FROM	ListaMenu
			ORDER BY Orden
		END
	ELSE
		BEGIN
			WITH ListaMenu (IdPagina,Orden,Descripcion,Url,IdPaginaPadre,Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu)
			AS
			(	
				select 
				Isnull(P.IdPaginaPadre,PF.IdPagina) IdPaginaPadre, 
				0 as Orden,
				Isnull((Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
				(Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Nombre, 
				
				Case When IdPaginaPadre is null then P.Url else null end	,
				null, M.IdModulo as Visible, 
				0,
				
				Isnull((Select Top 1 Icono From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
				(Select Top 1 Icono From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Icono, 0 ,
				(Select Descripcion from [Seguridad].[ModuloAgrupacion]
				 where IdAgrupacion in (select top 1 IdAgrupacion from [Seguridad].[Pagina]
									    where IdPagina = isnull(P.IdPaginaPadre,PF.IdPagina))) as Agrupacion,
				(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
									    where IdPagina = isnull(P.IdPaginaPadre,PF.IdPagina))as TamanoMenu
				
				from Seguridad.Pagina P
				join Seguridad.Modulo M On P.IdModulo = P.IdModulo
				join Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
				join Seguridad.Rol R on R.IdRol = PF.IdRol
				join Seguridad.UsuarioRol UR on UR.IdRol = R.IdRol
				join Seguridad.Usuario U on U.IdUsuario = UR.IdUsuario
				join Seguridad.Aplicacion A on A.IdAplicacion = PF.IdAplicacion
				and U.Usuario = @nombreUsuario And A.IdAplicacion = @IdAplicacion2
				And (P.IdPaginaPadre is not null Or Not Exists(Select 1 From Seguridad.Pagina Where IdPaginaPadre = P.IdPagina and P.IdEstado = 1))
				and R.IdEstado = 1 AND P.IdPaginaPadre not in (71)
				and P.IdEstado = 1
				union all
			
				select P.IdPagina,P.Orden as Orden,P.Nombre,P.Url,P.IdPaginaPadre IdPaginaPadre,P.Visible,P.Nivel as Nivel,Icono, 1 as LEVEL,--Level + 1
				(Select Descripcion from [Seguridad].[ModuloAgrupacion]
				 where IdAgrupacion in (select top 1 IdAgrupacion from [Seguridad].[Pagina]
									    where IdPagina = P.IdPagina)) as Agrupacion,
				(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
									    where IdPagina = P.IdPagina) as TamanoMenu
				from Seguridad.Pagina P
				join Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
				join Seguridad.Rol R on R.IdRol = PF.IdRol
				join Seguridad.UsuarioRol UR on UR.IdRol = R.IdRol
				join Seguridad.Usuario U on U.IdUsuario = UR.IdUsuario
				join Seguridad.Aplicacion A on A.IdAplicacion = PF.IdAplicacion
				and U.Usuario = @nombreUsuario And A.IdAplicacion = @IdAplicacion2
				And P.IdPaginaPadre is not null 
				and R.IdEstado = 1 AND P.IdPagina not in (72)
				and P.IdEstado = 1
			)
			
	

			SELECT	DISTINCT IdPagina,Orden,Descripcion,Url,IdPaginaPadre,CAST(Visible as BIT)as Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu

			FROM	ListaMenu
			ORDER BY Orden
		END
	
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_ObtenerSiteMapFarmacia]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Seguridad].[Usp_ObtenerSiteMapFarmacia]
	@IdAplicacion	int,
	@nombreUsuario	varchar(50),
	@Ip				varchar(50)
AS
BEGIN
	
	DECLARE @Flag INT
	DECLARE @Int  INT
	DECLARE @Count INT
	DECLARE @Vigencia INT
	DECLARE @FechaClave DATETIME
	DECLARE @Diferencia INT
	DECLARE @Op INT
	DECLARE @IdCentroAtencion INT
	
	DECLARE @IdAplicacion2 INT
	SET @IdAplicacion2 = @IdAplicacion

	DECLARE @ESNUMERO BIT;
	SET @ESNUMERO = ISNUMERIC(@IP);
	IF (@ESNUMERO = 1) --LISTAR MENU POR ID ROL
	BEGIN
		 			
		SET @Flag = (select top 1 ISNULL(ModoUsuaio,0) from Seguridad.Usuario where Usuario=@nombreUsuario) --2
		SET @Int = (select top 1 IdUsuario from Seguridad.Usuario where Usuario=@nombreUsuario)--10
		SET @Count = 2
		SET @Vigencia = (select Vigencia_Contrasena from Seguridad.Politica)--30
		SET @FechaClave = (SELECT FechaCreacion_Clave FROM Seguridad.Usuario WHERE Usuario=@nombreUsuario)--2015-01-15 22:08:06.260
		SET @Diferencia = (SELECT CAST(DATEDIFF(DAY,GETDATE(),@FechaClave)AS INT)) --  -11
	
		IF @Diferencia >= @Vigencia
			BEGIN
				SET @Op=1 -- Caducado
			END
		ELSE
			BEGIN
				SET @Op=0
			END
	
		IF @Flag=2 AND @Op=1
			BEGIN
			
				WITH ListaMenu (IdPagina,Orden,Descripcion,Url,IdPaginaPadre,Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu)
				AS
				(	
					select 
					Isnull(P.IdPaginaPadre,PF.IdPagina) IdPaginaPadre, 
					0 as Orden,
					Isnull((Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
					(Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Nombre, 
				
					Case When IdPaginaPadre is null then P.Url else null end	,
					null, M.IdModulo as Visible, 
					0,
				
					Isnull((Select Top 1 Icono From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
					(Select Top 1 Icono From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Icono, 0 ,
					(Select Descripcion from [Seguridad].[ModuloAgrupacion]
					 where IdAgrupacion in (select top 1 IdAgrupacion from [Seguridad].[Pagina]
											where IdPagina = isnull(P.IdPaginaPadre,PF.IdPagina))) as Agrupacion,
					(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
											where IdPagina = isnull(P.IdPaginaPadre,PF.IdPagina))as TamanoMenu
				
					from Seguridad.Pagina P
					join Seguridad.Modulo M On P.IdModulo = P.IdModulo
					join Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
					join Seguridad.Rol R on R.IdRol = PF.IdRol
					join Seguridad.UsuarioRol UR on UR.IdRol = R.IdRol
					join Seguridad.Usuario U on U.IdUsuario = UR.IdUsuario
					join Seguridad.Aplicacion A on A.IdAplicacion = PF.IdAplicacion
					and U.Usuario = @nombreUsuario And A.IdAplicacion = @IdAplicacion2
					--AND R.IdCentroAtencion = @IdCentroAtencion 
					AND R.IdRol = @Ip
					And (P.IdPaginaPadre is not null Or Not Exists(Select 1 From Seguridad.Pagina Where IdPaginaPadre = P.IdPagina and P.IdEstado = 1))
					and R.IdEstado = 1 AND P.IdPaginaPadre = 71
					and P.IdEstado = 1

					union all
			
					select P.IdPagina,	P.Orden as Orden,P.Nombre,P.Url,P.IdPaginaPadre IdPaginaPadre,P.Visible,P.Nivel as Nivel,Icono, 1 as LEVEL,--Level + 1,
					(Select Descripcion from [Seguridad].[ModuloAgrupacion]
					 where IdAgrupacion in (select top 1 IdAgrupacion from [Seguridad].[Pagina]
											where IdPagina = P.IdPagina)) as Agrupacion,
					(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
											where IdPagina = P.IdPagina) as TamanoMenu
					from Seguridad.Pagina P
					join Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
					join Seguridad.Rol R on R.IdRol = PF.IdRol
					join Seguridad.UsuarioRol UR on UR.IdRol = R.IdRol
					join Seguridad.Usuario U on U.IdUsuario = UR.IdUsuario
					join Seguridad.Aplicacion A on A.IdAplicacion = PF.IdAplicacion
					and U.Usuario = @nombreUsuario And A.IdAplicacion = @IdAplicacion2
					--AND R.IdCentroAtencion = @IdCentroAtencion 
					AND R.IdRol = @Ip
					And P.IdPaginaPadre is not null
					and R.IdEstado = 1 AND P.IdPagina=72
					and P.IdEstado = 1
				)
			
				SELECT	DISTINCT IdPagina,Orden,Descripcion,Url,IdPaginaPadre,CAST(Visible as BIT)as Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu

				FROM	ListaMenu
				ORDER BY Orden
			END
		ELSE IF @Flag=2 AND @Count=1
			BEGIN
			
				WITH ListaMenu (IdPagina,Orden,Descripcion,Url,IdPaginaPadre,Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu)
				AS
				(	select top 1
					Isnull(P.IdPaginaPadre,PF.IdPagina) IdPaginaPadre, 
					0 as Orden,
					Isnull((Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
					(Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Nombre, 

					Case When IdPaginaPadre is null then P.Url else null end	,
					null, M.IdModulo as Visible, 0,

					Isnull((Select Top 1 Icono From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
					(Select Top 1 Icono From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Icono, 0,

					(Select Descripcion from [Seguridad].[ModuloAgrupacion]
					 where IdAgrupacion in (select top 1 IdAgrupacion from [Seguridad].[Pagina]
											where IdPagina = PF.IdPagina)) as Agrupacion,
					(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
											where IdPagina = PF.IdPagina)as TamanoMenu
					from Seguridad.Pagina P
					join Seguridad.Modulo M On P.IdModulo = P.IdModulo
					join Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
					And (P.IdPaginaPadre is not null Or Not Exists(Select 1 From Seguridad.Pagina Where IdPaginaPadre = P.IdPagina and P.IdEstado = 1))
					AND P.IdPaginaPadre=71
					and P.IdEstado = 1
					union all

					select P.IdPagina,P.Orden as Orden,P.Nombre,P.Url,P.IdPaginaPadre IdPaginaPadre,P.Visible,P.Nivel as Nivel,Icono, 1 as LEVEL,--Level + 1
					(Select Descripcion from [Seguridad].[ModuloAgrupacion]
					 where IdAgrupacion in (select top 1 IdAgrupacion from [Seguridad].[Pagina]
											where IdPagina = P.IdPagina)) as Agrupacion,
					(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
											where IdPagina = P.IdPagina)as TamanoMenu
					from Seguridad.Pagina P
					join Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
					join Seguridad.Rol R on R.IdRol = PF.IdRol
					join Seguridad.UsuarioRol UR on UR.IdRol = R.IdRol
					join Seguridad.Usuario U on U.IdUsuario = UR.IdUsuario
					join Seguridad.Aplicacion A on A.IdAplicacion = PF.IdAplicacion
					And P.IdPaginaPadre is not null
					and R.IdEstado = 1 AND P.IdPagina=72
					and P.IdEstado = 1
				)
			
				SELECT	DISTINCT IdPagina,Orden,Descripcion,Url,IdPaginaPadre,CAST(Visible as BIT)as Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu
				FROM	ListaMenu
				ORDER BY Orden
			END
		ELSE
			BEGIN
				WITH ListaMenu (IdPagina,Orden,Descripcion,Url,IdPaginaPadre,Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu)
				AS
				(	
					select 
					Isnull(P.IdPaginaPadre,PF.IdPagina) IdPaginaPadre, 
					0 as Orden,
					Isnull((Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
					(Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Nombre, 
				
					Case When IdPaginaPadre is null then P.Url else null end	,
					null, M.IdModulo as Visible, 
					0,
				
					Isnull((Select Top 1 Icono From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
					(Select Top 1 Icono From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Icono, 0 ,
					(Select Descripcion from [Seguridad].[ModuloAgrupacion]
					 where IdAgrupacion in (select top 1 IdAgrupacion from [Seguridad].[Pagina]
											where IdPagina = isnull(P.IdPaginaPadre,PF.IdPagina))) as Agrupacion,
					(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
											where IdPagina = isnull(P.IdPaginaPadre,PF.IdPagina))as TamanoMenu
				
					from Seguridad.Pagina P
					join Seguridad.Modulo M On P.IdModulo = P.IdModulo
					join Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
					join Seguridad.Rol R on R.IdRol = PF.IdRol
					join Seguridad.UsuarioRol UR on UR.IdRol = R.IdRol
					join Seguridad.Usuario U on U.IdUsuario = UR.IdUsuario
					join Seguridad.Aplicacion A on A.IdAplicacion = PF.IdAplicacion
					and U.Usuario = @nombreUsuario And A.IdAplicacion = @IdAplicacion2
					--AND R.IdCentroAtencion = @IdCentroAtencion AND A.IdAplicacion = @IdAplicacion2
					AND R.IdRol = @Ip
					And (P.IdPaginaPadre is not null Or Not Exists(Select 1 From Seguridad.Pagina Where IdPaginaPadre = P.IdPagina and P.IdEstado = 1))
					and R.IdEstado = 1 AND P.IdPaginaPadre not in (71)
					and P.IdEstado = 1
					union all
			
					select P.IdPagina,P.Orden as Orden,P.Nombre,P.Url,P.IdPaginaPadre IdPaginaPadre,P.Visible,P.Nivel as Nivel,Icono, 1 as LEVEL,--Level + 1
					(Select Descripcion from [Seguridad].[ModuloAgrupacion]
					 where IdAgrupacion in (select top 1 IdAgrupacion from [Seguridad].[Pagina]
											where IdPagina = P.IdPagina)) as Agrupacion,
					(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
											where IdPagina = P.IdPagina) as TamanoMenu
					from Seguridad.Pagina P
					join Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
					join Seguridad.Rol R on R.IdRol = PF.IdRol
					join Seguridad.UsuarioRol UR on UR.IdRol = R.IdRol
					join Seguridad.Usuario U on U.IdUsuario = UR.IdUsuario
					join Seguridad.Aplicacion A on A.IdAplicacion = PF.IdAplicacion
					and U.Usuario = @nombreUsuario And A.IdAplicacion = @IdAplicacion2
					--AND R.IdCentroAtencion = @IdCentroAtencion AND A.IdAplicacion = @IdAplicacion2
					AND R.IdRol = @Ip
					And P.IdPaginaPadre is not null 
					and R.IdEstado = 1 AND P.IdPagina not in (72)
					and P.IdEstado = 1
				)
			
	

				SELECT	DISTINCT IdPagina,Orden,Descripcion,Url,IdPaginaPadre,CAST(Visible as BIT)as Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu

				FROM	ListaMenu
				ORDER BY Orden
			END
	END
	ELSE --LISTAR MENU POR IP
	BEGIN
		
		SET @IdCentroAtencion = (SELECT TOP 1 ISNULL(CA.IdCentroAtencion, 0) FROM [BD_ERP_MASTER].Maestro.CentroAtencion CA
		 INNER JOIN [BD_ERP_MASTER].Maestro.CentroAtencionIP CAI on CA.IdCentroAtencion = CAI.IdCentroAtencion
		 WHERE IP = @Ip )						
		SET @Flag = (select top 1 ISNULL(ModoUsuaio,0) from Seguridad.Usuario where Usuario=@nombreUsuario) --2
		SET @Int = (select top 1 IdUsuario from Seguridad.Usuario where Usuario=@nombreUsuario)--10
		SET @Count = 2
		SET @Vigencia = (select Vigencia_Contrasena from Seguridad.Politica)--30
		SET @FechaClave = (SELECT FechaCreacion_Clave FROM Seguridad.Usuario WHERE Usuario=@nombreUsuario)--2015-01-15 22:08:06.260
		SET @Diferencia = (SELECT CAST(DATEDIFF(DAY,GETDATE(),@FechaClave)AS INT)) --  -11
	
		IF @Diferencia >= @Vigencia
			BEGIN
				SET @Op=1 -- Caducado
			END
		ELSE
			BEGIN
				SET @Op=0
			END
	
		IF @Flag=2 AND @Op=1
			BEGIN
			
				WITH ListaMenu (IdPagina,Orden,Descripcion,Url,IdPaginaPadre,Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu)
				AS
				(	
					select 
					Isnull(P.IdPaginaPadre,PF.IdPagina) IdPaginaPadre, 
					0 as Orden,
					Isnull((Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
					(Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Nombre, 
				
					Case When IdPaginaPadre is null then P.Url else null end	,
					null, M.IdModulo as Visible, 
					0,
				
					Isnull((Select Top 1 Icono From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
					(Select Top 1 Icono From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Icono, 0 ,
					(Select Descripcion from [Seguridad].[ModuloAgrupacion]
					 where IdAgrupacion in (select top 1 IdAgrupacion from [Seguridad].[Pagina]
											where IdPagina = isnull(P.IdPaginaPadre,PF.IdPagina))) as Agrupacion,
					(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
											where IdPagina = isnull(P.IdPaginaPadre,PF.IdPagina))as TamanoMenu
				
					from Seguridad.Pagina P
					join Seguridad.Modulo M On P.IdModulo = P.IdModulo
					join Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
					join Seguridad.Rol R on R.IdRol = PF.IdRol
					--join Seguridad.UsuarioRol UR on UR.IdRol = R.IdRol
					--join Seguridad.Usuario U on U.IdUsuario = UR.IdUsuario
					join Seguridad.Aplicacion A on A.IdAplicacion = PF.IdAplicacion
					--and U.Usuario = @nombreUsuario And A.IdAplicacion = @IdAplicacion2
					AND R.IdCentroAtencion = @IdCentroAtencion 
					And (P.IdPaginaPadre is not null Or Not Exists(Select 1 From Seguridad.Pagina Where IdPaginaPadre = P.IdPagina and P.IdEstado = 1))
					and R.IdEstado = 1 AND P.IdPaginaPadre = 71
					and P.IdEstado = 1

					union all
			
					select P.IdPagina,	P.Orden as Orden,P.Nombre,P.Url,P.IdPaginaPadre IdPaginaPadre,P.Visible,P.Nivel as Nivel,Icono, 1 as LEVEL,--Level + 1,
					(Select Descripcion from [Seguridad].[ModuloAgrupacion]
					 where IdAgrupacion in (select top 1 IdAgrupacion from [Seguridad].[Pagina]
											where IdPagina = P.IdPagina)) as Agrupacion,
					(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
											where IdPagina = P.IdPagina) as TamanoMenu
					from Seguridad.Pagina P
					join Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
					join Seguridad.Rol R on R.IdRol = PF.IdRol
					--join Seguridad.UsuarioRol UR on UR.IdRol = R.IdRol
					--join Seguridad.Usuario U on U.IdUsuario = UR.IdUsuario
					join Seguridad.Aplicacion A on A.IdAplicacion = PF.IdAplicacion
					--and U.Usuario = @nombreUsuario And A.IdAplicacion = @IdAplicacion2
					AND R.IdCentroAtencion = @IdCentroAtencion 
					And P.IdPaginaPadre is not null
					and R.IdEstado = 1 AND P.IdPagina=72
					and P.IdEstado = 1
				)
			
				SELECT	DISTINCT IdPagina,Orden,Descripcion,Url,IdPaginaPadre,CAST(Visible as BIT)as Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu

				FROM	ListaMenu
				ORDER BY Orden
			END
		ELSE IF @Flag=2 AND @Count=1
			BEGIN
			
				WITH ListaMenu (IdPagina,Orden,Descripcion,Url,IdPaginaPadre,Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu)
				AS
				(	select top 1
					Isnull(P.IdPaginaPadre,PF.IdPagina) IdPaginaPadre, 
					0 as Orden,
					Isnull((Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
					(Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Nombre, 

					Case When IdPaginaPadre is null then P.Url else null end	,
					null, M.IdModulo as Visible, 0,

					Isnull((Select Top 1 Icono From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
					(Select Top 1 Icono From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Icono, 0,

					(Select Descripcion from [Seguridad].[ModuloAgrupacion]
					 where IdAgrupacion in (select top 1 IdAgrupacion from [Seguridad].[Pagina]
											where IdPagina = PF.IdPagina)) as Agrupacion,
					(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
											where IdPagina = PF.IdPagina)as TamanoMenu
					from Seguridad.Pagina P
					join Seguridad.Modulo M On P.IdModulo = P.IdModulo
					join Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
					And (P.IdPaginaPadre is not null Or Not Exists(Select 1 From Seguridad.Pagina Where IdPaginaPadre = P.IdPagina and P.IdEstado = 1))
					AND P.IdPaginaPadre=71
					and P.IdEstado = 1
					union all

					select P.IdPagina,P.Orden as Orden,P.Nombre,P.Url,P.IdPaginaPadre IdPaginaPadre,P.Visible,P.Nivel as Nivel,Icono, 1 as LEVEL,--Level + 1
					(Select Descripcion from [Seguridad].[ModuloAgrupacion]
					 where IdAgrupacion in (select top 1 IdAgrupacion from [Seguridad].[Pagina]
											where IdPagina = P.IdPagina)) as Agrupacion,
					(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
											where IdPagina = P.IdPagina)as TamanoMenu
					from Seguridad.Pagina P
					join Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
					join Seguridad.Rol R on R.IdRol = PF.IdRol
					--join Seguridad.UsuarioRol UR on UR.IdRol = R.IdRol
					--join Seguridad.Usuario U on U.IdUsuario = UR.IdUsuario
					join Seguridad.Aplicacion A on A.IdAplicacion = PF.IdAplicacion
					And P.IdPaginaPadre is not null
					and R.IdEstado = 1 AND P.IdPagina=72
					and P.IdEstado = 1
				)
			
				SELECT	DISTINCT IdPagina,Orden,Descripcion,Url,IdPaginaPadre,CAST(Visible as BIT)as Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu
				FROM	ListaMenu
				ORDER BY Orden
			END
		ELSE
			BEGIN
				WITH ListaMenu (IdPagina,Orden,Descripcion,Url,IdPaginaPadre,Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu)
				AS
				(	
					select 
					Isnull(P.IdPaginaPadre,PF.IdPagina) IdPaginaPadre, 
					0 as Orden,
					Isnull((Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
					(Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Nombre, 
				
					Case When IdPaginaPadre is null then P.Url else null end	,
					null, M.IdModulo as Visible, 
					0,
				
					Isnull((Select Top 1 Icono From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
					(Select Top 1 Icono From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Icono, 0 ,
					(Select Descripcion from [Seguridad].[ModuloAgrupacion]
					 where IdAgrupacion in (select top 1 IdAgrupacion from [Seguridad].[Pagina]
											where IdPagina = isnull(P.IdPaginaPadre,PF.IdPagina))) as Agrupacion,
					(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
											where IdPagina = isnull(P.IdPaginaPadre,PF.IdPagina))as TamanoMenu
				
					from Seguridad.Pagina P
					join Seguridad.Modulo M On P.IdModulo = P.IdModulo
					join Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
					join Seguridad.Rol R on R.IdRol = PF.IdRol
					--join Seguridad.UsuarioRol UR on UR.IdRol = R.IdRol
					--join Seguridad.Usuario U on U.IdUsuario = UR.IdUsuario
					join Seguridad.Aplicacion A on A.IdAplicacion = PF.IdAplicacion
					--and U.Usuario = @nombreUsuario And A.IdAplicacion = @IdAplicacion2
					AND R.IdCentroAtencion = @IdCentroAtencion AND A.IdAplicacion = @IdAplicacion2
					And (P.IdPaginaPadre is not null Or Not Exists(Select 1 From Seguridad.Pagina Where IdPaginaPadre = P.IdPagina and P.IdEstado = 1))
					and R.IdEstado = 1 AND P.IdPaginaPadre not in (71)
					and P.IdEstado = 1
					union all
			
					select P.IdPagina,P.Orden as Orden,P.Nombre,P.Url,P.IdPaginaPadre IdPaginaPadre,P.Visible,P.Nivel as Nivel,Icono, 1 as LEVEL,--Level + 1
					(Select Descripcion from [Seguridad].[ModuloAgrupacion]
					 where IdAgrupacion in (select top 1 IdAgrupacion from [Seguridad].[Pagina]
											where IdPagina = P.IdPagina)) as Agrupacion,
					(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
											where IdPagina = P.IdPagina) as TamanoMenu
					from Seguridad.Pagina P
					join Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
					join Seguridad.Rol R on R.IdRol = PF.IdRol
					--join Seguridad.UsuarioRol UR on UR.IdRol = R.IdRol
					--join Seguridad.Usuario U on U.IdUsuario = UR.IdUsuario
					join Seguridad.Aplicacion A on A.IdAplicacion = PF.IdAplicacion
					--and U.Usuario = @nombreUsuario And A.IdAplicacion = @IdAplicacion2
					AND R.IdCentroAtencion = @IdCentroAtencion AND A.IdAplicacion = @IdAplicacion2
					And P.IdPaginaPadre is not null 
					and R.IdEstado = 1 AND P.IdPagina not in (72)
					and P.IdEstado = 1
				)
			
	

				SELECT	DISTINCT IdPagina,Orden,Descripcion,Url,IdPaginaPadre,CAST(Visible as BIT)as Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu

				FROM	ListaMenu
				ORDER BY Orden
			END

	END


	
	
	
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_ObtenerSiteMapPorUsuario]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [Seguridad].[Usp_ObtenerSiteMapPorUsuario]
	@IdAplicacion	INT,
	@nombreUsuario	VARCHAR(50),
	@IdRol			VARCHAR(50)
AS
BEGIN
	
	DECLARE @Flag INT
	DECLARE @Int  INT
	DECLARE @Count INT
	DECLARE @Vigencia INT
	DECLARE @FechaClave DATETIME
	DECLARE @Diferencia INT
	DECLARE @Op INT
	DECLARE @IdCentroAtencion INT
	
	DECLARE @IdAplicacion2 INT
	SET @IdAplicacion2 = @IdAplicacion

	SET @Flag = (select top 1 ISNULL(ModoUsuaio,0) from Seguridad.Usuario where Usuario=@nombreUsuario) --2
	SET @Int = (select top 1 IdUsuario from Seguridad.Usuario where Usuario=@nombreUsuario)--10
	SET @Count = 2
	SET @Vigencia = (select Vigencia_Contrasena from Seguridad.Politica)--30
	SET @FechaClave = (SELECT FechaCreacion_Clave FROM Seguridad.Usuario WHERE Usuario=@nombreUsuario)--2015-01-15 22:08:06.260
	SET @Diferencia = (SELECT CAST(DATEDIFF(DAY,GETDATE(),@FechaClave)AS INT)) --  -11
	
	IF @Diferencia >= @Vigencia
		BEGIN
			SET @Op=1 -- Caducado
		END
	ELSE
		BEGIN
			SET @Op=0
		END
	
	IF @Flag=2 AND @Op=1
		BEGIN
		
			WITH ListaMenu (IdPagina,Orden,Descripcion,Url,IdPaginaPadre,Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu)
			AS
			(	
				select 
				Isnull(P.IdPaginaPadre,PF.IdPagina) IdPaginaPadre, 
				0 as Orden,
				Isnull((Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
				(Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Nombre, 
			
				Case When IdPaginaPadre is null then P.Url else null end	,
				null, M.IdModulo as Visible, 
				0,
			
				Isnull((Select Top 1 Icono From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
				(Select Top 1 Icono From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Icono, 0 ,
				(Select Descripcion from [Seguridad].[ModuloAgrupacion]
				 where IdAgrupacion in (select top 1 IdAgrupacion from [Seguridad].[Pagina]
										where IdPagina = isnull(P.IdPaginaPadre,PF.IdPagina))) as Agrupacion,
				(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
										where IdPagina = isnull(P.IdPaginaPadre,PF.IdPagina))as TamanoMenu
			
				from Seguridad.Pagina P
				join Seguridad.Modulo M On P.IdModulo = P.IdModulo
				join Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
				join Seguridad.Rol R on R.IdRol = PF.IdRol
				join Seguridad.UsuarioRol UR on UR.IdRol = R.IdRol
				join Seguridad.Usuario U on U.IdUsuario = UR.IdUsuario
				join Seguridad.Aplicacion A on A.IdAplicacion = PF.IdAplicacion
				and U.Usuario = @nombreUsuario And A.IdAplicacion = @IdAplicacion2
				--AND R.IdCentroAtencion = @IdCentroAtencion 
				AND R.IdRol = @IdRol
				And (P.IdPaginaPadre is not null Or Not Exists(Select 1 From Seguridad.Pagina Where IdPaginaPadre = P.IdPagina and P.IdEstado = 1))
				and R.IdEstado = 1 AND P.IdPaginaPadre = 71
				and P.IdEstado = 1

				union all
		
				select P.IdPagina,	P.Orden as Orden,P.Nombre,P.Url,P.IdPaginaPadre IdPaginaPadre,P.Visible,P.Nivel as Nivel,Icono, 1 as LEVEL,--Level + 1,
				(Select Descripcion from [Seguridad].[ModuloAgrupacion]
				 where IdAgrupacion in (select top 1 IdAgrupacion from [Seguridad].[Pagina]
										where IdPagina = P.IdPagina)) as Agrupacion,
				(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
										where IdPagina = P.IdPagina) as TamanoMenu
				from Seguridad.Pagina P
				join Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
				join Seguridad.Rol R on R.IdRol = PF.IdRol
				join Seguridad.UsuarioRol UR on UR.IdRol = R.IdRol
				join Seguridad.Usuario U on U.IdUsuario = UR.IdUsuario
				join Seguridad.Aplicacion A on A.IdAplicacion = PF.IdAplicacion
				AND U.Usuario = @nombreUsuario And A.IdAplicacion = @IdAplicacion2
				AND R.IdRol = @IdRol
				And P.IdPaginaPadre is not null
				AND R.IdEstado = 1 AND P.IdPagina=72
				AND P.IdEstado = 1
			)
		
			SELECT	DISTINCT IdPagina,Orden,Descripcion,Url,IdPaginaPadre,CAST(Visible as BIT)as Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu

			FROM	ListaMenu
			ORDER BY Orden
		END
	ELSE IF @Flag=2 AND @Count=1
		BEGIN
		
			WITH ListaMenu (IdPagina,Orden,Descripcion,Url,IdPaginaPadre,Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu)
			AS
			(	select top 1
				Isnull(P.IdPaginaPadre,PF.IdPagina) IdPaginaPadre, 
				0 as Orden,
				Isnull((Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
				(Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Nombre, 

				Case When IdPaginaPadre is null then P.Url else null end	,
				null, M.IdModulo as Visible, 0,

				Isnull((Select Top 1 Icono From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
				(Select Top 1 Icono From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Icono, 0,

				(Select Descripcion from [Seguridad].[ModuloAgrupacion]
				 where IdAgrupacion in (select top 1 IdAgrupacion from [Seguridad].[Pagina]
										where IdPagina = PF.IdPagina)) as Agrupacion,
				(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
										where IdPagina = PF.IdPagina)as TamanoMenu
				from Seguridad.Pagina P
				join Seguridad.Modulo M On P.IdModulo = P.IdModulo
				join Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
				And (P.IdPaginaPadre is not null Or Not Exists(Select 1 From Seguridad.Pagina Where IdPaginaPadre = P.IdPagina and P.IdEstado = 1))
				AND P.IdPaginaPadre=71
				and P.IdEstado = 1
				union all

				select P.IdPagina,P.Orden as Orden,P.Nombre,P.Url,P.IdPaginaPadre IdPaginaPadre,P.Visible,P.Nivel as Nivel,Icono, 1 as LEVEL,--Level + 1
				(Select Descripcion from [Seguridad].[ModuloAgrupacion]
				 where IdAgrupacion in (select top 1 IdAgrupacion from [Seguridad].[Pagina]
										where IdPagina = P.IdPagina)) as Agrupacion,
				(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
										where IdPagina = P.IdPagina)as TamanoMenu
				from Seguridad.Pagina P
				join Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
				join Seguridad.Rol R on R.IdRol = PF.IdRol
				join Seguridad.UsuarioRol UR on UR.IdRol = R.IdRol
				join Seguridad.Usuario U on U.IdUsuario = UR.IdUsuario
				join Seguridad.Aplicacion A on A.IdAplicacion = PF.IdAplicacion
				And P.IdPaginaPadre is not null
				and R.IdEstado = 1 AND P.IdPagina=72
				and P.IdEstado = 1
			)
		
			SELECT	DISTINCT IdPagina,Orden,Descripcion,Url,IdPaginaPadre,CAST(Visible as BIT)as Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu
			FROM	ListaMenu
			ORDER BY Orden
		END
	ELSE
		BEGIN
			WITH ListaMenu (IdPagina,Orden,OrdenModulo, OrdenAgrupador, OrdenPagina,Descripcion,Url,IdPaginaPadre,Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu)
			AS
			(	
				select 
				Isnull(P.IdPaginaPadre,PF.IdPagina) IdPaginaPadre, 
				0 as Orden,
				M.Orden AS OrdenModulo,
				0       AS OrdenAgrupador,
				0		AS OrdenPagina,
				Isnull((Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
				(Select Top 1 Nombre From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Nombre, 
			
				Case When IdPaginaPadre is null then P.Url else null end	,
				null, M.IdModulo as Visible, 
				0,
			
				Isnull((Select Top 1 Icono From Seguridad.Pagina Where IdPagina = P.IdPaginaPadre),
				(Select Top 1 Icono From Seguridad.Pagina Where IdPagina = PF.IdPagina)) Icono, 0 ,
				(Select Descripcion from [Seguridad].[ModuloAgrupacion]
				 where IdAgrupacion in (select top 1 IdAgrupacion from [Seguridad].[Pagina]
										where IdPagina = isnull(P.IdPaginaPadre,PF.IdPagina))) as Agrupacion,
				(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
										where IdPagina = isnull(P.IdPaginaPadre,PF.IdPagina))as TamanoMenu
			
				from Seguridad.Pagina P
				JOIN Seguridad.Modulo M On P.IdModulo = M.IdModulo
				JOIN Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
				JOIN Seguridad.Rol R on R.IdRol = PF.IdRol
				JOIN Seguridad.UsuarioRol UR on UR.IdRol = R.IdRol
				JOIN Seguridad.Usuario U on U.IdUsuario = UR.IdUsuario
				JOIN Seguridad.Aplicacion A on A.IdAplicacion = PF.IdAplicacion
				AND U.Usuario = @nombreUsuario And A.IdAplicacion = @IdAplicacion2
				AND R.IdRol = @IdRol
				AND (P.IdPaginaPadre is not null Or Not Exists(Select 1 From Seguridad.Pagina Where IdPaginaPadre = P.IdPagina and P.IdEstado = 1))
				AND R.IdEstado = 1 AND P.IdPaginaPadre not in (71)
				AND P.IdEstado = 1
				union all
		
				select P.IdPagina,P.Orden as Orden,
						0			AS OrdenModulo,
						MA.Orden    AS OrdenAgrupador,
						P.Orden		AS OrdenPagina,
						P.Nombre,P.Url,P.IdPaginaPadre IdPaginaPadre,P.Visible,P.Nivel as Nivel,Icono, 1 as LEVEL,--Level + 1
				MA.Descripcion as Agrupacion,
				(select top 1 IdTamanoMenu from [Seguridad].[Pagina]
										where IdPagina = P.IdPagina) as TamanoMenu
				from Seguridad.Pagina P
				join Seguridad.ModuloAgrupacion	MA ON P.IdAgrupacion = MA.IdAgrupacion
				join Seguridad.PermisoPerfil PF on P.IdPagina = PF.IdPagina
				join Seguridad.Rol R on R.IdRol = PF.IdRol
				join Seguridad.UsuarioRol UR on UR.IdRol = R.IdRol
				join Seguridad.Usuario U on U.IdUsuario = UR.IdUsuario
				join Seguridad.Aplicacion A on A.IdAplicacion = PF.IdAplicacion
				and U.Usuario = @nombreUsuario And A.IdAplicacion = @IdAplicacion2
				AND R.IdRol = @IdRol
				And P.IdPaginaPadre is not null 
				and R.IdEstado = 1 AND P.IdPagina not in (72)
				and P.IdEstado = 1
			)
		
	

			SELECT	DISTINCT IdPagina,Orden,Descripcion,Url,IdPaginaPadre,CAST(Visible as BIT)as Visible,Nivel,Icono, Level,Agrupacion,TamanoMenu,OrdenModulo, OrdenAgrupador, OrdenPagina

			FROM	ListaMenu
			ORDER BY Level, OrdenModulo, OrdenAgrupador, OrdenPagina
		END

END





GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Operacion_Listar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Seguridad].[Usp_Operacion_Listar]
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

		SELECT   IdOperacion
				,Descripcion
		FROM Seguridad.Operacion
		WHERE IdEstado = 1

	SET NOCOUNT OFF
END

GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Pagina_Actualizar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Proc [Seguridad].[Usp_Pagina_Actualizar]
(
@IdPagina int,
@IdModulo int,
@IdPaginaPadre int,
@Url Varchar(100),
@Nombre Varchar(100),
@Icono Varchar(100),
@Nivel int,
@Orden int,
@Visible bit,
@IdAgrupacion int,
@IdTamanoMenu int
)
as
Begin
	if(@IdPaginaPadre = 0)
		set @IdPaginaPadre = null
	if(@url = '')
		set @url = null	
		
	Update Seguridad.Pagina
	Set IdModulo = @IdModulo, IdPaginaPadre = @IdPaginaPadre, Url = @Url, 
	Nombre = @Nombre, Icono = @Icono, Nivel = @Nivel,
	Orden = @Orden, Visible = @Visible,
	IdAgrupacion = @IdAgrupacion,
	IdTamanoMenu = @IdTamanoMenu
	Where IdPagina = @IdPagina 
	
END

GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Pagina_ActualizarEstado]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [Seguridad].[Usp_Pagina_ActualizarEstado]
(
@IdPagina int,
@IdEstado int
)
as
Begin
	Update Seguridad.Pagina
	Set IdEstado = @IdEstado
	Where IdPagina = @IdPagina
	
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Pagina_Buscar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Seguridad].[Usp_Pagina_Buscar] 
(
	@IdPagina int
)
AS 
BEGIN	
	Select Distinct
		P.IdPagina,
		P.IdPaginaPadre,
		P.Url,
		P.Nombre NombrePagina,
		P.Icono,
		P.Nivel,
		P.Orden,
		P.Visible,
		A.IdAplicacion, 
		A.Nombre NombreAplicacion,
		A.Descripcion DescripcionAplicacion,
		M.IdModulo, 
		M.Nombre NombreModulo,
		M.Descripcion DescripcionModulo,
		E.IdEmpresa,
		ES.IdEstado,
		ES.Nombre NombreEstado,
		P.IdAgrupacion,
		P.IdTamanoMenu
		--TABLES 
		FROM Seguridad.Pagina P
		Inner Join Seguridad.Modulo M On M.IdModulo = P.IdModulo
		Inner Join Seguridad.Aplicacion A On A.IdAplicacion = M.IdAplicacion
		Inner Join Seguridad.EmpresaAplicacion EA On EA.IdAplicacion = A.IdAplicacion
		Inner Join Seguridad.Empresa E On E.IdEmpresa = EA.IdEmpresa
		Inner Join Estructura.Estado ES On ES.IdEstado = P.IdEstado
		WHERE			
		(@IdPagina = 0 Or IdPagina = @IdPagina)
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Pagina_Insertar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Proc [Seguridad].[Usp_Pagina_Insertar]
(
@IdModulo int,
@IdPaginaPadre int,
@Url Varchar(100),
@Nombre Varchar(100),
@Icono Varchar(100),
@Nivel int,
@Orden int,
@Visible bit,
@IdPagina int out,
@IdAgrupacion int,
@IdTamanoMenu int
)
as
Begin
	if(@IdPaginaPadre = 0)
		set @IdPaginaPadre = null
	if(@url = '')
		set @url = null	

	Declare @Exist int
	set @Exist = (select count(*) from Seguridad.Pagina where IdModulo = @IdModulo and Nombre = @Nombre)

	IF (@Exist = 0)
	BEGIN
		Insert Seguridad.Pagina (IdModulo, IdPaginaPadre, Url,Nombre, Icono, Nivel, Orden, Visible, IdEstado,IdAgrupacion,IdTamanoMenu)
		Values(@IdModulo, @IdPaginaPadre, @Url,@Nombre, @Icono, @Nivel, @Orden, @Visible, 1,@IdAgrupacion,@IdTamanoMenu)
		Set @IdPagina = @@Identity
	END
	ELSE
	BEGIN 
		Set @IdPagina = -1
	END
End


GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Pagina_Listar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Seguridad].[Usp_Pagina_Listar] 
AS 
BEGIN	
	Select
		P.IdPagina,
		P.IdPaginaPadre,
		P.Url,
		P.Nombre NombrePagina,
		P.Icono,
		P.Nivel,
		P.Orden,
		P.Visible,
		A.IdAplicacion, 
		A.Nombre NombreAplicacion,
		A.Descripcion DescripcionAplicacion,
		M.IdModulo, 
		M.Nombre NombreModulo,
		M.Descripcion DescripcionModulo,
		ES.IdEstado,
		ES.Nombre NombreEstado
		--TABLES 
		FROM Seguridad.Pagina P
		Inner Join Seguridad.Modulo M On M.IdModulo = P.IdModulo
		Inner Join Seguridad.Aplicacion A On A.IdAplicacion = M.IdAplicacion
		Inner Join Estructura.Estado ES On ES.IdEstado = P.IdEstado
		
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Pagina_Paginacion]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Seguridad].[Usp_Pagina_Paginacion] 
(
	@IdEmpresa int,
	@IdAplicacion int,
	@IdModulo int,
	@Nombre Varchar(200),
	
	@SortType VARCHAR(100), 
	@SortDir VARCHAR(50), 
	@Page INT, 
	@RowsPerPage INT, 
	@RowCount INT = 0 OUT 
)
AS 
BEGIN
	BEGIN		
		WITH Pagina AS
		(
			SELECT ROW_NUMBER() OVER 
			(ORDER BY
				--ASC
				CASE WHEN (@SortType = 'IdPagina' AND @SortDir = 'ASC') THEN P.IdPagina END ASC,
				CASE WHEN (@SortType = 'Modulo.Aplicacion.Empresa.IdEmpresa' AND @SortDir = 'ASC') THEN E.IdEmpresa END ASC,
				CASE WHEN (@SortType = 'Modulo.Aplicacion.Empresa.Nombre' AND @SortDir = 'ASC') THEN E.Nombre END ASC,
				CASE WHEN (@SortType = 'Modulo.Aplicacion.IdAplicacion' AND @SortDir = 'ASC') THEN A.IdAplicacion END ASC,
				CASE WHEN (@SortType = 'Modulo.Aplicacion.Nombre' AND @SortDir = 'ASC') THEN A.Nombre END ASC,
				CASE WHEN (@SortType = 'Modulo.IdModulo' AND @SortDir = 'ASC') THEN M.IdModulo END ASC,
				CASE WHEN (@SortType = 'Modulo.Nombre' AND @SortDir = 'ASC') THEN M.Nombre END ASC,
				--DESC
				CASE WHEN (@SortType = 'IdPagina' AND @SortDir = 'DESC') THEN P.IdPagina END DESC,
				CASE WHEN (@SortType = 'Modulo.Aplicacion.Empresa.IdEmpresa' AND @SortDir = 'DESC') THEN E.IdEmpresa END DESC,
				CASE WHEN (@SortType = 'Modulo.Aplicacion.Empresa.Nombre' AND @SortDir = 'DESC') THEN E.Nombre END DESC,
				CASE WHEN (@SortType = 'Modulo.Aplicacion.IdAplicacion' AND @SortDir = 'DESC') THEN A.IdAplicacion END DESC,
				CASE WHEN (@SortType = 'Modulo.Aplicacion.Nombre' AND @SortDir = 'DESC') THEN A.Nombre END DESC,
				CASE WHEN (@SortType = 'Modulo.IdModulo' AND @SortDir = 'DESC') THEN M.IdModulo END DESC,
				CASE WHEN (@SortType = 'Modulo.Nombre' AND @SortDir = 'DESC') THEN M.Nombre END DESC,
				--DEFAULT				
				CASE WHEN @SortType = '' THEN P.IdPagina END DESC 				
			)	
			AS ROWNUMBER,
			P.IdPagina,
			P.IdPaginaPadre,
			P.Url,
			UPPER(P.Nombre) NombrePagina,
			P.Icono,
			P.Nivel,
			P.Orden,
			P.Visible,
			E.IdEmpresa,
			UPPER(E.Nombre) NombreEmpresa,
			UPPER(E.Abreviatura) AbreviaturaEmpresa,
			A.IdAplicacion, 
			UPPER(A.Nombre) NombreAplicacion,
			UPPER(A.Descripcion) DescripcionAplicacion,
			M.IdModulo, 
			UPPER(M.Nombre) NombreModulo,
			UPPER(M.Descripcion) DescripcionModulo,
			ES.IdEstado,
			UPPER(ES.Nombre) NombreEstado
			--TABLES 
			FROM Seguridad.Pagina P
			Inner Join Seguridad.Modulo M On M.IdModulo = P.IdModulo
			Inner Join Seguridad.Aplicacion A On A.IdAplicacion = M.IdAplicacion
			Inner Join Seguridad.EmpresaAplicacion EA On EA.IdAplicacion = A.IdAplicacion  
			Inner Join Seguridad.Empresa E On E.IdEmpresa = EA.IdEmpresa
			Inner Join Estructura.Estado ES On ES.IdEstado = P.IdEstado
			WHERE			
			(@IdEmpresa = 0 Or EA.IdEmpresa = @IdEmpresa)
			And (@IdAplicacion = 0 Or EA.IdAplicacion = @IdAplicacion)	
			And (@IdModulo = 0 Or M.IdModulo = @IdModulo)
			And (@Nombre = '' Or P.Nombre Like '%' + @Nombre + '%')	
		)
		SELECT 
			IdPagina,
			IdPaginaPadre,
			Url,
			NombrePagina,
			Icono,
			Nivel,
			Orden,
			Visible,
			IdEmpresa,
			NombreEmpresa,
			AbreviaturaEmpresa,
			IdAplicacion, 
			NombreAplicacion,
			DescripcionAplicacion,
			IdModulo, 
			NombreModulo,
			DescripcionModulo,
			IdEstado,
			NombreEstado
		FROM Pagina
		WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page - 1) + 1) AND @Page * @RowsPerPage
		
		SET @RowCount = (
			SELECT COUNT(1)
			FROM Seguridad.Pagina P
			Inner Join Seguridad.Modulo M On M.IdModulo = P.IdModulo
			Inner Join Seguridad.Aplicacion A On A.IdAplicacion = M.IdAplicacion
			Inner Join Seguridad.EmpresaAplicacion EA On EA.IdAplicacion = A.IdAplicacion  
			Inner Join Seguridad.Empresa E On E.IdEmpresa = EA.IdEmpresa
			Inner Join Estructura.Estado ES On ES.IdEstado = P.IdEstado
			WHERE			
			(@IdEmpresa = 0 Or EA.IdEmpresa = @IdEmpresa)
			And (@IdAplicacion = 0 Or EA.IdAplicacion = @IdAplicacion)	
			And (@IdModulo = 0 Or M.IdModulo = @IdModulo)
			And (@Nombre = '' Or P.Nombre Like '%' + @Nombre + '%')	
		)	
	END
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_PaginaAccion_Eliminar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [Seguridad].[Usp_PaginaAccion_Eliminar]
(
@IdPagina int
)
as
Begin
	Delete Seguridad.PaginaAccion Where IdPagina = @IdPagina
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_PaginaAccion_Insertar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Seguridad].[Usp_PaginaAccion_Insertar]
    @TypePaginaAccion AS [SEGURIDAD].[TypePaginaAccion] READONLY
AS
BEGIN
	INSERT INTO [SEGURIDAD].[PaginaAccion] ([IdPagina],[IdAccion],[ChkAgregar]) 
	SELECT [IdPagina],[IdAccion],[ChkAgregar] FROM @TypePaginaAccion 	
	
	Select 1
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_PaginaGrupo_Eliminar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Proc [Seguridad].[Usp_PaginaGrupo_Eliminar]
(
@IdPagina int
)
as
Begin
	Delete Seguridad.PaginaGrupo Where IdPagina = @IdPagina
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_PaginaGrupo_Insertar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Seguridad].[Usp_PaginaGrupo_Insertar]
    @TypePaginaGrupo AS [SEGURIDAD].[TypePaginaGrupo] READONLY
AS
BEGIN
	INSERT INTO [SEGURIDAD].[PaginaGrupo] ([IdPagina],[IdGrupo]) 
	SELECT [IdPagina],[IdGrupo] FROM @TypePaginaGrupo 	
	
	Select 1
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_PaginaPadre_Listar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_PaginaPadre_Listar]
(
@IdModulo Int
)
As
Begin
	Select P.IdPagina, IdModulo, IdPaginaPadre, Url, Nombre NombrePagina, Icono, Nivel, Orden, Visible, IdEstado From Seguridad.Pagina P
	Where P.IdModulo = @IdModulo
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_PaginaPorModulo]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Seguridad].[Usp_PaginaPorModulo] 
(@IdModulo int)
AS 
BEGIN	
	Select Distinct
		P.IdPagina,
		P.IdPaginaPadre,
		P.Url,
		P.Nombre NombrePagina,
		P.Icono,
		P.Nivel,
		P.Orden,
		P.Visible,
		A.IdAplicacion, 
		A.Nombre NombreAplicacion,
		A.Descripcion DescripcionAplicacion,
		M.IdModulo, 
		M.Nombre NombreModulo,
		M.Descripcion DescripcionModulo,
		ES.IdEstado,
		ES.Nombre NombreEstado
		--TABLES 
		FROM Seguridad.Pagina P
		Inner Join Seguridad.Modulo M On M.IdModulo = P.IdModulo
		Inner Join Seguridad.Aplicacion A On A.IdAplicacion = M.IdAplicacion
		Inner Join Seguridad.EmpresaAplicacion EA On EA.IdAplicacion = A.IdAplicacion
		Inner Join Seguridad.Empresa E On E.IdEmpresa = EA.IdEmpresa
		Inner Join Estructura.Estado ES On ES.IdEstado = P.IdEstado
		Where P.IdModulo = @IdModulo
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_PermisoPerfil_Insertar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Seguridad].[Usp_PermisoPerfil_Insertar]
    @TypeRolPerfil AS [Seguridad].[TypePermisoPerfil] READONLY
as
begin
	
	DELETE FROM [Seguridad].[PermisoPerfil] 
	WHERE IDROL  IN(SELECT IdRol FROM @TypeRolPerfil)
	And IdEmpresa In (Select IdEmpresa From @TypeRolPerfil)
		
	INSERT INTO Seguridad.PermisoPerfil(IdEmpresa,IdAplicacion,IdModulo,IdPagina,IdAccion,IdRol) 
    SELECT CASE IdEmpresa WHEN 0 THEN NULL  ELSE IdEmpresa END ,
		   CASE IdAplicacion WHEN 0 THEN NULL  ELSE IdAplicacion END ,
	       CASE IdModulo WHEN 0 THEN NULL  ELSE IdModulo END,
		   CASE IdPagina WHEN 0 THEN NULL  ELSE IdPagina END,
		   CASE IdAccion WHEN 0 THEN NULL  ELSE IdAccion END,
		   IdRol 
    FROM @TypeRolPerfil-- WHERE  IdRol <> 0 AND (IdAplicacion <> 0 OR IdModulo<> 0 OR IdPagina <> 0  OR IdAccion <> 0)

	Select 1
end



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_PermisoPerfilPorGrupos]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [Seguridad].[Usp_PermisoPerfilPorGrupos] --14,91
(
@IdUsuario int,
@IdsGrupo Varchar(1000)
)
AS
BEGIN
	DECLARE @Count INT
	DECLARE @ID INT 
	DECLARE @GP VARCHAR(1000)
	
	SET @Count = 2--(select count(*) from Seguridad.Auditoria_Acceso  where IdUsuario=@IdUsuario)
	--SET @Count = (select count(*) from Seguridad.Auditoria_Acceso  where IdUsuario=@IdUsuario)
	
	IF @Count > 1
		BEGIN
			SELECT DISTINCT 
				0 IdPaginaAccion, 
				P.IdPagina, 
				P.Nombre NombrePagina, 
				P.Url, 
				P.Icono,
				A.IdAccion, 
				A.CodigoHTML, 
				A.Nombre NombreAccion, 
				A.Etiqueta, 
				A.MensajeToolTip, 
				A.Evento,
				A.TamañoButton,
				A.OrdenAccion,
				G.IdGrupo, 
				G.Codigo, 
				G.Nombre NombreGrupo, 
				G.Abreviatura,
				G.OrdenGrupo
			FROM Seguridad.PermisoPerfil  PF
			INNER JOIN Seguridad.Pagina P ON ( P.IdPagina = PF.IdPagina )
			INNER JOIN Seguridad.Rol R ON ( R.IdRol = PF.IdRol )
			INNER JOIN Seguridad.UsuarioRol UR ON ( UR.IdRol = R.IdRol And UR.IdUsuario = @IdUsuario )
			INNER JOIN Seguridad.Accion A ON ( A.IdAccion = PF.IdAccion )
			INNER JOIN Estructura.Grupo G ON ( G.IdGrupo = A.IdGrupo )
			Where G.IdGrupo In (Select item From ufnSplit(@IdsGrupo,',')) 
			ORDER BY G.OrdenGrupo,A.OrdenAccion
		END
	ELSE
		BEGIN
			SET @ID = 1 
			SET @GP = '90'
			
			SELECT DISTINCT 
				0 IdPaginaAccion, 
				P.IdPagina, 
				P.Nombre NombrePagina, 
				P.Url, 
				P.Icono,
				A.IdAccion, 
				A.CodigoHTML, 
				A.Nombre NombreAccion, 
				A.Etiqueta, 
				A.MensajeToolTip, 
				A.Evento,
				A.TamañoButton,
				A.OrdenAccion,
				G.IdGrupo, 
				G.Codigo, 
				G.Nombre NombreGrupo, 
				G.Abreviatura,
				G.OrdenGrupo
			From Seguridad.PermisoPerfil  PF
			INNER JOIN Seguridad.Pagina P ON ( P.IdPagina = PF.IdPagina )
			INNER JOIN Seguridad.Rol R ON ( R.IdRol = PF.IdRol )
			INNER JOIN Seguridad.UsuarioRol UR ON ( UR.IdRol = R.IdRol )
			INNER JOIN Seguridad.Accion A ON ( A.IdAccion = PF.IdAccion )
			INNER JOIN Estructura.Grupo G ON ( G.IdGrupo = A.IdGrupo )
			Where G.IdGrupo IN (Select item From ufnSplit(@GP,',')) 
		END

END

GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Rol_Actualizar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_Rol_Actualizar]
(
@IdRol int,
@Nombre Varchar(50),
@SiRango Bit,
@FechaInicio Date,
@FechaFin Date,
@IdAplicacion int,
@SiSuperAdmi bit
)
as
Begin
	--if(Exists(Select 1 From Seguridad.Rol Where Nombre = @Nombre And IdRol <> @IdRol))
	--	Select 1
	--else 
		Update Seguridad.Rol
		Set Nombre = @Nombre, SiRango = @SiRango, 
		FechaInicio = @FechaInicio, FechaFin = @FechaFin, 
		IdAplicacion = @IdAplicacion, SiSuperAdmi = @SiSuperAdmi
		Where IdRol = @IdRol
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Rol_ActualizarEstado]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_Rol_ActualizarEstado]
(
@IdRol int,
@IdEstado int
)
as
Begin
	Update Seguridad.Rol
	Set IdEstado = @IdEstado
	Where IdRol = @IdRol
	
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Rol_Buscar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_Rol_Buscar]
(
@IdRol int
)
as
Begin
	Select R.IdRol, R.IdEstado, R.Nombre NombreRol, R.SiSuperAdmi, R.SiRango, R.FechaInicio, R.FechaFin,
	E.Nombre NombreEstado, A.IdAplicacion, A.Nombre NombreAplicacion, A.Descripcion DescripcionAplicacion, A.Url
	From Seguridad.Rol R
	Inner Join Estructura.Estado E On E.IdEstado =  R.IdEstado 
	Inner Join Seguridad.Aplicacion A On A.IdAplicacion = R.IdAplicacion
	Where IdRol = @IdRol
	
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Rol_Insertar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_Rol_Insertar]
(
@Nombre Varchar(50),
@SiRango Bit,
@FechaInicio Date,
@FechaFin Date,
@IdAplicacion int,
@SiSuperAdmi bit
)
as
Begin
	Declare @Exist int
	DECLARE @IdRol INT
	DECLARE @IdCentroAtencion INT

	set @Exist = (select count(*) from Seguridad.Rol where IdAplicacion = @IdAplicacion and Nombre = @Nombre)

	IF (@Exist = 0)
	BEGIN
		Insert Into Seguridad.Rol (IdEstado, Nombre, SiRango, FechaInicio, FechaFin, IdAplicacion, SiSuperAdmi)
		Values (1, @Nombre, @SiRango, @FechaInicio, @FechaFin, @IdAplicacion, @SiSuperAdmi)

		SET @IdRol =  SCOPE_IDENTITY();

		INSERT INTO [BD_ERP_MASTER].[Maestro].[CentroAtencion]
		(DescripcionCentroAtencion, 
		 Activo,
		 IdArea, 
		 FlagGenComprobante, 
		 FlagSinAutCoberturaAMB, 
		 FlagImprimirGuiaSinRegistro, 
		 FlagPuntoConsumo,
		 FlagAtencionConsumo,
		 FechaRegistro)
		 VALUES
		 (@Nombre
		 ,1
		 ,1
		 ,1
		 ,0
		 ,1
		 ,0
		 ,0
		 ,GETDATE())

		 SET @IdCentroAtencion =  SCOPE_IDENTITY();

		 UPDATE Seguridad.Rol SET IdCentroAtencion = @IdCentroAtencion WHERE IdRol = @IdRol


		 INSERT INTO [BD_ERP_MASTER].Maestro.CentroAtencionIP
		 (IdCentroAtencion,
		 IP,
		 IdUsuarioRegistro,
		 FechaRegistro,
		 Activo,
		 IdOrigenPedido,
		 IdPuntoConsumo)
		 VALUES
		 (@IdCentroAtencion,
		 '192.168.0.0',
		 1,
		 GETDATE(),
		 1,
		 0,
		 0)

		 INSERT INTO [BD_ERP_MASTER].Maestro.CentroAtencionAlmacen
		 (IdCentroAtencion,
		 IdAlmacen)
		 VALUES
		 (@IdCentroAtencion,
		 0)


		select 1
	END
	ELSE
	BEGIN 
		select -1
	END

End
GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Rol_Listar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Seguridad].[Usp_Rol_Listar]

AS
BEGIN
	Select R.IdRol, R.IdEstado, R.Nombre NombreRol, R.SiSuperAdmi, R.SiRango, R.FechaInicio, R.FechaFin,
	E.Nombre NombreEstado , A.IdAplicacion, A.Nombre NombreAplicacion, A.Descripcion DescripcionAplicacion, A.Url
	From Seguridad.Rol R
	Inner Join Estructura.Estado E On E.IdEstado =  R.IdEstado 
	Inner Join Seguridad.Aplicacion A On A.IdAplicacion = R.IdAplicacion
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Rol_Paginacion]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Seguridad].[Usp_Rol_Paginacion] 
(
	@IdAplicacion int,
	@Nombre Varchar(200),
	
	@SortType VARCHAR(100), 
	@SortDir VARCHAR(50), 
	@Page INT, 
	@RowsPerPage INT, 
	@RowCount INT = 0 OUT 
)
AS 
BEGIN
	BEGIN		
		WITH Rol AS
		(
			SELECT ROW_NUMBER() OVER 
			(ORDER BY 
				--ASC
				CASE WHEN (@SortType = 'IdRol' AND @SortDir = 'ASC') THEN R.IdRol END ASC,
				CASE WHEN (@SortType = 'SiSuperAdmi' AND @SortDir = 'ASC') THEN R.SiSuperAdmi END ASC,
				CASE WHEN (@SortType = 'IdEstado' AND @SortDir = 'ASC') THEN E.IdEstado END ASC,
				CASE WHEN (@SortType = 'Estado.Nombre' AND @SortDir = 'ASC') THEN E.Nombre END ASC,
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'ASC') THEN R.Nombre END ASC,
				--DESC
				CASE WHEN (@SortType = 'IdRol' AND @SortDir = 'DESC') THEN R.IdRol END DESC,
				CASE WHEN (@SortType = 'SiSuperAdmi' AND @SortDir = 'DESC') THEN R.SiSuperAdmi END DESC,
				CASE WHEN (@SortType = 'IdEstado' AND @SortDir = 'DESC') THEN E.IdEstado END DESC,
				CASE WHEN (@SortType = 'Estado.Nombre' AND @SortDir = 'DESC') THEN E.Nombre END DESC,
				CASE WHEN (@SortType = 'Nombre' AND @SortDir = 'DESC') THEN R.Nombre END DESC,
				--DEFAULT				
				CASE WHEN @SortType = '' THEN R.IdRol END DESC 				
			)	
			AS ROWNUMBER,
			R.IdRol,
			R.SiSuperAdmi,
			E.IdEstado,
			upper(E.Nombre) NombreEstado,
			upper(R.Nombre) NombreRol,
			R.SiRango,
			R.FechaInicio,
			R.FechaFin,
			A.IdAplicacion,
			upper(A.Nombre) NombreAplicacion,
			upper(A.Descripcion) DescripcionAplicacion,
			upper(A.Url) Url
			
			--TABLES 
			FROM Seguridad.Rol R
			Inner Join Estructura.Estado E On R.IdEstado = E.IdEstado
			Inner Join Seguridad.Aplicacion A On A.IdAplicacion = R.IdAplicacion
			WHERE			
			(@Nombre = '' Or R.Nombre LIKE '%' + @Nombre + '%')
			And (@IdAplicacion = 0 Or R.IdAplicacion = @IdAplicacion)
			And R.IdEstado In (1,2)
		)
		SELECT 
			IdRol,
			SiSuperAdmi,
			IdEstado,
			NombreEstado,
			NombreRol,
			SiRango,
			FechaInicio,
			FechaFin,
			IdAplicacion,
			NombreAplicacion,
			DescripcionAplicacion,
			Url
		FROM Rol
		WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page - 1) + 1) AND @Page * @RowsPerPage
		
		SET @RowCount = (
			SELECT COUNT(1)
			FROM Seguridad.Rol R
			Inner Join Estructura.Estado E On R.IdEstado = E.IdEstado
			Inner Join Seguridad.Aplicacion A On A.IdAplicacion = R.IdAplicacion
			WHERE			
			(@Nombre = '' Or R.Nombre = @Nombre)
			And (@IdAplicacion = 0 Or R.IdAplicacion = @IdAplicacion)
			And R.IdEstado In (1,2)
		)	
	END
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_RolesPorAplicacion]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_RolesPorAplicacion]
(
@IdAplicacion int
)
as
Begin
	Select R.IdRol, 
	upper(R.Nombre) NombreRol, 
	R.SiSuperAdmi, 
	R.SiRango, 
	R.FechaInicio, R.FechaFin, R.IdAplicacion
	From Seguridad.Rol R 
	Inner Join Estructura.Estado ES On ES.IdEstado = R.IdEstado
	Inner Join Seguridad.Aplicacion A On A.IdAplicacion = R.IdAplicacion
	Where A.IdAplicacion = @IdAplicacion
	and R.IdEstado = 1
	order by 2
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_RolesPorUsuario]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_RolesPorUsuario]  --11
(
@IdUsuario int
)
as
Begin
	Select R.IdRol, UPPER(R.Nombre) NombreRol, Cast(R.SiSuperAdmi as Bit) SiSuperAdmi, Cast(R.SiRango as Bit) SiRango, R.FechaInicio, R.FechaFin,
	A.IdAplicacion, A.Nombre NombreAplicacion, A.Descripcion DescripcionAplicacion, R.IdCentroAtencion
	From Seguridad.Rol R
	Inner Join Seguridad.UsuarioRol UR On UR.IdRol = R.IdRol And UR.IdUsuario = @IdUsuario
	Inner Join Seguridad.Aplicacion A On A.IdAplicacion = R.IdAplicacion
	Inner Join Estructura.Estado E On E.IdEstado = R.IdEstado
	WHERE R.IdEstado = 1
	ORDER BY R.Nombre
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Sel_ContraseniaPorUsuario]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Seguridad].[Usp_Sel_ContraseniaPorUsuario]
@Usuario			VARCHAR(50)
AS

BEGIN
SELECT
Contrasena
FROM
Seguridad.Usuario 
WHERE
Usuario = @Usuario
END
GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Sel_Empresa_Relacionada]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Seguridad].[Usp_Sel_Empresa_Relacionada]
@TipoEmpresa VARCHAR(50)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	SELECT    IdCtaCte 
			 ,RazonSocial
	FROM BD_ERP_MASTER.flexline.CtaCte
	WHERE Tipo = UPPER(@TipoEmpresa)
	AND Empresa = '001'
	AND TipoCtaCte = 'CLIENTE'

	SET NOCOUNT OFF
END
GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Sel_ListaEnfermeraServicio]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Seguridad].[Usp_Sel_ListaEnfermeraServicio]
AS
BEGIN

	SELECT 
	IdUsuario,
	Usuario ,
	NombreApellido
	--NombreAbreviado
	
	FROM [Seguridad].[Usuario] 
	--WHERE IdUsuario IN (
	--SELECT IdUsuario FROM [Seguridad].[UsuarioRol] WHERE IDRol = 14)
	WHERE IdCargo = 	9
 
	-- IdCargo 9 Representa ENFERMERA SOP 
	--SELECT * FROM Estructura.Cargo 

END

GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Sel_OperacionPorRol]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Seguridad].[Usp_Sel_OperacionPorRol]
@IdRol INT
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	SELECT   OPE.IdOperacion
			,OPE.Descripcion
			,OPE.IdEstado
	FROM Seguridad.Operacion			OPE
	INNER JOIN Seguridad.OperacionRol	OPR ON OPE.IdOperacion = OPR.IdOperacion
	WHERE OPR.IdRol = @IdRol
	AND OPE.IdEstado = 1
	AND OPR.Activo = 1

	SET NOCOUNT OFF
END


GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Sel_Usuario_By_NombreUsuario]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Seguridad].[Usp_Sel_Usuario_By_NombreUsuario] --1127
@NombreUsuario VARCHAR(20)
AS
BEGIN
	SELECT	IdUsuario,
			Usuario,
			CambiarPassword	
	FROM Seguridad.Usuario
	WHERE Usuario = @NombreUsuario
END
GO
/****** Object:  StoredProcedure [Seguridad].[Usp_SincronizarUsuariosAD]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_SincronizarUsuariosAD]
as
Begin
	Declare @sAMAccountName Varchar(100),
	@accountExpires bigint,
	@Id int,
	
	@CodigoEmp Varchar(100),
	@NombreApellido Varchar(200),
	@IdEstado int,
	@IdUsuarioTipo int,
	@CodigoEmpresa Varchar(100),
	@Sexo Varchar(15),
	@EmailCoorporativo Varchar(150),
	@Direccion Varchar(150),
	@DNI Varchar(8),
	@IdSociedad int,
	@SociedadDescripcionCorta varchar(100),
	@IdAreaBU int,
	@AreaBUDescripcionCorta Varchar(100),
	@IdCargo int,
	@CargoDescripcionCorta Varchar(100),
	@IdComite int
	
	Update Seguridad.Usuario Set IdEstado = 2 
	
	DECLARE _Cursor CURSOR FOR 
	SELECT sAMAccountName,
	Case Convert(Varchar,accountExpires) when '9223372036854775807' then 1 
	when '0' then 1 else Cast(Convert(varchar, accountExpires,112) as int) end From Seguridad.UsuarioAD Where sAMAccountName not like '%$%'
	--Select Usuario,1 From Seguridad.Usuario where Usuario = 'yoni.marcelo'
	
	OPEN _Cursor
	FETCH NEXT FROM _Cursor INTO @sAMAccountName,@accountExpires
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		Select @CodigoEmp = Cast(IDAlternativo as int), @CodigoEmpresa = Cast(IdCompania as Int), @Sexo = Sexo, @Direccion = Direccion, 
		@DNI = Cast(Cast(NumeroDocIdentificacion as int) as Varchar), 
		@IdCargo = Cast(IdCargo as Int), @CargoDescripcionCorta = Nombrecargo, @NombreApellido = ApellidoPaterno + ', ' + ApellidoMaterno,
		@EmailCoorporativo = CorreoBoleta
		FROM [BD_KomatsuCoreEmpleado].[dbo].[VistaEmpleado] Where Upper(CorreoBoleta) In (Upper(@sAMAccountName + '@kmmp.com.pe'),Upper(@sAMAccountName + '@cumminsperu.pe'))
		--FROM [MMP-FRACTAL-WEB].[FRACTAL].[dbo].[FKMMP_VW_TRABAJADOR] Where Upper(CorreoBoleta) In (Upper(@sAMAccountName + '@kmmp.com.pe'),Upper(@sAMAccountName + '@cumminsperu.pe'))
		
		
		if(@accountExpires <> 1 And Cast(CONVERT(Varchar,getdate(),112) as int) > @accountExpires)
			Set @IdEstado = 2
		else 
			Set @IdEstado = 1
		
		If Exists(Select 1 From Seguridad.Usuario Where Usuario = @sAMAccountName)
		Begin
			Update Seguridad.Usuario 
			Set CodigoEmp = @CodigoEmp, EmailCoorporativo = @EmailCoorporativo, NombreApellido = @NombreApellido, 
			IdEstado = @IdEstado, IdUsuarioTipo = 1, CodigoEmpresa = @CodigoEmpresa, Sexo = @Sexo,
			DNI = @DNI, IdCargo = @IdCargo, CargoDescripcionCorta = @CargoDescripcionCorta
			Where Upper(Usuario)= Upper(@sAMAccountName )
			
		end
		Else 
		Begin
			select @Id = Isnull(Max(IdUsuario),0) + 1 From Seguridad.Usuario 
			
			Insert Into Seguridad.Usuario 
			(IdUsuario, Usuario,CodigoEmp,EmailCoorporativo,NombreApellido,IdEstado,IdUsuarioTipo, CodigoEmpresa, Sexo, DNI, IdCargo, CargoDescripcionCorta) 
			Values
			(@Id, @sAMAccountName,@CodigoEmp,@EmailCoorporativo,@NombreApellido,@IdEstado,1,@CodigoEmpresa, @Sexo, @DNI, @IdCargo, @CargoDescripcionCorta)
		
		End
		Set @CodigoEmp = NULL
		Set @CodigoEmpresa = NULL
		Set @Sexo = NULL
		Set @Direccion = NULL
		Set @IdCargo = NULL
		set @CargoDescripcionCorta = NULL
		set @NombreApellido = NULL 
		set @EmailCoorporativo = NULL
		
		FETCH NEXT FROM _Cursor INTO @sAMAccountName,@accountExpires
	END
	
	CLOSE _Cursor
	DEALLOCATE _Cursor
	
end



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Treeview_Listar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [Seguridad].[Usp_Treeview_Listar]--1023,'2152'
(
@IdEmpresa int,
@IdRol int
)
AS
BEGIN

	WITH ListaTreeView (Id,Nombre,IdPadre,Nivel,NivelPagina,IdPaginaPadre,[Check], Orden)
	AS
	(	
		SELECT DISTINCT  M.IdModulo				AS Id
						,M.Nombre				AS Nombre
						,M.IdAplicacion			AS IdPadre
						,2						AS Nivel
						,null					AS NivelPagina
						,null					AS IdPaginaPadre
						,CAST (CASE WHEN PF.IdModulo IS NULL THEN 0 ELSE 1 END AS BIT) [Check]
						,M.Orden				AS Orden
		FROM Seguridad.Modulo M
		INNER JOIN Seguridad.Rol R ON R.IdAplicacion = M.IdAplicacion And M.IdAplicacion = (SELECT IdAplicacion FROM Seguridad.Rol WHERE IdRol = @IdRol)
		LEFT JOIN Seguridad.PermisoPerfil PF ON M.IdModulo = PF.IdModulo And PF.IdRol = @IdRol And PF.IdEmpresa = @IdEmpresa
		
		UNION ALL

		SELECT DISTINCT  P1.IdPagina								AS Id
						,CONCAT(AGR.Descripcion, ' - ' , P1.Nombre) AS Nombre
						,P1.IdModulo								AS IdPadre
						,3											AS Nivel
						,P1.Nivel									AS NivelPagina
						,P1.IdPaginaPadre							AS IdPaginaPadre
						,CAST (CASE WHEN PF.IdPagina IS NULL THEN 0 ELSE 1 END AS BIT) [Check]
						,AGR.Orden									AS Orden
		FROM Seguridad.Pagina P1 
		LEFT JOIN Seguridad.ModuloAgrupacion AGR ON P1.IdAgrupacion = AGR.IdAgrupacion
		INNER JOIN Seguridad.Modulo M ON M.IdModulo = P1.IdModulo
		INNER JOIN Seguridad.Rol R ON R.IdAplicacion = M.IdAplicacion And M.IdAplicacion = (SELECT IdAplicacion FROM Seguridad.Rol WHERE IdRol = @IdRol)
		LEFT JOIN Seguridad.PermisoPerfil PF ON P1.IdPagina = PF.IdPagina And PF.IdRol = @IdRol And PF.IdEmpresa = @IdEmpresa
		WHERE IdPaginaPadre is not null
		OR NOT EXISTS(SELECT 1 FROM Seguridad.Pagina Where IdPaginaPadre = P1.IdPagina)

		UNION ALL
		
		SELECT DISTINCT   A.IdAccion			AS Id
						, A.Nombre					AS Nombre
						, P.IdPagina				AS IdPadre
						, 4							AS Nivel
						, NULL						AS NivelPagina
						, NULL						AS IdPaginaPadre
						,CAST (CASE WHEN PF.IdAccion IS NULL THEN 0 ELSE 1 END AS BIT) [Check]
						,0							AS Orden
		FROM Seguridad.PaginaAccion PA
		INNER JOIN Seguridad.Pagina P ON P.IdPagina = PA.IdPagina
		INNER JOIN Seguridad.Modulo M ON M.IdModulo = P.IdModulo
		INNER JOIN Seguridad.Rol R ON R.IdAplicacion = M.IdAplicacion And M.IdAplicacion = (SELECT IdAplicacion FROM Seguridad.Rol WHERE IdRol = @IdRol)
		INNER JOIN Seguridad.Accion A ON A.IdAccion = PA.IdAccion And PA.ChkAgregar = 1
		LEFT JOIN Seguridad.PermisoPerfil PF ON PA.IdAccion = PF.IdAccion And PF.IdRol = @IdRol And PF.IdEmpresa = @IdEmpresa and PF.IdPagina = P.IdPagina
	)
	SELECT	DISTINCT Id
					,Nombre
					,IdPadre
					,Nivel
					,NivelPagina
					,IdPaginaPadre
					,[Check]
					,LTV.Orden
	FROM	ListaTreeView LTV
	ORDER BY LTV.Orden
END

GO
/****** Object:  StoredProcedure [Seguridad].[Usp_UnidadOrganica_Listar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Seguridad].[Usp_UnidadOrganica_Listar]
AS
BEGIN
	Select [ID_UNIDAD_ORGANICA]
	,[DESCRIPCION]
	From [Estructura].[UnidadOrganica]
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Upd_CambiarContrasenia]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Seguridad].[Usp_Upd_CambiarContrasenia] --'FARMDEV'
@Usuario VARCHAR(20)
AS
BEGIN
	UPDATE Seguridad.Usuario SET CambiarPassword = 0 WHERE Usuario = @Usuario
END
GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Upd_Usuario_Contrasena]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE PROCEDURE [Seguridad].[Usp_Upd_Usuario_Contrasena]
 @IdUsuario INT,
 @Contrasena VARCHAR(200)
 AS
 BEGIN
 
 DECLARE @CodigoUsuario VARCHAR(100)
  
 UPDATE Seguridad.Usuario SET Contrasena  = @Contrasena ,  CambiarPassword = 0
 WHERE IdUsuario = @IdUsuario 

 SET @CodigoUsuario =  (SELECT TOP 1 Usuario FROM Seguridad.Usuario WHERE IdUsuario = @IdUsuario)

 IF(EXISTS(SELECT IdUsuario FROM [BD_ERP_MASTER].Seguridad.Usuario WHERE UsuUsuario = @CodigoUsuario))
 BEGIN
	UPDATE [BD_ERP_MASTER].Seguridad.Usuario 
	SET [Password] = @Contrasena, ContraseñaOperacion = @Contrasena, CambiarPassword = 0
	WHERE UsuUsuario = @CodigoUsuario

 END


 SELECT CAST(1 AS INT)
 END


GO
/****** Object:  StoredProcedure [Seguridad].[Usp_UpdContrasena_Usuario]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Seguridad].[Usp_UpdContrasena_Usuario] 
@Username	INT,
@Contrasena	VARCHAR(50)
AS
BEGIN
	DECLARE @CantContr INT
	DECLARE @ConfContr INT
	
	SET @CantContr = (SELECT COUNT(*) FROM [Seguridad].[HistorialContrasena] WHERE IdUsuario=@Username AND Contrasena=@Contrasena)
	SET @ConfContr = (SELECT CAST(CantidadContrasenaHist AS INT) FROM Seguridad.Politica)
	
	IF @CantContr<@ConfContr
		BEGIN
			UPDATE Seguridad.Usuario SET Contrasena=@Contrasena,FechaCreacion_Clave=GETDATE()
			WHERE IdUsuario=@Username AND IdEstado=1
			
			INSERT INTO [Seguridad].[HistorialContrasena] VALUES(@Username,@Contrasena)
			SELECT CAST(1 AS INT)
		END
	ELSE
		BEGIN
			SELECT CAST(2 AS INT)
		END
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Usuario_Actualizar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_Usuario_Actualizar] --2,'jcarlos','CARLOS FERNANDEZ',4,'1','AG@HOTMAIL.COM','AV.LA PAZ 300','12025484'
(
@IdUsuario				INT,
@UsuarioName			VARCHAR(100),
@NOMBRES				VARCHAR(200),
@IdTipoUsu				INT,
@CodEmpresa				VARCHAR(100),
@Email					VARCHAR(150),
@Direccion				VARCHAR(150),
@DNI					VARCHAR(8),
@IdCodEmp				VARCHAR(100),
@FlagResetearContrasena BIT,
@Contrasena				VARCHAR(30)

)
as
Begin
	IF EXISTS(SELECT * FROM SEGURIDAD.USUARIO U WHERE UPPER(U.Usuario)=UPPER(@UsuarioName) AND IdUsuario <> @IdUsuario) 
		BEGIN 
			SELECT CAST(2 AS INT) 
		END 

	ELSE
		BEGIN
			UPDATE BD_ERP_MASTER.Seguridad.Usuario
			SET CambiarPassword = @FlagResetearContrasena
			   ,NombreUsuario = @NOMBRES
			   ,[Password] = CASE WHEN @FlagResetearContrasena = 1 THEN @Contrasena ELSE [Password] END
			WHERE UsuUsuario = @UsuarioName
			
			UPDATE Seguridad.Usuario
			SET    Usuario = @UsuarioName,
				   NombreApellido = @NOMBRES,
				   IdUsuarioTipo = @IdTipoUsu,
				   CodigoEmpresa = @CodEmpresa,
				   EmailCoorporativo = @Email,
				   Direccion=@Direccion, 
				   DNI = @DNI,
				   CodigoEmp = @IdCodEmp
				   ,CambiarPassword = @FlagResetearContrasena
				   ,Contrasena = CASE WHEN @FlagResetearContrasena = 1 THEN @Contrasena ELSE Contrasena END

			WHERE IdUsuario = @IdUsuario

			SELECT CAST(1 AS INT) 
		END


		
END


GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Usuario_ActualizarEstado]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_Usuario_ActualizarEstado]
(
@IdUsuario int,
@IdEstado int
)
as
Begin
	Update Seguridad.Usuario
	Set IdEstado = @IdEstado
	Where IdUsuario = @IdUsuario
	
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Usuario_Buscar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Seguridad].[Usp_Usuario_Buscar] --11
(
@IdUsuario INT
)
as
Begin
	SELECT 
	U.IdUsuario,
	U.Usuario,
	NombreApellido,
	UT.IdUsuarioTipo as Tipo,
	E.IdEmpresa as Empresa,
	EmailCoorporativo,
	Direccion,
	DNI,
	UO.ID_UNIDAD_ORGANICA as IdUnidadOrganica,
	UO.DESCRIPCION as UnidadOrganicaDescripcion,
	A.ID_AREA as IdArea,
	A.DESCRIPCION as AreaDescripcion,
	U.CodigoEmp
	FROM Seguridad.Usuario U 
	INNER JOIN Estructura.UsuarioTipo UT ON UT.IdUsuarioTipo=U.IdUsuarioTipo
	INNER JOIN Seguridad.Empresa E ON E.IdEmpresa=U.CodigoEmpresa

	LEFT JOIN Estructura.Areas A on u.IdAreaBU = a.ID_AREA
	LEFT JOIN Estructura.UnidadOrganica UO ON U.IdSociedad = UO.ID_UNIDAD_ORGANICA

	WHERE U.IdUsuario=@IdUsuario
End


GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Usuario_Insertar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [Seguridad].[Usp_Usuario_Insertar] 
@IdUsuario	VARCHAR(100),
@IdCodEmp   VARCHAR(100),
@Nombres	VARCHAR(200),
@IdTipoUsu	INT,
@CodEmpresa	VARCHAR(100),
@Sexo		VARCHAR(15),
@Email		VARCHAR(150),
@Direccion	VARCHAR(150),
@DNI		VARCHAR(8),
@Modo		INT,
@Contrasena	VARCHAR(30),
@IdEstado   INT,
@IdEmpresaRelacionada   INT
AS
BEGIN

	IF EXISTS(SELECT * FROM SEGURIDAD.USUARIO U WHERE UPPER(U.Usuario)=UPPER(@IdUsuario)) 
		BEGIN 
			SELECT CAST(2 AS INT) 
		END 
	--ELSE IF EXISTS(SELECT * FROM SEGURIDAD.USUARIO U WHERE U.NombreApellido=UPPER(@NOMBRES)) 
	--	BEGIN 
	--		SELECT CAST(3 AS INT) 
	--	END 
	--ELSE IF EXISTS(SELECT * FROM SEGURIDAD.USUARIO U WHERE U.DNI=@DNI) 
	--	BEGIN 
	--		SELECT CAST(4 AS INT) 
	--	END 
	ELSE
		BEGIN
			DECLARE @IdUsu INT
			SET @IdUsu = (SELECT TOP 1 IdUsuario FROM Seguridad.Usuario ORDER BY IdUsuario DESC)
			SET @IdUsu = @IdUsu + 1
			
				IF @Modo=2
					BEGIN
						INSERT INTO Seguridad.Usuario 
						(Usuario
						,CodigoEmp
						,NombreApellido
						,IdEstado
						,IdUsuarioTipo
						,CodigoEmpresa
						,Sexo
						,EmailCoorporativo
						,Direccion
						,DNI
						,ModoUsuaio
						,Contrasena
						,FechaCreacion_Clave
						,IdArea
						,CambiarPassword
						,IdEmpresaRelacionada
						,NombreAbreviado) 
						VALUES
						(@IdUsuario
						,@IdCodEmp
						,@Nombres
						,@IdEstado
						,@IdTipoUsu
						,@CodEmpresa
						,@Sexo
						,@Email
						,@Direccion
						,@DNI
						,@Modo
						,@Contrasena
						,GETDATE()
						,1
						,1
						,@IdEmpresaRelacionada
						,CONCAT(SUBSTRING(@Nombres, 0,10),'.'))
						SELECT CAST(1 AS INT) 
					END
				ELSE
					BEGIN
						INSERT INTO Seguridad.Usuario 
						(Usuario
						,CodigoEmp
						,NombreApellido
						,IdEstado
						,IdUsuarioTipo
						,CodigoEmpresa
						,Sexo
						,EmailCoorporativo
						,Direccion
						,DNI
						,ModoUsuaio
						,Contrasena
						,IdArea
						,CambiarPassword
						,IdEmpresaRelacionada
						,NombreAbreviado) 
						VALUES
						(@IdUsuario
						,@IdCodEmp
						,@Nombres
						,@IdEstado
						,@IdTipoUsu
						,@CodEmpresa
						,@Sexo
						,@Email
						,@Direccion
						,@DNI
						,@Modo
						,@Contrasena
						,1
						,1
						,@IdEmpresaRelacionada
						,CONCAT(SUBSTRING(@Nombres, 0,10),'.'))
						SELECT CAST(1 AS INT) 
					END



				INSERT INTO [BD_ERP_MASTER].[Seguridad].[Usuario] (
															UsuUsuario
															,NombreUsuario
															,ActivoUsuario
															,Password
															,FechaCreacion
															,ContraseñaOperacion
															,IdArea
															,CambiarPassword
															,FlagAdministrador)
													VALUES  (@IdUsuario
															,@Nombres
															,@IdEstado
															,@Contrasena
															,GETDATE()
															,@IdCodEmp
															,1 --Farmacia
															,1
															,null)
			
		END
END


--SELECT TOP(10) 
--       [name], [object_id], [create_date], [modify_date]
--  FROM sys.all_objects 
-- WHERE [type] = 'P' AND [object_id] > 0 and name = 'Usp_Usuario_Insertar'
-- ORDER BY [modify_date] DESC


--SELECT TOP 5 * FROM Seguridad.Usuario
--SELECT CONCAT(SUBSTRING('RICHARD GÓMEZ', 0,10),'.')

--RICHARD G.
GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Usuario_Listar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Seguridad].[Usp_Usuario_Listar]

AS
BEGIN
	select IdUsuario, Usuario, EmailCoorporativo, NombreApellido from Seguridad.Usuario
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Usuario_ListarAsignadosPorRol]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Seguridad].[Usp_Usuario_ListarAsignadosPorRol]
(
	@IdRol int
)
AS
BEGIN
	SELECT DISTINCT U.IdUsuario, U.Usuario, U.EmailCoorporativo, U.Usuario + ' - ' + U.NombreApellido AS NombreApellido
	FROM Seguridad.Usuario U 
			JOIN Seguridad.UsuarioRol UR ON UR.IdUsuario = U.IdUsuario 
	WHERE	UR.IdRol = @IdRol 
			AND U.IdEstado = 1 
			AND Usuario Not Like '$%'
			AND NombreApellido is not null
END

GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Usuario_ListarNoAsignadosPorRol]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Seguridad].[Usp_Usuario_ListarNoAsignadosPorRol]-- 2
(
	@IdRol int
)
AS
BEGIN
	IF @IdRol <> 0
		BEGIN
			select Distinct U.IdUsuario, U.Usuario, U.EmailCoorporativo, U.Usuario + ' - ' + U.NombreApellido AS NombreApellido 
			from Seguridad.Usuario U
			where U.IdUsuario NOT IN (SELECT IdUsuario FROM Seguridad.UsuarioRol UR where UR.IdRol = @IdRol) And
			U.IdEstado = 1 And U.Usuario Not Like '%$%' 
			And NombreApellido is not null
		END
	ELSE
		BEGIN
			select Distinct U.IdUsuario, U.Usuario, U.EmailCoorporativo, U.Usuario + ' - ' + U.NombreApellido AS NombreApellido 
			from Seguridad.Usuario U
			join Seguridad.UsuarioRol UR
			on UR.IdUsuario = U.IdUsuario 
			where UR.IdRol = @IdRol And U.IdEstado = 1 And Usuario Not Like '$%'
			And NombreApellido is not null
		END
	
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Usuario_ListarPorRol]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Seguridad].[Usp_Usuario_ListarPorRol]
(
	@IdRol int
)
AS
BEGIN
	select U.IdUsuario, U.Usuario, U.EmailCoorporativo, U.NombreApellido 
	from Seguridad.Usuario U 
	join Seguridad.UsuarioRol UR
	on UR.IdUsuario = U.IdUsuario
	join Seguridad.Rol R
	on R.IdRol = UR.IdRol
	where R.IdRol = @IdRol

END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Usuario_ListarPorUsuario]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [Seguridad].[Usp_Usuario_ListarPorUsuario]
(
@IdUsuario        INT = 0,  
@Usuario VARCHAR(100) = '' 
)
AS
BEGIN
	SELECT	 U.IdUsuario
    		  ,U.DNI
    			,U.Usuario
    			,U.Contrasena Clave
    			,U.NombreApellido
    			,U.CodigoEmpresa 
    			,U.IdUsuarioTipo
          ,U.EmailCoorporativo
    			,U.IdEstado	
    			,A.IdArea
    			,A.NombreArea
          ,C.IdCargo
          ,C.NombreCargo
		  ,U.IdAreas
	FROM		Seguridad.Usuario U
	LEFT JOIN	Estructura.Area A
	ON		(U.IdArea = A.IDArea)
  LEFT JOIN Estructura.Cargo C
  ON    (U.IdCargo = C.IdCargo)
	WHERE (U.IdUsuario  = @IdUsuario OR @IdUsuario = 0)
  AND   (U.Usuario = @Usuario OR @Usuario = '' OR @Usuario IS NULL)
END

GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Usuario_Paginacion]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Seguridad].[Usp_Usuario_Paginacion] --'','',0,1,5,0,'','',2,100
(
	@Usuario varchar(100),
	@NombreApellido varchar(200),
	@IdUsuarioTipo Int,
	
	@IdEmpresa Int,
	@IdAplicacion Int,
	@IdRol Int,
	
	@SortType VARCHAR(100), 
	@SortDir VARCHAR(50), 
	@Page INT, 
	@RowsPerPage INT, 
	
	@RowCount INT = 0 OUT 
)
AS 
BEGIN
	BEGIN		
		WITH Usuario AS
		(
			SELECT ROW_NUMBER() OVER 
			(ORDER BY
				--ASC
				CASE WHEN (@SortType = 'UserName' AND @SortDir = 'ASC') THEN U.Usuario END ASC,
				CASE WHEN (@SortType = 'NombreApellido' AND @SortDir = 'ASC') THEN U.NombreApellido END ASC,
				CASE WHEN (@SortType = 'EmailCoorporativo' AND @SortDir = 'ASC') THEN U.EmailCoorporativo END ASC,
				CASE WHEN (@SortType = 'UsuarioTipo.Nombre' AND @SortDir = 'ASC') THEN UT.Nombre END ASC,
				CASE WHEN (@SortType = 'Estado.Nombre' AND @SortDir = 'ASC') THEN ES.Nombre END ASC,
				--DESC
				CASE WHEN (@SortType = 'UserName' AND @SortDir = 'DESC') THEN U.Usuario END DESC,
				CASE WHEN (@SortType = 'NombreApellido' AND @SortDir = 'DESC') THEN U.NombreApellido END DESC,
				CASE WHEN (@SortType = 'EmailCoorporativo' AND @SortDir = 'DESC') THEN U.EmailCoorporativo END DESC,
				CASE WHEN (@SortType = 'UsuarioTipo.Nombre' AND @SortDir = 'DESC') THEN UT.Nombre END DESC,
				CASE WHEN (@SortType = 'Estado.Nombre' AND @SortDir = 'DESC') THEN ES.Nombre END DESC,
				--DEFAULT				
				CASE WHEN @SortType = '' THEN U.Usuario END DESC 				
			)	
			AS ROWNUMBER,
			U.IdUsuario,
			U.Usuario,
			U.CodigoEmp,
			U.EmailCoorporativo,
			U.NombreApellido, 
			ES.IdEstado,
			ES.Nombre NombreEstado,
			UT.IdUsuarioTipo,
			UT.Nombre NombreUsuarioTipo
			--TABLES 
			FROM Seguridad.Usuario U
			Inner Join Estructura.Estado ES On ES.IdEstado = U.IdEstado
			Inner Join Estructura.UsuarioTipo UT On UT.IdUsuarioTipo = U.IdusuarioTipo
			LEFT JOIN  [Seguridad].[Empresa] E ON  U.CodigoEmpresa = E.CodigoEmpresa --AGREGADO Por PIERRE GUTIERREZ
			LEFT JOIN [Seguridad].[UsuarioRol] UR ON U.IdUsuario = UR.IdUsuario
			LEFT JOIN [Seguridad].[Rol] R	ON UR.IdRol = R.IdRol
			LEFT JOIN [Seguridad].[Aplicacion] A ON R.IdAplicacion = A.IdAplicacion
			WHERE			
			(@Usuario = '' Or U.Usuario Like '%' + @Usuario + '%')
			And (@NombreApellido = '' Or NombreApellido Like '%' + @NombreApellido + '%') 
			And (@IdUsuarioTipo = 0 Or U.IdUsuarioTipo = @IdUsuarioTipo) 
			And (@IdEmpresa= 0 OR E.IdEmpresa = @IdEmpresa)-- AGREGADO Por Pierre Gutierrez
			And (@IdAplicacion = 0 OR A.IdAplicacion = @IdAplicacion)
			And (@IdRol =0  Or R.IdRol = @IdRol )
			GROUP BY U.IdUsuario,U.Usuario , U.CodigoEmp,U.NombreApellido,U.EmailCoorporativo,ES.IdEstado,ES.Nombre,UT.IdUsuarioTipo,UT.Nombre	

		)
		
		SELECT 
			IdUsuario,
			Usuario,
			CodigoEmp,
			EmailCoorporativo,
			NombreApellido, 
			IdEstado,
			NombreEstado,
			IdUsuarioTipo,
			NombreUsuarioTipo
		FROM Usuario
		WHERE ROWNUMBER BETWEEN (@RowsPerPage * (@Page - 1) + 1) AND @Page * @RowsPerPage
		
		/*SET @RowCount = (
			SELECT COUNT(1)
			FROM Seguridad.Usuario U
			Inner Join Estructura.Estado ES On ES.IdEstado = U.IdEstado
			Inner Join Estructura.UsuarioTipo UT On UT.IdUsuarioTipo = U.IdusuarioTipo
			LEFT JOIN  [Seguridad].[Empresa] E ON  U.CodigoEmpresa = E.CodigoEmpresa --AGREGADO Por PIERRE GUTIERREZ
			LEFT JOIN [Seguridad].[UsuarioRol] UR ON U.IdUsuario = UR.IdUsuario
			LEFT JOIN [Seguridad].[Rol] R	ON UR.IdRol = R.IdRol
			LEFT JOIN [Seguridad].[Aplicacion] A ON R.IdAplicacion = A.IdAplicacion
			WHERE			
			(@Usuario = '' Or U.Usuario Like '%' + @Usuario + '%')
			And (@NombreApellido = '' Or NombreApellido Like '%' + @NombreApellido + '%') 
			And (@IdUsuarioTipo = 0 Or U.IdUsuarioTipo = @IdUsuarioTipo)
			And (@IdEmpresa= 0 OR E.IdEmpresa = @IdEmpresa)-- AGREGADO Por Pierre Gutierrez
			And (@IdAplicacion = 0 OR A.IdAplicacion = @IdAplicacion)
			And (@IdRol =0  Or R.IdRol = @IdRol )
			
		)	*/
		
		
		SET @RowCount = (select count(*) from (SELECT 
			U.IdUsuario,
			U.Usuario,
			U.CodigoEmp,
			U.EmailCoorporativo,
			U.NombreApellido, 
			ES.IdEstado,
			ES.Nombre NombreEstado,
			UT.IdUsuarioTipo,
			UT.Nombre NombreUsuarioTipo
			--TABLES 
			FROM Seguridad.Usuario U
			Inner Join Estructura.Estado ES On ES.IdEstado = U.IdEstado
			Inner Join Estructura.UsuarioTipo UT On UT.IdUsuarioTipo = U.IdusuarioTipo
			LEFT JOIN  [Seguridad].[Empresa] E ON  U.CodigoEmpresa = E.CodigoEmpresa --AGREGADO Por PIERRE GUTIERREZ
			LEFT JOIN [Seguridad].[UsuarioRol] UR ON U.IdUsuario = UR.IdUsuario
			LEFT JOIN [Seguridad].[Rol] R	ON UR.IdRol = R.IdRol
			LEFT JOIN [Seguridad].[Aplicacion] A ON R.IdAplicacion = A.IdAplicacion
			WHERE			
			(@Usuario = '' Or U.Usuario Like '%' + @Usuario + '%')
			And (@NombreApellido = '' Or NombreApellido Like '%' + @NombreApellido + '%') 
			And (@IdUsuarioTipo = 0 Or U.IdUsuarioTipo = @IdUsuarioTipo) 
			And (@IdEmpresa= 0 OR E.IdEmpresa = @IdEmpresa)-- AGREGADO Por Pierre Gutierrez
			And (@IdAplicacion = 0 OR A.IdAplicacion = @IdAplicacion)
			And (@IdRol =0  Or R.IdRol = @IdRol )
			GROUP BY U.IdUsuario,U.Usuario , U.CodigoEmp,U.NombreApellido,U.EmailCoorporativo,ES.IdEstado,ES.Nombre,UT.IdUsuarioTipo,UT.Nombre	
		)as temp) 
	END
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_UsuariobyContrasenaOperacion]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [Seguridad].[Usp_UsuariobyContrasenaOperacion]
(
	@ContrasenaOperacion varchar(30)
)
AS
BEGIN
	SELECT
	CodigoEmp,
	Usuario,
	IdUsuario,
	NombreApellido,
	EmailCoorporativo,
	Direccion,
	DNI

	FROM Seguridad.Usuario
	WHERE CodigoEmp = @ContrasenaOperacion
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_UsuarioRol_CrearPerfil]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Seguridad].[Usp_UsuarioRol_CrearPerfil]
     @Data AS [SEGURIDAD].[TYPEUSUARIOROL]	READONLY
    ,@IdRol									INT
	,@IdAccion								INT
	,@IdUsuario								INT
	,@IdTablaReferencia						INT
	,@IdTipoAccion							VARCHAR(10)
	,@UserName								VARCHAR(100)
	,@IP									VARCHAR(50)
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		   DECLARE @TablaUsuariosNuevos		AS [SEGURIDAD].[TYPEUSUARIOROL]
		   DECLARE @TablaUsuariosEliminados AS [SEGURIDAD].[TYPEUSUARIOROL]
		   
		   INSERT INTO @TablaUsuariosNuevos
		   (
		      IdUsuario
			 ,IdRol
		   )
		   SELECT IdUsuario
				  ,IdRol
		   FROM @Data D
		   WHERE IdUsuario NOT IN (
		   SELECT IdUsuario FROM  [SEGURIDAD].[USUARIOROL]
		   WHERE IdRol = @IdRol
		   )  AND IdUsuario <> 0

		   INSERT INTO @TablaUsuariosEliminados
		   (
		      IdUsuario
			 ,IdRol
		   )
		   SELECT  IdUsuario
				  ,IdRol
			FROM [SEGURIDAD].[USUARIOROL]
			WHERE IdRol = @IdRol
			AND  IdUsuario NOT IN (
			SELECT IdUsuario FROM  @Data
			WHERE IdUsuario <> 0
			)

			INSERT INTO [SEGURIDAD].[USUARIOROL]
		    (
		      IdUsuario
			 ,IdRol
		    ) 
			SELECT IdUsuario
				  ,IdRol
			FROM @TablaUsuariosNuevos


		   INSERT INTO Seguridad.Auditoria_Transacional
								(
								  IdAccion			
								 ,IdUsuario			
								 ,DescripcionAuditoria		
								 ,IdTablaReferencia	
								 ,IdTipoAccion		
								 ,IdReferencia		
								 ,UserName			
								 ,IP
								 ,FechaOperacion
								)
			SELECT       @IdAccion		
						,@IdUsuario			
						,'Id Usuario:' + CAST([IDUSUARIO] AS VARCHAR(20)) + ' | Id Rol : ' + CAST([IDROL] AS VARCHAR(20))
						,@IdTablaReferencia	
						,'01'		
						,0		
						,@UserName			
						,@IP
						,GETDATE()			
			FROM @TablaUsuariosNuevos

		   DELETE FROM [SEGURIDAD].[USUARIOROL]
		   WHERE IdRol = @IdRol
		   AND IdUsuario IN (
			   SELECT IdUsuario
			   FROM @TablaUsuariosEliminados
		   )


			INSERT INTO Seguridad.Auditoria_Transacional
								(
								  IdAccion			
								 ,IdUsuario			
								 ,DescripcionAuditoria		
								 ,IdTablaReferencia	
								 ,IdTipoAccion		
								 ,IdReferencia		
								 ,UserName			
								 ,IP
								 ,FechaOperacion
								)
			SELECT			     @IdAccion		
								,@IdUsuario			
								,'Id Usuario:' + CAST([IDUSUARIO] AS VARCHAR(20)) + ' | Id Rol : ' + CAST([IDROL] AS VARCHAR(20))
								,@IdTablaReferencia	
								,'06'		
								,0		
								,@UserName			
								,@IP
						,GETDATE()			
			FROM @TablaUsuariosEliminados

			SELECT CAST(1 AS INT)
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SELECT CAST(-1 AS INT)
	END CATCH
END


GO
/****** Object:  StoredProcedure [Seguridad].[Usp_UsuarioRol_CrearPerfil_bk]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--PARA QUE CREE CORRECTAMENTE LOS PERFILES DE LOS USUARIOS
CREATE PROCEDURE [Seguridad].[Usp_UsuarioRol_CrearPerfil_bk]
    @TypeRolUsuario AS [SEGURIDAD].[TYPEUSUARIOROL] READONLY,
    @Option INT
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION
		
			DECLARE @ROL INT = ( SELECT TOP 1 [IDROL]  FROM @TypeRolUsuario )
			
			--USUARIOS PARA AGREGAR
			
			IF @Option = 1
			BEGIN
				SELECT [IDUSUARIO],[IDROL] INTO #AGREGAR FROM @TypeRolUsuario 
				WHERE  IDUSUARIO <> 0 
				AND [IDUSUARIO] NOT IN ( SELECT[IDUSUARIO] FROM [SEGURIDAD].[USUARIOROL] WHERE [IDROL] = @ROL )
			END
			
			IF @Option = 2
			BEGIN
				SELECT [IDUSUARIO],[IDROL] INTO #QUITAR FROM @TypeRolUsuario 
				WHERE  IDUSUARIO <> 0 
			END
			--USUARIOS PARA QUITAR
			--SELECT [IDUSUARIO],[IDROL] INTO #QUITAR  FROM [SEGURIDAD].[USUARIOROL] 
			--WHERE [IDROL] = @ROL AND [IDUSUARIO] NOT IN ( SELECT [IDUSUARIO] FROM @TypeRolUsuario )
			
			IF @Option = 1
			BEGIN
			
				IF EXISTS (SELECT * FROM #AGREGAR )
				BEGIN
				
					INSERT INTO [SEGURIDAD].[USUARIOROL] ([IDUSUARIO],[IDROL]) 
					SELECT [IDUSUARIO],[IDROL] FROM #AGREGAR
					
				END
				
			END
			
			IF @Option = 2
			BEGIN
			
				IF EXISTS (SELECT * FROM #QUITAR )
				BEGIN
				
					DELETE FROM [SEGURIDAD].[USUARIOROL] 
					WHERE [IDROL] = @ROL AND 
					[IDUSUARIO] IN 
					( SELECT [IDUSUARIO] FROM #QUITAR )
					
				END
				
			END
			
			SELECT CAST(1 AS INT)
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SELECT CAST(-1 AS INT)
	END CATCH
END

GO
/****** Object:  StoredProcedure [Seguridad].[Usp_UsuarioRol_Eliminar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [Seguridad].[Usp_UsuarioRol_Eliminar]
(
@IdRol int
)
as
Begin
	Delete seguridad.UsuarioRol Where IdRol = @IdRol
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_Usuarios_Insertar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Seguridad].[Usp_Usuarios_Insertar]
    @TypeUsuarios AS [SEGURIDAD].[TypeUsuarios] READONLY,
    @Dominio As Varchar(50)
AS
BEGIN
	Declare @IdUsuario int,
	@Usuario Varchar(100),
	@CodigoEmp Varchar(100),
	@NombreApellido Varchar(200),
	@IdEstado int,
	@IdUsuarioTipo int,
	@CodigoEmpresa Varchar(100),
	@Sexo Varchar(15),
	@EmailCoorporativo Varchar(150),
	@Direccion Varchar(150),
	@DNI Varchar(8),
	@IdSociedad int,
	@SociedadDescripcionCorta varchar(100),
	@IdAreaBU int,
	@AreaBUDescripcionCorta Varchar(100),
	@IdCargo int,
	@CargoDescripcionCorta Varchar(100),
	@IdComite int,
	@Id int
	
	Update Seguridad.Usuario Set IdEstado = 2
	
	DECLARE _Cursor CURSOR FOR 
	SELECT Usuario,EmailCoorporativo,NombreApellido,IdEstado,IdUsuarioTipo FROM @TypeUsuarios

	OPEN _Cursor
	FETCH NEXT FROM _Cursor INTO @Usuario,@EmailCoorporativo,@NombreApellido,@IdEstado,@IdUsuarioTipo
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		select @Id = Isnull(Max(IdUsuario),0) + 1 From Seguridad.Usuario 
	
		Select @CodigoEmp = Cast(IDAlternativo as int), @CodigoEmpresa = Cast(IdCompania as Int), @Sexo = Sexo, @Direccion = Direccion, 
		@IdUsuarioTipo = Cast(IdTipoTrabajador as Int), @DNI = Cast(Cast(NumeroDocIdentificacion as int) as Varchar), 
		@IdCargo = Cast(IdCargo as Int), @CargoDescripcionCorta = Nombrecargo, @NombreApellido = ApellidoPaterno + ', ' + ApellidoMaterno  
		From BD_KomatsuCoreEmpleado.dbo.VistaEmpleado Where CorreoBoleta = @Usuario + @Dominio
		
		If Exists(Select 1 From Seguridad.Usuario Where Usuario = @Usuario)
		Begin
			Update Seguridad.Usuario 
			Set CodigoEmp = @CodigoEmp, EmailCoorporativo = @EmailCoorporativo, NombreApellido = @NombreApellido, 
			IdEstado = @IdEstado, IdUsuarioTipo = @IdUsuarioTipo, CodigoEmpresa = @CodigoEmpresa, Sexo = @Sexo,
			DNI = @DNI, IdCargo = @IdCargo, CargoDescripcionCorta = @CargoDescripcionCorta
			Where Usuario = @Usuario 
			
		end
		Else 
		Begin
			Insert Into Seguridad.Usuario 
			(IdUsuario, Usuario,CodigoEmp,EmailCoorporativo,NombreApellido,IdEstado,IdUsuarioTipo, CodigoEmpresa, Sexo, DNI, IdCargo, CargoDescripcionCorta) 
			Values
			(@Id, @Usuario,@CodigoEmp,@EmailCoorporativo,@NombreApellido,@IdEstado,@IdUsuarioTipo,@CodigoEmpresa, @Sexo, @DNI, @IdCargo, @CargoDescripcionCorta)
		
		End
		Set @CodigoEmp = ''
		
		FETCH NEXT FROM _Cursor INTO @Usuario,@EmailCoorporativo,@NombreApellido,@IdEstado,@IdUsuarioTipo
	END
	
	CLOSE _Cursor
	DEALLOCATE _Cursor
	
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_UsuariosxAplicacion]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Seguridad].[Usp_UsuariosxAplicacion] --4
@IdAplicacion int
AS
BEGIN
	SELECT
	U.IdUsuario AS IDUSUARIO ,
	U.Usuario AS USUARIO,
	U.NombreApellido AS NOMBRE_USUARIO,
	U.EmailCoorporativo AS EMAIL
	FROM Seguridad.Aplicacion A 
	LEFT JOIN Seguridad.Rol R ON (R.IdAplicacion = A.IdAplicacion)
	LEFT JOIN Seguridad.UsuarioRol UR ON (R.IdRol = UR.IdRol)
	LEFT JOIN Seguridad.Usuario U ON (U.IdUsuario = UR.IdUsuario)
	WHERE  A.Idaplicacion = @IdAplicacion
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_UsuarioTipo_Listar]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [Seguridad].[Usp_UsuarioTipo_Listar]
as
Begin
	Select  IdUsuarioTipo, Nombre NombreUsuarioTipo From Estructura.UsuarioTipo
End



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_ValContrasena_Usuario]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Seguridad].[Usp_ValContrasena_Usuario] 
@Username	INT,
@Contrasena	VARCHAR(50)
AS
BEGIN
	IF EXISTS(SELECT TOP 1 Contrasena FROM Seguridad.Usuario WHERE IdUsuario=@Username AND Contrasena=@Contrasena AND IdEstado=1)
		BEGIN
			SELECT CAST(1 AS INT)
		END
	ELSE
		BEGIN
			SELECT CAST(2 AS INT)
		END
END



GO
/****** Object:  StoredProcedure [Seguridad].[Usp_ValidarUsuarioPorContrasenaOperacion]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Seguridad].[Usp_ValidarUsuarioPorContrasenaOperacion]-- 3089, 'Kvvl6dkue2ibQTCdcnFpcQ==G'
(
	 @IdUsuario				INT
	,@ContrasenaOperacion	VARCHAR(30)
)
AS
BEGIN
    DECLARE @RESULT BIT = 0
	IF EXISTS(
					SELECT 1
					FROM Seguridad.Usuario
					WHERE CodigoEmp = @ContrasenaOperacion
					AND IdUsuario <> @IdUsuario)
    BEGIN
		SET @RESULT = 1
	END

	SELECT @RESULT
END
GO
/****** Object:  StoredProcedure [Seguridad].[Usp_ValModo_Usuario]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [Seguridad].[Usp_ValModo_Usuario] --'JHUGO'
@Username	VARCHAR(50)
AS
BEGIN
	DECLARE @Modo INT
	DECLARE @Bloqueo INT
	DECLARE @BloqueoDias INT
	DECLARE @FechaBloqueo DATETIME
	DECLARE @DiferenciaBloqueo INT
	
	SET @Bloqueo = (SELECT ISNULL(Bloqueo,0) FROM Seguridad.Usuario WHERE Usuario=@Username AND IdEstado=1)
	
	IF @Bloqueo=0
		BEGIN
			SET @Modo = (SELECT TOP 1 ISNULL(ModoUsuaio,0) FROM Seguridad.Usuario WHERE Usuario=@Username AND IdEstado=1)
			SELECT CAST(@Modo AS INT)
		END
	ELSE IF @Bloqueo=1
		BEGIN
			SET @BloqueoDias = (SELECT CAST(DiasBloqueoUsuario AS INT) FROM Seguridad.Politica)
			SET @FechaBloqueo = (SELECT FechaBloqueo FROM Seguridad.Usuario WHERE Usuario=@Username AND IdEstado=1)
			SET @DiferenciaBloqueo = (SELECT CAST(DATEDIFF(DAY,@FechaBloqueo,GETDATE())AS INT))
			
			IF @DiferenciaBloqueo >= @BloqueoDias
				BEGIN
					UPDATE Seguridad.Usuario SET Bloqueo=0,FechaBloqueo=GETDATE()
					WHERE Usuario=@Username
					
					SET @Modo = (SELECT TOP 1 ISNULL(ModoUsuaio,0) FROM Seguridad.Usuario WHERE Usuario=@Username AND IdEstado=1)
					SELECT CAST(@Modo AS INT)
			
				END
			ELSE
				BEGIN
					SELECT CAST(5 AS INT)
				END 
		END

END



GO
/****** Object:  UserDefinedFunction [dbo].[ufnSplit]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ufnSplit]
(
@ParameterList VARCHAR(MAX), -- Cadena de datos a separar
@Delimiter VARCHAR(8000) = ',' -- Separador de Datos
) 
RETURNS @ListaTemporal TABLE (item VARCHAR(MAX))
BEGIN
	DECLARE @Item VARCHAR(Max)
	WHILE CHARINDEX(@Delimiter,@ParameterList,0) <> 0
	BEGIN
		SELECT @Item=RTRIM(LTRIM(SUBSTRING(@ParameterList,1,
		CHARINDEX(@Delimiter,@ParameterList,0)-1))),
		@ParameterList=RTRIM(LTRIM(SUBSTRING(@ParameterList,
		CHARINDEX(@Delimiter,@ParameterList,0)
		+LEN(@Delimiter),LEN(@ParameterList))))
		IF LEN(@Item) > 0
		INSERT INTO @ListaTemporal SELECT @Item
	END
	IF LEN(@ParameterList) > 0
		INSERT INTO @ListaTemporal SELECT @ParameterList -- Coloca luego del último elemento
	RETURN
END


GO
/****** Object:  UserDefinedFunction [Estructura].[Fn_SplitContenido]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [Estructura].[Fn_SplitContenido] 
(    
    @RowData NVARCHAR(MAX),
    @Delimeter NVARCHAR(MAX)
)
RETURNS @RtnValue TABLE 
(
    ID INT IDENTITY(1,1),
    Data NVARCHAR(MAX)
) 
AS
BEGIN 
    DECLARE @Iterator INT
    SET @Iterator = 1

    DECLARE @FoundIndex INT
    SET @FoundIndex = CHARINDEX(@Delimeter,@RowData)

    WHILE (@FoundIndex>0)
    BEGIN
        INSERT INTO @RtnValue (data)
        SELECT 
            Data = LTRIM(RTRIM(SUBSTRING(@RowData, 1, @FoundIndex - 1)))

        SET @RowData = SUBSTRING(@RowData,
                @FoundIndex + DATALENGTH(@Delimeter) / 2,
                LEN(@RowData))

        SET @Iterator = @Iterator + 1
        SET @FoundIndex = CHARINDEX(@Delimeter, @RowData)
    END
    
    INSERT INTO @RtnValue (Data)
    SELECT Data = LTRIM(RTRIM(@RowData))

    RETURN
END


GO
/****** Object:  Table [Auditoria].[TablaReferencia]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Auditoria].[TablaReferencia](
	[IdTablaReferencia] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](250) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdTablaReferencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Auditoria].[TipoAccion]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Auditoria].[TipoAccion](
	[IdTipoAccion] [char](2) NOT NULL,
	[Descripcion] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdTipoAccion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DataUsuario]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DataUsuario](
	[IdUsuario] [int] NOT NULL,
	[Usuario] [varchar](100) NULL,
	[CodigoEmp] [varchar](100) NULL,
	[NombreApellido] [varchar](200) NULL,
	[IdEstado] [int] NULL,
	[IdUsuarioTipo] [int] NULL,
	[CodigoEmpresa] [varchar](100) NULL,
	[Sexo] [varchar](15) NULL,
	[EmailCoorporativo] [varchar](150) NULL,
	[Correo] [varchar](150) NULL,
	[Direccion] [varchar](150) NULL,
	[DNI] [varchar](8) NULL,
	[IdSociedad] [int] NULL,
	[SociedadDescripcionCorta] [varchar](100) NULL,
	[IdAreaBU] [int] NULL,
	[AreaBUDescripcionCorta] [varchar](100) NULL,
	[IdCargo] [int] NULL,
	[CargoDescripcionCorta] [varchar](100) NULL,
	[IdComite] [int] NULL,
	[ModoUsuaio] [int] NULL,
	[Contrasena] [varchar](30) NULL,
	[FechaCreacion_Clave] [datetime2](3) NULL,
	[Bloqueo] [int] NULL,
	[FechaBloqueo] [datetime2](3) NULL,
	[IdArea] [int] NULL,
	[IdAreas] [varchar](250) NULL,
	[CambiarPassword] [bit] NULL,
	[IdEmpresaRelacionada] [int] NULL,
	[CodigoVendedor] [varchar](6) NULL,
	[NombreAbreviado] [varchar](250) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Pisos$]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pisos$](
	[F1] [float] NULL,
	[DAPENOM] [nvarchar](255) NULL,
	[DUSUARI] [nvarchar](255) NULL,
	[DPASSWO] [nvarchar](255) NULL,
	[DFECING] [datetime] NULL,
	[DNORMAL] [nvarchar](255) NULL,
	[F7] [float] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Estructura].[Area]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Estructura].[Area](
	[IdArea] [int] NOT NULL,
	[NombreArea] [varchar](50) NULL,
	[Descripcion] [varchar](100) NULL,
	[Estado] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdArea] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Estructura].[AreaS]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Estructura].[AreaS](
	[ID_AREA] [int] NOT NULL,
	[ID_UNIDAD_ORGANICA] [int] NULL,
	[SIGLA] [varchar](100) NULL,
	[DESCRIPCION] [varchar](100) NULL,
	[IDUSUCREA] [int] NULL,
	[IDUSUMODI] [int] NULL,
	[FE_CREACION] [date] NULL,
	[FE_MODIFICACION] [date] NULL,
	[FLAG_ESTADO] [varchar](10) NULL,
 CONSTRAINT [PK_Estructura]].[AreaNew] PRIMARY KEY CLUSTERED 
(
	[ID_AREA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Estructura].[Cargo]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Estructura].[Cargo](
	[IdCargo] [int] NOT NULL,
	[NombreCargo] [varchar](50) NULL,
	[Descripcion] [varchar](100) NULL,
	[Estado] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdCargo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Estructura].[Estado]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Estructura].[Estado](
	[IdEstado] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[IdEstado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Estructura].[Grupo]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Estructura].[Grupo](
	[IdGrupo] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [varchar](50) NULL,
	[Nombre] [varchar](50) NOT NULL,
	[Abreviatura] [varchar](50) NULL,
	[IdEstado] [int] NOT NULL,
	[OrdenGrupo] [int] NULL,
 CONSTRAINT [PK_Objeto] PRIMARY KEY CLUSTERED 
(
	[IdGrupo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Estructura].[Lenguaje]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Estructura].[Lenguaje](
	[IdLenguaje] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](50) NULL,
	[Abreviatura] [varchar](10) NULL,
	[Activo] [bit] NULL,
 CONSTRAINT [PK_Lenguaje] PRIMARY KEY CLUSTERED 
(
	[IdLenguaje] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Estructura].[UnidadOrganica]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Estructura].[UnidadOrganica](
	[ID_UNIDAD_ORGANICA] [int] NOT NULL,
	[SIGLA] [varchar](100) NULL,
	[DESCRIPCION] [varchar](100) NULL,
	[IDUSUCREA] [int] NULL,
	[IDUSUMODI] [int] NULL,
	[FE_CREACION] [date] NULL,
	[FE_MODIFICACION] [date] NULL,
	[FLAG_ESTADO] [varchar](10) NULL,
 CONSTRAINT [PK_UnidadOrganica] PRIMARY KEY CLUSTERED 
(
	[ID_UNIDAD_ORGANICA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Estructura].[UsuarioTipo]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Estructura].[UsuarioTipo](
	[IdUsuarioTipo] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](100) NULL,
 CONSTRAINT [PK_UsuarioTipo] PRIMARY KEY CLUSTERED 
(
	[IdUsuarioTipo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Seguridad].[Accion]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Seguridad].[Accion](
	[IdAccion] [int] IDENTITY(1,1) NOT NULL,
	[IdGrupo] [int] NOT NULL,
	[CodigoHTML] [varchar](100) NULL,
	[Nombre] [varchar](150) NULL,
	[Etiqueta] [varchar](150) NULL,
	[MensajeToolTip] [varchar](150) NULL,
	[Evento] [varchar](150) NULL,
	[IdEstado] [int] NOT NULL,
	[OrdenAccion] [int] NULL,
	[TamañoButton] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdAccion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Seguridad].[Aplicacion]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Seguridad].[Aplicacion](
	[IdAplicacion] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](200) NULL,
	[Descripcion] [varchar](200) NULL,
	[Url] [varchar](200) NULL,
	[IdEstado] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdAplicacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Seguridad].[AplicacionTraductor]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Seguridad].[AplicacionTraductor](
	[IdAplicacionTraductor] [int] IDENTITY(1,1) NOT NULL,
	[IdLenguaje] [int] NULL,
	[IdAplicacion] [int] NULL,
	[Nombre] [varchar](150) NULL,
	[Activo] [bit] NULL,
 CONSTRAINT [PK_AplicacionTraductor] PRIMARY KEY CLUSTERED 
(
	[IdAplicacionTraductor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Seguridad].[Auditoria_Acceso]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Seguridad].[Auditoria_Acceso](
	[idAuditoriaAcceso] [int] IDENTITY(1,1) NOT NULL,
	[Fecha] [datetime] NULL,
	[Host] [varchar](100) NULL,
	[Ip] [varchar](100) NULL,
	[idUsuario] [int] NULL,
 CONSTRAINT [XPKAuditoria_Acceso] PRIMARY KEY CLUSTERED 
(
	[idAuditoriaAcceso] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Seguridad].[Auditoria_Transacional]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Seguridad].[Auditoria_Transacional](
	[idAuditoriaTransacional] [int] IDENTITY(1,1) NOT NULL,
	[idAccion] [int] NULL,
	[idUsuario] [int] NULL,
	[FechaOperacion] [datetime] NULL,
	[DescripcionAuditoria] [varchar](max) NULL,
	[IdTablaReferencia] [int] NULL,
	[IdTipoAccion] [char](2) NULL,
	[IdReferencia] [int] NULL,
	[UserName] [varchar](50) NULL,
	[IP] [varchar](15) NULL,
 CONSTRAINT [XPKAudiotoria_Transacional] PRIMARY KEY CLUSTERED 
(
	[idAuditoriaTransacional] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Seguridad].[Empresa]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Seguridad].[Empresa](
	[IdEmpresa] [int] IDENTITY(1,1) NOT NULL,
	[IdEstado] [int] NOT NULL,
	[Nombre] [varchar](200) NULL,
	[Abreviatura] [varchar](15) NULL,
	[CodigoEmpresa] [varchar](100) NULL,
	[ContentStyle] [varchar](300) NULL,
 CONSTRAINT [PK__Empresa__5EF4033E276EDEB3] PRIMARY KEY CLUSTERED 
(
	[IdEmpresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Seguridad].[EmpresaAplicacion]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Seguridad].[EmpresaAplicacion](
	[IdEmpresaAplicacion] [int] IDENTITY(1,1) NOT NULL,
	[IdEmpresa] [int] NOT NULL,
	[IdAplicacion] [int] NOT NULL,
 CONSTRAINT [PK_Objeto] PRIMARY KEY CLUSTERED 
(
	[IdEmpresaAplicacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Seguridad].[EmpresaUsuario]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Seguridad].[EmpresaUsuario](
	[CodRelacion] [int] IDENTITY(1,1) NOT NULL,
	[CodEmpresa] [varchar](100) NOT NULL,
	[IdUsuario] [varchar](100) NOT NULL,
 CONSTRAINT [PK_EmpresaUsuario] PRIMARY KEY CLUSTERED 
(
	[CodRelacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Seguridad].[HistorialContrasena]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Seguridad].[HistorialContrasena](
	[IdUsuario] [int] NOT NULL,
	[Contrasena] [varchar](100) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Seguridad].[Modulo]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Seguridad].[Modulo](
	[IdModulo] [int] IDENTITY(1,1) NOT NULL,
	[IdAplicacion] [int] NOT NULL,
	[Nombre] [varchar](200) NULL,
	[Descripcion] [varchar](200) NULL,
	[IdEstado] [int] NOT NULL,
	[Orden] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdModulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Seguridad].[ModuloAgrupacion]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Seguridad].[ModuloAgrupacion](
	[IdAgrupacion] [int] IDENTITY(1,1) NOT NULL,
	[IdModulo] [int] NULL,
	[Descripcion] [varchar](20) NULL,
	[Orden] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdAgrupacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Seguridad].[ModuloTraductor]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Seguridad].[ModuloTraductor](
	[IdModuloTraductor] [int] IDENTITY(1,1) NOT NULL,
	[IdLenguaje] [int] NULL,
	[IdModulo] [int] NULL,
	[Nombre] [varchar](200) NULL,
	[Activo] [bit] NULL,
 CONSTRAINT [PK_ModuloTraductor] PRIMARY KEY CLUSTERED 
(
	[IdModuloTraductor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Seguridad].[Operacion]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Seguridad].[Operacion](
	[IdOperacion] [int] IDENTITY(1,1) NOT NULL,
	[Descripcion] [varchar](250) NULL,
	[IdEstado] [int] NULL,
 CONSTRAINT [PK_Operacion] PRIMARY KEY CLUSTERED 
(
	[IdOperacion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Seguridad].[OperacionRol]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Seguridad].[OperacionRol](
	[IdOperacionRol] [int] IDENTITY(1,1) NOT NULL,
	[IdRol] [int] NOT NULL,
	[IdOperacion] [int] NOT NULL,
	[Activo] [bit] NOT NULL,
	[FechaHoraRegistro] [datetime] NOT NULL,
	[FechaHoraModificacion] [datetime] NULL,
 CONSTRAINT [PK_OperacionRol] PRIMARY KEY CLUSTERED 
(
	[IdOperacionRol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Seguridad].[Pagina]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Seguridad].[Pagina](
	[IdPagina] [int] IDENTITY(1,1) NOT NULL,
	[IdModulo] [int] NOT NULL,
	[IdPaginaPadre] [int] NULL,
	[Url] [varchar](100) NULL,
	[Nombre] [varchar](100) NULL,
	[Icono] [varchar](100) NULL,
	[Nivel] [int] NOT NULL,
	[Orden] [int] NULL,
	[Visible] [bit] NULL,
	[IdEstado] [int] NOT NULL,
	[IdAgrupacion] [int] NULL,
	[IdTamanoMenu] [int] NULL,
 CONSTRAINT [PK_Pagina] PRIMARY KEY CLUSTERED 
(
	[IdPagina] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Seguridad].[PaginaAccion]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Seguridad].[PaginaAccion](
	[IdPaginaAccion] [int] IDENTITY(1,1) NOT NULL,
	[IdPagina] [int] NULL,
	[IdAccion] [int] NULL,
	[ChkAgregar] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdPaginaAccion] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Seguridad].[PaginaGrupo]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Seguridad].[PaginaGrupo](
	[IdPaginaGrupo] [int] IDENTITY(1,1) NOT NULL,
	[IdPagina] [int] NOT NULL,
	[IdGrupo] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IdPaginaGrupo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Seguridad].[PaginaTraductor]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Seguridad].[PaginaTraductor](
	[IdPaginaTraductor] [int] IDENTITY(1,1) NOT NULL,
	[IdLenguaje] [int] NULL,
	[IdPagina] [int] NULL,
	[Nombre] [varchar](100) NULL,
 CONSTRAINT [PK_PaginaTraductor] PRIMARY KEY CLUSTERED 
(
	[IdPaginaTraductor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Seguridad].[PermisoPerfil]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Seguridad].[PermisoPerfil](
	[IdPermisoPerfil] [int] IDENTITY(1,1) NOT NULL,
	[IdRol] [int] NOT NULL,
	[IdEmpresa] [int] NULL,
	[IdAplicacion] [int] NULL,
	[IdModulo] [int] NULL,
	[IdPagina] [int] NOT NULL,
	[IdAccion] [int] NULL,
 CONSTRAINT [PK_PermisoPerfil] PRIMARY KEY CLUSTERED 
(
	[IdPermisoPerfil] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Seguridad].[Politica]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Seguridad].[Politica](
	[IdPolitica] [int] IDENTITY(1,1) NOT NULL,
	[LongMinima_Contrasena] [int] NOT NULL,
	[Vigencia_Contrasena] [int] NULL,
	[Diferencia_ContrasenaUsuario] [int] NULL,
	[NroMaximoIntentos] [int] NULL,
	[DiasBloqueoUsuario] [int] NULL,
	[ComplejidadContraseña] [int] NULL,
	[CantidadContrasenaHist] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdPolitica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Seguridad].[Rol]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Seguridad].[Rol](
	[IdRol] [int] IDENTITY(1,1) NOT NULL,
	[IdEstado] [int] NOT NULL,
	[Nombre] [varchar](50) NULL,
	[SiSuperAdmi] [bit] NOT NULL,
	[SiRango] [bit] NULL,
	[FechaInicio] [date] NULL,
	[FechaFin] [date] NULL,
	[IdAplicacion] [int] NOT NULL,
	[IdCentroAtencion] [int] NULL,
 CONSTRAINT [PK_Rol] PRIMARY KEY CLUSTERED 
(
	[IdRol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Seguridad].[RolTraductor]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Seguridad].[RolTraductor](
	[IdRolTraductor] [int] IDENTITY(1,1) NOT NULL,
	[IdLenguaje] [int] NULL,
	[IdRol] [int] NULL,
	[Nombre] [varchar](100) NULL,
	[Activo] [bit] NULL,
 CONSTRAINT [PK_RolTraductor] PRIMARY KEY CLUSTERED 
(
	[IdRolTraductor] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Seguridad].[TemporalUsuario]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Seguridad].[TemporalUsuario](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Codigo] [varchar](5) NULL,
	[DescVen] [nvarchar](max) NULL,
	[Nombre] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Seguridad].[Usuario]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Seguridad].[Usuario](
	[IdUsuario] [int] IDENTITY(1,1) NOT NULL,
	[Usuario] [varchar](100) NULL,
	[CodigoEmp] [varchar](100) NULL,
	[NombreApellido] [varchar](200) NULL,
	[IdEstado] [int] NULL,
	[IdUsuarioTipo] [int] NULL,
	[CodigoEmpresa] [varchar](100) NULL,
	[Sexo] [varchar](15) NULL,
	[EmailCoorporativo] [varchar](150) NULL,
	[Correo] [varchar](150) NULL,
	[Direccion] [varchar](150) NULL,
	[DNI] [varchar](8) NULL,
	[IdSociedad] [int] NULL,
	[SociedadDescripcionCorta] [varchar](100) NULL,
	[IdAreaBU] [int] NULL,
	[AreaBUDescripcionCorta] [varchar](100) NULL,
	[IdCargo] [int] NULL,
	[CargoDescripcionCorta] [varchar](100) NULL,
	[IdComite] [int] NULL,
	[ModoUsuaio] [int] NULL,
	[Contrasena] [varchar](30) NULL,
	[FechaCreacion_Clave] [datetime] NULL,
	[Bloqueo] [int] NULL,
	[FechaBloqueo] [datetime] NULL,
	[IdArea] [int] NULL,
	[IdAreas] [varchar](250) NULL,
	[CambiarPassword] [bit] NULL,
	[IdEmpresaRelacionada] [int] NULL,
	[CodigoVendedor] [varchar](6) NULL,
	[NombreAbreviado] [varchar](250) NULL,
 CONSTRAINT [PK_Usuario] PRIMARY KEY CLUSTERED 
(
	[IdUsuario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Seguridad].[Usuario_02062017]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Seguridad].[Usuario_02062017](
	[IdUsuario] [int] IDENTITY(1,1) NOT NULL,
	[Usuario] [varchar](100) NULL,
	[CodigoEmp] [varchar](100) NULL,
	[NombreApellido] [varchar](200) NULL,
	[IdEstado] [int] NULL,
	[IdUsuarioTipo] [int] NULL,
	[CodigoEmpresa] [varchar](100) NULL,
	[Sexo] [varchar](15) NULL,
	[EmailCoorporativo] [varchar](150) NULL,
	[Correo] [varchar](150) NULL,
	[Direccion] [varchar](150) NULL,
	[DNI] [varchar](8) NULL,
	[IdSociedad] [int] NULL,
	[SociedadDescripcionCorta] [varchar](100) NULL,
	[IdAreaBU] [int] NULL,
	[AreaBUDescripcionCorta] [varchar](100) NULL,
	[IdCargo] [int] NULL,
	[CargoDescripcionCorta] [varchar](100) NULL,
	[IdComite] [int] NULL,
	[ModoUsuaio] [int] NULL,
	[Contrasena] [varchar](30) NULL,
	[FechaCreacion_Clave] [datetime] NULL,
	[Bloqueo] [int] NULL,
	[FechaBloqueo] [datetime] NULL,
	[IdArea] [int] NULL,
	[IdAreas] [varchar](250) NULL,
	[CambiarPassword] [bit] NULL,
	[IdEmpresaRelacionada] [int] NULL,
	[CodigoVendedor] [varchar](6) NULL,
	[NombreAbreviado] [varchar](250) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Seguridad].[Usuario_20170717]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Seguridad].[Usuario_20170717](
	[IdUsuario] [int] IDENTITY(1,1) NOT NULL,
	[Usuario] [varchar](100) NULL,
	[CodigoEmp] [varchar](100) NULL,
	[NombreApellido] [varchar](200) NULL,
	[IdEstado] [int] NULL,
	[IdUsuarioTipo] [int] NULL,
	[CodigoEmpresa] [varchar](100) NULL,
	[Sexo] [varchar](15) NULL,
	[EmailCoorporativo] [varchar](150) NULL,
	[Correo] [varchar](150) NULL,
	[Direccion] [varchar](150) NULL,
	[DNI] [varchar](8) NULL,
	[IdSociedad] [int] NULL,
	[SociedadDescripcionCorta] [varchar](100) NULL,
	[IdAreaBU] [int] NULL,
	[AreaBUDescripcionCorta] [varchar](100) NULL,
	[IdCargo] [int] NULL,
	[CargoDescripcionCorta] [varchar](100) NULL,
	[IdComite] [int] NULL,
	[ModoUsuaio] [int] NULL,
	[Contrasena] [varchar](30) NULL,
	[FechaCreacion_Clave] [datetime] NULL,
	[Bloqueo] [int] NULL,
	[FechaBloqueo] [datetime] NULL,
	[IdArea] [int] NULL,
	[IdAreas] [varchar](250) NULL,
	[CambiarPassword] [bit] NULL,
	[IdEmpresaRelacionada] [int] NULL,
	[CodigoVendedor] [varchar](6) NULL,
	[NombreAbreviado] [varchar](250) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Seguridad].[Usuario_20170808]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Seguridad].[Usuario_20170808](
	[IdUsuario] [int] IDENTITY(1,1) NOT NULL,
	[Usuario] [varchar](100) NULL,
	[CodigoEmp] [varchar](100) NULL,
	[NombreApellido] [varchar](200) NULL,
	[IdEstado] [int] NULL,
	[IdUsuarioTipo] [int] NULL,
	[CodigoEmpresa] [varchar](100) NULL,
	[Sexo] [varchar](15) NULL,
	[EmailCoorporativo] [varchar](150) NULL,
	[Correo] [varchar](150) NULL,
	[Direccion] [varchar](150) NULL,
	[DNI] [varchar](8) NULL,
	[IdSociedad] [int] NULL,
	[SociedadDescripcionCorta] [varchar](100) NULL,
	[IdAreaBU] [int] NULL,
	[AreaBUDescripcionCorta] [varchar](100) NULL,
	[IdCargo] [int] NULL,
	[CargoDescripcionCorta] [varchar](100) NULL,
	[IdComite] [int] NULL,
	[ModoUsuaio] [int] NULL,
	[Contrasena] [varchar](30) NULL,
	[FechaCreacion_Clave] [datetime] NULL,
	[Bloqueo] [int] NULL,
	[FechaBloqueo] [datetime] NULL,
	[IdArea] [int] NULL,
	[IdAreas] [varchar](250) NULL,
	[CambiarPassword] [bit] NULL,
	[IdEmpresaRelacionada] [int] NULL,
	[CodigoVendedor] [varchar](6) NULL,
	[NombreAbreviado] [varchar](250) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Seguridad].[UsuarioAD]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Seguridad].[UsuarioAD](
	[sAMAccountName] [varchar](8000) NOT NULL,
	[accountExpires] [bigint] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [Seguridad].[UsuarioRol]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Seguridad].[UsuarioRol](
	[IdUsuario] [int] NOT NULL,
	[IdRol] [int] NOT NULL,
	[FechaHoraRegistroTupla] [datetime] NULL,
 CONSTRAINT [PK_UsuarioRol] PRIMARY KEY CLUSTERED 
(
	[IdUsuario] ASC,
	[IdRol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Seguridad].[UsuarioRol_BK05122016]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Seguridad].[UsuarioRol_BK05122016](
	[IdUsuario] [int] NOT NULL,
	[IdRol] [int] NOT NULL,
	[FechaHoraRegistroTupla] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Seguridad].[UsuarioRol_BK12012017]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Seguridad].[UsuarioRol_BK12012017](
	[IdUsuario] [int] NOT NULL,
	[IdRol] [int] NOT NULL,
	[FechaHoraRegistroTupla] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Seguridad].[UsuarioRol_BK12012017_1]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Seguridad].[UsuarioRol_BK12012017_1](
	[IdUsuario] [int] NOT NULL,
	[IdRol] [int] NOT NULL,
	[FechaHoraRegistroTupla] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Seguridad].[UsuarioRol_BK14012017]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Seguridad].[UsuarioRol_BK14012017](
	[IdUsuario] [int] NOT NULL,
	[IdRol] [int] NOT NULL,
	[FechaHoraRegistroTupla] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Seguridad].[UsuarioRol_BK17122016]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Seguridad].[UsuarioRol_BK17122016](
	[IdUsuario] [int] NOT NULL,
	[IdRol] [int] NOT NULL,
	[FechaHoraRegistroTupla] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[IdUsuario] ASC,
	[IdRol] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [Seguridad].[UsuarioRol_BK21112016]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Seguridad].[UsuarioRol_BK21112016](
	[IdUsuario] [int] NOT NULL,
	[IdRol] [int] NOT NULL,
	[FechaHoraRegistroTupla] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Seguridad].[UsuarioRol_BK23112016]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Seguridad].[UsuarioRol_BK23112016](
	[IdUsuario] [int] NOT NULL,
	[IdRol] [int] NOT NULL,
	[FechaHoraRegistroTupla] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Seguridad].[UsuarioRol_BK29112016]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Seguridad].[UsuarioRol_BK29112016](
	[IdUsuario] [int] NOT NULL,
	[IdRol] [int] NOT NULL,
	[FechaHoraRegistroTupla] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Seguridad].[UsuarioRol_BK30112016]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Seguridad].[UsuarioRol_BK30112016](
	[IdUsuario] [int] NOT NULL,
	[IdRol] [int] NOT NULL,
	[FechaHoraRegistroTupla] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [Seguridad].[UsuarioTemp]    Script Date: 11/08/2018 07:46:00 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [Seguridad].[UsuarioTemp](
	[IdUsuario] [int] NOT NULL,
	[Usuario] [varchar](100) NULL,
	[CodigoEmp] [varchar](100) NULL,
	[NombreApellido] [varchar](200) NULL,
	[IdEstado] [int] NULL,
	[IdUsuarioTipo] [int] NULL,
	[CodigoEmpresa] [varchar](100) NULL,
	[Sexo] [varchar](15) NULL,
	[EmailCoorporativo] [varchar](150) NULL,
	[Correo] [varchar](150) NULL,
	[Direccion] [varchar](150) NULL,
	[DNI] [varchar](8) NULL,
	[IdSociedad] [int] NULL,
	[SociedadDescripcionCorta] [varchar](100) NULL,
	[IdAreaBU] [int] NULL,
	[AreaBUDescripcionCorta] [varchar](100) NULL,
	[IdCargo] [int] NULL,
	[CargoDescripcionCorta] [varchar](100) NULL,
	[IdComite] [int] NULL,
	[ModoUsuaio] [int] NULL,
	[Contrasena] [varchar](30) NULL,
	[FechaCreacion_Clave] [datetime] NULL,
	[Bloqueo] [int] NULL,
	[FechaBloqueo] [datetime] NULL,
	[IdArea] [int] NULL,
	[IdAreas] [varchar](250) NULL,
	[CambiarPassword] [bit] NULL,
	[IdEmpresaRelacionada] [int] NULL,
	[CodigoVendedor] [varchar](6) NULL,
	[NombreAbreviado] [varchar](250) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [Estructura].[Area] ADD  DEFAULT ((1)) FOR [Estado]
GO
ALTER TABLE [Estructura].[Cargo] ADD  DEFAULT ((1)) FOR [Estado]
GO
ALTER TABLE [Seguridad].[Modulo] ADD  CONSTRAINT [DF_Modulo_Orden]  DEFAULT ((0)) FOR [Orden]
GO
ALTER TABLE [Seguridad].[ModuloAgrupacion] ADD  CONSTRAINT [DF_ModuloAgrupacion_Orden]  DEFAULT ((0)) FOR [Orden]
GO
ALTER TABLE [Seguridad].[Rol] ADD  CONSTRAINT [DF__Rol__SiSuperAdmi__1BC821DD]  DEFAULT ((0)) FOR [SiSuperAdmi]
GO
ALTER TABLE [Seguridad].[UsuarioRol] ADD  CONSTRAINT [DF_UsuarioRol]  DEFAULT (getdate()) FOR [FechaHoraRegistroTupla]
GO
ALTER TABLE [Estructura].[AreaS]  WITH CHECK ADD  CONSTRAINT [FK_Area_UnidadOrganica] FOREIGN KEY([ID_UNIDAD_ORGANICA])
REFERENCES [Estructura].[UnidadOrganica] ([ID_UNIDAD_ORGANICA])
GO
ALTER TABLE [Estructura].[AreaS] CHECK CONSTRAINT [FK_Area_UnidadOrganica]
GO
ALTER TABLE [Estructura].[Grupo]  WITH CHECK ADD  CONSTRAINT [FK_Grupo_Estado] FOREIGN KEY([IdEstado])
REFERENCES [Estructura].[Estado] ([IdEstado])
GO
ALTER TABLE [Estructura].[Grupo] CHECK CONSTRAINT [FK_Grupo_Estado]
GO
ALTER TABLE [Seguridad].[Accion]  WITH CHECK ADD  CONSTRAINT [FK_Accion_Estado] FOREIGN KEY([IdEstado])
REFERENCES [Estructura].[Estado] ([IdEstado])
GO
ALTER TABLE [Seguridad].[Accion] CHECK CONSTRAINT [FK_Accion_Estado]
GO
ALTER TABLE [Seguridad].[Accion]  WITH CHECK ADD  CONSTRAINT [FK_Accion_Grupo] FOREIGN KEY([IdGrupo])
REFERENCES [Estructura].[Grupo] ([IdGrupo])
GO
ALTER TABLE [Seguridad].[Accion] CHECK CONSTRAINT [FK_Accion_Grupo]
GO
ALTER TABLE [Seguridad].[Aplicacion]  WITH CHECK ADD  CONSTRAINT [FK_Aplicacion_Situacion] FOREIGN KEY([IdEstado])
REFERENCES [Estructura].[Estado] ([IdEstado])
GO
ALTER TABLE [Seguridad].[Aplicacion] CHECK CONSTRAINT [FK_Aplicacion_Situacion]
GO
ALTER TABLE [Seguridad].[AplicacionTraductor]  WITH CHECK ADD  CONSTRAINT [FK_AplicacionTraductor_Aplicacion] FOREIGN KEY([IdAplicacion])
REFERENCES [Seguridad].[Aplicacion] ([IdAplicacion])
GO
ALTER TABLE [Seguridad].[AplicacionTraductor] CHECK CONSTRAINT [FK_AplicacionTraductor_Aplicacion]
GO
ALTER TABLE [Seguridad].[AplicacionTraductor]  WITH CHECK ADD  CONSTRAINT [FK_AplicacionTraductor_Lenguaje] FOREIGN KEY([IdLenguaje])
REFERENCES [Estructura].[Lenguaje] ([IdLenguaje])
GO
ALTER TABLE [Seguridad].[AplicacionTraductor] CHECK CONSTRAINT [FK_AplicacionTraductor_Lenguaje]
GO
ALTER TABLE [Seguridad].[Auditoria_Transacional]  WITH CHECK ADD  CONSTRAINT [fk_AuditoriaTablaReferencia] FOREIGN KEY([IdTablaReferencia])
REFERENCES [Auditoria].[TablaReferencia] ([IdTablaReferencia])
GO
ALTER TABLE [Seguridad].[Auditoria_Transacional] CHECK CONSTRAINT [fk_AuditoriaTablaReferencia]
GO
ALTER TABLE [Seguridad].[Auditoria_Transacional]  WITH CHECK ADD  CONSTRAINT [fk_AuditoriaTipoAccion] FOREIGN KEY([IdTipoAccion])
REFERENCES [Auditoria].[TipoAccion] ([IdTipoAccion])
GO
ALTER TABLE [Seguridad].[Auditoria_Transacional] CHECK CONSTRAINT [fk_AuditoriaTipoAccion]
GO
ALTER TABLE [Seguridad].[Empresa]  WITH CHECK ADD  CONSTRAINT [FK_Empresa_Situacion] FOREIGN KEY([IdEstado])
REFERENCES [Estructura].[Estado] ([IdEstado])
GO
ALTER TABLE [Seguridad].[Empresa] CHECK CONSTRAINT [FK_Empresa_Situacion]
GO
ALTER TABLE [Seguridad].[EmpresaAplicacion]  WITH CHECK ADD  CONSTRAINT [FK_EmpresaAplicacion_Aplicacion] FOREIGN KEY([IdAplicacion])
REFERENCES [Seguridad].[Aplicacion] ([IdAplicacion])
GO
ALTER TABLE [Seguridad].[EmpresaAplicacion] CHECK CONSTRAINT [FK_EmpresaAplicacion_Aplicacion]
GO
ALTER TABLE [Seguridad].[EmpresaAplicacion]  WITH CHECK ADD  CONSTRAINT [FK_EmpresaAplicacion_Empresa] FOREIGN KEY([IdEmpresa])
REFERENCES [Seguridad].[Empresa] ([IdEmpresa])
GO
ALTER TABLE [Seguridad].[EmpresaAplicacion] CHECK CONSTRAINT [FK_EmpresaAplicacion_Empresa]
GO
ALTER TABLE [Seguridad].[Modulo]  WITH CHECK ADD FOREIGN KEY([IdAplicacion])
REFERENCES [Seguridad].[Aplicacion] ([IdAplicacion])
GO
ALTER TABLE [Seguridad].[Modulo]  WITH CHECK ADD FOREIGN KEY([IdAplicacion])
REFERENCES [Seguridad].[Aplicacion] ([IdAplicacion])
GO
ALTER TABLE [Seguridad].[Modulo]  WITH CHECK ADD  CONSTRAINT [FK_Modulo_Situacion] FOREIGN KEY([IdEstado])
REFERENCES [Estructura].[Estado] ([IdEstado])
GO
ALTER TABLE [Seguridad].[Modulo] CHECK CONSTRAINT [FK_Modulo_Situacion]
GO
ALTER TABLE [Seguridad].[ModuloTraductor]  WITH CHECK ADD  CONSTRAINT [FK_ModuloTraductor_Lenguaje] FOREIGN KEY([IdLenguaje])
REFERENCES [Estructura].[Lenguaje] ([IdLenguaje])
GO
ALTER TABLE [Seguridad].[ModuloTraductor] CHECK CONSTRAINT [FK_ModuloTraductor_Lenguaje]
GO
ALTER TABLE [Seguridad].[ModuloTraductor]  WITH CHECK ADD  CONSTRAINT [FK_ModuloTraductor_Modulo] FOREIGN KEY([IdModulo])
REFERENCES [Seguridad].[Modulo] ([IdModulo])
GO
ALTER TABLE [Seguridad].[ModuloTraductor] CHECK CONSTRAINT [FK_ModuloTraductor_Modulo]
GO
ALTER TABLE [Seguridad].[Operacion]  WITH CHECK ADD  CONSTRAINT [FK_Operacion_Estado] FOREIGN KEY([IdEstado])
REFERENCES [Estructura].[Estado] ([IdEstado])
GO
ALTER TABLE [Seguridad].[Operacion] CHECK CONSTRAINT [FK_Operacion_Estado]
GO
ALTER TABLE [Seguridad].[OperacionRol]  WITH CHECK ADD  CONSTRAINT [FK_OperacionRol_Operacion] FOREIGN KEY([IdOperacion])
REFERENCES [Seguridad].[Operacion] ([IdOperacion])
GO
ALTER TABLE [Seguridad].[OperacionRol] CHECK CONSTRAINT [FK_OperacionRol_Operacion]
GO
ALTER TABLE [Seguridad].[OperacionRol]  WITH CHECK ADD  CONSTRAINT [FK_OperacionRol_Rol] FOREIGN KEY([IdRol])
REFERENCES [Seguridad].[Rol] ([IdRol])
GO
ALTER TABLE [Seguridad].[OperacionRol] CHECK CONSTRAINT [FK_OperacionRol_Rol]
GO
ALTER TABLE [Seguridad].[Pagina]  WITH CHECK ADD  CONSTRAINT [FK_Pagina_Modulo] FOREIGN KEY([IdModulo])
REFERENCES [Seguridad].[Modulo] ([IdModulo])
GO
ALTER TABLE [Seguridad].[Pagina] CHECK CONSTRAINT [FK_Pagina_Modulo]
GO
ALTER TABLE [Seguridad].[Pagina]  WITH CHECK ADD  CONSTRAINT [FK_Pagina_Pagina] FOREIGN KEY([IdPaginaPadre])
REFERENCES [Seguridad].[Pagina] ([IdPagina])
GO
ALTER TABLE [Seguridad].[Pagina] CHECK CONSTRAINT [FK_Pagina_Pagina]
GO
ALTER TABLE [Seguridad].[Pagina]  WITH CHECK ADD  CONSTRAINT [FK_Pagina_Situacion] FOREIGN KEY([IdEstado])
REFERENCES [Estructura].[Estado] ([IdEstado])
GO
ALTER TABLE [Seguridad].[Pagina] CHECK CONSTRAINT [FK_Pagina_Situacion]
GO
ALTER TABLE [Seguridad].[PaginaAccion]  WITH CHECK ADD  CONSTRAINT [FK_PaginaAccion_Accion] FOREIGN KEY([IdAccion])
REFERENCES [Seguridad].[Accion] ([IdAccion])
GO
ALTER TABLE [Seguridad].[PaginaAccion] CHECK CONSTRAINT [FK_PaginaAccion_Accion]
GO
ALTER TABLE [Seguridad].[PaginaAccion]  WITH CHECK ADD  CONSTRAINT [FK_PaginaAccion_Pagina] FOREIGN KEY([IdPagina])
REFERENCES [Seguridad].[Pagina] ([IdPagina])
GO
ALTER TABLE [Seguridad].[PaginaAccion] CHECK CONSTRAINT [FK_PaginaAccion_Pagina]
GO
ALTER TABLE [Seguridad].[PaginaGrupo]  WITH CHECK ADD  CONSTRAINT [FK_PaginaGrupo_Grupo] FOREIGN KEY([IdGrupo])
REFERENCES [Estructura].[Grupo] ([IdGrupo])
GO
ALTER TABLE [Seguridad].[PaginaGrupo] CHECK CONSTRAINT [FK_PaginaGrupo_Grupo]
GO
ALTER TABLE [Seguridad].[PaginaGrupo]  WITH CHECK ADD  CONSTRAINT [FK_PaginaGrupo_Pagina] FOREIGN KEY([IdPagina])
REFERENCES [Seguridad].[Pagina] ([IdPagina])
GO
ALTER TABLE [Seguridad].[PaginaGrupo] CHECK CONSTRAINT [FK_PaginaGrupo_Pagina]
GO
ALTER TABLE [Seguridad].[PaginaTraductor]  WITH CHECK ADD  CONSTRAINT [FK_PaginaTraductor_Lenguaje] FOREIGN KEY([IdLenguaje])
REFERENCES [Estructura].[Lenguaje] ([IdLenguaje])
GO
ALTER TABLE [Seguridad].[PaginaTraductor] CHECK CONSTRAINT [FK_PaginaTraductor_Lenguaje]
GO
ALTER TABLE [Seguridad].[PaginaTraductor]  WITH CHECK ADD  CONSTRAINT [FK_PaginaTraductor_Pagina] FOREIGN KEY([IdPagina])
REFERENCES [Seguridad].[Pagina] ([IdPagina])
GO
ALTER TABLE [Seguridad].[PaginaTraductor] CHECK CONSTRAINT [FK_PaginaTraductor_Pagina]
GO
ALTER TABLE [Seguridad].[Rol]  WITH CHECK ADD  CONSTRAINT [FK_Rol_Estado] FOREIGN KEY([IdEstado])
REFERENCES [Estructura].[Estado] ([IdEstado])
GO
ALTER TABLE [Seguridad].[Rol] CHECK CONSTRAINT [FK_Rol_Estado]
GO
ALTER TABLE [Seguridad].[RolTraductor]  WITH CHECK ADD  CONSTRAINT [FK_RolTraductor_Lenguaje] FOREIGN KEY([IdLenguaje])
REFERENCES [Estructura].[Lenguaje] ([IdLenguaje])
GO
ALTER TABLE [Seguridad].[RolTraductor] CHECK CONSTRAINT [FK_RolTraductor_Lenguaje]
GO
ALTER TABLE [Seguridad].[RolTraductor]  WITH CHECK ADD  CONSTRAINT [FK_RolTraductor_Rol] FOREIGN KEY([IdRol])
REFERENCES [Seguridad].[Rol] ([IdRol])
GO
ALTER TABLE [Seguridad].[RolTraductor] CHECK CONSTRAINT [FK_RolTraductor_Rol]
GO
ALTER TABLE [Seguridad].[UsuarioRol]  WITH CHECK ADD  CONSTRAINT [FK__UsuarioRo__IdRol__318258D2] FOREIGN KEY([IdRol])
REFERENCES [Seguridad].[Rol] ([IdRol])
GO
ALTER TABLE [Seguridad].[UsuarioRol] CHECK CONSTRAINT [FK__UsuarioRo__IdRol__318258D2]
GO
ALTER TABLE [Seguridad].[UsuarioRol]  WITH CHECK ADD  CONSTRAINT [FK__UsuarioRo__IdRol__3F115E1A] FOREIGN KEY([IdRol])
REFERENCES [Seguridad].[Rol] ([IdRol])
GO
ALTER TABLE [Seguridad].[UsuarioRol] CHECK CONSTRAINT [FK__UsuarioRo__IdRol__3F115E1A]
GO
