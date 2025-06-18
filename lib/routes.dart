import 'package:cardio_care/responsive/desktop_scafold.dart';
import 'package:cardio_care/responsive/mobile_scafold.dart';
import 'package:cardio_care/responsive/responsive_layout.dart';
import 'package:cardio_care/responsive/tablet_scafold.dart';
import 'package:cardio_care/screens/home/patient/patient_dashbaord.dart';
import 'package:cardio_care/screens/login/login_screen.dart';
import 'package:cardio_care/screens/signup/register_screen.dart';
import 'package:flutter/material.dart';

final routes = {
  '/': (BuildContext context) => LoginScreen(),
  '/login': (BuildContext context) => LoginScreen(),
  '/signup': (BuildContext context) => AppRouteBuilder.builderSignUp,
  '/home': (BuildContext context) => AppRouteBuilder.builderHome,
  '/patient': (BuildContext context) => AppRouteBuilder.builderPatientDashboard,
};

class AppRouteBuilder {
  // Responsive screen for home page
  static const builderHome = ResponsiveLayout(
    mobileScafold: MobileScafold(),
    tabletScafold: TabletScafold(),
    desktopScafold: DesktopScafold(),
  );

  static var builderSignUp = ResponsiveLayout(
    mobileScafold: RegisterScreen(),
    tabletScafold: RegisterScreen(),
    desktopScafold: RegisterScreen(),
  );

  static const builderPatientDashboard = ResponsiveLayout(
    mobileScafold: PatientDashboard(),
    tabletScafold: PatientDashboard(),
    desktopScafold: PatientDashboard(),
  );
}
