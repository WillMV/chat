class CustomException {
  final String error;

  final Map<String, String> _erros = {
    '[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.':
        'Login ou senha incorretos'
  };

  CustomException({required this.error});

  @override
  String toString() {
    return _erros[error] ?? 'Algo deu errado: $error';
  }
}
