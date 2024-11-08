import 'package:flutter/material.dart';

void main() {
  runApp(const EBankApp());
}

class EBankApp extends StatelessWidget {
  const EBankApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EBANK',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 22), 
          bodyLarge: TextStyle(fontSize: 18), 
          bodyMedium: TextStyle(fontSize: 16),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EBANK Login')),
      body: Center(
        child: CustomButton(
          text: 'Go to Dashboard',
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const Dashboard(),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EBANK Dashboard')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SendMoneyPage(),
      ),
    );
  }
}

class SendMoneyPage extends StatefulWidget {
  const SendMoneyPage({Key? key}) : super(key: key);

  @override
  _SendMoneyPageState createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  final _formKey = GlobalKey<FormState>();
  final _recipientController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedPaymentMethod;
  bool _isFavorite = false;
  bool _showSuccessMessage = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Send Money',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _recipientController,
              label: 'Recipient Name',
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter the recipient name';
                return null;
              },
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _amountController,
              label: 'Amount',
              validator: (value) {
                if (value == null || value.isEmpty || double.tryParse(value)! <= 0) {
                  return 'Please enter a positive amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedPaymentMethod,
              items: ['Bank Transfer', 'Mobile Money', 'Credit Card']
                  .map((method) => DropdownMenuItem(
                        value: method,
                        child: Text(method),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Payment Method'),
              validator: (value) => value == null ? 'Please select a payment method' : null,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Mark as Favorite'),
                Switch(
                  value: _isFavorite,
                  onChanged: (value) {
                    setState(() {
                      _isFavorite = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Send Money',
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _showSuccessMessage = true;
                  });
                }
              },
            ),
            AnimatedOpacity(
              opacity: _showSuccessMessage ? 1.0 : 0.0,
              duration: const Duration(seconds: 1),
              child: const Text(
                'Transaction Successful!',
                style: TextStyle(color: Colors.green, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({Key? key, required this.text, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        textStyle: const TextStyle(fontSize: 16),
        backgroundColor: Colors.blue,
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: validator,
    );
  }
}
