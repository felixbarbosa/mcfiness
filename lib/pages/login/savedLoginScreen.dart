import 'package:flutter/material.dart';
import 'package:mcfitness/pages/home/home_page_aluno.dart';

class SavedLoginScreen extends StatefulWidget {
  final String userName;
  final String email;
  final String logoURL;

  const SavedLoginScreen({
    required this.userName,
    required this.email,
    required this.logoURL,
    Key? key,
  }) : super(key: key);

  @override
  _SavedLoginScreenState createState() => _SavedLoginScreenState();
}

class _SavedLoginScreenState extends State<SavedLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordCtrl = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                //const WisellLogo(),
                const SizedBox(height: 60.0),
                Text(
                  'Olá novamente\n${widget.userName}!',
                  style: Theme.of(context).textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25.0),
                Text(
                  'Seja bem vindo de volta ao seu marketplace!',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.w200,
                        fontSize: 18.0,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 55.0),
                TextFormField(
                  controller: _passwordCtrl,
                  //hintText: 'Senha',
                  //counterText: '',
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _isPasswordObscure,
                  maxLength: 24,
                  enabled: !_isLoading,
                  onEditingComplete: () => FocusScope.of(context).unfocus(),
                  textInputAction: TextInputAction.done,
                  /*suffixIcon: IconButton(
                    splashRadius: 25.0,
                    onPressed: () => setState(
                        () => _isPasswordObscure = !_isPasswordObscure),
                    icon: Icon(
                      _isPasswordObscure
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),*/
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Este campo não pode ser vazio';
                    } else if (value.length < 5) {
                      return 'Senha muito curta';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 20.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      
                    },
                    child: const Text(
                      'Recuperar senha',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 35.0),
                MaterialButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            //_login();
                          }
                        },
                  child: _isLoading
                      ? const SizedBox.square(
                          dimension: 15.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                          ),
                        )
                      : const Text('Entrar'),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: (){},//_navigateToInitialScreen,
                  child: const Text(
                    'Não é você? Então toque aqui!',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}