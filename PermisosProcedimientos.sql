GRANT CREATE ANY PROCEDURE TO llanos;
GRANT CREATE ANY PROCEDURE TO romero;
GRANT CREATE ANY PROCEDURE TO mescua;
GRANT CREATE ANY PROCEDURE TO zorrilla;

GRANT INSERT ON mype_financiero.caja_diaria TO llanos;
GRANT EXECUTE ON mype_financiero.sp_abrir_caja_diaria TO llanos;
GRANT INSERT, SELECT ON mype_financiero.venta TO romero;


