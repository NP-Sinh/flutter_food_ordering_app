// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:food_ordering_app/api/api_nguoidung.dart';
import 'package:food_ordering_app/models/NguoiDung.dart';
import 'package:food_ordering_app/pages/NguoiDung/update_nguoidung_page.dart';

class NguoidungPage extends StatefulWidget {
  const NguoidungPage({super.key});

  @override
  State<NguoidungPage> createState() => _NguoiDungPageState();
}

class _NguoiDungPageState extends State<NguoidungPage> {
  ApiNguoiDung apiNguoiDung = ApiNguoiDung();

  late List<NguoiDung> data = [];

  void getData() async {
    data = await apiNguoiDung.getNguoiDungData();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Người dùng"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 3, 95, 58),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => UpdateNguoiDungPage(nguoiDung: data[index]),
                ),
              );
              if (result == true) {
                getData();
              }
            },
            leading: Text("${data[index].maNguoiDung}"),
            title: Text("${data[index].hoTen}"),
            subtitle: Text("${data[index].email}"),
          );
        },
      ),
    );
  }
}
