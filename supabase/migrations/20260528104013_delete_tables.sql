
-- =========================
-- ELIMINAR TABLAS DEPENDIENTES
-- =========================

drop table if exists actividad cascade;
drop table if exists colaboracion cascade;

-- =========================
-- ELIMINAR COLABORACION SI EXISTE EN EMPRESA (si vienes de versión anterior)
-- =========================
-- (solo si existía como estado o algo raro)
-- alter table empresa drop column if exists colaboracion;

-- =========================
-- EMPRESA (ACTUALIZACIÓN)
-- =========================

alter table empresa
add column if not exists colaboraciones int default 0;
