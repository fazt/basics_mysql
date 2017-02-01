-- acciones que realiza un usuario en un intervalo de tiempo

DROP PROCEDURE `PRO_AUDIT_UsuarioIntervalo`//
CREATE DEFINER=`root`@`localhost` PROCEDURE `PRO_AUDIT_UsuarioIntervalo`(IN FechaInicio varchar(10),IN FechaFin varchar(10),IN Usuario varchar(20))
BEGIN

IF(Usuario<>'')
THEN
select f.user_id as Usuario, f.timestamp as FechaAccion, f.node_uuid as IdNodo,
(select a1.arg_2 from alf_audit_fact a1 where a1.return_val like concat(concat('%',f.node_uuid),'%') and a1.audit_source_id=8) as NombreFichero,
(Select method from alf_audit_source where id=f.audit_source_id) as Accion,
f.arg_1 as Detalle1, f.arg_2 as Detalle2,f.arg_3 as Detalle3,f.exception_message as MensajeError
from alf_audit_fact f
where ((f.audit_source_id=6 and f.arg_2 like '%versionLabel%') or
f.audit_source_id=1 or f.audit_source_id=5 or f.audit_source_id=6 or f.audit_source_id=7 or f.audit_source_id=8 or f.audit_source_id=10 or f.audit_source_id=12) and
(date(f.timestamp) between FechaInicio and FechaFin) and f.user_id<>'System' and (f.user_id LIKE Usuario or (f.user_id LIKE 'guest' and f.arg_1 LIKE Usuario));

ELSE

select f.user_id as Usuario, f.timestamp as FechaAccion, f.node_uuid as IdNodo,
(select a1.arg_2 from alf_audit_fact a1 where a1.return_val like concat(concat('%',f.node_uuid),'%') and a1.audit_source_id=8) as NombreFichero,
(Select method from alf_audit_source where id=f.audit_source_id) as Accion,
f.arg_1 as Detalle1, f.arg_2 as Detalle2,f.arg_3 as Detalle3,f.exception_message as MensajeError
from alf_audit_fact f
where ((f.audit_source_id=6 and f.arg_2 like '%versionLabel%') or
f.audit_source_id=1 or f.audit_source_id=5 or f.audit_source_id=6 or f.audit_source_id=7 or f.audit_source_id=8 or f.audit_source_id=10 or f.audit_source_id=12) and
(date(f.timestamp) between FechaInicio and FechaFin) and f.user_id<>'System';

END IF;

END
