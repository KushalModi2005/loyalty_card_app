class LoyaltyCard {
  String id;
  String name;
  String barcode;
  DateTime expirationDate;
  String imagePath; // Path for storing card image

  LoyaltyCard({
    required this.id,
    required this.name,
    required this.barcode,
    required this.expirationDate,
    required this.imagePath,
  });
}
