/****** SCRIPT DE ACTUALIZACION BD XSITE 20190623 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[VW_EventoAccesoPair]
AS
WITH SET_A AS (SELECT        EA.IdEvento, EA.IdTipoActivoXIndicador, EA.IdActivo, EA.IdCategoriaActivo, EA.IdEstado, EA.IdReglaEvento, EA.IdUsuario, EA.FechaHoraEvento, EA.FechaHoraBitacora, 
                                                              EA.FechaHoraModificacion, EA.FechaHoraLocalEvento, EA.IdLLave, EA.IdTipoAcceso, EA.IdPersonal, EA.IdPuerta, EA.FechaHoraNormalizacion, EA.FechaHoraLocalNormalizacion, 
                                                              E.IdActivoPadre
                                     FROM            dbo.EventoAcceso AS EA INNER JOIN
                                                              dbo.Equipo AS E ON EA.IdActivo = E.IdEquipo
                                     WHERE        (EA.IdTipoAcceso = 1) AND (E.IdCategoriaActivoPadre = 2)), SET_B AS
    (SELECT        EA.IdEvento, EA.IdTipoActivoXIndicador, EA.IdActivo, EA.IdCategoriaActivo, EA.IdEstado, EA.IdReglaEvento, EA.IdUsuario, EA.FechaHoraEvento, EA.FechaHoraBitacora, EA.FechaHoraModificacion, 
                                EA.FechaHoraLocalEvento, EA.IdLLave, EA.IdTipoAcceso, EA.IdPersonal, EA.IdPuerta, EA.FechaHoraNormalizacion, EA.FechaHoraLocalNormalizacion, E.IdActivoPadre
      FROM            dbo.EventoAcceso AS EA INNER JOIN
                                dbo.Equipo AS E ON EA.IdActivo = E.IdEquipo
      WHERE        (EA.IdTipoAcceso = 0) AND (E.IdCategoriaActivoPadre = 2))
    SELECT        A.IdPersonal, A.IdEvento AS IdEventoEntrada, A.FechaHoraEvento AS FechaHoraEventoEntrada, A.FechaHoraLocalEvento AS FechaHoraLocalEntrada, B.IdEvento AS IdEventoSalida, 
                              B.FechaHoraEvento AS FechaHoraEventoSalida, B.FechaHoraLocalEvento AS FechaHoraLocalSalida, A.IdActivo, P.Nombres, P.Apellidos, C.Descripcion AS Cargo, A.IdActivoPadre AS IdUbicacion
     FROM            SET_A AS A LEFT OUTER JOIN
                              SET_B AS B ON CAST(A.FechaHoraLocalEvento AS DATE) = CAST(B.FechaHoraLocalEvento AS DATE) AND A.IdPersonal = B.IdPersonal AND a.IdActivo = b.IdActivo INNER JOIN
                              dbo.Personal AS P ON P.IdPersonal = A.IdPersonal INNER JOIN
                              dbo.DatoAdicional AS DA ON DA.IdActivo = P.IdPersonal INNER JOIN
                              dbo.TipoDatoAdicional AS TDA ON DA.IdTipoDatoAdicional = TDA.IdTipoDatoAdicional INNER JOIN
                              dbo.Cargo AS C ON P.IdCargo = C.IdCargo
     WHERE        (TDA.Descripcion = 'EsPersonalInterno') AND (DA.Valor = '1')


GO
DROP TRIGGER [dbo].[FechaUltimaActualizacionDatoAdicional]
GO
DROP TRIGGER [dbo].[OnInsertUpdateDatoAdicional]
GO




