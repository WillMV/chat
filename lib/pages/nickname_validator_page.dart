// import 'package:chat/components/input_nickname_validator.dart';
// import 'package:chat/core/models/auth_form_data.dart';
// import 'package:flutter/material.dart';

// class NicknameValidatorPage extends StatefulWidget {
//   final AuthFormData formData;

//   const NicknameValidatorPage({
//     super.key,
//     required this.formData,
//   });

//   @override
//   State<NicknameValidatorPage> createState() => _NicknameValidatorPage();
// }

// class _NicknameValidatorPage extends State<NicknameValidatorPage> {
//   bool isValid = false;

//   void isValidated(bool isValidNick) {
//     setState(() {
//       isValid = isValidNick;
//     });
//   }

//   onSubmit() {
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final nickname = widget.formData.nicknameController;

//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Escolha um apelido único',
//                     style: theme.textTheme.titleLarge,
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     'É por ele que seus amigos vão te encontrar.',
//                     style: theme.textTheme.bodyLarge,
//                   ),
//                   const SizedBox(
//                     height: 50,
//                   ),
//                   InputNicknameValidator(
//                     nickname: nickname,
//                     isValidated: isValidated,
//                   ),
//                 ],
//               ),
//             ),
//             ElevatedButton(
//               onPressed: isValid ? onSubmit : null,
//               child: const Text('Prosseguir'),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
