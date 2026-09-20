-- Generado por Oracle SQL Developer Data Modeler 24.3.1.351.0831 (Optimizado Manualmente)
-- Proyecto: Sistema MYPE Inventario Políglota - Módulo Financiero (Perú)
-- Sitio: Oracle Database 21c

----------------------------------------------------------------────────
-- 1. TABLA: CAJA DIARIA (AISLADA FÍSICAMENTE PARA ENFOQUE DISTRIBUIDO)
----------------------------------------------------------------────────
CREATE TABLE caja_diaria (
    id_caja              INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL, 
    id_sucursal          INTEGER NOT NULL, -- Vínculo lógico con PostgreSQL
    id_comerciante       INTEGER NOT NULL, -- Vínculo lógico con PostgreSQL
    fecha_apertura       TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Automático: Fecha y hora exacta del turno
    monto_apertura       NUMBER(10,2) NOT NULL, 
    fecha_cierre         TIMESTAMP NULL,                               -- Manual: Se actualiza en el backend al cerrar la caja
    monto_cierre_real    NUMBER(10,2) DEFAULT 0.00 NOT NULL, 
    monto_cierre_sistema NUMBER(10,2) DEFAULT 0.00 NOT NULL, 
    estado_caja          VARCHAR2(15 CHAR) DEFAULT 'ABIERTA' NOT NULL,
    CONSTRAINT chk_estado_caja CHECK (estado_caja IN ('ABIERTA', 'CERRADA'))
);

ALTER TABLE caja_diaria ADD CONSTRAINT caja_diaria_PK PRIMARY KEY ( id_caja );


----------------------------------------------------------------────────
-- 2. TABLA: PROVEEDOR
----------------------------------------------------------------────────
CREATE TABLE proveedor (
    id_proveedor  INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL, 
    ruc_proveedor VARCHAR2(11 CHAR) NOT NULL, 
    razon_social  VARCHAR2(150 CHAR) NOT NULL, 
    nombre        VARCHAR2(100 CHAR) NOT NULL, 
    telefono      VARCHAR2(20 CHAR) NOT NULL, 
    correo        VARCHAR2(100 CHAR) NOT NULL
);

ALTER TABLE proveedor ADD CONSTRAINT proveedor_PK PRIMARY KEY ( id_proveedor );
ALTER TABLE proveedor ADD CONSTRAINT proveedor_ruc_proveedor_UN UNIQUE ( ruc_proveedor );
ALTER TABLE proveedor ADD CONSTRAINT proveedor_razon_social_UN UNIQUE ( razon_social );
ALTER TABLE proveedor ADD CONSTRAINT proveedor_correo_UN UNIQUE ( correo );


----------------------------------------------------------------────────
-- 3. TABLA: ORDEN COMPRA
----------------------------------------------------------------────────
CREATE TABLE orden_compra (
    id_orden               INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL, 
    id_sucursal_destino    INTEGER NOT NULL, -- Vínculo lógico con PostgreSQL
    fecha_emision          DATE DEFAULT TRUNC(SYSDATE) NOT NULL, -- Automático: Fecha del servidor sin horas/minutos
    fecha_recepcion        DATE NULL,                            -- Manual: Se llena solo al recibir físicamente la mercancía
    estado_orden           VARCHAR2(20 CHAR) DEFAULT 'SOLICITADO' NOT NULL, 
    total_compra           NUMBER(10,2) NOT NULL, 
    proveedor_id_proveedor INTEGER NOT NULL,
    CONSTRAINT chk_estado_orden CHECK (estado_orden IN ('SOLICITADO', 'RECIBIDO', 'CANCELADO'))
);

ALTER TABLE orden_compra ADD CONSTRAINT orden_compra_PK PRIMARY KEY ( id_orden );


----------------------------------------------------------------────────
-- 4. TABLA: DETALLE ORDEN COMPRA
----------------------------------------------------------------────────
CREATE TABLE detalle_orden_compra (
    id_detalle_orden      INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL, 
    id_variante_sku       VARCHAR2(50 CHAR) NOT NULL, -- Vínculo lógico con catálogo flexible de MongoDB
    cantidad_solicitada   NUMBER(8,2) NOT NULL, 
    cantidad_recibida     NUMBER(8,2) DEFAULT 0.00 NOT NULL, 
    costo_unitario        NUMBER(10,2) NOT NULL, 
    orden_compra_id_orden INTEGER NOT NULL
);

ALTER TABLE detalle_orden_compra ADD CONSTRAINT detalle_orden_compra_PK PRIMARY KEY ( id_detalle_orden );


----------------------------------------------------------------────────
-- 5. TABLA: VENTA
----------------------------------------------------------------────────
CREATE TABLE venta (
    id_venta       INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL, 
    fecha_venta    TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Automático: Instante exacto de la emisión de la venta
    total_neto     NUMBER(10,2) NOT NULL, 
    total_impuesto NUMBER(10,2) NOT NULL, 
    total_bruto    NUMBER(10,2) NOT NULL, 
    metodo_pago    VARCHAR2(40 CHAR) NOT NULL,
    CONSTRAINT chk_metodo_pago CHECK (metodo_pago IN ('EFECTIVO', 'YAPE', 'PLIN', 'TARJETA'))
);

ALTER TABLE venta ADD CONSTRAINT venta_PK PRIMARY KEY ( id_venta );


----------------------------------------------------------------────────
-- 6. TABLA: DETALLE VENTA
----------------------------------------------------------------────────
CREATE TABLE detalle_venta (
    id_detalle_venta INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL, 
    id_variante_sku  VARCHAR2(50 CHAR) NOT NULL, -- Vínculo lógico con catálogo flexible de MongoDB
    cantidad         NUMBER(10,2) NOT NULL, 
    precio_unitario  NUMBER(10,2) NOT NULL, 
    descuento        NUMBER(10,2) DEFAULT 0.00 NOT NULL, 
    subtotal         NUMBER(10,2) NOT NULL, 
    venta_id_venta   INTEGER NOT NULL
);

ALTER TABLE detalle_venta ADD CONSTRAINT detalle_venta_PK PRIMARY KEY ( id_detalle_venta );


----------------------------------------------------------------────────
-- 7. TABLA: COMPROBANTE PAGO (RELACIÓN 1:1 CON VENTA)
----------------------------------------------------------------────────
CREATE TABLE comprobante_pago (
    id_comprobante     INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL, 
    tipo_comprobante   VARCHAR2(2 CHAR) NOT NULL, -- Ajustado a estándar SUNAT ('01' = Factura, '03' = Boleta)
    serie              VARCHAR2(4 CHAR) NOT NULL, 
    numero_correlativo INTEGER NOT NULL, 
    estado_sunat       VARCHAR2(30 CHAR) DEFAULT 'PENDIENTE' NOT NULL, 
    codigo_sunat       VARCHAR2(100 CHAR) NULL, -- Manual/Asíncrono: Se llena al recibir el CDR de SUNAT
    venta_id_venta     INTEGER NOT NULL,
    CONSTRAINT chk_tipo_comprobante CHECK (tipo_comprobante IN ('01', '03'))
);

ALTER TABLE comprobante_pago ADD CONSTRAINT comprobante_pago_PK PRIMARY KEY ( id_comprobante );

-- ADAPTACIÓN DEL DIAGRAMA: Unicidad Compuesta de Serie + Número Correlativo para SUNAT
ALTER TABLE comprobante_pago ADD CONSTRAINT comprobante_pago_serie_correlativo_UN UNIQUE ( serie, numero_correlativo );


----------------------------------------------------------------────────
-- RESTRICCIONES DE LLAVES FORÁNEAS (FOREIGN KEYS)
----------------------------------------------------------------────────

-- Relación: Venta -> Comprobante de Pago (1:1)
ALTER TABLE comprobante_pago 
    ADD CONSTRAINT comprobante_pago_venta_FK FOREIGN KEY ( venta_id_venta ) 
    REFERENCES venta ( id_venta );

-- Relación: Venta -> Detalle Venta (1:N en Cascada)
ALTER TABLE detalle_venta 
    ADD CONSTRAINT detalle_venta_venta_FK FOREIGN KEY ( venta_id_venta ) 
    REFERENCES venta ( id_venta ) 
    ON DELETE CASCADE;

-- Relación: Proveedor -> Orden Compra (1:N)
ALTER TABLE orden_compra 
    ADD CONSTRAINT orden_compra_proveedor_FK FOREIGN KEY ( proveedor_id_proveedor ) 
    REFERENCES proveedor ( id_proveedor );

-- Relación: Orden Compra -> Detalle Orden Compra (1:N en Cascada)
ALTER TABLE detalle_orden_compra 
    ADD CONSTRAINT dtl_ord_compra_ord_cmpra_FK FOREIGN KEY ( orden_compra_id_orden ) 
    REFERENCES orden_compra ( id_orden ) 
    ON DELETE CASCADE;
