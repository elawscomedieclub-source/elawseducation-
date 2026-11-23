import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  String _message(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'Cette adresse e-mail possède déjà un compte.';
      case 'invalid-email':
        return 'Cette adresse e-mail n’est pas valide.';
      case 'weak-password':
        return 'Choisis un mot de passe d’au moins 6 caractères.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Adresse e-mail ou mot de passe incorrect.';
      case 'network-request-failed':
        return 'Connexion Internet indisponible. Réessaie.';
      default:
        return 'Une erreur est survenue. Vérifie les informations et réessaie.';
    }
  }

  Future<void> _showAccountDialog(BuildContext context, {required bool create}) async {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    bool loading = false;
    String? errorText;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(create ? 'Créer mon compte' : 'Me connecter'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Adresse e-mail',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe (6 caractères minimum)',
                    border: OutlineInputBorder(),
                  ),
                ),
                if (errorText != null) ...[
                  const SizedBox(height: 12),
                  Text(errorText!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: loading ? null : () => Navigator.pop(dialogContext),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: loading ? null : () async {
                final email = emailController.text.trim();
                final password = passwordController.text;
                if (email.isEmpty || password.isEmpty) {
                  setDialogState(() => errorText = 'Remplis les deux champs.');
                  return;
                }
                setDialogState(() { loading = true; errorText = null; });
                try {
                  if (create) {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                  } else {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );
                  }
                  if (dialogContext.mounted) Navigator.pop(dialogContext);
                } on FirebaseAuthException catch (error) {
                  if (!context.mounted) return;
                  setDialogState(() {
                    loading = false;
                    errorText = _message(error);
                  });
                } catch (_) {
                  if (!context.mounted) return;
                  setDialogState(() {
                    loading = false;
                    errorText = 'Impossible de terminer. Réessaie plus tard.';
                  });
                }
              },
              child: loading
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text(create ? 'Créer le compte' : 'Connexion'),
            ),
          ],
        ),
      ),
    );
    emailController.dispose();
    passwordController.dispose();
  }

  Future<void> _resetPassword(BuildContext context) async {
    final emailController = TextEditingController();
    final email = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Réinitialiser le mot de passe'),
        content: TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Adresse e-mail',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, emailController.text.trim()),
            child: const Text('Envoyer'),
          ),
        ],
      ),
    );
    emailController.dispose();
    if (email == null || email.isEmpty) return;
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Si cette adresse possède un compte, un e-mail de réinitialisation a été envoyé.')),
        );
      }
    } on FirebaseAuthException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_message(error))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: user == null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Compte facultatif', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      const Text('Tu peux apprendre sans compte. Crée-en un ou connecte-toi si tu souhaites utiliser les services liés à ton compte.'),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => _showAccountDialog(context, create: true),
                          icon: const Icon(Icons.person_add_alt_1),
                          label: const Text('Créer un compte'),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () => _showAccountDialog(context, create: false),
                          icon: const Icon(Icons.login),
                          label: const Text('Me connecter'),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _resetPassword(context),
                        child: const Text('Mot de passe oublié ?'),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Mon compte', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      Text(user.email ?? 'Compte connecté'),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () async => FirebaseAuth.instance.signOut(),
                        icon: const Icon(Icons.logout),
                        label: const Text('Se déconnecter'),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
