import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_project/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_flutter_project/features/auth/presentation/pages/login_page.dart';
import 'package:my_flutter_project/bottom_nav_bar_page.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          return const BottomNavBarPage();
        } else if (state is Unauthenticated || state is AuthError) {
          return const LoginPage();
        } else {
          // AuthInitial or AuthLoading
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
