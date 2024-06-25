class CustomException implements Exception {
  final String key;

  final Map<String, String> _erros = {
    '[firebase_auth/invalid-credential] The supplied auth credential is incorrect, malformed or has expired.':
        'Login ou senha incorretos',
    "[firebase_auth/email-already-in-use] The email address is already in use by another account.":
        'Email já cadastrado.'
  };

  CustomException(this.key);

  @override
  String toString() {
    return _erros[key] ?? 'Algo deu errado: $key';
  }
}
