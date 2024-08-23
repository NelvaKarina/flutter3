import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Setingan TabMenu
class TabScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text('SMK Negeri 4 - Mobile Apps'),
          backgroundColor: Color.fromARGB(234, 221, 87, 120),
        ),
        body: TabBarView(
          children: [
            BerandaTab(),
            UsersTab(),
            ProfilTab(),
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.dashboard), text: 'Dashboard'),
            Tab(icon: Icon(Icons.group), text: 'Users'),
            Tab(icon: Icon(Icons.account_circle), text: 'Profil'),
          ],
          labelColor: Color.fromARGB(255, 138, 38, 63),
          unselectedLabelColor: Colors.grey,
          indicatorColor: Color.fromARGB(255, 83, 45, 126),
        ),
      ),
    );
  }
}

// Layout untuk Tab Beranda
class BerandaTab extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.school, 'label': 'Kegiatan'},
    {'icon': Icons.announcement, 'label': 'Pengumuman'},
    {'icon': Icons.schedule, 'label': 'Jadwal Pelajaran'},
    {'icon': Icons.assignment, 'label': 'Tugas'},
    {'icon': Icons.calendar_today, 'label': 'Kalender Akademik'},
    {'icon': Icons.chat, 'label': 'Forum Diskusi'},
    {'icon': Icons.settings, 'label': 'Pengaturan'},
    {'icon': Icons.help_outline, 'label': 'Bantuan'},
  ];

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of items per row (2 for a larger layout)
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 12.0,
          childAspectRatio: 1.0, // Aspect ratio for more space between items
        ),
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return GestureDetector(
            onTap: () {
              // Handle tap on the menu icon
              print('${item['label']} tapped');
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 4.0,
              shadowColor: Colors.grey.withOpacity(0.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    item['icon'],
                    size: 50.0,
                    color: Color.fromARGB(255, 197, 114, 114),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    item['label'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 34, 34, 34),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


// Layout untuk Tab User
class UsersTab extends StatelessWidget {
  Future<List<User>> fetchUsers() async {
    final response =
        await http.get(Uri.parse('https://reqres.in/api/users?page=2'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      return data.map((user) => User.fromJson(user)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Pengguna'),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
      body: FutureBuilder<List<User>>(
        future: fetchUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final users = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 5,
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          'https://reqres.in/img/faces/${user.id}-image.jpg'),
                    ),
                    title: Text(
                      user.firstName,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 34, 34, 34),
                      ),
                    ),
                    subtitle: Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 83, 45, 126),
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    onTap: () {
                      // Handle tap to open user details
                      print('${user.firstName} tapped');
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}


// Layout untuk Tab Profil
class ProfilTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(
                  'https://instagram.fcgk11-1.fna.fbcdn.net/v/t51.2885-19/451742013_474649248527424_7018256088553611026_n.jpg?stp=dst-jpg_s150x150&_nc_ht=instagram.fcgk11-1.fna.fbcdn.net&_nc_cat=100&_nc_ohc=gotzvOZg7SMQ7kNvgGYkyqa&edm=AEhyXUkBAAAA&ccb=7-5&oh=00_AYAFiLiyIsmhoGlNFCXmFI1jgpp3ZIWgYQVBcXFeAIXREw&oe=66CDF1F3&_nc_sid=8f1549'), // Ganti dengan path gambar profil
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              'Nelva Karina',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              'Email: nelvakarina18@gmail.com',
              style: TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 76, 54, 175)),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Informasi Profil',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.school),
            title: Text('Kelas'),
            subtitle: Text('XII RPL 2'),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text('Nomor Telepon'),
            subtitle: Text('089673240951'),
          ),
          ListTile(
            leading: Icon(Icons.cake),
            title: Text('Tanggal Lahir'),
            subtitle: Text('18 Desember 2006'),
          )
        ],
      ),
    );
  }
}

class User {
  final int id;
  final String firstName;
  final String email;

  User({required this.id, required this.firstName, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      email: json['email'],
    );
  }
}
