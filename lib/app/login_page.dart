import 'package:flutter/material.dart';
import 'package:info_cash/app/home_copy.dart'; // Импортируйте главную страницу после успешного входа
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();
  bool _isSmsCodeVisible = false;
  bool _isLoading = false;

  // Создаем маску для номера телефона
  final _phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+7 ### ### - ## - ##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  void _authenticate() async {
    setState(() {
      _isLoading = true;
    });

    // Симуляция отправки кода и авторизации
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _isSmsCodeVisible = true; // Показываем поле для ввода кода из SMS
    });
  }

  void _verifySmsCode() async {
    setState(() {
      _isLoading = true;
    });

    // Симуляция проверки кода из SMS
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // После успешной авторизации перенаправляем на главную страницу
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage2()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Авторизация',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                inputFormatters: [_phoneMaskFormatter], // Применяем маску
                decoration: InputDecoration(
                  labelText: 'Номер телефона',
                  hintText: '+7 777 777 - 77 - 77',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 20),
              if (_isSmsCodeVisible)
                Column(
                  children: [
                    TextField(
                      controller: _smsCodeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Код из SMS',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        prefixIcon: const Icon(Icons.message),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : _isSmsCodeVisible
                        ? _verifySmsCode
                        : _authenticate,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        _isSmsCodeVisible ? 'Подтвердить' : 'Авторизоваться',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
