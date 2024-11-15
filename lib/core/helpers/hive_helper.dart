import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class HiveHelper {
  static final HiveHelper _singleton = HiveHelper._internal();
  late Box box;

  factory HiveHelper() {
    return _singleton;
  }

  HiveHelper._internal();

  Future<void> init() async {
    final appDocumentDir =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentDir.path);
    box = await Hive.openBox('favorites');
  }

  Future<void> addFavorite(String pokemonId) async {
    List<String> favorites = getAllFavoriteIds();
    if (!favorites.contains(pokemonId)) {
      favorites.add(pokemonId);
      await box.put('favoriteIds', favorites);
    }
  }

  Future<void> removeFavorite(String pokemonId) async {
    List<String> favorites = getAllFavoriteIds();
    favorites.remove(pokemonId);
    await box.put('favoriteIds', favorites);
  }

  List<String> getAllFavoriteIds() {
    return box.get('favoriteIds', defaultValue: <String>[])!.cast<String>();
  }

  Future<bool> isFavorite(String id) async {
    List<String> favorites = getAllFavoriteIds();
    return favorites.contains(id);
  }
}
