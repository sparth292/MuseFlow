import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection('Account', [
                      _buildSettingItem('Profile', Icons.person_outline),
                      _buildSettingItem('Email', Icons.email_outlined),
                      _buildSettingItem('Password', Icons.lock_outline),
                      _buildSettingItem('Subscription', Icons.card_membership),
                    ]),

                    _buildSection('Audio', [
                      _buildSettingItem('Audio Quality', Icons.high_quality),
                      _buildSettingItem('Download Quality', Icons.download_outlined),
                      _buildSettingItem('Equalizer', Icons.equalizer),
                      _buildSettingItem('Crossfade', Icons.compare_arrows),
                    ]),

                    _buildSection('Playback', [
                      _buildSettingItem('Offline Mode', Icons.wifi_off_outlined),
                      _buildSettingItem('Gapless Playback', Icons.play_circle_outline),
                      _buildSettingItem('Automix', Icons.shuffle),
                      _buildSettingItem('Device Selection', Icons.devices),
                    ]),

                    _buildSection('Storage', [
                      _buildSettingItem('Storage Location', Icons.folder_outlined),
                      _buildSettingItem('Clear Cache', Icons.cleaning_services_outlined),
                      _buildSettingItem('Download Manager', Icons.download_for_offline_outlined),
                    ]),

                    _buildSection('About', [
                      _buildSettingItem('Version', Icons.info_outline),
                      _buildSettingItem('Terms of Service', Icons.description_outlined),
                      _buildSettingItem('Privacy Policy', Icons.privacy_tip_outlined),
                      _buildSettingItem('Licenses', Icons.gavel_outlined),
                    ]),

                    // Sign out button
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Sign Out',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildSettingItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
} 