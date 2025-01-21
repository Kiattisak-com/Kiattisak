import 'package:flutter/material.dart';

// รับข้อมูลสินค้าที่ส่งมา
class productdetail extends StatelessWidget {
  final Map<String, dynamic> product;

  productdetail({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 10), // เว้นระยะระหว่างไอคอนกับข้อความ
              Text(
                product['name'], // ใช้ชื่อสินค้าแทน "MENU MAIN"
                style: TextStyle(
                  color: const Color.fromARGB(
                      255, 0, 0, 0), // เปลี่ยนสีข้อความเป็นสีขาว
                  fontWeight: FontWeight.bold, // เพิ่มน้ำหนักตัวอักษร
                  letterSpacing: 1.5, // เพิ่มระยะห่างระหว่างตัวอักษร
                ),
              ),
            ],
          ),
          centerTitle: true, // จัดตำแหน่งข้อความตรงกลาง
          backgroundColor: Colors.yellow, // กำหนดสีพื้นหลัง
          elevation: 5, // เพิ่มเงาให้ AppBar
          toolbarHeight: 70, // กำหนดความสูงของ AppBar
          iconTheme: IconThemeData(
              color: const Color.fromARGB(255, 0, 0, 0)), // เปลี่ยนสีไอคอน
        ),
        body: Padding(
          padding: const EdgeInsets.all(0.0), // Remove any padding on the edges
          child: Scaffold(
            backgroundColor: Colors
                .white, // Set background color to white for the entire screen
            body: Padding(
              padding: const EdgeInsets.all(
                  16.0), // Padding inside the container to prevent it from touching the edges
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Set background color to white
                  borderRadius: BorderRadius.all(
                      Radius.circular(8.0)), // Optional: rounded corners
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                      16.0), // Padding inside the container
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ชื่อสินค้า: ${product['name']}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'รายละเอียด: ${product['description']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'ราคา: ${product['price']} บาท',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'จำนวน: ${product['quantity']} ชิ้น',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
