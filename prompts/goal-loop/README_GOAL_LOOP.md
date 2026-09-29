# Goals y Loops — guía para S2-S5

## Diferencia conceptual

### `/goal`
Úsalo cuando existe **un estado final verificable** y quieres que el agente continúe entre turnos hasta lograrlo.

Codex documenta `/goal <objective>` con control de estado, pause/resume/clear. Si no aparece, el estudiante puede habilitar la feature `goals` según la versión de Codex instalada.

Claude Code también dispone de `/goal`: evalúa una condición de finalización después de cada turno y continúa si todavía no se cumple.

### Loop de ingeniería del curso
El loop de S4 es **Builder → Verifier → feedback → retry → stop/escalate**. No depende de que exista un slash command llamado `/loop`.

En Codex se implementará principalmente mediante `/goal` + instrucciones de checkpoints/verificación/presupuesto.

Claude Code sí tiene un `/loop` nativo, pero su semántica es repetir un prompt por intervalo mientras la sesión permanece abierta. Es útil para checks recurrentes; no debe confundirse automáticamente con el Builder/Verifier loop de S4.

## Regla de clase
- Aprender los ejemplos estandarizados usando Codex.
- Explicar cómo trasladar el patrón a Claude Code.
- El segundo ejercicio puede ser sugerido o elegido por el estudiante.
- El tercer ejercicio es un reto independiente.

## Artefactos del proyecto de citas

### S4 — completar el MVP
- `GOAL_S4_01_MIS_CITAS_Y_CANCELACION.md` — HU-018 y HU-019.
- `GOAL_S4_02_REPROGRAMACION.md` — HU-020 y HU-021.
- `GOAL_S4_03_OPERACION_PROFESIONAL.md` — HU-022 y HU-023.
- `GOAL_S4_04_OPERACION_ADMINISTRATIVA_Y_AUDITORIA.md` — HU-024 y HU-025.
- `GOAL_S4_05_RECUPERACION_DE_CONTRASENA.md` — HU-004.
- `GOAL_S4_06_CATALOGOS_CONFIGURABLES.md` — HU-006 a HU-008.
- `LOOP_01_GUIADO_SIMPLE.md`, `LOOP_02_GUIADO_AVANZADO.md` y `LOOP_03_RETO_INDEPENDIENTE.md` — ciclos S4.

### S5 — MCP y n8n
- `GOAL_S5_01_WF001_RECORDATORIOS_MCP.md` — HU-028 / WF-001.
- `LOOP_S5_01_VERIFICAR_WF001.md` — Builder/Verifier del workflow.
- `GOAL_S5_02_CONTENIDO_NO_CONFIABLE.md` — análisis de contenido no confiable y riesgos residuales.

## Registro de ejecución

Cada goal o loop debe crear o actualizar un registro breve en
`citas-api/docs/evidence/goals-loops/S4/` o `citas-api/docs/evidence/goals-loops/S5/`.
El registro identifica HU, iteración, cambios, comandos ejecutados, resultado del
Verifier, bloqueos y evidencia. No debe incluir secretos, tokens, credenciales ni
datos personales reales.
