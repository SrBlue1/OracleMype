CREATE OR REPLACE PROCEDURE mype_financiero.sp_registrar_venta_romero (
    p_total_bruto IN mype_financiero.venta.total_bruto%TYPE,
    p_metodo_pago IN mype_financiero.venta.metodo_pago%TYPE,
    o_id_venta    OUT INTEGER
) IS
    v_neto     NUMBER(10,2);
    v_impuesto NUMBER(10,2);
BEGIN
    v_neto     := p_total_bruto / 1.18;
    v_impuesto := p_total_bruto - v_neto;

    INSERT INTO mype_financiero.venta (
        total_neto, total_impuesto, total_bruto, metodo_pago
    ) VALUES (
        v_neto, v_impuesto, p_total_bruto, UPPER(p_metodo_pago)
    ) RETURNING id_venta INTO o_id_venta;

    COMMIT;
END;
/

CREATE INDEX mype_financiero.idx_venta_metodo_romero 
ON mype_financiero.venta (metodo_pago);
SELECT id_venta, total_bruto, metodo_pago 
FROM mype_financiero.venta 
WHERE metodo_pago = 'YAPE';

