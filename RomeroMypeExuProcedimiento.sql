SET SERVEROUTPUT ON;
DECLARE
    v_id_generado INTEGER;
BEGIN
    sp_registrar_venta_romero(
        p_total_bruto => 118.00,
        p_metodo_pago => 'Yape',
        o_id_venta    => v_id_generado
    );
    DBMS_OUTPUT.PUT_LINE('VENTA INTERNA PROCESADA CON ÉXITO. ID: ' || v_id_generado);
END;
/