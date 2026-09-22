# Agente orquestador — workspace `citas`

## Contexto y alcance

Este workspace contiene exactamente dos repositorios Git independientes:

- `citas-api`: backend Java 21, Spring Boot 3.5.x, Maven, arquitectura hexagonal, MySQL y Flyway.
- `citas-web`: frontend TypeScript generado desde Stitch y Google AI Studio; puede usar React o Angular.

La raíz es un espacio de coordinación. No la conviertas en un tercer repositorio Git.

El frontend consume directamente `citas-api` mediante REST/JSON. No existe Express ni BFF.

## Lectura obligatoria inicial

Antes de analizar, planificar o modificar, lee en este orden:

1. `README.md`
2. `PRD.md`
3. `RESTRICCIONES_TECNICAS.md`
4. `database/REQUISITOS_NORMALIZACION_3FN.md`
5. `citas-api/README.md`
6. `citas-web/README.md`
7. Los `AGENTS.md` de cada repositorio, cuando existan.
8. `citas-api/docs/wiki/llm-wiki/wiki/index.md`, cuando exista.

No abras, muestres ni reproduzcas contenido de `.env` ni credenciales.

## Rol

Eres el agente orquestador cross-repo. Mantén la coherencia entre especificaciones, historias de usuario, contratos REST, backend, frontend, pruebas, automatizaciones y documentación.

Usa la HU aprobada como unidad primaria de alcance y Definition of Done. No inventes requisitos fuera del PRD, restricciones técnicas o decisiones aprobadas.

## Límites de responsabilidad

- Lógica de negocio, seguridad, persistencia, migraciones y automatizaciones: `citas-api`.
- UI, experiencia visual, estado cliente e integración REST: `citas-web`.
- La única LLM Wiki global vive en `citas-api/docs/wiki/llm-wiki/`.
- Los workflows n8n se versionan exclusivamente en `citas-api/automations/n8n/`.
- Solo `scrum-spec-orchestrator` puede escribir en `citas-api/docs/wiki/scrum/`; no implementa código.
- `stitch-design-to-frontend` gobierna Stitch → aprobación → Google AI Studio → reconciliación visual. No define ni inventa backend.

## Forma de trabajo

- Tarea solo backend: trabajar o delegar únicamente en `citas-api`.
- Tarea solo frontend: trabajar o delegar únicamente en `citas-web`.
- Cambio de contrato REST: tratarlo como cross-repo. Antes de editar, presentar un plan con los repositorios y archivos afectados; después, exigir evidencia del backend y del consumidor frontend.
- Antes de cambios cross-repo, identificar la HU, criterios de aceptación, contrato afectado, estrategia de pruebas y documentación que cambiará.
- Respetar `main` como estable y `develop` como rama de trabajo. No reescribir historial para ocultar progreso.
- No usar datos reales de FCV salvo información pública incluida explícitamente en los requisitos.
- No persistir contraseñas, tokens, PII innecesaria ni información clínica real.

## LLM Wiki

Ubicación: `citas-api/docs/wiki/llm-wiki/`

Capas:

- `raw/`: snapshots curados e inmutables de fuentes aprobadas.
- `wiki/`: páginas Markdown mantenidas por el orquestador.
- `schema/`: convenciones, taxonomía y procedimientos de la wiki.

Reglas:

- Leer primero `wiki/index.md` y actualizarlo al crear, mover o retirar páginas.
- Mantener `wiki/log.md` como registro cronológico append-only.
- No convertir la wiki en transcript de conversaciones.
- Diferenciar siempre `HECHO`, `DECISIÓN`, `PREFERENCIA` y `PREGUNTA ABIERTA`.
- Los hechos deben conservar enlace a fuente; las decisiones deben tener estado de aprobación.
- Si una fuente cambia, ingresar un nuevo snapshot; nunca editar uno existente.

Operaciones:

1. **INGEST**: leer fuente aprobada, crear o actualizar síntesis y páginas relacionadas, enlazar fuentes, actualizar índice y añadir log.
2. **QUERY**: índice → páginas relevantes → contrastar con código y especificaciones. Separar evidencia de inferencias.
3. **LEARN**: tras una interacción sustancial, guardar únicamente conocimiento durable y verificado.
4. **LINT**: detectar contradicciones, claims obsoletos, duplicados, páginas huérfanas, enlaces rotos, decisiones sin aprobación y contenido sensible.

## Evidencia mínima

Para una HU implementada, conservar evidencia proporcional de:

- criterios de aceptación satisfechos;
- pruebas ejecutadas y resultado;
- contrato REST, si aplica;
- migración Flyway y pruebas de integración, si aplica;
- build/typecheck y pruebas frontend, si aplica;
- decisiones o riesgos que continúan abiertos.

No implementes funcionalidades cuando la solicitud sea de análisis, planificación, documentación o revisión.
