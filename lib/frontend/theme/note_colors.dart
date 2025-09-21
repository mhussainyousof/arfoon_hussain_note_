import 'package:flutter/material.dart';

class AppColors {
  static const background = Colors.white;
  static const greyText = Color(0xFFA2A2A2);
   static const textLight = Colors.black;
    static const textDark = Colors.white;

  static const List<Color> noteColors = [
    Color(0XFF00A894),
    Color(0XFFFF7E56),
    Color(0XFF0081C8),
  ];
}

class AppTheme {
static  bool _isPersion(Locale locale){
     return locale.languageCode == 'fa' || locale.languageCode == 'ps';
      
    }
  static ThemeData lightTheme(Locale locale) {
   
    return ThemeData(

      fontFamily: _isPersion(locale) ? 'Iranian Sans' : 'Geist',
      useMaterial3: true,
      brightness: Brightness.light,
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
              foregroundColor: WidgetStateProperty.all(Colors.white),
                backgroundColor: WidgetStateProperty.all(Colors.black))),

      //
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.black, foregroundColor: Colors.white),
        
      //
        chipTheme: ChipThemeData(
        backgroundColor: Colors.white, 
        selectedColor: Colors.black, 
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

        iconButtonTheme: const IconButtonThemeData(
          style: ButtonStyle(iconColor:WidgetStatePropertyAll(Colors.black54))
        ),

      //
        cardTheme: const CardThemeData(
        color: Colors.white,
        shadowColor: Colors.black,
        elevation: 2
        ),
        
        //
        textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textLight),
        bodyMedium: TextStyle(color: AppColors.textLight),
        titleLarge: TextStyle(color: AppColors.textLight),
        titleMedium: TextStyle(color: AppColors.textLight),
      ),
        );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      fontFamily: 'Geist',
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color.fromARGB(255, 13, 13, 13) ,
      drawerTheme:  const DrawerThemeData(
  
      backgroundColor: Color.fromARGB(255, 22, 22, 22)),
      appBarTheme: const AppBarTheme(
        backgroundColor:  Color.fromARGB(255, 13, 13, 13)
      ),

    //
      dialogTheme:  DialogThemeData(backgroundColor: Colors.grey[2000]),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ButtonStyle(
              foregroundColor: WidgetStateProperty.all(Colors.black),
              backgroundColor: WidgetStateProperty.all(Colors.white)),
      ),

    //
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.white, foregroundColor: Colors.black
          ),

    //
           chipTheme: ChipThemeData(
      backgroundColor: Colors.grey[800]!,
      selectedColor: Colors.black, 
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
    
    //
     iconButtonTheme:  IconButtonThemeData(
          style: ButtonStyle(
            iconColor:WidgetStateProperty.all(Colors.white54))
        ),

    //
      cardTheme:  const CardThemeData(
        color: Colors.black,
        shadowColor: Colors.white60,
        elevation: 2,
      ),

    //
     textTheme: const TextTheme(
        bodyLarge: TextStyle(color: AppColors.textDark),
        bodyMedium: TextStyle(color: AppColors.textDark),
        titleLarge: TextStyle(color: AppColors.textDark),
        titleMedium: TextStyle(color: AppColors.textDark),
      ),
    );
  }
}
