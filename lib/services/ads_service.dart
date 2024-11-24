import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/custom_ad_model.dart';

class AdService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetches custom ads from Firestore
  /// Returns a list of [CustomAdModel] or an empty list in case of error.
  Future<List<CustomAdModel>> fetchCustomAds() async {
    try {
      // Fetch the document from the settings collection
      DocumentSnapshot snapshot = await _firestore
          .collection('settings')
          .doc('app')
          .get(); // Get the document data

      // Check if the document exists and contains the ads field
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data() as Map<String, dynamic>;
        print(data); // Print the full data structure

        // Access the custom_ads field within the ads object
        var adsData = data['ads'];
        List<dynamic>? customAdsList = adsData['custom_ads'];

        // Map the custom ads list to CustomAdModel instances
        List<CustomAdModel> ads = customAdsList?.map((ad) {
          return CustomAdModel.fromMap(ad as Map<String, dynamic>);
        }).toList() ?? [];

        // Log the fetched ads
        print('Fetched ads: $ads');
        return ads; // Return the list of ads
      } else {
        print('No ads found or document does not exist.');
        return []; // Return an empty list if no ads are found
      }
    } catch (e) {
      // Handle any errors
      print('Error fetching ads: $e');
      return []; // Return an empty list in case of error
    }
  }
}
