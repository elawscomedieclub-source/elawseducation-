import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  bool isListening = false;
  final List<Map<String, String>> messages = [
    {
      'role': 'assistant',
      'text': 'Bonjour ! Je suis ton professeur virtuel. Pose-moi une question sur tes cours de 6ème à Terminale.',
    },
  ];

  void _toggleListen() {
    setState(() {
      isListening = !isListening;
    });

    if (isListening) {
      // Simulate listening then response
      Future.delayed(const Duration(seconds: 3), () {
        if (!mounted) return;
        setState(() {
          isListening = false;
          messages.add({'role': 'user', 'text': 'C’est quoi une fraction ?'});
          messages.add({
            'role': 'assistant',
            'text':
                'Une fraction représente une partie d’un tout. On l’écrit a/b où a est le numérateur et b le dénominateur. Par exemple 3/4 signifie 3 parts sur 4.',
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Professeur Vocal'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                    decoration: BoxDecoration(
                      color: isUser
                          ? AppColors.primary
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isUser ? 16 : 4),
                        bottomRight: Radius.circular(isUser ? 4 : 16),
                      ),
                    ),
                    child: Text(
                      msg['text']!,
                      style: TextStyle(
                        color: isUser ? Colors.white : theme.colorScheme.onSurface,
                        height: 1.4,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Microphone area
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(color: theme.dividerColor.withOpacity(0.4)),
              ),
            ),
            child: Column(
              children: [
                Text(
                  isListening ? 'Je t’écoute…' : 'Appuie et pose ta question',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _toggleListen,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: isListening ? 84 : 72,
                    height: isListening ? 84 : 72,
                    decoration: BoxDecoration(
                      color: isListening ? AppColors.accent : AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (isListening ? AppColors.accent : AppColors.primary)
                              .withOpacity(0.4),
                          blurRadius: isListening ? 24 : 12,
                          spreadRadius: isListening ? 4 : 0,
                        ),
                      ],
                    ),
                    child: Icon(
                      isListening
                          ? PhosphorIconsFill.microphoneStage
                          : PhosphorIconsFill.microphone,
                      color: Colors.white,
                      size: 32,
                    ),
                  )
                      .animate(target: isListening ? 1 : 0)
                      .scale(begin: const Offset(1, 1), end: const Offset(1.05, 1.05))
                      .then()
                      .shimmer(
                        duration: 1200.ms,
                        color: Colors.white.withOpacity(0.3),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
