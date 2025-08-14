import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_guard_flutter/screens/FamilyMemberDetailScreen.dart';
import 'package:health_guard_flutter/screens/manage_family_members_screen.dart';
import 'package:health_guard_flutter/screens/medication_reminder_screen.dart';
import 'package:health_guard_flutter/screens/link_doctor_screen.dart'; // Added import for LinkDoctorScreen
import '../models/user_roles.dart';
import '../screens/manage_vitals_screen.dart'; // Import your UserRole enum

// Import screen destinations - replace with your actual screen paths
// ... (your existing screen imports)
// import '../screens/admin_user_management_screen.dart'; // Example for Admin
// import '../screens/admin_system_settings_screen.dart'; // Example for Admin

// ... (PlaceholderScreen definition remains the same) ...

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
      case UserRole.admin: // <-- Added Admin case for header
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
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(
                builder: (_) => const PlaceholderScreen(title: "My Profile")));
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
            icon: Icons.medical_information_outlined,
            text: 'Doctor Reports',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                  builder: (_) =>
                  const PlaceholderScreen(
                      title: "My Medical Records")));
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
      // ... (Family Member items as before)
        drawerItems.addAll([
          _buildDrawerListItem(
            icon: Icons.monitor_heart_outlined,
            text: "Patient's Vitals",
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                  builder: (_) =>
                  const PlaceholderScreen(
                      title: "Patient's Vitals")));
            },
          ),
          _buildDrawerListItem(
            icon: Icons.notifications_active_outlined,
            text: 'Notifications Setup',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(
                  builder: (_) =>
                  const PlaceholderScreen(
                      title: "Notifications Setup")));
            },
          ),
        ]);
        break;
      case UserRole.admin: // <-- Added Admin case for specific items
        drawerItems.addAll([
          _buildDrawerListItem(
            icon: Icons.manage_accounts_outlined,
            text: 'User Management',
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to Admin User Management Screen
              Navigator.push(context, MaterialPageRoute(
                  builder: (_) =>
                  const PlaceholderScreen(
                      title: "User Management")));
              // Example: Navigator.pushNamed(context, '/admin_user_management');
            },
          ),
          _buildDrawerListItem(
            icon: Icons.display_settings_outlined,
            text: 'System Settings',
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to Admin System Settings Screen
              Navigator.push(context, MaterialPageRoute(
                  builder: (_) =>
                  const PlaceholderScreen(
                      title: "System Settings")));
              // Example: Navigator.pushNamed(context, '/admin_system_settings');
            },
          ),
          _buildDrawerListItem(
            icon: Icons.analytics_outlined,
            text: 'View System Analytics',
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to Admin Analytics Screen
              Navigator.push(context, MaterialPageRoute(
                  builder: (_) =>
                  const PlaceholderScreen(
                      title: "System Analytics")));
              // Example: Navigator.pushNamed(context, '/admin_analytics');
            },
          ),
          _buildDrawerListItem(
            icon: Icons.flag_outlined,
            text: 'Content Moderation',
            onTap: () {
              Navigator.pop(context);
              // TODO: Navigate to Admin Content Moderation Screen
              Navigator.push(context, MaterialPageRoute(
                  builder: (_) =>
                  const PlaceholderScreen(
                      title: "Content Moderation")));
              // Example: Navigator.pushNamed(context, '/admin_moderation');
            },
          ),
        ]);
        break;
      case UserRole.unknown:
        break;
    }

    // --- Common bottom items (About, Logout/Login) ---
    // ... (This section remains largely the same)
    drawerItems.add(const Divider());
    drawerItems.add(
      _buildDrawerListItem(
        icon: Icons.info_outline,
        text: 'About App',
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(
              builder: (_) => const PlaceholderScreen(title: "About App")));
        },
      ),
    );

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