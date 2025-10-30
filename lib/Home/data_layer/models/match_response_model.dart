class MatchResponseModel {
  final List<String>matches;
  MatchResponseModel({required this.matches});
  factory MatchResponseModel.fromJson(Map<String,dynamic>json){
    var matchesFromJson = json['matches'] as List? ?? [];
    List<String>parsedMatches = matchesFromJson.map((url)=>url.toString()).toList();
    return MatchResponseModel(matches: parsedMatches);
  }
}