import 'package:flutter/material.dart';
import 'showfiltertype.dart';

class showproducttype extends StatefulWidget {
  @override
  State<showproducttype> createState() => _ShowProductTypeState();
}

class _ShowProductTypeState extends State<showproducttype> {
  Widget categoryButton(String category, IconData icon) {
    return ElevatedButton(
      onPressed: () {
        // เปิดหน้า ShowFilterType พร้อมส่งหมวดหมู่
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowFilterType(category: category),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        minimumSize: Size(120, 120),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        backgroundColor: Colors.yellow,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            category,
            style: TextStyle(
                fontSize: 16, color: const Color.fromARGB(255, 0, 0, 0)),
          ),
          SizedBox(height: 8),
          Icon(icon, size: 30, color: const Color.fromARGB(255, 0, 0, 0)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประเภทสินค้า'),
        backgroundColor:
            Colors.yellow, // เปลี่ยนสีพื้นหลังของ AppBar เป็นสีเหลือง
        foregroundColor:
            Colors.black, // เปลี่ยนสีข้อความและไอคอนใน AppBar เป็นสีดำ
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(4.0), // Reduced padding for a smaller grid
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4.0, // Reduced cross-axis spacing
            mainAxisSpacing: 4.0, // Reduced main-axis spacing
            childAspectRatio:
                1.2, // Adjusted aspect ratio to make items smaller
          ),
          shrinkWrap: true,
          itemCount: 4,
          itemBuilder: (context, index) {
            String category;
            IconData icon;
            switch (index) {
              case 0:
                category = 'Electronics';
                icon = Icons.electric_car;
                break;
              case 1:
                category = 'Clothing';
                icon = Icons.checkroom;
                break;
              case 2:
                category = 'Food';
                icon = Icons.fastfood;
                break;
              case 3:
                category = 'Books';
                icon = Icons.book;
                break;
              default:
                category = 'Other';
                icon = Icons.help;
            }
            return categoryButton(category, icon);
          },
        ),
      ),
    );
  }
}
