CREATE TABLE caja_diaria (
    id_caja              INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL, 
    id_sucursal          INTEGER NOT NULL, 
    id_empleado       INTEGER NOT NULL, 
    fecha_apertura       TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,  
    monto_apertura       NUMBER(10,2) NOT NULL, 
    fecha_cierre         TIMESTAMP NULL,                               
    monto_cierre_real    NUMBER(10,2) DEFAULT 0.00 NOT NULL, 
    monto_cierre_sistema NUMBER(10,2) DEFAULT 0.00 NOT NULL, 
    estado_caja          VARCHAR2(15 CHAR) DEFAULT 'ABIERTA' NOT NULL,
    CONSTRAINT chk_estado_caja CHECK (estado_caja IN ('ABIERTA', 'CERRADA'))
);

ALTER TABLE caja_diaria ADD CONSTRAINT caja_diaria_PK PRIMARY KEY ( id_caja );


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



CREATE TABLE orden_compra (
    id_orden               INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL, 
    id_sucursal_destino    INTEGER NOT NULL,
    fecha_emision          DATE DEFAULT TRUNC(SYSDATE) NOT NULL, 
    fecha_recepcion        DATE NULL,                            
    estado_orden           VARCHAR2(20 CHAR) DEFAULT 'SOLICITADO' NOT NULL, 
    total_compra           NUMBER(10,2) NOT NULL, 
    proveedor_id_proveedor INTEGER NOT NULL,
    CONSTRAINT chk_estado_orden CHECK (estado_orden IN ('SOLICITADO', 'RECIBIDO', 'CANCELADO'))
);

ALTER TABLE orden_compra ADD CONSTRAINT orden_compra_PK PRIMARY KEY ( id_orden );



CREATE TABLE detalle_orden_compra (
    id_detalle_orden      INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL, 
    id_variante_sku       VARCHAR2(50 CHAR) NOT NULL,
    cantidad_solicitada   NUMBER(8,2) NOT NULL, 
    cantidad_recibida     NUMBER(8,2) DEFAULT 0.00 NOT NULL, 
    costo_unitario        NUMBER(10,2) NOT NULL, 
    orden_compra_id_orden INTEGER NOT NULL
);

ALTER TABLE detalle_orden_compra ADD CONSTRAINT detalle_orden_compra_PK PRIMARY KEY ( id_detalle_orden );



CREATE TABLE venta (
    id_venta       INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL, 
    fecha_venta    TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, 
    total_neto     NUMBER(10,2) NOT NULL, 
    total_impuesto NUMBER(10,2) NOT NULL, 
    total_bruto    NUMBER(10,2) NOT NULL, 
    metodo_pago    VARCHAR2(40 CHAR) NOT NULL,
    CONSTRAINT chk_metodo_pago CHECK (metodo_pago IN ('EFECTIVO', 'YAPE', 'PLIN', 'TARJETA'))
);

ALTER TABLE venta ADD CONSTRAINT venta_PK PRIMARY KEY ( id_venta );


CREATE TABLE detalle_venta (
    id_detalle_venta INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL, 
    id_variante_sku  VARCHAR2(50 CHAR) NOT NULL, 
    cantidad         NUMBER(10,2) NOT NULL, 
    precio_unitario  NUMBER(10,2) NOT NULL, 
    descuento        NUMBER(10,2) DEFAULT 0.00 NOT NULL, 
    subtotal         NUMBER(10,2) NOT NULL, 
    venta_id_venta   INTEGER NOT NULL
);

ALTER TABLE detalle_venta ADD CONSTRAINT detalle_venta_PK PRIMARY KEY ( id_detalle_venta );


CREATE TABLE comprobante_pago (
    id_comprobante     INTEGER GENERATED ALWAYS AS IDENTITY NOT NULL, 
    tipo_comprobante   VARCHAR2(2 CHAR) NOT NULL, 
    serie              VARCHAR2(4 CHAR) NOT NULL, 
    numero_correlativo INTEGER NOT NULL, 
    estado_sunat       VARCHAR2(30 CHAR) DEFAULT 'PENDIENTE' NOT NULL, 
    codigo_sunat       VARCHAR2(100 CHAR) NULL,
    venta_id_venta     INTEGER NOT NULL,
    CONSTRAINT chk_tipo_comprobante CHECK (tipo_comprobante IN ('01', '03'))
);

ALTER TABLE comprobante_pago ADD CONSTRAINT comprobante_pago_PK PRIMARY KEY ( id_comprobante );
ALTER TABLE comprobante_pago ADD CONSTRAINT comprobante_pago_serie_correlativo_UN UNIQUE ( serie, numero_correlativo );

ALTER TABLE comprobante_pago 
    ADD CONSTRAINT comprobante_pago_venta_FK FOREIGN KEY ( venta_id_venta ) 
    REFERENCES venta ( id_venta );

ALTER TABLE detalle_venta 
    ADD CONSTRAINT detalle_venta_venta_FK FOREIGN KEY ( venta_id_venta ) 
    REFERENCES venta ( id_venta ) 
    ON DELETE CASCADE;

ALTER TABLE orden_compra 
    ADD CONSTRAINT orden_compra_proveedor_FK FOREIGN KEY ( proveedor_id_proveedor ) 
    REFERENCES proveedor ( id_proveedor );

ALTER TABLE detalle_orden_compra 
    ADD CONSTRAINT dtl_ord_compra_ord_cmpra_FK FOREIGN KEY ( orden_compra_id_orden ) 
    REFERENCES orden_compra ( id_orden ) 
    ON DELETE CASCADE;
