import 'package:form_field_validator/form_field_validator.dart';

final userNameValidator =
    MultiValidator([RequiredValidator(errorText: 'Username name is required')]);

final emailValidator =
    MultiValidator([RequiredValidator(errorText: 'Email name is required')]);

final phoneValidator =
    MultiValidator([RequiredValidator(errorText: 'Phone number is required')]);

final otpValidator =
    MultiValidator([RequiredValidator(errorText: 'Otp is required')]);
//
// final creatorValidator =
//     MultiValidator([RequiredValidator(errorText: 'Creator name is required')]);
//
// final creatorValidator =
//     MultiValidator([RequiredValidator(errorText: 'Creator name is required')]);
//
// final creatorValidator =
//     MultiValidator([RequiredValidator(errorText: 'Creator name is required')]);
