# GOAL S4.05 — Recuperación de contraseña

```text
/goal Implementa HU-004 Recuperar contraseña. Lee PRD RF-03 y requisitos de seguridad; HU/DoD; contrato REST y AGENTS aplicables. Inicia solo si HU-004 está aprobada y las decisiones de duración, entrega controlada en desarrollo y formato de contrato están aprobadas. La meta se cumple cuando USER solicita recuperación por email, recibe el mecanismo controlado aprobado para desarrollo o envío autorizado, usa un token temporal de un solo uso para cambiar su contraseña, y el token queda consumido o inválido tras el cambio; solicitudes inválidas o tokens vencidos/usados no cambian datos; passwords y tokens no aparecen en logs, respuestas no autorizadas ni repositorio; y las pruebas aplicables pasan. No añadas SMTP obligatorio, secretos ni flujos de autenticación adicionales. Si falta una decisión, pausa y escala. Máximo 3 intentos por criterio y evidencia en citas-api/docs/evidence/goals-loops/S4/.
```
