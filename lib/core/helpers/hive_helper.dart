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
    box = await Hive.openBox('appData');
  }

  // Métodos para favoritos (sin cambios)
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

  Future<void> clearAllFavorites() async {
    try {
      await box.put('favoriteIds', <String>[]);
    } catch (e) {
      throw Exception('Error clearing favorites: $e');
    }
  }

  Future<void> cachePokemons(Map<String, dynamic> pokemons) async {
    try {
      await box.put('pokemons', pokemons);
    } catch (e) {
      throw Exception('Error caching Pokémon: $e');
    }
  }

  Map<String, dynamic> getCachedPokemons() {
    final cachedData = box.get('pokemons', defaultValue: []);
    return Map<String, dynamic>.from(cachedData);
  }

  bool isCacheAvailable() {
    return box.containsKey('pokemons');
  }

  Future<void> clearCache() async {
    try {
      await box.delete('pokemons');
    } catch (e) {
      throw Exception('Error clearing Pokémon cache: $e');
    }
  }
}
