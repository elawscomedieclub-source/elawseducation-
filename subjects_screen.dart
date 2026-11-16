import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../data/catalog/class_catalog.dart';
import '../../data/models/models.dart';
import 'subject_detail_screen.dart';

class SubjectsScreen extends StatefulWidget {
  const SubjectsScreen({super.key});

  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  SchoolClassInfo selectedClass = ClassCatalog.classes[6];
  String search = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subjects = ClassCatalog.subjectsFor(selectedClass)
        .where((s) => s.name.toLowerCase().contains(search.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cours et matières'),
        actions: [
          IconButton(
            tooltip: 'Rechercher une matière',
            icon: const Icon(Icons.search),
            onPressed: () async {
              final value = await showSearch<String>(
                context: context,
                delegate: _SubjectSearchDelegate(),
              );
              if (value != null) setState(() => search = value);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(.07),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: theme.colorScheme.primary.withOpacity(.2)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<SchoolClassInfo>(
                  value: selectedClass,
                  isExpanded: true,
                  icon: const Icon(Icons.expand_more),
                  hint: const Text('Choisir une classe'),
                  items: ClassCatalog.classes.map((c) => DropdownMenuItem(
                    value: c,
                    child: Text(c.label),
                  )).toList(),
                  onChanged: (value) {
                    if (value != null) setState(() {
                      selectedClass = value;
                      search = '';
                    });
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Matières de ${selectedClass.label}',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Text('${subjects.length} matières',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Expanded(
            child: subjects.isEmpty
                ? const Center(child: Text('Aucune matière trouvée.'))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: subjects.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final subject = subjects[index];
                      final color = Color(int.parse('FF${subject.colorHex.substring(1)}', radix: 16));
                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: CircleAvatar(
                            backgroundColor: color.withOpacity(.13),
                            child: Icon(PhosphorIconsRegular.bookOpen, color: color),
                          ),
                          title: Text(subject.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: const Text('Chapitres • Leçons • Exercices corrigés'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SubjectDetailScreen(subject: subject)),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _SubjectSearchDelegate extends SearchDelegate<String> {
  @override
  String get searchFieldLabel => 'Rechercher une matière';

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, ''),
  );

  @override
  Widget buildResults(BuildContext context) => ListTile(
    title: Text('Filtrer les matières contenant « $query »'),
    onTap: () => close(context, query),
  );

  @override
  Widget buildSuggestions(BuildContext context) => ListTile(
    title: Text(query.isEmpty ? 'Tape le nom d’une matière' : 'Rechercher « $query »'),
    onTap: () => close(context, query),
  );
}
