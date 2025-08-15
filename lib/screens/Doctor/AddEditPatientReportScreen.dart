import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../models/health_models/MedicalReport.dart';

class AddEditPatientReportScreen extends StatefulWidget {
  final MedicalReport? initialReport;
  final String patientId; // The ID of the patient this report is for
  final String doctorId; // The ID of the currently logged-in doctor

  const AddEditPatientReportScreen({
    super.key,
    this.initialReport,
    required this.patientId,
    required this.doctorId,
  });

  @override
  State<AddEditPatientReportScreen> createState() =>
      _AddEditPatientReportScreenState();
}

class _AddEditPatientReportScreenState
    extends State<AddEditPatientReportScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _reportTypeController;
  late TextEditingController _attachmentUrlController; // For simplicity, direct URL input
  late DateTime _selectedDate;

  bool get _isEditing => widget.initialReport != null;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialReport?.date ?? DateTime.now();
    _titleController =
        TextEditingController(text: widget.initialReport?.title ?? '');
    _contentController =
        TextEditingController(text: widget.initialReport?.content ?? '');
    _reportTypeController = TextEditingController(
        text: widget.initialReport?.reportType ?? 'Consultation Note');
    _attachmentUrlController =
        TextEditingController(text: widget.initialReport?.attachmentUrl ?? '');
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)), // Allow today
    );
    if (picked != null && picked != _selectedDate && mounted) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final report = MedicalReport(
        id: widget.initialReport?.id ?? const Uuid().v4(),
        patientId: widget.patientId,
        doctorId: widget.doctorId,
        // Assuming you have a way to get current doctor's ID
        title: _titleController.text.trim(),
        date: _selectedDate,
        content: _contentController.text.trim(),
        reportType: _reportTypeController.text
            .trim()
            .isNotEmpty ? _reportTypeController.text.trim() : null,
        attachmentUrl: _attachmentUrlController.text
            .trim()
            .isNotEmpty ? _attachmentUrlController.text.trim() : null,
      );
      Navigator.of(context).pop(report);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _reportTypeController.dispose();
    _attachmentUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            _isEditing ? 'Edit Medical Report' : 'Add New Medical Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: _submitForm,
            tooltip: 'Save Report',
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Report Title*',
                  hintText: 'e.g., Follow-up Visit, Lab Results',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title_outlined),
                ),
                validator: (value) =>
                (value == null || value
                    .trim()
                    .isEmpty) ? 'Title cannot be empty' : null,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Theme
                      .of(context)
                      .dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () => _pickDate(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Report Date: ${DateFormat.yMMMd().format(
                            _selectedDate)}', style: textTheme.titleMedium),
                        const Icon(Icons.calendar_today_outlined),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _reportTypeController,
                decoration: const InputDecoration(
                  labelText: 'Report Type (Optional)',
                  hintText: 'e.g., Consultation Note, Lab Analysis',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                    labelText: 'Report Content / Summary*',
                    hintText: 'Detailed notes, observations, plan...',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    // Good for multi-line
                    prefixIcon: Padding(
                      padding: EdgeInsets.fromLTRB(12, 12, 12, 0),
                      // Adjust icon position for multiline
                      child: Icon(Icons.article_outlined),
                    )
                ),
                maxLines: 8,
                minLines: 4,
                validator: (value) =>
                (value == null || value
                    .trim()
                    .isEmpty) ? 'Content cannot be empty' : null,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _attachmentUrlController,
                decoration: const InputDecoration(
                  labelText: 'Attachment URL (Optional)',
                  hintText: 'e.g., https://example.com/report.pdf',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link_outlined),
                ),
                keyboardType: TextInputType.url,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.check_circle_outline),
                label: Text(_isEditing ? 'Save Changes' : 'Create Report',
                    style: const TextStyle(fontSize: 16)),
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}