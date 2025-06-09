enum UserType { pessoaFisica, pessoaJuridica }

extension UserTypeExtension on UserType {
  String get displayName {
    switch (this) {
      case UserType.pessoaFisica:
        return 'Pessoa Física';
      case UserType.pessoaJuridica:
        return 'Pessoa Jurídica';
    }
  }

  String get documentLabel {
    switch (this) {
      case UserType.pessoaFisica:
        return 'CPF';
      case UserType.pessoaJuridica:
        return 'CNPJ';
    }
  }
}
