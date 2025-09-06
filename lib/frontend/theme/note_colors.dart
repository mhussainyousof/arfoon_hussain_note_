import 'package:flutter/material.dart';

class AppColors {
  static const primaryBlue = Color(0xFF0081C8);
  static const background = Colors.white;
  static const greyText = Color(0xFFA2A2A2);
  static const chipSelected = Colors.black;
  static const chipUnselected = Color(0xFFE0E0E0);

  static const List<Color> noteColors = [
    Color(0XFF00A894),
    Color(0XFFFF7E56),
    Color(0XFF0081C8),
  ];
}

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
        scaffoldBackgroundColor: Colors.white,
        drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),

        //
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
        ),

        //
        dialogTheme: const DialogThemeData(backgroundColor: Colors.white),

        //
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.black))),

        //
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.black, foregroundColor: Colors.white),
        
        //
        chipTheme: ChipThemeData(
        backgroundColor: Colors.white, 
        selectedColor: AppColors.chipSelected, 
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), 
        labelStyle: const TextStyle(
          fontSize: 13,
          color: Colors.black54, 
          fontWeight: FontWeight.normal,
        ),
        secondaryLabelStyle: const TextStyle(
          fontSize: 13,
          color: Colors.white, 
          fontWeight: FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100), 
          side: const BorderSide(color: Colors.grey), 
        ),
        elevation: 0,
        shadowColor: Colors.transparent,
        checkmarkColor: Colors.white, 
      ),
        );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      scaffoldBackgroundColor: Colors.black,
      drawerTheme: const DrawerThemeData(backgroundColor: Colors.black),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black,
      ),
      dialogTheme: const DialogThemeData(backgroundColor: Colors.black),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.white)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.white, foregroundColor: Colors.black
          ),

           chipTheme: ChipThemeData(
      backgroundColor: Colors.grey[800]!,
      selectedColor: AppColors.chipSelected, 
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      labelStyle:  TextStyle(
        fontSize: 13,
        color: Colors.grey[400]!,
        fontWeight: FontWeight.normal,
      ),
      secondaryLabelStyle: const TextStyle(
        fontSize: 13,
        color: Colors.white,
        fontWeight: FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100),
        side:  BorderSide(color: Colors.grey[700]!), 
      ),
      elevation: 0,
      shadowColor: Colors.transparent,
      checkmarkColor: Colors.white,
    ),
    );
  }
}
