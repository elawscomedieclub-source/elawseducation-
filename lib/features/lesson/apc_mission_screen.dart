import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/models.dart';
import '../../data/sample/sample_data.dart';
import 'apc_lesson_guide.dart';

class ApcMissionScreen extends StatefulWidget {
  final Lesson lesson;
  const ApcMissionScreen({super.key, required this.lesson});

  @override
  State<ApcMissionScreen> createState() => _ApcMissionScreenState();
}

class _ApcMissionScreenState extends State<ApcMissionScreen> {
  final TextEditingController _answerController = TextEditingController();
  bool _loading = true;
  bool _saving = false;
  bool _saved = false;

  String get _storageKey => 'proftogo_apc_answer_${widget.lesson.id}';

  ApcLessonGuide get _guide {
    final chapter = demoChapters.firstWhere(
      (item) => item.id == widget.lesson.chapterId,
      orElse: () => demoChapters.first,
    );
    return ApcLessonGuide.forLesson(widget.lesson, chapter);
  }

  @override
  void initState() {
    super.initState();
    _loadAnswer();
  }

  Future<void> _loadAnswer() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final answer = prefs.getString(_storageKey) ?? '';
      if (!mounted) return;
      _answerController.text = answer;
      setState(() {
        _saved = answer.trim().isNotEmpty;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible de charger ta production enregistrée.')),
      );
    }
  }

  Future<void> _saveAnswer() async {
    final answer = _answerController.text.trim();
    if (answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Écris d’abord ta réponse.')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setString(_storageKey, answer);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _saved = success;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Ta production APC est enregistrée sur cet appareil.'
              : 'L’enregistrement a échoué. Réessaie.'),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d’enregistrer ta production. Réessaie.')),
      );
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final guide = _guide;
    return Scaffold(
      appBar: AppBar(title: const Text('Mission APC')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(18),
              children: [
                const Chip(
                  avatar: Icon(Icons.school_outlined),
                  label: Text('APPRENTISSAGE PAR COMPÉTENCES'),
                ),
                Text(widget.lesson.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Text('Ta situation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                const SizedBox(height: 6),
                Text(guide.situation),
                const SizedBox(height: 16),
                const Text('Ta mission', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                const SizedBox(height: 6),
                Text(guide.mission),
                const SizedBox(height: 16),
                const Text('Comment travailler ?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                const SizedBox(height: 6),
                ...guide.steps.asMap().entries.map((entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Text('${entry.key + 1}. ${entry.value}'),
                )),
                const SizedBox(height: 16),
                const Text('Production attendue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                const SizedBox(height: 6),
                Text(guide.production),
                const SizedBox(height: 16),
                const Text('Rédige ta solution', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                const SizedBox(height: 8),
                TextField(
                  controller: _answerController,
                  minLines: 7,
                  maxLines: 14,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'Explique ta démarche et donne ta réponse ici…',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _saving ? null : _saveAnswer,
                  icon: Icon(_saved ? Icons.save_as_outlined : Icons.save_outlined),
                  label: Text(_saving ? 'Enregistrement…' : 'Enregistrer ma production'),
                ),
                if (_saved) ...[
                  const SizedBox(height: 8),
                  const Text('Une réponse est enregistrée sur cet appareil. Tu peux la modifier et l’enregistrer à nouveau.', style: TextStyle(color: Colors.green)),
                ],
                const SizedBox(height: 20),
                const Text('Vérifie ton travail', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                const SizedBox(height: 8),
                ...guide.criteria.map((criterion) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.check_circle_outline, color: Color(0xFF006A4E)),
                  title: Text(criterion),
                )),
              ],
            ),
    );
  }
}
