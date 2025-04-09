import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:food_ordering_app/const/colors.dart';
import 'package:food_ordering_app/widgets/customNavBar.dart';
import 'package:food_ordering_app/models/NguoiDung.dart';
import 'package:food_ordering_app/api/api_nguoidung.dart';
import 'package:food_ordering_app/utils/helper.dart';
import 'package:food_ordering_app/utils/notification_util.dart';

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

  void updateData() async {
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
      ngayTao:
          data['ngayTao'] is String
              ? DateFormat('dd-MM-yyyy').parse(data['ngayTao'])
              : data['ngayTao'],
    );

    try {
      final response = await _api.updateNguoiDung(
        maNguoiDung: widget.nguoiDung.maNguoiDung,
        nguoiDung: updated,
      );

      if (!mounted) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        NotificationUtil.showSuccessMessage(
          context,
          'Thành công!',
          onComplete: () {
            if (context.mounted) {
              Navigator.pop(context, true);
            }
          },
        );
      }
    } catch (e) {
      NotificationUtil.showErrorMessage(
        context,
        'Thất bại!',
        onComplete: () {
          if (context.mounted) {
            Navigator.pop(context, true);
          }
        },
      );
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontSize: 16, color: AppColor.primary),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColor.placeholder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: AppColor.orange, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
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
                children: [
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
                            "Cập nhật người dùng",
                            style: Helper.getTheme(context).headlineMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  FormBuilder(
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
                          decoration: _inputDecoration('Tên đăng nhập'),
                          validator: FormBuilderValidators.required(
                            errorText: 'Vui lòng nhập tên đăng nhập',
                          ),
                        ),
                        const SizedBox(height: 16),
                        FormBuilderTextField(
                          name: 'matKhau',
                          decoration: _inputDecoration('Mật khẩu'),
                          obscureText: true,
                          validator: FormBuilderValidators.required(
                            errorText: 'Vui lòng nhập mật khẩu',
                          ),
                        ),
                        const SizedBox(height: 16),
                        FormBuilderTextField(
                          name: 'hoTen',
                          decoration: _inputDecoration('Họ và tên'),
                          validator: FormBuilderValidators.required(
                            errorText: 'Vui lòng nhập họ và tên',
                          ),
                        ),
                        const SizedBox(height: 16),
                        FormBuilderTextField(
                          name: 'email',
                          decoration: _inputDecoration('Email'),
                          keyboardType: TextInputType.emailAddress,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: 'Vui lòng nhập email',
                            ),
                            FormBuilderValidators.email(
                              errorText: 'Email không hợp lệ',
                            ),
                          ]),
                        ),
                        const SizedBox(height: 16),
                        FormBuilderTextField(
                          name: 'soDienThoai',
                          decoration: _inputDecoration('Số điện thoại'),
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
                        const SizedBox(height: 16),
                        FormBuilderTextField(
                          name: 'diaChi',
                          decoration: _inputDecoration('Địa chỉ'),
                          validator: FormBuilderValidators.required(
                            errorText: 'Vui lòng nhập địa chỉ',
                          ),
                        ),
                        const SizedBox(height: 16),
                        FormBuilderDateTimePicker(
                          name: 'ngayTao',
                          decoration: _inputDecoration('Ngày tạo'),
                          inputType: InputType.date,
                          format: DateFormat('dd-MM-yyyy'),
                          validator: FormBuilderValidators.required(
                            errorText: 'Vui lòng chọn ngày',
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: updateData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Cập nhật',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar(home: true),
    );
  }
}
