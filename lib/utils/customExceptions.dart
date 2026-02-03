enum ExceptionType {
  wrongEmailOrPassword,
  userNotFound,
  contextNotFound,
  emailAlreadyInUse,
  failedToAddToDatabase,
  failedToFetchFromDatabase,
}

class CustomExceptions implements Exception {
  final ExceptionType type;

  CustomExceptions(this.type);

  String get message {
    switch (type) {
      case ExceptionType.wrongEmailOrPassword:
        return 'Email or password is incorrect.';
      case ExceptionType.userNotFound:
        return 'No user found for the provided email.';
      case ExceptionType.contextNotFound:
        return 'The provided context is no longer valid.';
      case ExceptionType.emailAlreadyInUse:
        return 'The email address is already in use by another account.';
      case ExceptionType.failedToAddToDatabase:
        return 'Failed to add data to the database.';
      case ExceptionType.failedToFetchFromDatabase:
        return 'Failed to fetch data from the database.';
    }
  }

  @override
  String toString() {
    return message;
  }
}
