import 'package:flutter/material.dart';
import '../../models/user_models/Doctor.dart'; // Adjust path if needed

class DoctorDetailsScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailsScreen({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(doctor.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileAvatar(textTheme, colorScheme),
            const SizedBox(height: 20),
            _buildDoctorDetailsCard(context),
          ],
        ),
      ),
    );
  }

  /// Profile Avatar (Initials if no image provided)
  Widget _buildProfileAvatar(TextTheme textTheme, ColorScheme colorScheme) {
    return Center(
      child: CircleAvatar(
        radius: 50,
        backgroundColor: doctor.isVerified
            ? colorScheme.primaryContainer
            : colorScheme.tertiaryContainer,
        child: Text(
          doctor.name.isNotEmpty ? doctor.name[0].toUpperCase() : 'D',
          style: textTheme.headlineMedium?.copyWith(
            color: doctor.isVerified
                ? colorScheme.onPrimaryContainer
                : colorScheme.onTertiaryContainer,
          ),
        ),
      ),
    );
  }

  /// Doctor Details Card
  Widget _buildDoctorDetailsCard(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDetailRow(
              context,
              label: "Name",
              value: doctor.name,
              icon: Icons.person_outline,
            ),
            _buildDetailRow(
              context,
              label: "Specialty",
              value: doctor.specialty,
              icon: Icons.medical_services_outlined,
            ),
            _buildDetailRow(
              context,
              label: "Email",
              value: doctor.email,
              icon: Icons.email_outlined,
            ),
            _buildDetailRow(
              context,
              label: "Phone",
              value: doctor.phoneNumber,
              icon: Icons.phone_outlined,
            ),
            _buildDetailRow(
              context,
              label: "Gender",
              value: doctor.gender,
              icon: Icons.person, // Or use specific gender icons
            ),
            _buildDetailRow(
              context,
              label: "Medical License",
              value: doctor.medicalLicenseNumber,
              icon: Icons.badge_outlined,
            ),
            _buildDetailRow(
              context,
              label: "Verification Status",
              value: doctor.isVerified ? "Verified" : "Not Verified",
              icon: doctor.isVerified
                  ? Icons.verified_user_outlined
                  : Icons.unpublished_outlined,
              highlight: true,
              highlightColor: doctor.isVerified
                  ? Colors.green.shade700
                  : Colors.orange.shade800,
            ),
            // Add more fields as needed:
            // _buildDetailRow(context, label: "Phone", value: doctor.phone ?? "N/A", icon: Icons.phone_outlined),
            // _buildDetailRow(context, label: "Clinic Address", value: doctor.clinicAddress ?? "N/A", icon: Icons.location_on_outlined),
          ],
        ),
      ),
    );
  }

  /// Reusable Row for Each Detail
  Widget _buildDetailRow(
      BuildContext context, {
        required String label,
        required String value,
        IconData? icon,
        bool highlight = false,
        Color? highlightColor,
      }) {
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: primaryColor),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: textTheme.bodyLarge?.copyWith(
                color: highlight ? highlightColor : null,
                fontWeight: highlight ? FontWeight.w600 : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
