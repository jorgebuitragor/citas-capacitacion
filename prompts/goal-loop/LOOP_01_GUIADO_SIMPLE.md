# LOOP 1 — guiado sencillo S4: cancelación de cita

> Este es el **patrón de loop S4**, no necesariamente el slash `/loop` de Claude.

## Escenario
Existe una prueba roja, un criterio pendiente o un defecto acotado en la cancelación de una cita propia.

## Prompt estandarizado para Codex (usar con `/goal`)

```text
/goal Ejecuta un loop Builder/Verifier para completar o corregir exclusivamente HU-019 Cancelar cita, con HU-018 como dependencia de consulta. Máximo 3 iteraciones. Antes de modificar, verifica que ambas HU están aprobadas, que sus dependencias S3 están completadas con evidencia y que existe contrato REST aplicable. En cada iteración, BUILDER lee el fallo y aplica el cambio mínimo en citas-api y, solo si el flujo lo requiere, citas-web; ejecuta las verificaciones reales disponibles. Luego VERIFIER, en revisión separada y sin implementar, revisa HU/DoD, diff, contrato, pruebas y evidencia. PASS exige: USER cancela solo una cita propia, futura y no terminal; queda CANCELLED; se liberan los slots; se registra el historial; intentos sobre cita ajena, pasada, terminal o ya cancelada no cambian datos; la UI evita doble envío y refleja éxito/error cuando aplique. Si FAIL, usa únicamente ese feedback en la siguiente iteración. No reactives citas, no cambies reglas fuera de HU-019 y no inventes ventanas adicionales de cancelación. Si falta una regla o contrato, pausa y escala. Finaliza con PASS o BLOCKED tras 3 iteraciones. Registra cada iteración en citas-api/docs/evidence/goals-loops/S4/.
```

## En Claude Code
El equivalente recomendado para este caso es `/goal` con la misma condición. El `/loop` temporal de Claude sirve para repetición por intervalo, no es necesario aquí.
