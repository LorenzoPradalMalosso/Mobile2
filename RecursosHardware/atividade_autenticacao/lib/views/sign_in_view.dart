import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '../services/auth_service.dart';
import 'home_view.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _auth = AuthService();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  bool _busy = false, _hidePassword = true, _creatingAccount = false;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirmation.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = _email.text.trim().toLowerCase();
    if (_creatingAccount && _password.text != _confirmation.text) {
      _message('As senhas não coincidem.');
      return;
    }
    setState(() => _busy = true);
    try {
      if (_creatingAccount) {
        await _auth.createAccount(email, _password.text);
      } else {
        await _auth.signIn(email, _password.text);
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              HomeScreen(userName: email.split('@').first, email: email),
        ),
      );
    } on AuthException catch (e) {
      _message(e.message);
    } catch (e) {
      _message('Não foi possível acessar a conta: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _biometricSignIn() async {
    setState(() => _busy = true);
    try {
      final account = await _auth.biometricAccount();
      if (account == null) {
        _message('Faça primeiro o acesso com e-mail e senha neste aparelho.');
        return;
      }
      final localAuth = LocalAuthentication();
      if (!await localAuth.isDeviceSupported() ||
          !await localAuth.canCheckBiometrics) {
        _message('Este aparelho não tem biometria configurada.');
        return;
      }
      final authenticated = await localAuth.authenticate(
        localizedReason: 'Confirme sua identidade para acessar o Ponto Seguro',
      );
      if (!authenticated || !mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              HomeScreen(userName: account.split('@').first, email: account),
        ),
      );
    } catch (e) {
      _message('Não foi possível confirmar a biometria: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _message(String text) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 74,
                  width: 74,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE1F1E9),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.fingerprint_rounded,
                    size: 42,
                    color: Color(0xFF176B58),
                  ),
                ),
                const SizedBox(height: 26),
                const Text(
                  'Ponto Seguro',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Registro de jornada conectado à API.',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 28),
                Text(
                  _creatingAccount ? 'Crie sua conta' : 'Acesse sua conta',
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'NIF ou e-mail',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _password,
                  obscureText: _hidePassword,
                  onSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () =>
                          setState(() => _hidePassword = !_hidePassword),
                      icon: Icon(
                        _hidePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                    ),
                  ),
                ),
                if (_creatingAccount) ...[
                  const SizedBox(height: 14),
                  TextField(
                    controller: _confirmation,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirme a senha',
                      prefixIcon: Icon(Icons.lock_reset),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: _busy ? null : _submit,
                  icon: _busy
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.login),
                  label: Text(
                    _busy
                        ? 'Aguarde...'
                        : _creatingAccount
                        ? 'Criar conta'
                        : 'Entrar',
                  ),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                  ),
                ),
                TextButton(
                  onPressed: _busy
                      ? null
                      : () => setState(
                          () => _creatingAccount = !_creatingAccount,
                        ),
                  child: Text(
                    _creatingAccount
                        ? 'Já tenho uma conta'
                        : 'Criar nova conta',
                  ),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _busy ? null : _biometricSignIn,
                  icon: const Icon(Icons.face_retouching_natural),
                  label: const Text('Entrar com biometria'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'A conta e os registros são gerenciados pela API. A biometria é validada pelo sistema operacional.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
