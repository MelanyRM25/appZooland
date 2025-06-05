import 'package:flutter/material.dart';

class NavItem {
  final IconData icon;
  final String label;

  NavItem({required this.icon, required this.label});
}

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final List<NavItem> items;
  final Function(int) onItemTap;
  final Color activeColor;
  final Color inactiveColor;
  final Color backgroundColor;

  const Navbar({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onItemTap,
    this.activeColor = Colors.cyan,
    this.inactiveColor = Colors.grey,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    assert(items.length == 4, 'Se requieren 4 ítems');

    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: backgroundColor,
      elevation: 10,
      child: SizedBox(
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTab(0, items[0]),
            _buildTab(1, items[1]),
            const SizedBox(width: 48), // espacio para FAB
            _buildTab(2, items[2]),
            _buildTab(3, items[3]),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(int index, NavItem item) {
    final selected = index == selectedIndex;
    final color = selected ? activeColor : inactiveColor;

    return GestureDetector(
      onTap: () => onItemTap(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, color: color),
            Text(item.label, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
