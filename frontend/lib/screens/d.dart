import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/screens/camera_screen.dart';
import '/screens/gallery_screen.dart';
import '/screens/attendance_screen.dart';
import '/utils/app_colors.dart';
import '/utils/app_styles.dart';
import '/widgets/custom_navbar.dart';
import '/widgets/description_text_widget.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    CameraScreen(),
    GalleryScreen(),
    AttendanceScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hazari Hub', style: AppStyles.heading1),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        actions: [
          // Add a settings/profile icon to the app bar
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Handle settings/profile tap
              // (e.g., navigate to settings screen, show profile dialog, etc.)
            },
          ),
        ],
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.75),
              BlendMode.darken,
            ),
          ),
        ),
        child:SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              // App Heading
              Text(
                'Hazari Hub',
                style: AppStyles.heading1.copyWith(
                  fontSize: 32,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),

              // Introduction Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: DescriptionTextWidget(
                  text:
                      "Effortlessly manage attendance with Hazari Hub!  We leverage the power of cutting-edge YOLO object detection and a robust Django backend, paired with Firebase storage for a seamless experience. Snap, upload, and track - it's that simple!",
                ),
              ),
              SizedBox(height: 30),

              // Meet the Team Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25), // Rounded corners
                  ),
                  elevation: 2, // Add a subtle shadow
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TeamScreen()),
                  );
                },
                child: Text(
                  'Meet the Team',
                  style: TextStyle(
                      color: AppColors.white, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 30),

              // Original Buttons
              _buildDashboardButton(
                context,
                'Capture', // Add some label
                Icons.camera_alt,
                AppColors.accentColor, // Use accent color
                CameraScreen(),
              ),
              SizedBox(height: 20),
              _buildDashboardButton(
                context,
                'Gallery',
                Icons.photo_library,
                AppColors.primaryColor,
                GalleryScreen(),
              ),
              SizedBox(height: 20),
              _buildDashboardButton(
                context,
                'Attendance',
                Icons.list_alt,
                AppColors.primaryColor,
                AttendanceScreen(),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }

  Widget _buildDashboardButton(
    BuildContext context,
    String label,
    IconData icon,
    Color buttonColor,
    Widget screenToNavigate,
  ) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25), // More rounded corners
        ),
        elevation: 2,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screenToNavigate),
        );
      },
      icon: Icon(icon, size: 28, color: AppColors.white),
      label: Text(
        label,
        style: TextStyle(color: AppColors.white),
      ),
    );
  }
}

class TeamScreen extends StatelessWidget {
  final List<TeamMember> teamMembers = [
    TeamMember(
        name: 'Faseeh Awan',
        role: 'Backend Developer',
        imageUrl:
            'https://scontent.fkhi20-1.fna.fbcdn.net/v/t39.30808-6/346165227_792930818880418_1299876299498417856_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=efb6e6&_nc_eui2=AeECemSxa1yXh2l8r-9jR-F74hD5rFpW2C5JqJ57yYdEXa57XhP9l0YhG13kK86U5j7tP1I9nJ0pWJ9N_OqGz45z&_nc_ohc=g-3lM02I9K8AX9xJ-G7&_nc_ht=scontent.fkhi20-1.fna&oh=00_AfC8Yp30G105xWvH1_Lg8rM5wJ5h-9Bw7mJkE37h4j7Uew&oe=660F6DB9'),
    TeamMember(
        name: 'Huzaifa Ahmed',
        role: 'Frontend Developer',
        imageUrl: 'https://avatars.githubusercontent.com/u/58684873?v=4'),
    TeamMember(
        name: 'Saqib Mayo',
        role: 'AI Developer',
        imageUrl:
            'https://media.licdn.com/dms/image/D4D03AQHGc19V81h7Rw/profile-displayphoto-shrink_400_400/0/1711001234977?e=1716422400&v=beta&t=5P2Jc2l8Xq_w8tT_5kLOMYqSg2mY8K5Y0E5p7j_k64Y'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meet the Team', style: AppStyles.heading1),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
      ),
      backgroundColor: AppColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch to full width
          children: teamMembers.map((member) {
            return TeamMemberCard(teamMember: member);
          }).toList(),
        ),
      ),
    );
  }
}

class TeamMember {
  final String name;
  final String role;
  final String imageUrl;

  TeamMember({required this.name, required this.role, required this.imageUrl});
}

class TeamMemberCard extends StatelessWidget {
  final TeamMember teamMember;

  TeamMemberCard({required this.teamMember});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.accentLight,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: teamMember.imageUrl,
                  fit: BoxFit.cover,
                  width: 80.0,
                  height: 80.0,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor), // Use app's primary color
                      strokeWidth: 3, // Adjust the thickness of the indicator
                      backgroundColor: AppColors.gray, // Optional: Set the background color of the indicator
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    size: 30,
                    color: AppColors.errorColor,
                  ),
                ),
              ),
            ),
            SizedBox(width: 20), // Space between image and text
            Expanded(
              // Use expanded to allow text to take up remaining space
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teamMember.name,
                    style: AppStyles.bodyText.copyWith(
                        fontWeight: FontWeight.bold, color: AppColors.primaryDark, fontSize: 16.0),
                  ),
                  SizedBox(height: 5),
                  Text(
                    teamMember.role,
                    style: AppStyles.bodyText.copyWith(
                        color: AppColors.gray, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}