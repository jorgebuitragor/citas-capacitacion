# Datos semilla para probar la aplicación

Todos los datos son **sintéticos** (dominio `@demo.invalid`, documentos ficticios). Sirven solo para
entrenamiento; no contienen personas, EPS ni profesionales reales. Las sedes (HIC, ICV) y los nombres de
especialidades sí son públicos de la FCV.

## Cuenta por defecto

| Campo | Valor |
|---|---|
| Correo | `admin@demo.invalid` |
| Contraseña | `Demo1234*` |
| Rol | `ADMIN` |

**Todas las cuentas de esta página usan la misma contraseña: `Demo1234*`.**

## Cómo se cargan (sin pasos manuales)

La migración `citas-api/src/main/resources/db/migration/V11__seed_demo_users_and_appointments.sql` se aplica
sola al arrancar la API (Flyway). Es idempotente: se puede ejecutar varias veces sin duplicar usuarios,
profesionales ni EPS, y funciona tanto sobre una base creada por Flyway como sobre una creada con
`database/reference/db.sql`.

Las fechas de las citas y de la disponibilidad son **relativas al día de aplicación** (mañana, +2 días, hace 7
días…). Si el entorno lleva días encendido y se quedó sin franjas futuras, ejecuta:

```bash
./scripts/refresh-demo-data.sh
```

Para empezar de cero (borra todos los datos locales y vuelve a cargar todo):

```bash
docker compose down -v && docker compose up -d
```

## Usuarios

### Administración

| Correo | Roles | Para probar |
|---|---|---|
| `admin@demo.invalid` | ADMIN | Bandeja de aprobaciones, catálogos (EPS/planes/especialidades), reprogramaciones |
| `admin2@demo.invalid` | ADMIN | Un segundo administrador (decisiones tomadas por otra persona) |
| `multirol@demo.invalid` | ADMIN + PROFESSIONAL + USER | Una cuenta con los tres roles; es también la profesional `PROF-DEMO-105` |

### Profesionales (rol PROFESSIONAL)

| Correo | Código | Especialidad | Sedes | Notas |
|---|---|---|---|---|
| `dra.gomez@demo.invalid` | PROF-DEMO-101 | Medicina General | HIC, ICV | Tiene la mayoría de citas generales |
| `dr.salazar@demo.invalid` | PROF-DEMO-102 | Cardiología Adulto | HIC | Cardiología requiere aprobación ADMIN |
| `dra.ortiz@demo.invalid` | PROF-DEMO-103 | Ortopedia y Traumatología (60 min) | ICV | Cita de dos franjas |
| `dr.inactivo@demo.invalid` | PROF-DEMO-104 | Medicina General | HIC | Profesional **inactivo**: no debe aparecer para agendar |
| `multirol@demo.invalid` | PROF-DEMO-105 | Medicina General + Cardiología | HIC, ICV | Ver arriba |
| `prof.general@demo.invalid`, `prof.especialista@demo.invalid` | PROF-GENERAL-001, PROF-ESPECIAL-001 | General / Cardiología + Ortopedia | HIC | Heredados de S3; **sin acceso** (cuenta inactiva) y con disponibilidad de demostración |

### Pacientes (rol USER)

| Correo | Situación | Qué se puede probar |
|---|---|---|
| `paciente.nuevo@demo.invalid` | Sin citas | Estado vacío, primera reserva |
| `paciente.general@demo.invalid` | 1 APPROVED (mañana 14:00) + 1 COMPLETED (hace 7 días) | Listado, cancelación, historial |
| `paciente.especialista@demo.invalid` | 1 REQUESTED (cardiología, +2 días) + 1 APPROVED (ortopedia 60 min, +3 días) | Cita pendiente de aprobación y cita de dos franjas |
| `paciente.historial@demo.invalid` | 4 citas pasadas: COMPLETED, NO_SHOW, CANCELLED, REJECTED | Todos los estados terminales, historial de estados |
| `paciente.reprogramacion@demo.invalid` | 2 APPROVED con reprogramación **PENDING** (franja retenida) y **REJECTED** (el paciente aún debe decidir) | Flujo de reprogramación de punta a punta |
| `paciente.recordatorio@demo.invalid` | 1 APPROVED que empieza en unas 3 h | Recordatorio de WF-001 (ventana de 24 h) |
| `paciente.inactivo@demo.invalid` | Cuenta **inactiva** con 1 APPROVED mañana 15:00 | No puede iniciar sesión (401); WF-001 no le envía recordatorio |

Cada cita sembrada tiene su fila inicial en el historial de estados. Los pacientes `paciente.*` no tienen
afiliación a EPS: la afiliación del paciente (HU-005) todavía no está implementada.

## Catálogos

| Entidad | Datos |
|---|---|
| Sedes | `HIC` (Hospital Internacional de Colombia, Piedecuesta), `ICV` (Instituto Cardiovascular, Floridablanca) |
| Especialidades | `MEDICINA_GENERAL` (30 min, sin aprobación), `CARDIOLOGIA_ADULTO` (30 min), `ORTOPEDIA_TRAUMATOLOGIA` (60 min); la base de referencia añade 9 más |
| Regímenes | Contributivo, Subsidiado, Especial, Excepción, Particular (fijos) |
| EPS activas | `EPS_DEMO_A` Demo Salud, `EPS_DEMO_B` Demo Familiar, `EPS_DEMO_C` Demo Magisterio, `PARTICULAR_DEMO` |
| EPS inactiva | `EPS_DEMO_INACTIVA` (para probar que no se ofrece) |
| Planes activos | `A-CONTRIB`, `A-SUBS`, `B-CONTRIB`, `B-ESPECIAL`, `C-CONTRIB`, `C-EXCEP`, `PARTICULAR` |
| Planes inactivos | `A-ESPECIAL-OFF`, `X-CONTRIB` |

## Cómo comprobarlo rápido

1. Levanta el entorno (`docker compose --profile dev up -d`) y arranca la API.
2. Abre la web e inicia sesión con `admin@demo.invalid` / `Demo1234*`: la bandeja debe mostrar la solicitud
   `REQUESTED` de `paciente.especialista` y la reprogramación `PENDING` de `paciente.reprogramacion`.
3. Cierra sesión e ingresa como `paciente.historial@demo.invalid`: deben verse cuatro citas con estados distintos.

## Advertencias

- **Solo laboratorio.** Estas credenciales no deben usarse jamás fuera de un entorno local de entrenamiento.
- Las pruebas de integración de la API (`mvn test`) corren contra la **misma base** que usa la aplicación y
  crean usuarios `*@example.test` que borran al terminar; si una prueba se interrumpe pueden quedar filas
  sueltas. No afectan a las cuentas `@demo.invalid`.
- `docker-compose.override.yml` usa la base `citas_jorge_buitrago`, no `citas_fcv_training`; el volumen se
  crea una sola vez, por lo que `down -v` es la forma limpia de regenerar todo.
