import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:virtualpilgrimage/ui/components/atoms/primary_button.dart';
import 'package:virtualpilgrimage/ui/components/atoms/secondary_button.dart';
import 'package:virtualpilgrimage/ui/components/my_app_bar.dart';
import 'package:virtualpilgrimage/ui/components/my_text_form_field.dart';
import 'package:virtualpilgrimage/ui/model/form_model.codegen.dart';
import 'package:virtualpilgrimage/ui/pages/sign_in/sign_in_presenter.dart';
import 'package:virtualpilgrimage/ui/pages/sign_in/sign_in_state.codegen.dart';
import 'package:virtualpilgrimage/ui/style/font.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const MyAppBar(isLogin: false),
      body: _SignInPageBody(ref),
    );
  }
}

class _SignInPageBody extends StatelessWidget {
  const _SignInPageBody(this.ref);

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(signInPresenterProvider.notifier);
    final state = ref.watch(signInPresenterProvider);

    return Builder(
      builder: (context) {
        return ColoredBox(
          color: Theme.of(context).backgroundColor,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                _emailOrNicknameForm(state, notifier),
                _passwordForm(state, notifier),
                _signInButtons(context, notifier),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _emailOrNicknameForm(SignInState state, SignInPresenter notifier) {
    return SizedBox(
      height: 130,
      child: Padding(
        padding: const EdgeInsets.only(left: 12, top: 32, right: 12),
        child: _createTextFormField(
          state.emailOrNickname,
          notifier.onChangeEmail,
          const InputDecoration(
            hintText: '????????????????????? or ??????????????????',
            prefixIcon: Icon(Icons.mail_outline),
          ),
          TextInputType.emailAddress,
        ),
      ),
    );
  }

  Widget _passwordForm(SignInState state, SignInPresenter notifier) {
    return SizedBox(
      height: 130,
      child: Padding(
        padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
        child: _createTextFormField(
          state.password,
          notifier.onChangePassword,
          const InputDecoration(
            hintText: '???????????????',
            prefixIcon: Icon(Icons.password_outlined),
          ),
          // ?????????????????????????????????????????????????????????????????????DB????????????????????????????????????????????????Authentication ??????????????????????????????????????????????????????
          TextInputType.visiblePassword,
          true,
          TextInputAction.done,
        ),
      ),
    );
  }

  Widget _signInButtons(BuildContext context, SignInPresenter notifier) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 10 * 7,
            child: PrimaryButton(
              onPressed: () async => notifier.signInWithEmailAndPassword(),
              text: '?????????????????????????????????????????????',
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: MediaQuery.of(context).size.width / 10 * 7,
            child: SecondaryButton(onPressed: notifier.movePasswordResetPage, text: '?????????????????????????????????'),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Text(
              '?????????',
              style: TextStyle(
                fontSize: FontSize.mediumSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Center(
              child: SignInButton(
                Buttons.GoogleDark,
                text: 'Google ??????????????????',
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onPressed: () async {
                  await notifier.signInWithGoogle();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _createTextFormField(
    FormModel formModel,
    ValueChanged<FormModel> onChanged,
    InputDecoration decoration,
    TextInputType textInputType, [
    bool obsecureText = false,
    TextInputAction inputAction = TextInputAction.next,
  ]) {
    return MyTextFormField(
      formModel: formModel,
      onChanged: onChanged,
      decoration: decoration,
      obscureText: obsecureText,
      textInputType: textInputType,
      inputAction: inputAction,
    );
  }
}
