import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:food_ordering_app/api/api_nguoidung.dart';
import 'package:food_ordering_app/models/NguoiDung.dart';
import 'package:intl/intl.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final ApiNguoiDung _api = ApiNguoiDung();

  Future<void> registerUser() async {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng kiểm tra lại thông tin')),
      );
      return;
    }

    final data = _formKey.currentState!.value;

    final newUser = NguoiDung(
      maNguoiDung: 0,
      tenDangNhap: data['tenDangNhap'],
      matKhau: data['matKhau'],
      hoTen: data['hoTen'],
      email: data['email'],
      soDienThoai: data['soDienThoai'],
      diaChi: data['diaChi'],
      ngayTao: data['ngayTao'],
    );

    try {
      final response = await _api.createNguoiDung(nguoiDung: newUser);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đăng ký thành công')));
        Navigator.pop(context, true);
      } else {
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đăng ký thất bại: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Đăng ký"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: FormBuilder(
            key: _formKey,
            initialValue: {'ngayTao': DateTime.now()},
            child: Column(
              children: [
                FormBuilderTextField(
                  name: 'tenDangNhap',
                  decoration: const InputDecoration(labelText: 'Tên đăng nhập'),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 12),
                FormBuilderTextField(
                  name: 'matKhau',
                  decoration: const InputDecoration(labelText: 'Mật khẩu'),
                  obscureText: true,
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 12),
                FormBuilderTextField(
                  name: 'hoTen',
                  decoration: const InputDecoration(labelText: 'Họ và tên'),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 12),
                FormBuilderTextField(
                  name: 'email',
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(),
                    FormBuilderValidators.email(),
                  ]),
                ),
                const SizedBox(height: 12),
                FormBuilderTextField(
                  name: 'soDienThoai',
                  decoration: const InputDecoration(labelText: 'Số điện thoại'),
                  keyboardType: TextInputType.phone,
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(
                      errorText: 'Vui lòng nhập số điện thoại',
                    ),
                    FormBuilderValidators.match(
                      RegExp(r'^\+?\d{7,15}$'),
                      errorText: 'Số điện thoại không hợp lệ',
                    ),
                  ]),
                ),
                const SizedBox(height: 12),
                FormBuilderTextField(
                  name: 'diaChi',
                  decoration: const InputDecoration(labelText: 'Địa chỉ'),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 12),
                FormBuilderDateTimePicker(
                  name: 'ngayTao',
                  decoration: const InputDecoration(labelText: 'Ngày tạo'),
                  inputType: InputType.date,
                  format: DateFormat('yyyy-MM-dd'),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: registerUser,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('Đăng ký', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
