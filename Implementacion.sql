-- Generado por Oracle SQL Developer Data Modeler 24.3.1.351.0831
--   en:        2026-09-20 11:47:44 PET
--   sitio:      Oracle Database 21c
--   tipo:      Oracle Database 21c



-- predefined type, no DDL - MDSYS.SDO_GEOMETRY

-- predefined type, no DDL - XMLTYPE

CREATE TABLE caja_diaria 
    ( 
     id_caja              INTEGER  NOT NULL , 
     id_sucursal          INTEGER  NOT NULL , 
     id_comerciante       INTEGER  NOT NULL , 
     fecha_apertura       TIMESTAMP  NOT NULL , 
     monto_apertura       NUMBER (10,2)  NOT NULL , 
     fecha_cierre         TIMESTAMP  NOT NULL , 
     monto_cierre_real    NUMBER (10,2)  NOT NULL , 
     monto_cierre_sistema NUMBER (10,2)  NOT NULL , 
     estado_caja          VARCHAR2 (15 CHAR)  NOT NULL 
    ) 
;

ALTER TABLE caja_diaria 
    ADD CONSTRAINT caja_diaria_PK PRIMARY KEY ( id_caja ) ;

CREATE TABLE comprobante_pago 
    ( 
     id_comprobante     INTEGER  NOT NULL , 
     tipo_comprobante   VARCHAR2 (20 CHAR)  NOT NULL , 
     serie              VARCHAR2 (4 CHAR)  NOT NULL , 
     numero_correlativo INTEGER  NOT NULL , 
     estado_sunat       VARCHAR2 (30 CHAR)  NOT NULL , 
     codigo_sunat       VARCHAR2 (100 CHAR)  NOT NULL , 
     venta_id_venta     INTEGER  NOT NULL 
    ) 
;

ALTER TABLE comprobante_pago 
    ADD CONSTRAINT comprobante_pago_PK PRIMARY KEY ( id_comprobante ) ;

ALTER TABLE comprobante_pago 
    ADD CONSTRAINT comprobante_pago_serie_UN UNIQUE ( serie ) ;


 
ALTER TABLE comprobante_pago 
    ADD CONSTRAINT cmprob_pgo_num_correlativo_UN UNIQUE ( numero_correlativo ) ;

CREATE TABLE detalle_orden_compra 
    ( 
     id_detalle_orden      INTEGER  NOT NULL , 
     id_variante_sku       VARCHAR2 (50 CHAR)  NOT NULL , 
     cantidad_solicitada   NUMBER (8,2)  NOT NULL , 
     cantidad_recibida     NUMBER (8,2)  NOT NULL , 
     costo_unitario        NUMBER (10,2)  NOT NULL , 
     orden_compra_id_orden INTEGER  NOT NULL 
    ) 
;

ALTER TABLE detalle_orden_compra 
    ADD CONSTRAINT detalle_orden_compra_PK PRIMARY KEY ( id_detalle_orden ) ;

CREATE TABLE detalle_venta 
    ( 
     id_detalle_venta INTEGER  NOT NULL , 
     id_variante_sku  VARCHAR2 (50 CHAR)  NOT NULL , 
     cantidad         NUMBER (10,2)  NOT NULL , 
     precio_unitario  NUMBER (10,2)  NOT NULL , 
     descuento        NUMBER (10,2)  NOT NULL , 
     subtotal         NUMBER (10,2)  NOT NULL , 
     venta_id_venta   INTEGER  NOT NULL 
    ) 
;

ALTER TABLE detalle_venta 
    ADD CONSTRAINT detalle_venta_PK PRIMARY KEY ( id_detalle_venta ) ;

CREATE TABLE orden_compra 
    ( 
     id_orden               INTEGER  NOT NULL , 
     id_sucursal_destino    INTEGER  NOT NULL , 
     fecha_emision          DATE  NOT NULL , 
     fecha_recepcion        DATE  NOT NULL , 
     estado_orden           VARCHAR2 (20 CHAR)  NOT NULL , 
     total_compra           NUMBER (10,2)  NOT NULL , 
     proveedor_id_proveedor INTEGER  NOT NULL 
    ) 
;

ALTER TABLE orden_compra 
    ADD CONSTRAINT orden_compra_PK PRIMARY KEY ( id_orden ) ;

CREATE TABLE proveedor 
    ( 
     id_proveedor  INTEGER  NOT NULL , 
     ruc_proveedor VARCHAR2 (11 CHAR)  NOT NULL , 
     razon_social  VARCHAR2 (150 CHAR)  NOT NULL , 
     nombre        VARCHAR2 (100 CHAR)  NOT NULL , 
     telefono      VARCHAR2 (20 CHAR)  NOT NULL , 
     correo        VARCHAR2 (100 CHAR)  NOT NULL 
    ) 
;

ALTER TABLE proveedor 
    ADD CONSTRAINT proveedor_PK PRIMARY KEY ( id_proveedor ) ;

ALTER TABLE proveedor 
    ADD CONSTRAINT proveedor_ruc_proveedor_UN UNIQUE ( ruc_proveedor ) ;

ALTER TABLE proveedor 
    ADD CONSTRAINT proveedor_razon_social_UN UNIQUE ( razon_social ) ;

ALTER TABLE proveedor 
    ADD CONSTRAINT proveedor_correo_UN UNIQUE ( correo ) ;

CREATE TABLE venta 
    ( 
     id_venta       INTEGER  NOT NULL , 
     fecha_venta    TIMESTAMP  NOT NULL , 
     total_neto     NUMBER (10,2)  NOT NULL , 
     total_impuesto NUMBER (10,2)  NOT NULL , 
     total_bruto    NUMBER (10,2)  NOT NULL , 
     metodo_pago    VARCHAR2 (40 CHAR)  NOT NULL 
    ) 
;

ALTER TABLE venta 
    ADD CONSTRAINT venta_PK PRIMARY KEY ( id_venta ) ;

ALTER TABLE comprobante_pago 
    ADD CONSTRAINT comprobante_pago_venta_FK FOREIGN KEY 
    ( 
     venta_id_venta
    ) 
    REFERENCES venta 
    ( 
     id_venta
    ) 
;


ALTER TABLE detalle_orden_compra 
    ADD CONSTRAINT dtl_ord_compra_ord_cmpra_FK FOREIGN KEY 
    ( 
     orden_compra_id_orden
    ) 
    REFERENCES orden_compra 
    ( 
     id_orden
    ) 
    ON DELETE CASCADE 
;

ALTER TABLE detalle_venta 
    ADD CONSTRAINT detalle_venta_venta_FK FOREIGN KEY 
    ( 
     venta_id_venta
    ) 
    REFERENCES venta 
    ( 
     id_venta
    ) 
    ON DELETE CASCADE 
;

ALTER TABLE orden_compra 
    ADD CONSTRAINT orden_compra_proveedor_FK FOREIGN KEY 
    ( 
     proveedor_id_proveedor
    ) 
    REFERENCES proveedor 
    ( 
     id_proveedor
    ) 
;



-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             7
-- CREATE INDEX                             0
-- ALTER TABLE                             16
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- WARNINGS                                 0
