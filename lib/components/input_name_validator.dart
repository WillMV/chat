import 'package:chat/core/services/user/user_service.dart';
import 'package:flutter/material.dart';

class InputNameValidator extends StatefulWidget {
  final TextEditingController name;
  final void Function(bool isValid) isValidated;

  const InputNameValidator({
    super.key,
    required this.name,
    required this.isValidated,
  });

  @override
  State<InputNameValidator> createState() => _InputNicknameValidatorState();
}

class _InputNicknameValidatorState extends State<InputNameValidator> {
  bool? isValidNick;

  Future<Widget?> selectIconByValidator() async {
    if (widget.name.text.length < 4) return null;

    await nickValidator();

    return isValidNick!
        ? const Icon(
            Icons.check,
            color: Color.fromARGB(120, 29, 134, 33),
          )
        : const Icon(
            Icons.close,
            color: Color.fromARGB(120, 134, 18, 3),
          );
  }

  Future<void> nickValidator() async {
    final bool isValid = await UserService().isValidUserName(widget.name.text);

    setState(() {
      isValidNick = isValid;
    });
    widget.isValidated(isValid);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: (_) {
        setState(() {});
      },
      controller: widget.name,
      decoration: InputDecoration(
        label: const Text('Apelido'),
        suffixIcon: FutureBuilder(
          future: selectIconByValidator(),
          builder: (context, snapshot) =>
              snapshot.data == null ? const Spacer() : snapshot.data!,
        ),
      ),
    );
  }
}
