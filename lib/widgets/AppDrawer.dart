import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:health_guard_flutter/models/profile_models/AdminProfile.dart';
import 'package:health_guard_flutter/models/profile_models/DoctorProfile.dart';
import 'package:health_guard_flutter/models/profile_models/FamilyMemberProfile.dart';
import 'package:health_guard_flutter/models/profile_models/PatientProfile.dart';
import 'package:health_guard_flutter/screens/Patient/LinkDoctorScreen.dart';
import 'package:health_guard_flutter/screens/Patient/ManageFamilyMembersScreen.dart';
import 'package:health_guard_flutter/screens/Patient/ManageVitalsScreen.dart';
import 'package:health_guard_flutter/screens/Patient/MedicationReminderScreen.dart';
import 'package:health_guard_flutter/screens/profile/ProfileScreen.dart';

import '../models/UserRoles.dart'; 
import '../models/profile_models/BaseProfile.dart'; 
import '../services/AuthService.dart';



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
  const AppDrawer({super.key}); 

  UserRole _getUserRole(UserType? userType) {
    if (userType == null) return UserRole.unknown;
    switch (userType) {
      case UserType.patient:
        return UserRole.patient;
      case UserType.doctor:
        return UserRole.doctor;
      case UserType.familyMember:
        return UserRole.familyMember;
      case UserType.admin:
        return UserRole.admin;
      default:
        return UserRole.unknown;
    }
  }

  Widget _buildDrawerHeader(BuildContext context, BaseProfile? userProfile, UserRole currentUserRole) {
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
        userProfile?.name ?? roleText,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.deepPurple.shade900),
      ),
      accountEmail: Text(
        userProfile?.email ??
            (currentUserRole == UserRole.unknown
                ? "Not logged in"
                : "Role: ${currentUserRole.name.toUpperCase()}"), 
        style: TextStyle(
          color: Colors.deepPurple.shade800,
        ),
      ),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.deepPurple,
        backgroundImage: userProfile?.profileImageUrl != null
            ? NetworkImage(userProfile!.profileImageUrl!)
            : null,
        child: userProfile?.profileImageUrl == null
            ? Icon(
                roleIcon,
                size: 40,
                color: Theme.of(context).colorScheme.primaryContainer,
              )
            : null,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      otherAccountsPictures: [
        CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: SvgPicture.asset(
            'assets/icons/health-insurance.svg',
            width: 32.0,
            height: 32.0,
            colorFilter: const ColorFilter.mode(
              Colors.deepPurple,
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
    return Builder(builder: (context) {
      return ListTile(
        leading: Icon(icon, color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).iconTheme.color),
        title: Text(text, style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).textTheme.bodyLarge?.color,
        )),
        selected: isSelected,
        selectedTileColor: isSelected ? Theme.of(context).colorScheme.primary.withOpacity(0.1) : null,
        tileColor: Colors.transparent,
        onTap: onTap,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final BaseProfile? userProfile = AuthService().userProfile;
    final UserRole currentUserRole = _getUserRole(userProfile?.userType);

    List<Widget> drawerItems = [];

    
    if (userProfile != null) {
      drawerItems.add(
        _buildDrawerListItem(
          icon: Icons.person_outline,
          text: 'My Profile',
          onTap: () {
            Navigator.pop(context); 
            
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProfileScreen(userProfile: userProfile),
              ),
            );
          },
        ),
      );
    }

    
    
    switch (currentUserRole) {
      case UserRole.patient:
        drawerItems.addAll([
          _buildDrawerListItem(
            icon: Icons.monitor_heart,
            text: 'Vitals',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageVitalsScreen()));
            },
          ),
          _buildDrawerListItem(
            icon: Icons.medical_services,
            text: 'Doctor',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const LinkDoctorScreen()));
            },
          ),
          _buildDrawerListItem(
            icon: Icons.groups,
            text: 'Family Members',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageFamilyMembersScreen()));
            },
          ),
          _buildDrawerListItem(
            icon: Icons.alarm_on_outlined,
            text: 'Medication Reminders',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const MedicationReminderScreen()));
            },
          ),
        ]);
        break;
      case UserRole.doctor:
        
        
        
        break;
      case UserRole.familyMember:
        
        
        
        break;
      case UserRole.admin:
        
        
        
        break;
      case UserRole.unknown:
        
        break;
    }

    drawerItems.add(const Divider());

    
    if (userProfile != null) { 
      drawerItems.add(
        _buildDrawerListItem(
          icon: Icons.logout_outlined,
          text: 'Logout',
          onTap: () {
            AuthService().logoutUser(); 
            Navigator.pop(context); 
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false); 
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
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false); 
          },
        ),
      );
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildDrawerHeader(context, userProfile, currentUserRole),
          ...drawerItems,
        ],
      ),
    );
  }
}
