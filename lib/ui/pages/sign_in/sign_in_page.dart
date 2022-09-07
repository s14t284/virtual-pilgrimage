import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:virtualpilgrimage/model/form_model.codegen.dart';
import 'package:virtualpilgrimage/ui/components/my_text_form_field.dart';
import 'package:virtualpilgrimage/ui/pages/sign_in/sign_in_presenter.dart';
import 'package:virtualpilgrimage/ui/style/color.dart';
import 'package:virtualpilgrimage/ui/style/font.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SignInPageBody(ref),
    );
  }
}

class SignInPageBody extends StatelessWidget {
  const SignInPageBody(this.ref, {super.key});

  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(signInPresenterProvider.notifier);
    final state = ref.watch(signInPresenterProvider);

    return Builder(
      builder: (context) {
        return SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 40),
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      await notifier.signInWithEmailAndPassword();
                    },
                    // ボタンを押したときの色
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      onPrimary: Theme.of(context).primaryColorDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(
                        fontSize: FontStyle.mediumSize,
                        // TODO(s14t284): custom font を導入
                        // ref. https://zenn.dev/susatthi/articles/20220419-143426-flutter-custom-fonts
                        // fontFamily: ""
                      ),
                      padding: const EdgeInsets.all(10),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text(
                        'アカウント作成',
                        style: TextStyle(color: ColorStyle.text),
                      )
                    ),
                  ),ElevatedButton(
                        onPressed: () async {
                          await notifier.signInWithEmailAndPassword();
                        },
                        // ボタンを押したときの色
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                          onPrimary: Theme.of(context).primaryColorDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          textStyle: const TextStyle(
                            fontSize: FontStyle.mediumSize,
                            // TODO(s14t284): custom font を導入
                            // ref. https://zenn.dev/susatthi/articles/20220419-143426-flutter-custom-fonts
                            // fontFamily: ""
                          ),
                          padding: const EdgeInsets.all(10),
                        ),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            alignment: Alignment.center,
                            child: Text(
                              'ログイン',
                              style: TextStyle(color: ColorStyle.text),
                            )
                        ),
                      )
                /*
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'または',
                    style: TextStyle(
                      fontSize: FontStyle.mediumSize,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    right: 8,
                    left: 8,
                    bottom: 8,
                  ),
                  child: Center(
                    child: SignInButton(
                      Buttons.GoogleDark,
                      text: 'Google でサインイン',
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () async {
                        await notifier.signInWithGoogle();
                      },
                    ),
                  ),
                )*/
                    ]
                )
            )
        );
      },
    );
  }
  Widget _createTextFormField(
    FormModel formModel,
    ValueChanged<FormModel> onChanged,
    InputDecoration decoration, [
    bool obsecureText = false,
  ]) {
    return MyTextFormField(
      formModel: formModel,
      onChanged: onChanged,
      decoration: decoration,
      obscureText: obsecureText,
    );
  }

  InputDecoration _inputDecorationBuilder(
    BuildContext context,
    String hintText,
    Icon icon,
  ) {
    return InputDecoration(
      filled: true,
      fillColor: ColorStyle.white,
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Theme.of(context).unselectedWidgetColor,
          width: 2,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 2,
        ),
      ),
      prefixIcon: icon,
    );
  }
}
