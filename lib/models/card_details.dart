class CardDetails {
  const CardDetails({
    required this.name,
    required this.center,
    required this.date,
    required this.dose,
    required this.location,
    required this.image,
    required this.imageName,
    required this.userId,
    required this.id,
    this.link,
    this.type,
  });

  final String name;
  final String center;
  final String date;
  final String dose;
  final String location;
  final String image;
  final String imageName;
  final String userId;
  final String id;
  final String? link;
  final String? type;

  static CardDetails fromMap(Map<String, dynamic> mapData) {
    return CardDetails(
      id: mapData['id'],
      userId: mapData['userId'],
      name: mapData['name'],
      center: mapData['center'],
      date: mapData['date'],
      dose: mapData['dose'],
      location: mapData['location'],
      image: mapData['image'],
      imageName: mapData['imageName'],
      link: mapData['link'],
      type: mapData['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'center': center,
      'date': date,
      'dose': dose,
      'location': location,
      'image': image,
      'imageName': imageName,
      'link': link,
      'type': type,
    };
  }
}
