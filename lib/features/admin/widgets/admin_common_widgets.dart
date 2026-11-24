import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

/// Admin-only colors that are not in the shared AppColors file.
class AdminColors {
  AdminColors._();
  static const Color warning = Color(0xFF9A6700);
  static const Color warningContainer = Color(0xFFFFF1CC);
}

// ───────────────────────── Scaffold ─────────────────────────
class AdminScaffold extends StatelessWidget {
  const AdminScaffold({
    super.key,
    required this.title,
    required this.body,
    this.eyebrow,
    this.actions,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  final String title;
  final String? eyebrow;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: false,
        toolbarHeight: 68,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (eyebrow != null)
              Text(
                eyebrow!.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: -0.4)),
          ],
        ),
        actions: [...?actions, const SizedBox(width: 8)],
      ),
      body: SafeArea(top: false, child: body),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

// ───────────────────────── Basic pieces ─────────────────────────
class AdminCard extends StatelessWidget {
  const AdminCard({super.key, required this.child, this.onTap, this.dark = false});
  final Widget child;
  final VoidCallback? onTap;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: dark ? AppColors.midnightBlack : AppColors.pureWhite,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: dark ? AppColors.elevatedDark : AppColors.borderLight.withValues(alpha: 0.6)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class AdminSearchField extends StatelessWidget {
  const AdminSearchField({super.key, required this.hint, required this.onChanged});
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder b(Color c) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c),
        );
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textMuted),
        prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
        filled: true,
        fillColor: AppColors.pureWhite,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: b(AppColors.borderLight),
        enabledBorder: b(AppColors.borderLight),
        focusedBorder: b(AppColors.midnightBlack),
      ),
    );
  }
}

class FilterChipsRow extends StatelessWidget {
  const FilterChipsRow({super.key, required this.options, required this.selected, required this.onSelected});
  final List<String> options;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final o = options[i];
          final on = o == selected;
          return GestureDetector(
            onTap: () => onSelected(o),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: on ? AppColors.midnightBlack : AppColors.pureWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: on ? AppColors.midnightBlack : AppColors.borderLight),
              ),
              child: Text(
                o,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: on ? AppColors.limeNeon : AppColors.onSurfaceVariant,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

enum ChipTone { success, warning, danger, neutral, dark }

ChipTone toneFor(String status) {
  switch (status) {
    case 'Active':
    case 'Paid':
    case 'Completed':
    case 'Checked In':
    case 'Available':
      return ChipTone.success;
    case 'Pending':
    case 'Upcoming':
    case 'Maintenance':
      return ChipTone.warning;
    case 'Suspended':
    case 'Expired':
    case 'Cancelled':
    case 'Failed':
      return ChipTone.danger;
    default:
      return ChipTone.neutral;
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip(this.label, {super.key, this.tone});
  final String label;
  final ChipTone? tone;

  @override
  Widget build(BuildContext context) {
    final t = tone ?? toneFor(label);
    late Color bg, fg;
    switch (t) {
      case ChipTone.success:
        bg = AppColors.secondaryContainer;
        fg = const Color(0xFF2F3D00);
      case ChipTone.warning:
        bg = AdminColors.warningContainer;
        fg = AdminColors.warning;
      case ChipTone.danger:
        bg = AppColors.errorContainer;
        fg = AppColors.error;
      case ChipTone.neutral:
        bg = AppColors.surfaceContainer;
        fg = AppColors.onSurfaceVariant;
      case ChipTone.dark:
        bg = AppColors.midnightBlack;
        fg = AppColors.limeNeon;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(fontSize: 10, letterSpacing: 0.8, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }
}

class IconBox extends StatelessWidget {
  const IconBox(this.icon, {super.key, this.dark = true, this.lime = false, this.size = 40});
  final IconData icon;
  final bool dark;
  final bool lime;
  final double size;

  @override
  Widget build(BuildContext context) {
    final bg = lime ? AppColors.secondaryContainer : (dark ? AppColors.midnightBlack : AppColors.surfaceContainer);
    final fg = lime ? AppColors.secondary : (dark ? AppColors.pureWhite : AppColors.midnightBlack);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, size: size * 0.5, color: fg),
    );
  }
}

class AdminEmptyState extends StatelessWidget {
  const AdminEmptyState({super.key, this.message = 'Nothing found'});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inbox_outlined, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminPrimaryButton extends StatelessWidget {
  const AdminPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.outlined = false,
    this.danger = false,
  });
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool outlined;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
        Text(label),
      ],
    );

    final Widget button;
    if (danger) {
      button = OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.error,
          side: const BorderSide(color: AppColors.error),
        ),
        child: content,
      );
    } else if (outlined) {
      button = OutlinedButton(onPressed: onPressed, child: content);
    } else {
      button = ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.midnightBlack,
          foregroundColor: AppColors.limeNeon,
        ),
        child: content,
      );
    }
    return SizedBox(width: double.infinity, child: button);
  }
}

IconData iconForFacility(String text) {
  final t = text.toLowerCase();
  if (t.contains('pool')) return Icons.pool;
  if (t.contains('gym')) return Icons.fitness_center;
  if (t.contains('padel') || t.contains('tennis') || t.contains('court')) return Icons.sports_tennis;
  return Icons.stadium_outlined;
}

// ───────────────────────── Dialogs & sheets ─────────────────────────
void showAdminSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text(message, style: const TextStyle(color: AppColors.limeNeon, fontWeight: FontWeight.w600)),
      backgroundColor: AppColors.midnightBlack,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
}

Future<bool?> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool danger = false,
}) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.pureWhite,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      content: Text(message, style: const TextStyle(color: AppColors.onSurfaceVariant)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel', style: TextStyle(color: AppColors.onSurfaceVariant)),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(confirmLabel,
              style: TextStyle(color: danger ? AppColors.error : AppColors.midnightBlack, fontWeight: FontWeight.w700)),
        ),
      ],
    ),
  );
}

const _sheetShape = RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24)));

Widget _handle() => Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(color: AppColors.borderLight, borderRadius: BorderRadius.circular(2)),
      ),
    );

Future<void> showDetailsSheet(
  BuildContext context, {
  required String title,
  String? status,
  required Map<String, String> rows,
  List<Widget> actions = const [],
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.pureWhite,
    shape: _sheetShape,
    builder: (_) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _handle(),
          Row(
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700))),
              if (status != null) StatusChip(status),
            ],
          ),
          const SizedBox(height: 16),
          for (final e in rows.entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.key, style: const TextStyle(color: AppColors.textMuted)),
                  const SizedBox(width: 16),
                  Flexible(child: Text(e.value, textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.w600))),
                ],
              ),
            ),
          const SizedBox(height: 16),
          for (final a in actions) ...[a, const SizedBox(height: 8)],
        ],
      ),
    ),
  );
}

class FormFieldSpec {
  const FormFieldSpec(this.key, this.label, {this.initial = '', this.keyboard = TextInputType.text, this.maxLines = 1, this.isDate = false});
  final String key;
  final String label;
  final String initial;
  final TextInputType keyboard;
  final int maxLines;
  final bool isDate;
}

Future<Map<String, String>?> showAdminFormSheet(
  BuildContext context, {
  required String title,
  required List<FormFieldSpec> fields,
  String submitLabel = 'Save',
}) {
  return showModalBottomSheet<Map<String, String>>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.pureWhite,
    shape: _sheetShape,
    builder: (_) => _FormSheet(title: title, fields: fields, submitLabel: submitLabel),
  );
}

class _FormSheet extends StatefulWidget {
  const _FormSheet({required this.title, required this.fields, required this.submitLabel});
  final String title;
  final List<FormFieldSpec> fields;
  final String submitLabel;

  @override
  State<_FormSheet> createState() => _FormSheetState();
}

class _FormSheetState extends State<_FormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _c = {
    for (final f in widget.fields) f.key: TextEditingController(text: f.initial),
  };

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController c) async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(c.text) ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );
    if (d != null) {
      c.text = '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder b(Color col) => OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: col));
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _handle(),
              Text(widget.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              for (final f in widget.fields) ...[
                TextFormField(
                  controller: _c[f.key],
                  keyboardType: f.keyboard,
                  maxLines: f.maxLines,
                  readOnly: f.isDate,
                  onTap: f.isDate ? () => _pickDate(_c[f.key]!) : null,
                  validator: (v) => (v == null || v.trim().isEmpty) ? '${f.label} is required' : null,
                  decoration: InputDecoration(
                    labelText: f.label,
                    suffixIcon: f.isDate ? const Icon(Icons.calendar_today_outlined, size: 18) : null,
                    labelStyle: const TextStyle(color: AppColors.textMuted),
                    floatingLabelStyle: const TextStyle(color: AppColors.midnightBlack),
                    filled: true,
                    fillColor: AppColors.surfaceMuted,
                    border: b(AppColors.borderLight),
                    enabledBorder: b(AppColors.borderLight),
                    focusedBorder: b(AppColors.midnightBlack),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              const SizedBox(height: 4),
              AdminPrimaryButton(
                label: widget.submitLabel,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context, {for (final e in _c.entries) e.key: e.value.text.trim()});
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}