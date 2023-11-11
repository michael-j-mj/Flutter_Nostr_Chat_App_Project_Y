abstract interface class ILocalStorage {
  Future<void> start();

  Future<dynamic> read(LOCALSTORAGETYPE type);
  Future<bool> update(LOCALSTORAGETYPE type, var message);

  Future<bool> delete(LOCALSTORAGETYPE type);
  Future<bool> deleteAll();
}

enum LOCALSTORAGETYPE {
  account,
  metadata,
  following,
  blockedList,
  privateMessages,
  relayList,
}
