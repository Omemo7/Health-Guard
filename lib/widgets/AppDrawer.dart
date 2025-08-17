import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_guard_flutter/screens/Family%20member/RelatedPatientDetailScreen.dart';
import 'package:health_guard_flutter/screens/Patient/ManageFamilyMembersScreen.dart';
import 'package:health_guard_flutter/screens/Patient/MedicationReminderScreen.dart';
import 'package:health_guard_flutter/screens/Patient/LinkDoctorScreen.dart'; // Added import for LinkDoctorScreen
import 'package:health_guard_flutter/screens/profile/ProfileScreen.dart';
import '../models/user_roles.dart';
import '../screens/Patient/ManageVitalsScreen.dart'; // Import your UserRole enum
// import 'package:health_guard_flutter/screens/profile/ProfileScreen.dart'; // Duplicate import removed

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Content for $title')),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final UserRole currentUserRole;
  final String? userName;
  final String? userEmail;
  final String? userProfileImageUrl;

  const AppDrawer({
    super.key,
    required this.currentUserRole,
    this.userName,
    this.userEmail,
    this.userProfileImageUrl,
  });

  Widget _buildDrawerHeader(BuildContext context) {
    String roleText;
    IconData roleIcon;

    switch (currentUserRole) {
      case UserRole.patient:
        roleText = "Patient Portal";
        roleIcon = Icons.personal_injury_outlined;
        break;
      case UserRole.doctor:
        roleText = "Doctor Dashboard";
        roleIcon = Icons.medical_services_outlined;
        break;
      case UserRole.familyMember:
        roleText = "Family Member View";
        roleIcon = Icons.family_restroom_outlined;
        break;
      case UserRole.admin:
        roleText = "Administrator Panel";
        roleIcon = Icons.admin_panel_settings_outlined;
        break;
      case UserRole.unknown:
      default:
        roleText = "Guest";
        roleIcon = Icons.person_outline;
        break;
    }

    return UserAccountsDrawerHeader(
      accountName: Text(
        userName ?? roleText,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.deepPurple.shade900),
      ),
      accountEmail: Text(
        userEmail ??
            (currentUserRole == UserRole.unknown
                ? "Not logged in"
                : "Role: ${currentUserRole.name.toUpperCase()}"),
        style: TextStyle(
          color: Colors.deepPurple.shade800,
        ),
      ),
      currentAccountPicture: CircleAvatar(backgroundColor: Colors.deepPurple,
        backgroundImage: userProfileImageUrl != null ? NetworkImage(
            userProfileImageUrl!) : null,
        child: userProfileImageUrl == null
            ? Icon(
          roleIcon,
          size: 40,
          color: Theme
              .of(context)
              .colorScheme
              .primaryContainer,
        )
            : null,
      ),
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .colorScheme
            .primaryContainer,
      ),
      otherAccountsPictures: [
        CircleAvatar(
          backgroundColor: Theme
              .of(context) // Changed background for better visibility if needed
              .colorScheme
              .secondaryContainer,
          child: SvgPicture.asset(
            'assets/icons/health-insurance.svg', // Use relative path from pubspec.yaml
            width: 32.0, // Adjusted size for better appearance in CircleAvatar
            height: 32.0,
            colorFilter: ColorFilter.mode(
              Colors.deepPurple, // Changed color for better contrast
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDrawerListItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
    bool isSelected = false,
  }) {
    // Using a Builder to ensure context is available for Theme.of
    return Builder(builder: (context) {
      return ListTile(
        leading: Icon(icon, color: isSelected ? Theme
            .of(context)
            .colorScheme
            .primary : Theme
            .of(context)
            .iconTheme
            .color),
        title: Text(text, style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme
              .of(context)
              .colorScheme
              .primary : Theme
              .of(context)
              .textTheme
              .bodyLarge
              ?.color,
        )),
        selected: isSelected,
        selectedTileColor: isSelected ? Theme
            .of(context)
            .colorScheme
            .primary
            .withOpacity(0.1) : null,
        tileColor: Colors.transparent,
        // Ensure it doesn't override parent's color unless selected
        onTap: onTap,
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    List<Widget> drawerItems = [];

    // --- Common Items for all logged-in users (adjust as needed) ---
    if (currentUserRole != UserRole.unknown) {
      // My Profile & Settings (as before)
      drawerItems.addAll([
        _buildDrawerListItem(
          icon: Icons.person_outline,
          text: 'My Profile',
          // isSelected: ModalRoute.of(context)?.settings.name == '/profile',
          onTap: () {
            Navigator.pop(context); // Close the drawer

            // --- Temporary Mock Profile Data ---
            // You MUST replace this with your actual user profile data logic
            BaseProfile mockProfile;
            switch (currentUserRole) {
              case UserRole.patient:
                mockProfile = PatientProfile(
                  id: "patient123",
                  name: userName ?? "Patient User",
                  email: userEmail ?? "patient@example.com",
                  profileImageUrl: userProfileImageUrl,
                  // Add other patient-specific fields if needed for initial display
                );
                break;
              case UserRole.doctor:
                mockProfile = DoctorProfile(
                  id: "doctor456",
                  name: userName ?? "Doctor User",
                  email: userEmail ?? "doctor@example.com",
                  profileImageUrl: userProfileImageUrl,
                  // Add other doctor-specific fields
                );
                break;
              case UserRole.familyMember:
                mockProfile = FamilyMemberProfile(
                  id: "family789",
                  name: userName ?? "Family Member",
                  email: userEmail ?? "family@example.com",
                  profileImageUrl: userProfileImageUrl,
                  linkedPatientId: "unknown_patient", // This can remain as a placeholder
                  relationshipToPatient: null,      // Ensure this is null or ""
                );
                break;

              case UserRole.admin: // This case should already exist
                mockProfile = AdminProfile( // Ensure this is AdminProfile
                  id: "admin001",
                  name:  "koko",
                  username: userName ??"Admin User",
                  email: userEmail ?? "admin@example.com",
                  profileImageUrl: null,

                );
                break;
            // ...
              default: // Includes UserRole.admin and UserRole.unknown
              // For Admin or Unknown, maybe navigate to a different profile screen
              // or show a generic one. For now, let's use a basic BaseProfile.
                mockProfile = BaseProfile(
                    id: "user000",
                    name: userName ?? "User",
                    email: userEmail ?? "user@example.com",
                    profileImageUrl: userProfileImageUrl,
                    userType: UserType
                        .patient // Or a generic type if you add one
                );
            // Alternatively, for Admin/Unknown, you might not want to show this profile screen
            // or show a different message/screen.
            // For this example, we'll proceed but ideally, Admins might have a different profile view.
            }
            // --- End of Temporary Mock Profile Data ---

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(userProfile: mockProfile),
              ),
            );
          },
        ),
      ]);
    }

    // --- Role-Specific Items ---
    switch (currentUserRole) {
      case UserRole.patient:
      // ... (Patient items as before, including Medication Reminders)
        drawerItems.addAll([
          _buildDrawerListItem(
          icon: Icons.monitor_heart,
          text: 'Vitals',
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(
                builder: (_) =>
                const ManageVitalsScreen()));
          },
        ),
          _buildDrawerListItem(
            icon: Icons.medical_services,
            text: 'Doctor',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                  builder: (_) =>
                  const LinkDoctorScreen()));
            },
          ),

          _buildDrawerListItem(
            icon: Icons.groups,
            text: 'Family Members',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                  builder: (_) =>
                  const ManageFamilyMembersScreen()));
            },
          ),
          _buildDrawerListItem(
            icon: Icons.alarm_on_outlined,
            text: 'Medication Reminders',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                  builder: (_) =>
                  const MedicationReminderScreen()));
            },
          ),
        ]);
        break;
      case UserRole.doctor:
      // ... (Doctor items as before)
        break;
      case UserRole.familyMember:

        break;
      case UserRole.admin: // <-- Added Admin case for specific items

        break;
      case UserRole.unknown:
        break;
    }


    drawerItems.add(const Divider());


    if (currentUserRole != UserRole.unknown) {
      drawerItems.add(
        _buildDrawerListItem(
          icon: Icons.logout_outlined,
          text: 'Logout',
          onTap: () {
            Navigator.pop(context);
            // TODO: Implement actual logout logic
            print("Logout Tapped");
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
          },
        ),
      );
    } else {
      drawerItems.add(
        _buildDrawerListItem(
          icon: Icons.login_outlined,
          text: 'Login',
          onTap: () {
            Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', (Route<dynamic> route) => false);
          },
        ),
      );
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildDrawerHeader(context),
          ...drawerItems,
        ],
      ),
    );
  }
}
