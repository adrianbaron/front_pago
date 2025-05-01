class Validators {
  // Validador de correo electrónico
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // Validador de número de teléfono
  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    return phoneRegex.hasMatch(phone);
  }

   // Método para validar correo electrónico
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'El correo electrónico es requerido';
    }
    
    // Expresión regular para validar correo electrónico
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    
    if (!emailRegExp.hasMatch(value)) {
      return 'Ingrese un correo electrónico válido';
    }
    
    return null;
  }
  
  // Método para validar número de teléfono
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'El número de teléfono es requerido';
    }
    
    // Expresión regular para validar números de teléfono internacionales
    // Acepta formato +[código de país][número], por ejemplo: +521234567890
    final phoneRegExp = RegExp(r'^\+?[0-9]{10,15}$');
    
    // Eliminar espacios para la validación
    final cleanValue = value.replaceAll(' ', '');
    
    if (!phoneRegExp.hasMatch(cleanValue)) {
      return 'Ingrese un número de teléfono válido';
    }
    
    return null;
  }

  // Validar el destinatario según el tipo de notificación
  static String? validateRecipient(String? value, String notificationType) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese el destinatario';
    }

    switch (notificationType) {
      case 'email':
        if (!isValidEmail(value)) {
          return 'Por favor ingrese un correo electrónico válido';
        }
        break;
      case 'sms':
      case 'ws':
        if (!isValidPhone(value)) {
          return 'Por favor ingrese un número de teléfono válido';
        }
        break;
    }
    return null;
  }

  // Validar el monto
  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese un monto';
    }

    try {
      // Reemplazar coma por punto para manejar formatos de números locales
      String normalizedInput = value.replaceAll(',', '.');
      double amount = double.parse(normalizedInput);
      if (amount <= 0) {
        return 'El monto debe ser mayor a 0';
      }
    } catch (e) {
      return 'Por favor ingrese un monto válido';
    }
    return null;
  }
}