import 'package:flutter/material.dart';
import 'package:stipres/screens/features_student/widgets/cards/course_detail_card.dart';

class CourseDialog extends StatefulWidget {
  final String namaMatkul;
  final String idMatkul;
  final String tanggal;
  final String jam;
  final String dosen;

  const CourseDialog({
    super.key,
    required this.namaMatkul,
    required this.idMatkul,
    required this.tanggal,
    required this.jam,
    required this.dosen,
  });

  @override
  State<CourseDialog> createState() => _CourseDialogState();
}

class _CourseDialogState extends State<CourseDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  void _closeDialog() async {
    await _controller.reverse();
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(20),
      child: SlideTransition(
        position: _offsetAnimation,
        child: Stack(
          children: [
            CourseDetailCard(
              namaMatkul: widget.namaMatkul,
              idMatkul: widget.idMatkul,
              tanggal: widget.tanggal,
              jam: widget.jam,
              dosen: widget.dosen,
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: _closeDialog,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
