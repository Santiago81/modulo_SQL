--Creación BD de KeepCoding

-- Tabla de alumnos
create table alumnos (
    id_alumno SERIAL primary key,
    nombre varchar(255),
    apellido varchar(255),
    email varchar(255),
    fecha_inscripcion date,
    id_bootcamp int,
    foreign key (id_bootcamp) references bootcamps(id_bootcamp)
);

-- Tabla de bootcamps
create table bootcamps (
    id_bootcamp SERIAL primary key,
    nombre varchar(255),
    descripcion text
);

-- Tabla de módulos
create table modulos (
    id_modulo SERIAL primary key,
    nombre varchar(255),
    descripcion text
);

-- Tabla intermedia bootcamp_modulo (relación m:m entre bootcamps y módulos)
create table bootcamp_modulo_relacion (
    id_bootcamp int not null,
    id_modulo int not null,
    primary key (id_bootcamp, id_modulo),
    foreign key (id_bootcamp) references bootcamps(id_bootcamp),
    foreign key (id_modulo) references modulos(id_modulo) 
);

-- Tabla de profesores
create table profesores (
    id_profesor SERIAL primary key,
    nombre varchar(255),
    apellido varchar(255),
    email varchar(255) unique not null
);

-- Tabla intermedia profesores_modulo_relacion (relación m:m entre profesores y módulos)
create table profesores_modulo_relacion (
    id_profesor int not null,
    id_modulo int not null,
    primary key (id_profesor, id_modulo),
    foreign key (id_profesor) references profesores(id_profesor),
    foreign key (id_modulo) references modulos(id_modulo) 
);

-- Tabla de evaluaciones
create table evaluaciones (
    id_evaluacion SERIAL primary key,
    calificacion decimal(4,2),
    comentarios text,
    id_alumno int not null,
    id_modulo int not null,
    foreign key (id_alumno) references alumnos(id_alumno) ,
    foreign key (id_modulo) references modulos(id_modulo) 
);