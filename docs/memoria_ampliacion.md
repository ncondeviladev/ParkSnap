# Ampliación de ParkSnap + Firebase 🚀

Para la mejora de mi aplicación en la Unidad 6, he integrado servicios en la nube para transformar ParkSnap en una solución multiplataforma y conectada.

## 1. Autenticación con Firebase

He implementado un sistema de acceso seguro que permite a los usuarios registrarse y hacer login de dos formas:

- **Email y Contraseña:** Registro tradicional gestionado por Firebase Auth.
- **Google Sign-In:** Acceso rápido utilizando la cuenta de Gmail del dispositivo.
  Gracias a esto, cada usuario tiene sus propios datos protegidos y su propia sesión de aparcamiento independiente.

## 2. Nueva Arquitectura de Datos (Firestore)

He migrado la persistencia de datos local a **Cloud Firestore**. Para ello, he refactorizado la capa de datos siguiendo un patrón más profesional:

- **Repositorio y DAO:** He separado la lógica de acceso a datos, facilitando el mantenimiento.
- **Sincronización en la nube:** Ahora las coordenadas del coche, la dirección y la fecha se guardan en la base de datos de Firebase. Esto permite que si el usuario cambia de móvil, pueda ver dónde dejó el coche al iniciar sesión. En el futuro se guardarán las fotos en storage cuando resuelva algunos problemas.

## 3. Control de Conexión y UX

Dado que la app ahora depende de internet, he añadido un sistema robusto de gestión de conectividad utilizando la librería `connectivity_plus`:

- **Avisos Inteligentes:** La app detecta si hay red al arrancar y antes de realizar acciones importantes (aparcar o encontrar).
- **Botón de Emergencia:** He diseñado un botón flotante rojo que solo aparece cuando se pierde la conexión. Este botón lleva directamente al usuario a los ajustes de red del móvil para que pueda activar los datos rápidamente.

## 4. Mejoras en la Interfaz

He aprovechado esta actualización para corregir problemas de diseño:

- **Scroll Adaptativo:** He implementado `SingleChildScrollView` en la pantalla principal para evitar errores de visualización ("overflow") al girar el móvil o en pantallas de diferentes tamaños.
