.bail on

.load dist/hello0
.load dist/hola0
.mode box
.header on

select hello('Alex');
select hello_version();

select hola('Alex');
select hola_version();