import 'package:chat_app_mini/components/my_drawer.dart';
import 'package:chat_app_mini/components/user_tile.dart';
import 'package:chat_app_mini/pages/chat_page.dart';
import 'package:chat_app_mini/services/auth_service.dart';
import 'package:chat_app_mini/services/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../routes/app_routes.dart';
import '../utils/confirmation_dialog.dart';


class HomePage extends StatelessWidget {
  HomePage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  void _logout(BuildContext context) async {
    final confirm = await showConfirmationDialog(
      context,
      title: "Logout",
      message: "Are you sure you want to logout?",
      confirmText: "Logout",
      cancelText: "Cancel",
    );
    if (confirm == true) {
      await _authService.logout();
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
            (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _logout(context), // <- gọi dialog ở đây
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      drawer: MyDrawer(),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
        stream: _chatService.getUsersStream(),
        builder: (context, snapshot){
          if (snapshot.hasError){
            return const Text("Error");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Padding(
            padding: EdgeInsets.only(top: 20.h),// cách trên 16px
            child: ListView(
              children: snapshot.data!
                  .map<Widget>((userData) => _buildUserListItem(userData, context))
                  .toList(),
            ),
          );
        }
    );
  }

  Widget _buildUserListItem (
      Map<String,dynamic> userData , BuildContext context){
    if(userData['email'] != _authService.getCurrentUser()!.email){
      return UserTile(
        text: userData['email'],
        onTap: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                    receiverEmail: userData['email'],
                    receiverId: userData['uid'],
                  ))
          );
        },
      );
    } else {
      return Container();
    }
  }
}
