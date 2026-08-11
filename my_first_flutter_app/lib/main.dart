import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My First Flutter Application',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('My First Flutter Application'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.4),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                Card(
                  color: Colors.white.withOpacity(0.15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.school,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: 24),

                        Text(
                          'Full Name: JAMES NEIL M. MAANO',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 12),

                        Text(
                          'Course & Section: BSIT 3',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),

                        SizedBox(height: 8),

                        Text(
                          'My First Flutter Application',
                          style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(height: 12),

                        Text(
                          'Hobby: Basketball',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),

                        SizedBox(height: 8),

                        Text(
                          'Date: July 30, 2026',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),

                        SizedBox(height: 16),

                        Divider(
                          color: Colors.white54,
                          thickness: 1,
                        ),

                        SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Age: 21',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            Text(
                              'Birthdate: July 30, 2004',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                FavoritesCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FavoritesCard extends StatelessWidget {
  const FavoritesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Favorites',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            SizedBox(height: 16),

            Text(
              'Favorite Game: Mobile Legends',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),

            SizedBox(height: 10),

            Text(
              'Favorite Movie: Interstellar',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),

            SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Favorite Food: Adobo',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                Icon(Icons.restaurant, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}