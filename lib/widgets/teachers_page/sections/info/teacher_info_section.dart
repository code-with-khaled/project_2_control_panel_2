import 'package:flutter/material.dart';

class TeacherInfoSection extends StatelessWidget {
  const TeacherInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildPersonalInfo(),
        SizedBox(height: 20),
        _buildAdditionalInfo(),
      ],
    );
  }

  Widget _buildPersonalInfo() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person_outline),
              SizedBox(width: 8),
              Text(
                "المعلومات الشخصية",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.mail_outline, size: 18, color: Colors.black54),
                    SizedBox(width: 8),
                    Flexible(child: Text("ahmad_mohamed@gmail.com")),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.phone_outlined, size: 18, color: Colors.black54),
                    SizedBox(width: 8),
                    Text("0994-387-970"),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 18,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 8),
                    Text("ماجستير في الفيزياء"),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: Colors.black54,
                    ),
                    SizedBox(width: 8),
                    Text("3 سنوات من الخبرة"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "معلومات إضافية",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 15),
          Row(
            children: [
              Text(
                "تاريخ الانضمام: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 5),
              Text("11/6/2025"),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text("الخبرات: ", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 5),
              Flexible(
                child: Text("+8 سنوات في تدريس الفيزياء النظرية والتطبيقية"),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text("الوصف: ", style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(width: 5),
              Flexible(
                child: Text(
                  "مدرس صاحب شغف كبير وخبرة في الفيزياء، كرس حياته لمساعدة الطلاب على الوصول لأهدافهم التعليمية.",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
