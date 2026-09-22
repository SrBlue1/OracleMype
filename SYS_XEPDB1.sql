CREATE ROLE rol_seguridad_mype;
GRANT SELECT, INSERT, UPDATE ON mype_financiero.caja_diaria TO rol_seguridad_mype;

CREATE USER llanos IDENTIFIED BY "L123";
GRANT CONNECT TO llanos;
GRANT CREATE PROCEDURE TO llanos; 
GRANT CREATE ANY INDEX TO llanos; 

GRANT rol_seguridad_mype TO llanos;



CREATE ROLE rol_ventas_mype;
GRANT SELECT, INSERT, UPDATE ON mype_financiero.venta TO rol_ventas_mype;
GRANT SELECT, INSERT, UPDATE ON mype_financiero.detalle_venta TO rol_ventas_mype;
GRANT SELECT, INSERT, UPDATE ON mype_financiero.comprobante_pago TO rol_ventas_mype;

CREATE USER romero IDENTIFIED BY "R456";
GRANT CONNECT TO romero;
GRANT CREATE PROCEDURE TO romero;
GRANT CREATE ANY INDEX TO romero;

GRANT rol_ventas_mype TO romero;



CREATE ROLE rol_logistica_mype;
GRANT SELECT, INSERT, UPDATE ON mype_financiero.proveedor TO rol_logistica_mype;
GRANT SELECT, INSERT, UPDATE ON mype_financiero.orden_compra TO rol_logistica_mype;
GRANT SELECT, INSERT, UPDATE ON mype_financiero.detalle_orden_compra TO rol_logistica_mype;

CREATE USER mescua IDENTIFIED BY "M789";
GRANT CONNECT TO mescua;
GRANT CREATE PROCEDURE TO mescua;
GRANT CREATE ANY INDEX TO mescua;

GRANT rol_logistica_mype TO mescua;



CREATE ROLE rol_analista_mype;
GRANT SELECT ON mype_financiero.caja_diaria TO rol_analista_mype;
GRANT SELECT ON mype_financiero.venta TO rol_analista_mype;
GRANT SELECT ON mype_financiero.detalle_venta TO rol_analista_mype;
GRANT SELECT ON mype_financiero.comprobante_pago TO rol_analista_mype;

CREATE USER zorrilla IDENTIFIED BY "Z012";
GRANT CONNECT TO zorrilla;
GRANT CREATE PROCEDURE TO zorrilla;
GRANT CREATE ANY INDEX TO zorrilla;

GRANT rol_analista_mype TO zorrilla;