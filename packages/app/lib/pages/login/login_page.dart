import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tedbook/pages/home/bloc/home_bloc.dart';
import 'package:tedbook/pages/home/home_page.dart';
import 'package:tedbook/pages/login/bloc/login_bloc.dart';
import 'package:tedbook/persistance/base_status.dart';
import 'package:tedbook/persistance/text_style_const.dart';
import 'package:tedbook/utils/navigator_extension.dart';
import 'package:tedbook/utils/size_context_extension.dart';
import 'package:tedbook/utils/utils.dart';
import 'package:tedbook/widgets/custom_button.dart';
import 'package:tedbook/widgets/custom_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginBloc bloc;
  FocusNode _loginFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();

  @override
  void initState() {
    bloc = context.read<LoginBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugLog("\nscreenWidth: ${screenWidth}\nscreenHeight: ${screenHeight}");

    return BlocListener<LoginBloc, LoginState>(
      listener: (_, state) {
        if (state.loginStatus.type == StatusType.success) {
          pushAndRemoveAllWithBloc(HomePage(), HomeBloc());
        } else if (state.loginStatus.type == StatusType.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              dismissDirection: DismissDirection.none,
              padding: EdgeInsets.zero,
              margin: const EdgeInsets.only(bottom: 15),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
              content: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xff656565),
                  ),
                  child: Text(state.loginStatus.message?.text ?? ""),
                ),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        body: _body,
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
      ),
    );
  }

  Widget get _body => Stack(
        children: [
          SizedBox(height: screenHeight),
          Image(
            image: AssetImage("assets/images/login_back.webp"),
            fit: BoxFit.cover,
          ),
          Container(
            height: screenHeight * 0.4,
            alignment: Alignment.center,
            child: SvgPicture.asset("assets/images/logo_text.svg"),
          ),
          if (!_loginFocus.hasFocus && !_passwordFocus.hasFocus)
            Positioned(
              left: 0,
              right: 0,
              bottom: 24,
              // padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                "© TEDBOOK Kompaniyasi 2021",
                style: TextStyleS.s12w500(),
                textAlign: TextAlign.center,
              ),
            ),
          _mainUi,
        ],
      );

  Widget get _mainUi => SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 56),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.48),
            _textInputFields,
            const SizedBox(height: 21),
            _loginButton,
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      );

  Widget get _textInputFields => Column(
        children: [
          CustomTextField(
            controller: bloc.loginCtrl,
            focusNode: _loginFocus,
            hintText: "Логин",
            height: 60,
          ),
          const SizedBox(height: 13),
          CustomTextField(
            controller: bloc.passwordCtrl,
            focusNode: _passwordFocus,
            hintText: "Пароль",
            height: 60,
            inputAction: TextInputAction.done,
          ),
        ],
      );

  Widget get _loginButton => BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) =>
            previous.loginStatus.type != current.loginStatus.type,
        builder: (_, state) {
          return CustomButton(
            text: "Войти",
            isLoading: state.loginStatus.type == StatusType.loading,
            onTap: () => bloc.add(LoginCheckEvent()),
          );
        },
      );
}
