# GOAL S3 — reserva de citas end-to-end

Ejecutar desde el workspace raíz con visibilidad de ambos repos, después de aprobar HU-015, HU-016, HU-017 y la decisión DEC-003 sobre exclusión de slots.

```text
/goal Implementa de extremo a extremo las HU aprobadas HU-015 reservar cita general, HU-016 solicitar cita especializada y HU-017 decidir cita especializada, en citas-api y citas-web. Lee primero PRD RF-11, RF-12 y RN-01 a RN-09, las tres HU con sus criterios y DoD, el DoD transversal de S3, la decisión DEC-003 sobre exclusión de slots, el contrato REST vigente y los AGENTS de ambos repos. Escribe las pruebas antes o durante la implementación, nunca después, y conserva evidencia de al menos una prueba roja intencional que luego pase a verde. La meta se cumple solo cuando: USER puede buscar disponibilidad por sede, especialidad, profesional y fecha desde citas-web; confirmar una franja de Medicina General crea una cita APPROVED automáticamente sin intervención de ADMIN; solicitar una franja especializada crea una cita REQUESTED que ocupa sus slots; una especialidad de 60 minutos exige dos slots consecutivos y no genera ocupación parcial cuando no existen; una segunda reserva sobre un slot ya ocupado falla con 409 sin crear cita duplicada, demostrado por una prueba de doble reserva; ADMIN aprueba una solicitud conservando sus slots, y solo puede rechazarla con motivo, liberando los slots al rechazar; cada transición queda registrada en el historial con estado, actor, fuente y fecha; existen pruebas de autorización que verifican que USER y PROFESSIONAL no pueden decidir solicitudes ajenas; mvn test pasa completo en citas-api; typecheck, test y build pasan en citas-web; el hook pre-commit de ambos repos corre en verde y bloquea un secreto ficticio; no hay secretos hardcodeados. No implementes cancelación, reprogramación, cierre de atención ni recordatorios. Mantén un log corto de checkpoints y detente si una incompatibilidad de contrato o una regla no definida en las fuentes requiere decisión humana.
```

## Prerequisitos antes de lanzarlo

Este goal asume que ya está hecho el trabajo previo. Si se lanza antes, se bloqueará a mitad de camino.

1. **HU aprobadas.** HU-015, HU-016 y HU-017 en `estado: Aprobada`, junto con sus prerequisitos HU-009 a HU-014.
2. **DEC-003 registrada** en `citas-api/docs/wiki/llm-wiki/wiki/decisiones.md`. Sin ella, el scrum README bloquea explícitamente HU-015 y HU-016: *"El mecanismo exacto de concurrencia/retención de slots … debe aprobarse antes"*.
3. **DoD transversal de S3** creado, con las exigencias que los DoD actuales no cubren: test-first, prueba roja intencional, hook en FAIL y PASS, bloqueo de secreto ficticio y tabla de evidencia rellena.
4. **Prerequisitos funcionales implementados:** profesionales y sus asignaciones (HU-009/010/011), bloques de disponibilidad y calendario (HU-012/013), consulta de disponibilidad (HU-014), y la materialización de `professional_slots` a partir de cada bloque.
5. **Infraestructura de verificación:** Vitest y scripts `typecheck`/`test` en `citas-web`, router y guards por rol, y el hook `pre-commit` en `.githooks/` de ambos repos.
6. **Bloqueadores técnicos resueltos:** conflicto de ids de rol entre `V2__add_refresh_tokens.sql` y `database/reference/db.sql`; migraciones Flyway versionadas en git; CORS ampliado a PUT/PATCH/DELETE; mecanismo de ownership para PROFESSIONAL; `ApiExceptionHandler` con 404 y 409 de regla de negocio.

## Por qué este recorte

S3 abarca nueve HU, pero la rúbrica de `GOAL_03_RETO_INDEPENDIENTE.md` exige que un goal tenga *"una sola capacidad/resultado"* y una *"condición verificable de finalización"*. HU-015, HU-016 y HU-017 son esa capacidad única: una persona reserva una cita y el sistema la resuelve correctamente. Atraviesan ambos repos y concentran las reglas que S3 obliga a demostrar —duración 30/60, no doble reserva, autorización y auditoría de transiciones—. Las HU-009 a HU-014 son sus prerequisitos, no su objetivo.

## Nota operativa

El contenedor `citas-api-dev` no tiene recarga en caliente. Tras cambiar entidades o configuración hay que reiniciar `mvn spring-boot:run`; si no, el runtime sigue usando metadata vieja de Hibernate y produce errores engañosos (en S2 esto se manifestó como un `401` espurio en registro y login).
