enum HttpStatusError {
  badRequest(400, 'Petición incorrecta'),
  unauthorized(401, 'No autorizado'),
  forbidden(403, 'Acceso prohibido'),
  notFound(404, 'Recurso no encontrado'),
  requestTimeout(408, 'Tiempo de petición agotado'),
  conflict(409, 'Conflicto'),
  unprocessableEntity(422, 'Datos no válidos'),
  internalServerError(500, 'Error interno del servidor'),
  badGateway(502, 'Bad gateway'),
  serviceUnavailable(503, 'Servicio no disponible'),
  gatewayTimeout(504, 'Gateway timeout');

  final int code;
  final String message;
  const HttpStatusError(this.code, this.message);

  static HttpStatusError? tryFromCode(int? code) {
    for (final value in values) {
      if (value.code == code) return value;
    }
    return null;
  }

  static String messageFor(int? code) {
    final found = tryFromCode(code);
    return found?.message ?? 'Error del servidor ($code)';
  }
}
