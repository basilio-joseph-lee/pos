import 'package:flutter/material.dart';
import 'package:pos/components/contents/Store_page.dart';
import 'package:pos/components/contents/User.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  int selectedIndex = 0;

  final List<Widget> contents = [StorePage(), User()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromARGB(255, 4, 160, 144),
              ),
              width: 200,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  // Avatar
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipOval(
                        child: Image.asset(
                          "assets/images/jihyo.jpg",
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Park Jihyo",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Menu items
                  _menuItem("Store", Icons.store, 0),
                  _menuItem("User", Icons.person, 1),
                ],
              ),
            ),
          ),

          // Vertical divider
          const VerticalDivider(width: 1),

          Expanded(
            child: Column(
              children: [
                // Fixed header
                Container(
                  width: double.infinity,

                  margin: EdgeInsets.all(20),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    "POS (Point of Sales) v3.0",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                // Page content
                Expanded(child: contents[selectedIndex]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(String title, IconData icon, int index) {
    bool isSelected = selectedIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        color: isSelected ? Colors.teal[700] : Colors.transparent,
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Text(title, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
