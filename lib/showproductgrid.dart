import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Method หลักที่ Run
void main() {
  runApp(MyApp());
}

// Class stateless สั่งแสดงผลหน้าจอ
class MyApp extends StatelessWidget {
  const MyApp({super.key});
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: showproductgrid(),
    );
  }
}

// Class stateful เรียกใช้การทำงานแบบโต้ตอบ
class showproductgrid extends StatefulWidget {
  @override
  State<showproductgrid> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<showproductgrid> {
// สร้าง reference ไปยัง Firebase Realtime Database
  DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
  List<Map<String, dynamic>> products = [];

  Future<void> fetchProducts() async {
    try {
      final query = dbRef.orderByChild('category').equalTo('Book');
      // ดึงข้อมูลจาก Realtime Database
      final snapshot = await dbRef.get();
      if (snapshot.exists) {
        List<Map<String, dynamic>> loadedProducts = [];
        // วนลูปเพื่อแปลงข้อมูลเป็น Map
        snapshot.children.forEach((child) {
          Map<String, dynamic> product =
              Map<String, dynamic>.from(child.value as Map);
          product['key'] =
              child.key; // เก็บ key สำหรับการอ้างอิง (เช่นการแก้ไข/ลบ)
          loadedProducts.add(product);
        });
        // **เรียงลำดับข้อมูลตามราคา จากมากไปน้อย**
        loadedProducts.sort((a, b) => b['price'].compareTo(a['price']));
        // อัปเดต state เพื่อแสดงข้อมูล
        setState(() {
          products = loadedProducts;
        });
        print(
            "จำนวนรายการสินค้าทั้งหมด: ${products.length} รายการ"); // Debugging
      } else {
        print("ไม่พบรายการสินค้าในฐานข้อมูล"); // กรณีไม่มีข้อมูล
      }
    } catch (e) {
      print("Error loading products: $e"); // แสดงข้อผิดพลาดทาง Console
      // แสดง Snackbar เพื่อแจ้งเตือนผู้ใช้
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts(); // เรียกใช้เมื่อ Widget ถูกสร้าง
  }

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  //ฟังก์ชันที่ใช้ลบ
  void deleteProduct(String key, BuildContext context) {
//คําสั่งลบโดยอ้างถึงตัวแปร dbRef ที่เชือมต่อตาราง product ไว้
    dbRef.child(key).remove().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบสินค้าเรียบร้อย')),
      );
      fetchProducts();
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    });
  }

  //ฟังก์ชันถามยืนยันก่อนลบ
  void showDeleteConfirmationDialog(String key, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // ป้องกันการปิ ด Dialog โดยการแตะนอกพื้นที่
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('ยืนยันการลบ'),
          content: Text('คุณแน่ใจว่าต้องการลบสินค้านี้ใช่หรือไม่?'),
          actions: [
// ปุ่ มยกเลิก
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
              },
              child: Text('ไม่ลบ'),
            ),
// ปุ่ มยืนยันการลบ
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // ปิ ด Dialog
                deleteProduct(key, context); // เรียกฟังก์ชันลบข้อมูล
//ข้อความแจ้งว่าลบเรียบร้อย
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('ลบข้อมูลเรียบร้อยแล้ว'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: Text('ลบ', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  //ฟังก์ชันแสดง AlertDialog หน้าจอเพื่อแก้ไขข้อมูล
  //ฟังก์ชันแสดง AlertDialog หน้าจอเพื่อแก้ไขข้อมูล
  void showEditProductDialog(Map<String, dynamic> product) {
    // Initialize controllers with existing data
    TextEditingController nameController =
        TextEditingController(text: product['name']);
    TextEditingController descriptionController =
        TextEditingController(text: product['description']);
    TextEditingController priceController =
        TextEditingController(text: product['price'].toString());
    TextEditingController categoryController =
        TextEditingController(text: product['category'].toString());
    TextEditingController quantityController =
        TextEditingController(text: product['quantity'].toString());

    // Format the production date to the desired format
    DateTime productionDate = DateTime.parse(product['productionDate']);
    TextEditingController productionDateController = TextEditingController(
        text: DateFormat('dd-MMMM-yyyy').format(productionDate));

    // Create the dialog
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('แก้ไขข้อมูลสินค้า'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'รายละเอียด'),
                ),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'ราคา'),
                ),
                TextField(
                  controller: categoryController,
                  decoration: InputDecoration(labelText: 'ประเภทสินค้า'),
                ),
                TextField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'จำนวน'),
                ),
                TextField(
                  controller: productionDateController,
                  decoration: InputDecoration(labelText: 'วันที่ผลิต'),
                  readOnly: true, // Make it read-only as we format it manually
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                // Prepare the updated data
                Map<String, dynamic> updatedData = {
                  'name': nameController.text,
                  'description': descriptionController.text,
                  'price': int.parse(priceController.text),
                  'category': categoryController.text,
                  'quantity': int.parse(quantityController.text),
                  'productionDate': DateFormat('yyyy-MM-dd')
                      .format(productionDate), // Store the date in the database
                };

                // Update the database
                dbRef.child(product['key']).update(updatedData).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('แก้ไขข้อมูลเรียบร้อย')),
                  );
                  fetchProducts(); // Reload the data
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $error')),
                  );
                });
                Navigator.of(dialogContext).pop(); // Close dialog
              },
              child: Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  // ส่วนการออกแบบหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการสินค้า'),
        backgroundColor:
            Colors.yellow, // เปลี่ยนสีพื้นหลังของ AppBar เป็นสีเหลือง
        foregroundColor:
            Colors.black, // เปลี่ยนสีข้อความและไอคอนใน AppBar เป็นสีดำ
      ),
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // จำนวนคอลัมน์ 2 คอลัมน์
                crossAxisSpacing: 8.0, // ระยะห่างระหว่างคอลัมน์
                mainAxisSpacing: 8.0, // ระยะห่างระหว่างแถว
                childAspectRatio: 2 / 1.7, // อัตราส่วนของแต่ละไอเท็ม
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  color: Colors.white, // ตั้งสีพื้นหลังของ Card เป็นสีขาว
                  elevation: 4, // เพิ่มเงาให้ Card
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8.0), // ทำขอบ Card ให้โค้งมน
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                        8.0), // เพิ่ม Padding รอบๆ เนื้อหาใน Card
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // แสดงชื่อสินค้า
                        Text(
                          product['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // เปลี่ยนสีข้อความให้เป็นสีดำ
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        // แสดงรายละเอียดสินค้า
                        Text(
                          'รายละเอียด: ${product['description']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black, // เปลี่ยนสีข้อความให้เป็นสีดำ
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4),
                        // แสดงวันที่ผลิต
                        Text(
                          'วันที่ผลิต: ${formatDate(product['productionDate'])}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black, // เปลี่ยนสีข้อความให้เป็นสีดำ
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        // แสดงราคา
                        Text(
                          'ราคา: ${product['price']} บาท',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // เปลี่ยนสีข้อความให้เป็นสีดำ
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center, // จัดปุ่มทั้งสองให้อยู่ตรงกลางแนวนอน
                          children: [
                            Container(
                              width: 40, // กำหนดขนาดของปุ่มวงกลม
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.red[50], // พื้นหลังสีแดงอ่อน
                                shape: BoxShape.circle, // รูปทรงวงกลม
                              ),
                              child: IconButton(
                                onPressed: () {
                                  // กดปุ่มแก้ไข
                                  showEditProductDialog(
                                      product); // เปิด Dialog แก้ไขสินค้า
                                },
                                icon: Icon(Icons.edit),
                                color: Colors.red, // สีของไอคอน
                                iconSize: 20, // ขนาดของไอคอน
                                tooltip: 'แก้ไขสินค้า',
                              ),
                            ),
                            SizedBox(width: 20), // เพิ่มระยะห่างระหว่างปุ่ม
                            Container(
                              width: 40, // กำหนดขนาดของปุ่มวงกลม
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.red[50], // พื้นหลังสีแดงอ่อน
                                shape: BoxShape.circle, // รูปทรงวงกลม
                              ),
                              child: IconButton(
                                onPressed: () {
                                  // กดปุ่มลบ
                                },
                                icon: Icon(Icons.delete),
                                color: Colors.red, // สีของไอคอน
                                iconSize: 20, // ขนาดของไอคอน
                                tooltip: 'ลบสินค้า',
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
