CREATE OR REPLACE PROCEDURE mype_financiero.sp_abrir_caja_diaria (
    p_id_sucursal    IN mype_financiero.caja_diaria.id_sucursal%TYPE,
    p_id_empleado    IN mype_financiero.caja_diaria.id_empleado%TYPE,
    p_monto_apertura IN mype_financiero.caja_diaria.monto_apertura%TYPE
) IS
BEGIN
    INSERT INTO mype_financiero.caja_diaria (id_sucursal, id_empleado, monto_apertura, estado_caja) VALUES 
    (p_id_sucursal, p_id_empleado, p_monto_apertura, 'ABIERTA');
    COMMIT;
END;
/
BEGIN
    mype_financiero.sp_abrir_caja_diaria(
        p_id_sucursal    => 5,      
        p_id_empleado    => 10,     
        p_monto_apertura => 150.00  
    );
END;
/

SELECT id_caja, id_sucursal, id_empleado, monto_apertura 
FROM mype_financiero.caja_diaria 
WHERE estado_caja = 'ABIERTA';

CREATE INDEX mype_financiero.idx_caja_estado_llanos 
ON mype_financiero.caja_diaria (estado_caja);



