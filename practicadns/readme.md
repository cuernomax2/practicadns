## Código de docker-compose:  

- version: "3.3"  

### asir_bind9    


### docker-compose: Cliente  


### Networks  


### Procedimiento de creación de servicios (contenedor)  
   Es necesario saber y definir el servicio a correr. En el caso de esta práctica ese servicio será Bind9.  
     
   Con el comando: 
~~~
docker compose up
~~~

   Iniciaremos el servicio seleccionado anteriormente y se creará el documento "docker-compose.yml":
~~~
version: "3.3"
services:
  asir_bind9:
    container_name: asir_bind9
    image: internetsystemsconsortium/bind9:9.16
    ports:
      - 5300:53/tcp
      - 5300:53/udp
    networks:
      alberto:
        ipv4_address: 10.1.0.254
    volumes:
      - /home/asir2a/Escritorio/SRI/practicadns/conf:/etc/bind
      - /home/asir2a/Escritorio/SRI/practicadns/zonas:/var/lib/bind

  alberto_cliente:
    container_name: alberto_cliente
    image: alpine
    networks:
      - alberto
    stdin_open: true  
    tty: true         
    dns:
      - 10.1.0.254  # IP del contenedor dns 
networks:
  bind9_subnet: 
    external: true
~~~

### Modificación de la configuración, arranque y parada de servicio bind9
   Para arrancar el servicio Bind9 se utiliza este comando:
~~~
docker-compose up
~~~
   Y para parar el servicio este otro:
~~~
docker-compose down
~~~
   La configuración completa se encuentra en: "/home/asir2a/Escritorio/SRI/practicadns/docker-compose.yml"
### Configuración zona y como comprobar que funciona  
   Para configurar la zona deberemos acceder al archivo llamado "named.conf.local", el cual podemos encontrar en "/home/asir2a/Escritorio/practicadns/conf".  
   Para comprobar si este está activo deberemos hacerle ping al nombre de la zona (en mi caso "alumnadocastelao.com").
~~~
zone "alumnadocastelao.com"  {
    type master;
    file "/var/lib/bind/db.alumnadocastelao.com";
    allow-query {
        any;
     };
};
~~~
### Configuración Práctica DNS
   1. Volumen por separado de la configuración  
   La configuración del contenedor por defecto está en "/home/asir2a/Escritorio/SRI/practicadns/conf/named.conf". Para hacer más fácil el proceso deberemos separar este archivo en dos partes.
   El primero se llamará: "named.conf.local"
   El segundo se llamará: "named.conf.options"
   Una vez hayamos hecho esto deberemos borrar todo del archivo original "named.conf" y escribir estas dos líneas de código:
~~~
include "/etc/bind/named.conf.options";
include "/etc/bind/named.conf.local";
~~~
   2. Red propia interna para todos los contenedores  
      Utilizando el comando de abajo crearemos una subred para el contenedor.
~~~
docker network create --subnet 10.1.0.0/24 --gateway 10.0.0.1 contenedores_subnet
~~~
   Tambien podemos entrar en el documento "docker-compose.yml y añadir manualmente la subred en la sección Networks.
   
   3. ip fija en el servidor  
   En el mismo documento (docker-compose.yml) deberemos añadir una nueva línea para darle una IP fija al servidor:
~~~
ipv4_address: X.X.X.X (ipv4_address: 10.1.0.254 en mi caso)
~~~

   4. Configurar Forwarders  
   Para añadir o modificar la IP del servicio DNS deberemos dirigirnos a la seccion "forwarders" del documento "named.conf.options"
~~~
    forwarders {
        1.2.3.4;
        5.6.7.8;
    };
~~~
   
   5. Crear Zona propia
   Para crear una nueva zona deberemos acceder al archivo "named.conf.local" y añadir una nueva zona.
~~~
zone "alumnadocastelao.com"  {
    type master;
    file "/var/lib/bind/db.alumnadocastelao.com";
    allow-query {
        any;
     };
};
~~~
   - Para configurar los registros deberemos dirigirnos al archivo "db.alumnadocastelao.com" y añadir el nombre de la zona y alias
   6. Cliente con herramientas de red
   Para configurar el cliente deberemos dirigirnos de nuevo al archivo "docker-compose.yml" y crear el cliente (con el nombre, la network que queremos que utilice, el modo de arranque y demás parámetros necesarios).
