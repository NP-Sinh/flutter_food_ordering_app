import 'package:flutter/material.dart';
import 'package:food_ordering_app/api/api_nguoidung.dart';
import 'package:food_ordering_app/models/NguoiDung.dart';
import 'package:food_ordering_app/pages/NguoiDung/nguoidung_page.dart';
import 'package:food_ordering_app/screens/forgetPwScreen.dart';
import 'package:food_ordering_app/screens/signUpScreen.dart';
import 'package:food_ordering_app/utils/helper.dart';
import 'package:food_ordering_app/widgets/customTextInput.dart';
import 'package:food_ordering_app/const/colors.dart';
import 'package:food_ordering_app/screens/homeScreen.dart';

class Login extends StatefulWidget {
  static const routeName = "/login";

  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final ApiNguoiDung _apiNguoiDung = ApiNguoiDung();

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      try {
        final List<NguoiDung> users = await _apiNguoiDung.getNguoiDungData();

        final NguoiDung? matchedUser = users.firstWhere(
          (user) => user.tenDangNhap == username && user.matKhau == password,
        );

        if (matchedUser != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => NguoiDungPage()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Đăng nhập thất bại! Vui lòng kiểm tra lại thông tin.",
            ),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Helper.getScreenHeight(context),
        width: Helper.getScreenWidth(context),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Đăng nhập",
                    style: Helper.getTheme(context).headlineSmall,
                  ),
                  const Spacer(),
                  const Text(''),
                  const Spacer(),
                  CustomTextInput(
                    hintText: "Tên đăng nhập",
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Vui lòng nhập tên đăng nhập";
                      }
                      return null;
                    },
                  ),
                  const Spacer(),
                  CustomTextInput(
                    hintText: "Mật khẩu",
                    controller: _passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Vui lòng nhập mật khẩu";
                      }
                      return null;
                    },
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      child: const Text("Đăng nhập"),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(ForgetPwScreen.routeName);
                    },
                    child: const Text("Bạn quên mật khẩu?"),
                  ),
                  const Spacer(flex: 2),
                  const Text("hoặc Đăng nhập với"),
                  const Spacer(),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xFF367FC0),
                        ),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(Helper.getAssetName("fb.png", "virtual")),
                          const SizedBox(width: 30),
                          const Text("Đăng nhập với Facebook"),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color(0xFFDD4B39),
                        ),
                      ),
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Helper.getAssetName("google.png", "virtual"),
                          ),
                          const SizedBox(width: 30),
                          const Text("Đăng nhập với Google"),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(flex: 4),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(
                        context,
                      ).pushReplacementNamed(SignUpPage.routeName);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Không có tài khoản?"),
                        Text(
                          "Đăng ký",
                          style: TextStyle(
                            color: AppColor.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
