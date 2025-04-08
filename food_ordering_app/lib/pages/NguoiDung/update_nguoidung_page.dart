import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:food_ordering_app/api/api_nguoidung.dart';
import 'package:food_ordering_app/models/NguoiDung.dart';
import 'package:intl/intl.dart';

class UpdateNguoiDungPage extends StatefulWidget {
  final NguoiDung nguoiDung;
  const UpdateNguoiDungPage({Key? key, required this.nguoiDung})
    : super(key: key);

  @override
  State<UpdateNguoiDungPage> createState() => _UpdateNguoiDungPageState();
}

class _UpdateNguoiDungPageState extends State<UpdateNguoiDungPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final ApiNguoiDung _api = ApiNguoiDung();

  Future<void> updateData() async {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng kiểm tra lại thông tin')),
      );
      return;
    }

    final data = _formKey.currentState!.value;
    final updated = NguoiDung(
      maNguoiDung: widget.nguoiDung.maNguoiDung,
      tenDangNhap: data['tenDangNhap'],
      matKhau: data['matKhau'],
      hoTen: data['hoTen'],
      email: data['email'],
      soDienThoai: data['soDienThoai'],
      diaChi: data['diaChi'],
      ngayTao: data['ngayTao'],
    );

    try {
      final response = await _api.updateNguoiDung(
        maNguoiDung: widget.nguoiDung.maNguoiDung,
        nguoiDung: updated,
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Thành công')));
        Navigator.pop(context, true);
      } else {
        throw Exception('Status code: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Thất bại: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cập nhật người dùng'),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: FormBuilder(
            key: _formKey,
            initialValue: {
              'tenDangNhap': widget.nguoiDung.tenDangNhap,
              'matKhau': widget.nguoiDung.matKhau,
              'hoTen': widget.nguoiDung.hoTen,
              'email': widget.nguoiDung.email,
              'soDienThoai': widget.nguoiDung.soDienThoai,
              'diaChi': widget.nguoiDung.diaChi,
              'ngayTao': widget.nguoiDung.ngayTao,
            },
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
                  format: DateFormat('dd-MM-yyyy'),
                  validator: FormBuilderValidators.required(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: updateData,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Text('Cập nhật', style: TextStyle(fontSize: 16)),
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
