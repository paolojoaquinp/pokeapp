import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_response.freezed.dart';
part 'pokemon_response.g.dart';

@freezed
class PokemonResponse with _$PokemonResponse {
    factory PokemonResponse({
      required int count,
      required String next,
      dynamic previous,
      List<dynamic>? results
    }) = _PokemonResponse;

  factory PokemonResponse.fromJson(Map<String, dynamic> json) => _$PokemonResponseFromJson(json);    
}
