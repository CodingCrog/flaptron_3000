class NFTModel {
  final String name;
  final String description;
  final String contract;
  final String image_url;
  final String identifier;
  final String collection;
  final String token_standard;
  final String opensea_url;

  NFTModel(
      {required this.name,
      required this.description,
      required this.contract,
      required this.image_url,
      required this.opensea_url,
      required this.identifier,
      required this.collection,
      required this.token_standard});

  factory NFTModel.fromJson(Map<String, dynamic> json) {
    return NFTModel(
      name: json['name'],
      description: json['description'],
      contract: json['contract'],
      image_url: json['image_url'],
      identifier: json['identifier'],
      collection: json['collection'],
      token_standard: json['token_standard'],
      opensea_url: json['opensea_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'contract': contract,
      'image_url': image_url,
      'identifier': identifier,
      'collection': collection,
      'token_standard': token_standard,
      'opensea_url': opensea_url,
    };
  }
}
