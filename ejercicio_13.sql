--Crear una función de limpieza de enteros

create or replace function `keepcoding.clean_integer`(value int64)
returns  int64
as (
  ifnull(value, -999999)
);