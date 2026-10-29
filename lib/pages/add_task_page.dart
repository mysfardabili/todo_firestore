import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/firestore_service.dart';
import '../theme/app_theme.dart';

class AddTaskPage extends StatefulWidget {
  final Task? taskToEdit;

  const AddTaskPage({super.key, this.taskToEdit});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _firestore = FirestoreService();

  late String _priority;
  bool _isLoading = false;

  bool get _isEditing => widget.taskToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.taskToEdit!.title;
      _descController.text = widget.taskToEdit!.description ?? '';
      _priority = widget.taskToEdit!.priority;
    } else {
      _priority = 'Sedang';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isEditing) {
        await _firestore.updateTask(
          widget.taskToEdit!.id,
          title: _titleController.text,
          description: _descController.text,
          priority: _priority,
        );
      } else {
        await _firestore.addTask(
          _titleController.text,
          description: _descController.text,
          priority: _priority,
        );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Colors.white),
                const SizedBox(width: 8),
                Text(_isEditing
                    ? 'Tugas berhasil diperbarui!'
                    : 'Tugas berhasil disimpan ke cloud!'),
              ],
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppTheme.dangerColor,
            content: Text('Gagal menyimpan tugas: $e'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Color _getPriorityColor(String p) {
    switch (p) {
      case 'Tinggi':
        return AppTheme.dangerColor;
      case 'Sedang':
        return AppTheme.accentColor;
      case 'Rendah':
        return AppTheme.secondaryColor;
      default:
        return AppTheme.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Tugas' : 'Tambah Tugas Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _isEditing ? Icons.edit_note_rounded : Icons.post_add_rounded,
                        color: AppTheme.primaryColor,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isEditing
                                ? 'Perbarui Rincian Tugas'
                                : 'Rencanakan Hari Anda',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _isEditing
                                ? 'Perubahan akan otomatis tersinkron di cloud.'
                                : 'Tuliskan hal penting yang ingin Anda selesaikan.',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Title input
              const Text(
                'Judul Tugas',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                autofocus: !_isEditing,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Contoh: Belajar Pemrograman Mobile',
                  prefixIcon: Icon(Icons.assignment_outlined, size: 20),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Judul tugas tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Description input
              const Text(
                'Catatan Tambahan (Opsional)',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'Tambahkan detail atau instruksi tugas...',
                  alignLabelWithHint: true,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(bottom: 40),
                    child: Icon(Icons.notes_rounded, size: 20),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Priority Selector
              const Text(
                'Prioritas Tugas',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: ['Tinggi', 'Sedang', 'Rendah'].map((p) {
                  final isSelected = _priority == p;
                  final pColor = _getPriorityColor(p);
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : pColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(p),
                        ],
                      ),
                      selected: isSelected,
                      selectedColor: pColor,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        fontSize: 13,
                      ),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                          color: isSelected ? pColor : const Color(0xFFCBD5E1),
                        ),
                      ),
                      onSelected: (selected) {
                        if (selected) setState(() => _priority = p);
                      },
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 36),

              // Action Buttons
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _save,
                  icon: _isLoading
                      ? const SizedBox.shrink()
                      : Icon(_isEditing ? Icons.check_circle_outline : Icons.save_rounded),
                  label: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(_isEditing ? 'Perbarui Tugas' : 'Simpan Tugas'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
