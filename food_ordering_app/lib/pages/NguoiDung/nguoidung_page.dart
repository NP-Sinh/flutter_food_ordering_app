import 'package:flutter/material.dart';
import 'package:food_ordering_app/api/api_nguoidung.dart';
import 'package:food_ordering_app/models/NguoiDung.dart';
import 'package:food_ordering_app/pages/NguoiDung/update_nguoidung_page.dart';
import 'package:food_ordering_app/utils/helper.dart';
import 'package:food_ordering_app/widgets/customNavBar.dart';
import 'package:food_ordering_app/const/colors.dart';

class NguoiDungPage extends StatefulWidget {
  static const routeName = "/nguoiDungPage";
  const NguoiDungPage({super.key});

  @override
  State<NguoiDungPage> createState() => _NguoiDungPageState();
}

class _NguoiDungPageState extends State<NguoiDungPage> {
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
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header tùy chỉnh
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_rounded,
                            color: AppColor.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Danh sách người dùng",
                            style: Helper.getTheme(context).headlineMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Danh sách người dùng
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final nguoiDung = data[index];
                      return GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      UpdateNguoiDungPage(nguoiDung: nguoiDung),
                            ),
                          );
                          if (result == true) {
                            getData();
                          }
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(10),
                            leading: CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(
                                Helper.getAssetName(
                                  "icons8-user-50.png",
                                  "virtual",
                                ),
                              ),
                            ),
                            title: Text(
                              nguoiDung.hoTen,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            subtitle: Text(nguoiDung.email),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavBar(home: true),
    );
  }
}
