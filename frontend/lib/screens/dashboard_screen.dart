import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/screens/camera_screen.dart';
import '/screens/gallery_screen.dart';
import '/screens/attendance_screen.dart';
import '/utils/app_colors.dart';
import '/utils/app_styles.dart';
import '/widgets/custom_navbar.dart';
import '/widgets/description_text_widget.dart';
import '/screens/game_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  double _sideMenuWidth = 250; // Adjust as needed
  bool _isSideMenuOpen = false;

  late AnimationController _animationController;
  late Animation<double> _menuAnimation;

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
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _menuAnimation = Tween<double>(
      begin: -_sideMenuWidth, // Start offscreen to the left
      end: 0, // End fully visible
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSideMenu() {
    setState(() {
      _isSideMenuOpen = !_isSideMenuOpen;
    });
    if (_isSideMenuOpen) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Container
      (
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
        child:Stack(
        children: [
          // Main Content Area
          SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 60), // Account for AppBar height
                  Text(
                    'Hazari Hub',
                    style: AppStyles.heading1.copyWith(
                      fontSize: 32,
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: DescriptionTextWidget(
                      text:
                          "Effortlessly manage attendance with Hazari Hub! We leverage the power of cutting-edge YOLO object detection and a robust Django backend, paired with Firebase storage for a seamless experience. Snap, upload, and track - it's that simple!",
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 2,
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
                  _buildDashboardButton(
                    context,
                    'Capture',
                    Icons.camera_alt,
                    AppColors.accentColor,
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
          // Side Menu (Initially hidden)
          AnimatedBuilder(
            animation: _menuAnimation,
            builder: (context, child) {
              return Positioned(
                left: _menuAnimation.value,
                top: 0,
                bottom: 0,
                width: _sideMenuWidth,
                child: Container(
                  color: AppColors.primaryColor, // Or a different menu color
                  child: Column(
                    children: [
                      // Add padding at the top of the menu to align with the AppBar
                      SizedBox(
                        height: MediaQuery.of(context).padding.top + 60,
                      ),
                      ListTile(
                        leading: Icon(Icons.gamepad, color: AppColors.white),
                        title: Text(
                          'Play Game',
                          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GameScreen()),
                          );
                        },
                      ),
                      // Add more side menu items here
                    ],
                  ),
                ),
              
              );
            },
          ),

          // App Bar (Always visible, above other content)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              leading: IconButton(
                icon: Icon(Icons.menu, color: AppColors.white),
                onPressed: _toggleSideMenu,
              ),
              title: Text('Hazari Hub', style: AppStyles.heading1),
              backgroundColor: AppColors.primaryDark,
              elevation: 0,
            ),
          ),
        ],
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
        name: 'Hamza Amin',
        role: 'Backend Developer',
        imageUrl:
            'https://i1.sndcdn.com/artworks-cHBUUymTx569YCrd-tIIEtQ-t500x500.jpg'),
    TeamMember(
        name: 'Maaz Hamid',
        role: 'Frontend Developer',
        imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSDwWwty8v8U9MCaZNMgmsMI9GqCTx-y04oVw&s'),
    TeamMember(
        name: 'Ali Vijdaan',
        role: 'Annotation Rat',
        imageUrl:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT765buj8mI8JGDniTmjE6gCWrQTbUHJeVyHw&s'),
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