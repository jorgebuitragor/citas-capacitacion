# GOAL S4.01 — Mis citas y cancelación

Ejecutar desde la raíz del workspace.

```text
/goal Implementa de extremo a extremo HU-018 Consultar mis citas y HU-019 Cancelar cita. Antes de editar, lee PRD RF-13, RF-14, RN-09 y RN-11; restricciones; HU/DoD; contrato REST; AGENTS de ambos repos; y el diseño aprobado disponible. Inicia solo si estas HU están aprobadas y HU-015/HU-016 tienen evidencia de completitud. La meta se cumple cuando USER lista y filtra solo sus citas por estado/fecha, visualiza sede, profesional, especialidad, fecha/hora, duración, estado y motivo de rechazo aplicable; puede cancelar únicamente una cita propia futura y no terminal; la transición CANCELLED libera slots y crea historial; una cita ajena, pasada, terminal o cancelada no cambia; el frontend maneja loading, empty, error, success y prevención de doble envío; pruebas backend aplicables, build/typecheck/pruebas frontend disponibles y validación del contrato pasan. No implementes reprogramación, cierre de atención, auditoría general ni ventanas adicionales de cancelación. Si falta una regla, contrato o diseño aprobado, pausa y escala con evidencia. Máximo 3 intentos por el mismo criterio. Registra checkpoints y resultado final en citas-api/docs/evidence/goals-loops/S4/.
```
