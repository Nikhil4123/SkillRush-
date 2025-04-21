import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Resource {
  final String id;
  final String title;
  final String description;
  final String url;
  final String courseId;
  final String resourceType;
  final DateTime uploadDate;
  final int downloadCount;

  Resource({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.courseId,
    required this.resourceType,
    required this.uploadDate,
    this.downloadCount = 0,
  });

  // Create a Resource from Firestore data
  factory Resource.fromFirestore(String id, Map<String, dynamic> data) {
    return Resource(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      url: data['url'] ?? '',
      courseId: data['courseId'] ?? '',
      resourceType: data['resourceType'] ?? 'Other',
      uploadDate:
          data['uploadDate'] != null
              ? (data['uploadDate'] as Timestamp).toDate()
              : DateTime.now(),
      downloadCount: data['downloadCount'] ?? 0,
    );
  }

  // Convert Resource to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'url': url,
      'courseId': courseId,
      'resourceType': resourceType,
      'uploadDate': uploadDate,
      'downloadCount': downloadCount,
    };
  }

  // Get icon based on resource type
  IconData get icon {
    switch (resourceType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'document':
        return Icons.description;
      case 'spreadsheet':
        return Icons.table_chart;
      case 'presentation':
        return Icons.slideshow;
      case 'image':
        return Icons.image;
      case 'code':
        return Icons.code;
      default:
        return Icons.insert_drive_file;
    }
  }

  // Get file extension from URL
  String get fileExtension {
    final url = this.url.toLowerCase();
    if (url.endsWith('.pdf')) return 'PDF';
    if (url.endsWith('.doc') || url.endsWith('.docx')) return 'DOC';
    if (url.endsWith('.xls') || url.endsWith('.xlsx')) return 'XLS';
    if (url.endsWith('.ppt') || url.endsWith('.pptx')) return 'PPT';
    if (url.endsWith('.jpg') || url.endsWith('.jpeg')) return 'JPG';
    if (url.endsWith('.png')) return 'PNG';
    if (url.endsWith('.txt')) return 'TXT';
    return 'FILE';
  }
}
