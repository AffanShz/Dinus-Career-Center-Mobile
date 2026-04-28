import 'package:flutter/material.dart';
import '../models/event_model.dart';

class EventService {
  Future<List<EventModel>> fetchEvents() async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      EventModel(
        id: '1',
        title: 'Future-Ready Careers: Navigating AI in Tech 2024',
        date: '24 Okt 2024',
        time: '09:00 WIB',
        location: 'Gedung H Lt. 7, UDINUS',
        address: 'Jl. Imam Bonjol No. 207, Semarang',
        imageUrl: 'assets/images/event1.png',
        tag: 'CAREER WORKSHOP',
        tagColor: const Color(0xFF6B8DD6),
        description: 'Persiapkan diri Anda untuk menghadapi perubahan lanskap industri teknologi. Dalam workshop eksklusif ini, DCC UDINUS menghadirkan pakar industri untuk membahas integrasi Artificial Intelligence dalam karir masa depan.\n\nPeserta akan mempelajari bagaimana memanfaatkan alat berbasis AI untuk meningkatkan produktivitas, strategi personal branding di era digital, serta peluang karir baru yang muncul seiring dengan perkembangan teknologi otomatisasi.',
        benefits: [
          'E-Certificate Resmi DCC',
          'Networking dengan HR Tech Company',
          'Snack & Lunch Box',
        ],
        speakerName: 'Dr. Sarah Wijaya',
        speakerRole: 'Lead AI Researcher at TechCorp',
        speakerImage: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1974&auto=format&fit=crop',
        price: 'Gratis',
      ),
      EventModel(
        id: '2',
        title: 'Global Tech Expo: Semarang Edition',
        date: '20 Nov 2024',
        time: '13:00 WIB',
        location: 'Zoom Cloud Meetings',
        address: 'Online via Zoom',
        imageUrl: 'assets/images/event2.png',
        tag: 'WEBINAR',
        tagColor: const Color(0xFF1E293B),
        locationIcon: Icons.videocam_outlined,
        description: 'Jelajahi inovasi teknologi terbaru dari seluruh dunia dalam Global Tech Expo edisi Semarang. Acara ini akan menampilkan demo produk, diskusi panel dengan CTO terkemuka, dan sesi tanya jawab interaktif.',
        benefits: [
          'Update Tren Teknologi Global',
          'Akses Rekaman Acara',
          'Digital Goodie Bag',
        ],
        speakerName: 'Budi Santoso',
        speakerRole: 'CTO of CloudPulse Systems',
        speakerImage: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=2070&auto=format&fit=crop',
        price: 'Gratis',
      ),
      EventModel(
        id: '3',
        title: 'UI/UX Career Path: From Junior to Lead',
        date: '05 Dec - 06 Dec 2024',
        time: '10:00 WIB',
        location: 'DCC Career Hub Room 2',
        address: 'Gedung Career Center Lantai 2',
        imageUrl: 'assets/images/event3.png',
        tag: 'WORKSHOP',
        tagColor: const Color(0xFFBC5919),
        description: 'Kembangkan keahlian desain Anda dan pelajari langkah-langkah strategis untuk meniti karir dari desainer junior hingga menjadi team lead yang kompeten.',
        benefits: [
          'Portfolio Review Session',
          'Career Roadmap Template',
          'Sertifikat Kompetensi',
        ],
        speakerName: 'Anita Sari',
        speakerRole: 'Senior UX Designer at DesignFlow',
        speakerImage: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=2070&auto=format&fit=crop',
        price: 'Rp 50.000',
      ),
    ];
  }
}
