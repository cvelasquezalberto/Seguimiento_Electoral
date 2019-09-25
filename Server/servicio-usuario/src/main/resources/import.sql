INSERT INTO usuario(nombre,apellido,dni,correo,contrasena, activo, foto) VALUES('Christian', 'Velasquez', '11223344', 'cvelasquez@gmail.com', '$2a$10$7on.0CxWJISxafxsj4MbgO8mlv4M55aQ0RD59w/B27B/zLPEzkQjS', 1, 'usuario/user.jpge');
INSERT INTO usuario(nombre,apellido,dni,correo,contrasena, activo, foto) VALUES('Juan Carlos', 'Ramirez', '88552211', 'jramirez@gmail.com', '$2a$10$3VSrYUgRN85N2UvFqjJSUO9Mr6/yFklD4UYzrcltUStQJbenCOA8u', 1, 'usuario/user.jpge');

INSERT INTO rol (nombre) VALUES ('ROLE_USER');
INSERT INTO rol (nombre) VALUES ('ROLE_ADMIN');

INSERT INTO usuarios_roles(id_usuario, id_rol) VALUES(1, 1);
INSERT INTO usuarios_roles(id_usuario, id_rol) VALUES(1, 2);
INSERT INTO usuarios_roles(id_usuario, id_rol) VALUES(2, 1);