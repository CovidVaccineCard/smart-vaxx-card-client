import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:smart_vaxx_card_client/models/card_details.dart';
import 'package:smart_vaxx_card_client/screens/view_card/view_image.dart';

class ViewCardScreen extends StatelessWidget {
  ViewCardScreen({required this.cardDetails, this.fromLink = false});

  final CardDetails cardDetails;
  final cards = FirebaseFirestore.instance.collection('cards');
  final storage = FirebaseStorage.instance;
  final bool fromLink;
  final height = 200.0, width = 300.0;

  Future<String> createShortLink() async {
    final parameters = DynamicLinkParameters(
      uriPrefix: 'https://vaxxcard.page.link',
      link: Uri.parse('https://vaxxcard.page.link/?cardId=${cardDetails.id}'),
      androidParameters: AndroidParameters(
        packageName: 'com.covid.vaxxcard.smart_vaxx_card_client',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: 'Smart Vaxx Card',
        description: 'Take a look, this is my vaccination card',
      ),
    );

    final shortUri = await parameters.buildShortLink();
    return shortUri.shortUrl.toString();
  }

  Widget _buildDetails(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(width: 10),
          Expanded(flex: 1, child: Text(value, style: TextStyle(fontSize: 20))),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewImageScreen(
                image: cardDetails.image,
                imageName: cardDetails.imageName,
                userId: cardDetails.userId,
              ),
            ),
          );
        },
        splashColor: Colors.white,
        child: SizedBox(
          height: height,
          width: width,
          child: Stack(
            children: [
              Image.network(
                cardDetails.image,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                        ? child
                        : Center(child: CircularProgressIndicator()),
                errorBuilder: (context, error, stackTrace) =>
                    Center(child: const Text('Failed')),
                height: height,
                width: width,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.low,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 55,
                  padding: const EdgeInsets.all(16),
                  color: Colors.black,
                  child: Center(
                    child: const Text('View',
                        style: TextStyle(color: Colors.white, fontSize: 22)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        actions: (!fromLink)
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await cards.doc(cardDetails.id).delete();
                    await storage
                        .ref(
                            'cards/${cardDetails.userId}/${cardDetails.imageName}')
                        .delete();
                    Navigator.pop(context);
                  },
                ),
              ]
            : null,
        leading: fromLink
            ? null
            : IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close),
              ),
        title: const Text('View card'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final link = cardDetails.link;
          if (link != null) {
            await Share.share(link);
          } else {
            final shortUrl = await createShortLink();
            await cards.doc(cardDetails.id).update({
              'link': shortUrl,
            });
            await Share.share(shortUrl);
          }
        },
        label: Text('Share'),
        icon: Icon(Icons.share),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildImage(context),
              _buildDetails('Name: ', cardDetails.name),
              _buildDetails('Center: ', cardDetails.center),
              _buildDetails('Dose: ', cardDetails.dose),
              _buildDetails('Location: ', cardDetails.location),
              _buildDetails('Date: ', cardDetails.date),
              if(cardDetails.type != null) _buildDetails('Vaccine type: ', cardDetails.type!)
            ],
          ),
        ),
      ),
    );
  }
}
