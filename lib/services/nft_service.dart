import 'dart:convert';

import 'package:flaptron_3000/model/nft_model.dart';
import 'package:http/http.dart' as http;

class NFTService {
  static String polygon =
      'https://api.opensea.io/api/v2/chain/matic/account/{ethAddress}/nfts?collection=flaptron-3000-1';

  static Future<List<NFTModel>?> fetchNFTsByETHAddress(
      String ethAddress) async {
    final url = polygon.replaceAll(
        '{ethAddress}', '0x6142b865c26b663030bd454f07f8655bdb07cd5a');
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'x-api-key': 'b4ec8bbb790449b7a462c6194cea99d9'},
      );
      final resMap = jsonDecode(response.body);
      final nfts = List<NFTModel>.from(
          resMap['nfts'].map((e) => NFTModel.fromJson(e)).toList());
      return nfts;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
