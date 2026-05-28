
-- =========================
-- NOMENCLADOR: SECTOR
-- =========================
create table sector (
    id bigint generated always as identity primary key,
    nombre text not null unique
);

-- =========================
-- NOMENCLADOR: INTERES
-- =========================
create table interes (
    id bigint generated always as identity primary key,
    nombre text not null unique
);

-- =========================
-- NOMENCLADOR: FASE PIPELINE
-- =========================
create table fase_pipeline (
    id bigint primary key,
    nombre text not null unique
);

-- Fases iniciales (con ID fijo)
insert into fase_pipeline(id, nombre) values
(1, 'Nuevo'),
(2, 'Partner');

-- =========================
-- NOMENCLADOR: LOCALIDAD
-- =========================
create table localidad (
    id bigint generated always as identity primary key,
    nombre text not null unique
);

-- =========================
-- EMPRESA (tabla principal)
-- =========================
create table empresa (
    id bigint generated always as identity primary key,

    razon_social text not null,
    email text,
    telefono text,
    direccion text,
    website text,

    sector_id bigint references sector(id),
    localidad_id bigint references localidad(id),

    fase_id bigint not null default 1 references fase_pipeline(id),

    colaboraciones int default 0,

    notas text,

    created_at timestamp default now(),
    updated_at timestamp
);

-- Trigger updated_at automático
create or replace function update_updated_at_column()
returns trigger as $$
begin
    new.updated_at = now();
    return new;
end;
$$ language plpgsql;

create trigger trg_update_empresa
before update on empresa
for each row
execute function update_updated_at_column();

-- =========================
-- CONTACTO (1:1 con empresa)
-- =========================
create table contacto (
    id bigint generated always as identity primary key,

    empresa_id bigint unique references empresa(id) on delete cascade,

    nombre text not null,
    cargo text,
    email text,
    telefono text
);

-- =========================
-- RELACIÓN EMPRESA - INTERES (N:M)
-- =========================
create table empresa_interes (
    empresa_id bigint references empresa(id) on delete cascade,
    interes_id bigint references interes(id) on delete cascade,
    primary key (empresa_id, interes_id)
);

-- =========================
-- COLABORACION
-- =========================
create table colaboracion (
    id bigint generated always as identity primary key,

    empresa_id bigint references empresa(id) on delete cascade,

    tipo text,
    descripcion text,

    fecha date default now(),

    created_at timestamp default now()
);

-- =========================
-- ACTIVIDAD (historial CRM)
-- =========================
create table actividad (
    id bigint generated always as identity primary key,

    empresa_id bigint references empresa(id) on delete cascade,
    contacto_id bigint references contacto(id),

    tipo text,
    descripcion text,

    fecha timestamp default now()
);

-- =========================
-- DATOS INICIALES
-- =========================

insert into sector(nombre) values
('Tecnología'),
('Marketing'),
('Construcción'),
('Educación'),
('RRHH');

insert into interes(nombre) values
('Prácticas'),
('Formación'),
('Contratación');

insert into localidad(nombre) values
('Madrid'),
('Valencia'),
('Barcelona'),
('Sevilla'),
('Bilbao');