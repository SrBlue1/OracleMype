
INSERT INTO proveedor (ruc_proveedor, razon_social, nombre, telefono, correo)
VALUES ('20789456123', 'Distribuidora Textil Gamarra S.A.C.', 'Almacén Central', '999888777', 'ventas@gamarramayorista.com');


INSERT INTO orden_compra (id_sucursal_destino, total_compra, proveedor_id_proveedor)
VALUES (5, 900.00, 1);


INSERT INTO detalle_orden_compra (id_variante_sku, cantidad_solicitada, cantidad_recibida, costo_unitario, orden_compra_id_orden)
VALUES ('TEXTIL-POLO-M-AZUL', 30.00, 30.00, 15.00, 1);

INSERT INTO detalle_orden_compra (id_variante_sku, cantidad_solicitada, cantidad_recibida, costo_unitario, orden_compra_id_orden)
VALUES ('TEXTIL-CASACA-L-NEGRO', 15.00, 15.00, 30.00, 1);


INSERT INTO caja_diaria (id_sucursal, id_comerciante, monto_apertura, monto_cierre_sistema, monto_cierre_real, estado_caja, fecha_cierre)
VALUES (5, 3, 100.00, 350.00, 350.00, 'CERRADA', CURRENT_TIMESTAMP);


INSERT INTO venta (total_neto, total_impuesto, total_bruto, metodo_pago)
VALUES (211.86, 38.14, 250.00, 'YAPE');


INSERT INTO comprobante_pago (tipo_comprobante, serie, numero_correlativo, estado_sunat, codigo_sunat, venta_id_venta)
VALUES ('03', 'B001', 1, 'ACEPTADO', 'Respuesta_SUNAT_CDR_OK_98432', 1);


INSERT INTO detalle_venta (id_variante_sku, cantidad, precio_unitario, descuento, subtotal, venta_id_venta)
VALUES ('TEXTIL-POLO-M-AZUL', 2.00, 35.00, 0.00, 70.00, 1);

INSERT INTO detalle_venta (id_variante_sku, cantidad, precio_unitario, descuento, subtotal, venta_id_venta)
VALUES ('TEXTIL-CASACA-L-NEGRO', 3.00, 60.00, 0.00, 180.00, 1);

COMMIT;


SELECT 
    p.razon_social AS "Proveedor",
    oc.id_orden AS "Nro Orden",
    oc.fecha_emision AS "Fecha Emisión",
    oc.id_sucursal_destino AS "ID Sucursal (Postgres)",
    doc.id_variante_sku AS "SKU Producto (MongoDB)",
    doc.cantidad_solicitada AS "Cantidad",
    doc.costo_unitario AS "Costo Unitario (S/)"
FROM orden_compra oc
JOIN proveedor p ON oc.proveedor_id_proveedor = p.id_proveedor -- Nota: verifica si en tu script es 'id_proveedor' o 'proveedor_id_proveedor' en el JOIN
JOIN detalle_orden_compra doc ON doc.orden_compra_id_orden = oc.id_orden;
