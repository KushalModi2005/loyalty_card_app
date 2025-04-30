import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/loyalty_card.dart';
import 'card_management_page.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<LoyaltyCard>> cards;

  @override
  void initState() {
    super.initState();
    loadCards();
  }

  void loadCards() {
    cards = DatabaseHelper().getCards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Loyalty Card Storage')),
      body: FutureBuilder<List<LoyaltyCard>>(
        future: cards,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading cards'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No cards found.'));
          }
          final cardList = snapshot.data!;
          return ListView.builder(
            itemCount: cardList.length,
            itemBuilder: (context, index) {
              final card = cardList[index];
              return ListTile(
                title: Text(card.name),
                subtitle: Text('Expires on: ${card.expirationDate.toLocal()}'),
                leading: Image.file(File(card.imagePath)), // Display card image
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    DatabaseHelper().deleteCard(card.id); // Delete card from database
                    loadCards(); // Refresh the cards
                  },
                ),
                onTap: () {
                  // Navigate to card detail or edit page
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CardManagementPage())).then((_) => loadCards());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
