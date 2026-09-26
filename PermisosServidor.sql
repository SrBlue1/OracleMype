ALTER SESSION SET CONTAINER = XEPDB1;

-- 2. Cambiar el alias lógico hacia la raíz C:\
CREATE OR REPLACE DIRECTORY dir_mype_pump AS 'C:\OracleBackup';

-- 3. Reconfirmar permisos al esquema en mayúsculas
GRANT READ, WRITE ON DIRECTORY dir_mype_pump TO MYPE_FINANCIERO;