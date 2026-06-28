import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EventSearchBar extends StatelessWidget {
  const EventSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9), // Light grey background
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Cari event...',
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey[500],
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          icon: Icon(Icons.search_rounded, color: Colors.grey[500], size: 24),
        ),
      ),
    );
  }
}
