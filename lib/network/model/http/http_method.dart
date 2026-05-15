enum HttpMethod {
  get,
  post,
  put,
  delete,
  patch;

  String get name {
    return switch (this) {
      HttpMethod.get => 'GET',
      HttpMethod.post => 'POST',
      HttpMethod.put => 'PUT',
      HttpMethod.delete => 'DELETE',
      HttpMethod.patch => 'PATCH',
    };
  }
}
