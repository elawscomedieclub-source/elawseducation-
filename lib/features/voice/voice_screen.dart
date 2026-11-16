import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../shared/widgets/menu_button.dart';

class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  final FlutterTts _tts = FlutterTts();
  final TextEditingController _textController = TextEditingController(
    text: 'Bonjour ! Je suis ProfTogo. Choisis une leçon et je pourrai t’aider à la lire à voix haute.',
  );

  String _language = 'fr-FR';
  bool _speaking = false;

  @override
  void initState() {
    super.initState();
    _tts.setStartHandler(() {
      if (mounted) setState(() => _speaking = true);
    });
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _speaking = false);
    });
    _tts.setCancelHandler(() {
      if (mounted) setState(() => _speaking = false);
    });
    _tts.setErrorHandler((_) {
      if (mounted) setState(() => _speaking = false);
    });
    _tts.awaitSpeakCompletion(true);
  }

  Future<void> _speak() async {
    final text = _textController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Écris ou colle un texte avant de lancer la lecture.')),
      );
      return;
    }

    try {
      await _tts.setLanguage(_language);
      await _tts.setSpeechRate(0.45);
      await _tts.setVolume(1.0);
      await _tts.setPitch(1.0);
      await _tts.speak(text);
    } catch (_) {
      if (!mounted) return;
      setState(() => _speaking = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La lecture vocale n’est pas disponible. Vérifie la voix installée sur ton appareil ou le navigateur.'),
        ),
      );
    }
  }

  Future<void> _stop() async {
    await _tts.stop();
    if (mounted) setState(() => _speaking = false);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const ProfTogoMenuButton(),
        title: const Text('Professeur vocal'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 12),
          const Icon(
            Icons.record_voice_over_rounded,
            size: 72,
            color: Color(0xFF006A4E),
          ),
          const SizedBox(height: 16),
          const Text(
            'Écoute tes leçons avec ProfTogo',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Saisis un texte ou colle une partie de ton cours. ProfTogo le lira à voix haute.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<String>(
            value: _language,
            decoration: const InputDecoration(
              labelText: 'Langue de lecture',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'fr-FR', child: Text('Français')),
              DropdownMenuItem(value: 'en-US', child: Text('Anglais')),
              DropdownMenuItem(value: 'pt-PT', child: Text('Portugais')),
              DropdownMenuItem(value: 'es-ES', child: Text('Espagnol')),
            ],
            onChanged: _speaking
                ? null
                : (value) {
                    if (value != null) setState(() => _language = value);
                  },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            minLines: 5,
            maxLines: 9,
            decoration: const InputDecoration(
              labelText: 'Texte à écouter',
              hintText: 'Écris ou colle ici ton cours…',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 52,
            child: FilledButton.icon(
              onPressed: _speaking ? _stop : _speak,
              icon: Icon(_speaking ? Icons.stop_rounded : Icons.volume_up_rounded),
              label: Text(_speaking ? 'Arrêter la lecture' : 'Lire à voix haute'),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Remarque : la voix dépend des langues installées sur le téléphone ou disponibles dans le navigateur. La reconnaissance des questions parlées sera ajoutée dans une prochaine étape.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
