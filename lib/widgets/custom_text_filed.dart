// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:translator_app/config/presentation/app_color.dart';

// class CustomTextField extends StatelessWidget {
//   final TextEditingController? textEditingController;
//   final bool isEnable;
//   final bool readOnly;
//   final String fieldTitle;
//   final String hintText;
//   final Function(String)? onChanged;
//   final Function(String)? onFieldSubmitted;
//   final GestureTapCallback? onTap;
//   final List<TextInputFormatter>? inputFormatters;
//   final TextInputType keyboardType;

//   const CustomTextField({
//     Key? key,
//     this.textEditingController,
//     this.isEnable = true,
//     this.readOnly = false,
//     required this.fieldTitle,
//     required this.hintText,
//     this.onChanged,
//     this.onFieldSubmitted,
//     this.onTap,
//     this.keyboardType = TextInputType.number,
//     this.inputFormatters,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: SizedBox(
//         width: double.infinity,
//         height: 40,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 fieldTitle,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             // const SizedBox(width: 50),
//             Expanded(
//               child: SizedBox(
//                 width: 50,
//                 child: TextFormField(
//                   controller: textEditingController,
//                   inputFormatters: inputFormatters,
//                   textAlign: TextAlign.center,
//                   enabled: isEnable,
//                   readOnly: readOnly,
//                   keyboardType: keyboardType,
//                   onChanged: (value) {
//                     if (onChanged != null) onChanged!(value);
//                   },
//                   onFieldSubmitted: (value) {
//                     if (onFieldSubmitted != null) onFieldSubmitted!(value);
//                   },
//                   onTap: onTap,
//                   decoration: InputDecoration(
//                     contentPadding: const EdgeInsets.all(10),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(8.0),
//                       borderSide: BorderSide.none,
//                     ),
//                     filled: true,
//                     hintStyle: const TextStyle(color: AppColor.greyColor),
//                     hintText: hintText,
//                     fillColor: AppColor.lightGreyColor,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

import '../config/presentation/app_color.dart';

class CustomTextField extends StatelessWidget {
  final String placeholderText;
  final TextEditingController textEditingController;
  final bool readOnly;
  final bool obscureText;
  final Color textColor;
  final TextInputType keyboardType;

  const CustomTextField({
    Key? key,
    required this.placeholderText,
    required this.textEditingController,
    this.readOnly = false,
    this.obscureText = false,
    this.textColor = AppColor.textColor,
    this.keyboardType = TextInputType.multiline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: textEditingController,
        validator: (value) => value!.isEmpty ? '* required' : null,
        readOnly: readOnly,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: 10,
        decoration: InputDecoration(
          labelText: placeholderText,
          labelStyle: TextStyle(
            color: textColor,
            fontSize: 15,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color: AppColor.greyColor,
              width: 1,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: const BorderSide(
              color: AppColor.borderColor,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}