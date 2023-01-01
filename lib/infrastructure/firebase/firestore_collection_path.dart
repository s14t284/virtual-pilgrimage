// Firestore の collection のパス定義
extension FirestoreCollectionPath on String {
  static const String users = 'users';
  static const String temples = 'temples';
  static const String deletedUsers = 'deleted_users';
  static const String rankings = 'rankings';

  static String health(String userId) => '$users/$userId/health';
}
