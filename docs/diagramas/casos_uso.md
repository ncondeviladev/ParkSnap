# Diagrama de Casos de Uso

```mermaid
graph TD
    %%{init: {'theme': 'redux-dark'}}%%

    User["Usuario"]

    subgraph Sistema_ParkSnap [Sistema ParkSnap]
        direction TB

        %% --- Casos de Uso Principales ---
        UC_Aparcar(["<b>Aparcar Coche</b>"])
        UC_Encontrar(["<b>Encontrar Coche</b>"])
        UC_Historial(["<b>Consultar Historial</b>"])

        %% --- Extensiones y Opciones ---
        Opt_FotosAparcar(["Tomar Fotos"])
        Opt_VerFotos(["Ver Fotos Guardadas"])

        %% --- Formas de Ver Historial ---
        Opt_Lista(["Ver Lista"])
        Opt_MapaGlobal(["Ver Mapa Global"])

        %% --- Relaciones Usuario ---
        User --> UC_Aparcar
        User --> UC_Encontrar
        User --> UC_Historial

        %% --- Relaciones del Sistema ---
        %% Aparcar solo tiene opción de fotos
        Opt_FotosAparcar -.->|extend| UC_Aparcar

        %% Encontrar solo tiene opción de ver fotos
        Opt_VerFotos -.->|extend| UC_Encontrar

        %% Historial tiene dos formas de consulta
        UC_Historial --> Opt_Lista
        UC_Historial --> Opt_MapaGlobal
    end
```
